extends Node

enum TowerId {
	TOWER_1,
	TOWER_2,
	TOWER_3,
	TOWER_4,
	TOWER_5,
	TOWER_6
}

signal current_level_changed(current_level_index: int, tower_id: TowerId)

## Ordered array of levels (from the easiest to the hardest)
var level_scenes: Array[String] = [
	"res://2d/side_scrolling/levels/1_first_level.tscn",
	"res://2d/side_scrolling/levels/2_second_level.tscn",
]

var curr_index: int
var has_game_restarted = false
var changing_level = false

func _ready():
	init()

func init():
	curr_index = 0
	LevelManager.changing_level = false

func climb_up(tower_id: TowerId):
	if curr_index == 0:
		return
	set_level(curr_index - 1, tower_id)

func climb_down(tower_id: TowerId):
	if curr_index == level_scenes.size() - 1:
		return
	set_level(curr_index + 1, tower_id)

func set_level(level_index: int, tower_id: TowerId):
	LevelManager.changing_level = true
	CharacterState.health.invincible = true
	curr_index = level_index
	current_level_changed.emit(curr_index, tower_id)

func get_current_level_scene_path() -> String:
	return level_scenes[curr_index]

func is_surface_level() -> bool:
	return curr_index == 0

func is_last_level() -> bool:
	return curr_index == level_scenes.size()-1
