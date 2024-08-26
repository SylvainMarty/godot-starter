extends Node

enum TowerId {
	TOWER_1,
	TOWER_2,
	TOWER_3,
	TOWER_4,
	TOWER_5,
	TOWER_6
}

signal current_biome_changed(current_biome_index: int, tower_id: TowerId)

## Ordered array of biomes (from the easiest to the hardest)
var biome_scenes: Array[String] = [
	"res://components/biomes/0_surface.tscn",
	"res://components/biomes/1_first_underground.tscn",
	"res://components/biomes/2_second_underground.tscn"
]

var curr_index: int
var has_game_restarted = false
var changing_biome = false

func _ready():
	init()

func init():
	curr_index = 0
	BiomeManager.changing_biome = false

func climb_up(tower_id: TowerId):
	if curr_index == 0:
		return
	set_biome(curr_index - 1, tower_id)

func climb_down(tower_id: TowerId):
	if curr_index == biome_scenes.size() - 1:
		return
	set_biome(curr_index + 1, tower_id)

func set_biome(biome_index: int, tower_id: TowerId):
	BiomeManager.changing_biome = true
	CharacterState.health.invincible = true
	curr_index = biome_index
	current_biome_changed.emit(curr_index, tower_id)

func get_current_biome_scene_path() -> String:
	return biome_scenes[curr_index]

func is_surface_biome() -> bool:
	return curr_index == 0

func is_last_biome() -> bool:
	return curr_index == biome_scenes.size()-1
