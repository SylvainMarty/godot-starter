extends Node2D
class_name Tower

const DOOR_HINT_ACTIONS_DICT = {
	"climb_up": "Press %s to go up",
	"climb_down": "Press %s to go down"
}

@export var tower_id: BiomeManager.TowerId

@onready var door_actionable: Actionable = $DoorActionable
@onready var player_spawn_point_marker_2d = $PlayerSpawnPointMarker2D
@onready var tower_sprite = $TowerSprite
@onready var animation_player = $MovingPointLight/MovingPointLight2D/AnimationPlayer


var can_climb = false
var can_climb_up = false
var can_climb_down = false
var climbing = false

func _ready():
	if BiomeManager.is_surface_biome():
		can_climb_down = true
	else:
		tower_sprite.modulate = '#ff5e36'
		if not BiomeManager.is_last_biome():
			can_climb_up = true
			can_climb_down = true
		else:
			can_climb_up = true
	prepare_door_actionable_hints()
	animation_player.play("moving")

func prepare_door_actionable_hints():
	door_actionable.actions = []
	door_actionable.action_labels = []
	if can_climb_up:
		door_actionable.actions.append(DOOR_HINT_ACTIONS_DICT.keys()[0])
		door_actionable.action_labels.append(DOOR_HINT_ACTIONS_DICT.values()[0])
	if can_climb_down:
		door_actionable.actions.append(DOOR_HINT_ACTIONS_DICT.keys()[1])
		door_actionable.action_labels.append(DOOR_HINT_ACTIONS_DICT.values()[1])
	door_actionable.prepare_hints()

func _on_door_actionable_actionable(is_actionable):
	can_climb = is_actionable

func _process(delta):
	if not can_climb or climbing:
		return
	if can_climb_up and Input.is_action_pressed("climb_up"):
		BiomeManager.climb_up(tower_id)
		climbing = true
		return
	if can_climb_down and Input.is_action_pressed("climb_down"):
		BiomeManager.climb_down(tower_id)
		climbing = true
		return

func get_player_spawn_point() -> Marker2D:
	return player_spawn_point_marker_2d
