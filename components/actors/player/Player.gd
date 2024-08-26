extends CharacterBody2D
class_name Player

signal moving(position: Vector2, global_position: Vector2)

const WEAPON_POSITION = Vector2(13, 9)

@export var weapon: MeleeWeapon
@export var flowers: Array = []

var dir = "right"
var is_holding_weapon = false
var knocked_back = false
var die_sound_running = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite
@onready var weapon_container = $WeaponContainer
@onready var point_light_2d = $PointLight2D
@onready var health_bar = $HealthBar
@onready var walking_audio_stream_player_2d = $WalkingAudioStreamPlayer2D
@onready var hurting_audio_stream_player_2d = $HurtingAudioStreamPlayer2D
@onready var pick_up_weapon_audio_stream_player_2d = $PickUpWeaponAudioStreamPlayer2D
@onready var die_audio_stream_player_2d_2 = $DieAudioStreamPlayer2D2
@onready var jumping_audio_stream_player_2d = $JumpingAudioStreamPlayer2D
@onready var pick_up_flower_audio_stream_player_2d = $PickUpFlowerAudioStreamPlayer2D

func _ready():
	CharacterState.object_pick_up_started.connect(self.add_object)
	CharacterState.health.dead.connect(self.play_die_sound)
	BiomeManager.current_biome_changed.connect(self._on_biome_changed)
	health_bar.health = CharacterState.health


func _unhandled_input(event: InputEvent):
	if weapon and event.is_action_pressed("attack"):
		weapon.attack()


func add_object(object):
	if (object is MeleeWeapon):
		self.add_weapon(object)
		return
	
	if (object is MagicFlower):
		self.add_flower(object)


func add_weapon(equipment):
	if not (equipment is MeleeWeapon):
		return
	if is_holding_weapon:
		return
	weapon = equipment
	weapon_container.add_child(weapon)
	weapon.position = WEAPON_POSITION
	weapon.weapon_holder_stat = CharacterState.stats
	is_holding_weapon = true
	play_pick_up_weapon_sound()


func add_flower(flower):
	flowers.append(flower.color)
	play_pick_up_flower_sound()
	# heal to full health
	CharacterState.health.set_health_points(CharacterState.DEFAULT_HEALTH_POINTS)
	if flower.color == Constants.FlowerColor.RED:
		CharacterState.health.set_health_points(CharacterState.DEFAULT_HEALTH_POINTS * 1.5)
		CharacterState.stats.movement_speed = 600.0
		CharacterState.stats.attack_damage = 60.0


func _physics_process(delta):
	if knocked_back:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		play_jumping_sound()
		velocity.y = - CharacterState.stats.jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	var animation
	if direction:
		velocity.x = direction * CharacterState.stats.movement_speed
		if direction > 0:
			animation = "move_right_weapon" if is_holding_weapon else "move_right"
			dir = "right"
			weapon_container.scale.x = 1
		if direction < 0:
			animation = "move_left_weapon" if is_holding_weapon else "move_left"
			dir = "left"
			weapon_container.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, CharacterState.stats.movement_speed)
		if is_holding_weapon:
			animation = "idle_left_weapon" if dir == "left" else "idle_right_weapon"
		else:
			animation = "idle_right" if dir == "right" else "idle_left"
	
	if animated_sprite.animation != animation:
		animated_sprite.play(animation)

	if direction and is_on_floor():
		play_walk_sound()
	else:
		stop_walk_sound()

	move_and_slide()
	moving.emit(position, global_position)


func handle_hit(damage):
	play_hurt_sound()
	CharacterState.health.damage(max(damage - CharacterState.stats.defense_damage_resistance, 0))

func play_walk_sound():
	if not walking_audio_stream_player_2d.playing:
		walking_audio_stream_player_2d.play()

func stop_walk_sound():
	if walking_audio_stream_player_2d.playing:
		walking_audio_stream_player_2d.stop()

func play_hurt_sound():
	if not hurting_audio_stream_player_2d.playing:
		hurting_audio_stream_player_2d.play()

func play_pick_up_weapon_sound():
	if not pick_up_weapon_audio_stream_player_2d.playing:
		pick_up_weapon_audio_stream_player_2d.play()

func play_pick_up_flower_sound():
	if not pick_up_flower_audio_stream_player_2d.playing:
		pick_up_flower_audio_stream_player_2d.play()

func play_jumping_sound():
	jumping_audio_stream_player_2d.play()

func play_die_sound():
	if not die_audio_stream_player_2d_2.playing:
		die_sound_running = true
		die_audio_stream_player_2d_2.play()

func die_sound_finished():
	await die_audio_stream_player_2d_2.finished

func handle_knock_back(knock_back_velocity: Vector2):
	knocked_back = true
	velocity = knock_back_velocity
	move_and_slide()
	knocked_back = false


func _on_biome_changed(_current_biome_index, _tower_id):
	if not BiomeManager.is_surface_biome():
		point_light_2d.show()
	elif point_light_2d.visible:
		point_light_2d.hide()

func _on_die_audio_stream_player_2d_2_finished():
	die_sound_running = false

func wait_for_die_sound_to_finish():
	while die_sound_running:
		await get_tree().create_timer(0.2).timeout
