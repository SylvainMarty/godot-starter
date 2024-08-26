extends Node2D

enum GameOverReason {
	PlayerDied,
	VillageDied,
	VillageSaved
}

@export var transition_screen_scene: PackedScene

@onready var player = $Player
@onready var biome: BaseBiome
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player = $AudioStreamPlayer/AnimationPlayer
@onready var main_menu: MainMenu = $MainMenu

var game_over_started = false

func _ready():
	BiomeManager.current_biome_changed.connect(self._on_current_biome_changed)
	CharacterState.health.dead.connect(self.game_over.bind(GameOverReason.PlayerDied))
	VillageState.health.dead.connect(self.game_over.bind(GameOverReason.VillageDied))
	VillageState.village_saved.connect(self.game_over.bind(GameOverReason.VillageSaved))
	biome = $Biome
	start_music()
	if not BiomeManager.has_game_restarted:
		main_menu.show_start_menu()
	BiomeManager.has_game_restarted = false
	BiomeManager.changing_biome = false
	CharacterState.health.invincible = false
	game_over_started = false

func get_used_tower(used_tower_id: BiomeManager.TowerId):
	var towers = get_tree().get_nodes_in_group("towers")
	for tower in towers:
		if tower.tower_id == used_tower_id:
			return tower
	return null

func _on_player_moving(position, global_position):
	CharacterState.call_deferred("update_positions", position, global_position)

func set_audio_stream():
	audio_stream_player.stream = biome.audio_stream

func replace_audio_stream():
	var curr_position = audio_stream_player.get_playback_position()
	audio_stream_player.stream = biome.audio_stream
	audio_stream_player.play(curr_position)

func start_music():
	set_audio_stream()
	audio_stream_player.play()
	animation_player.play("fade_in")

func replace_music():
	if audio_stream_player.stream != biome.audio_stream:
		animation_player.play("fade_out")
		await animation_player.animation_finished
		audio_stream_player.stop()
		start_music()
	else:
		replace_audio_stream()

func _on_current_biome_changed(curr_biome_index, tower_id):
	var biome_path = BiomeManager.get_current_biome_scene_path()
	var transition_screen: TransitionScreen = transition_screen_scene.instantiate()
	add_child(transition_screen)
	await transition_screen.fade_in()
	remove_child(biome)
	biome.queue_free()
	var biome_scene = await Utils.load_async(biome_path, get_tree())
	biome = biome_scene.instantiate()
	add_child(biome)
	replace_music()
	var used_tower: Tower = get_used_tower(tower_id)
	if used_tower:
		player.global_position = used_tower.get_player_spawn_point().global_position
	else:
		player.global_position = biome.player_spawn_point.global_position
	await transition_screen.fade_out()
	remove_child(transition_screen)
	transition_screen.queue_free()
	BiomeManager.changing_biome = false
	CharacterState.health.invincible = false

func game_over(reason: GameOverReason):
	if game_over_started:
		return
	game_over_started = true
	var should_remove_player = reason != GameOverReason.VillageSaved
	if should_remove_player:
		player.hide()
	var transition_screen: TransitionScreen = transition_screen_scene.instantiate()
	add_child(transition_screen)
	await transition_screen.fade_in()
	if should_remove_player:
		await player.wait_for_die_sound_to_finish()
		remove_child(player)
		player.queue_free()
	await get_tree().create_timer(0.3).timeout
	match reason:
		GameOverReason.PlayerDied:
			main_menu.show_player_died_menu()
		GameOverReason.VillageDied:
			main_menu.show_village_died_menu()
		GameOverReason.VillageSaved:
			main_menu.show_village_saved_menu()
