## CharacterState class
##
## This class is used to store global character state (health, stats, etc.)
## You can also use signals to trigger external behavior (i.e. the player loses health and you want to trigger a specific sound)

extends Node

signal object_pick_up_started(object)

const DEFAULT_HEALTH_POINTS = 100
const DEFAULT_MOVEMENT_SPEED = 200.0
const DEFAULT_JUMP_VELOCITY = 250.0
const DEFAULT_ATTACK_SPEED = 0.0
const DEFAULT_ATTACK_RANGE = 0.0
const DEFAULT_ATTACK_DAMAGE = 0.0
const DEFAULT_ATTACK_KNOCK_BACK_VECTOR = Vector2(0, 0)
const DEFAULT_ATTACK_SELF_KNOCK_BACK_STRENGTH = 0.0
const DEFAULT_DEFENSE_DAMAGE_RESISTANCE = 0

var health: HealthStat
var stats: ActorStat

var position: Vector2
var global_position: Vector2


func _ready():
	init()


func init():
	health = HealthStat.new(DEFAULT_HEALTH_POINTS)
	stats = ActorStat.new(
		DEFAULT_MOVEMENT_SPEED,
		DEFAULT_JUMP_VELOCITY,
		DEFAULT_ATTACK_SPEED,
		DEFAULT_ATTACK_RANGE,
		DEFAULT_ATTACK_DAMAGE,
		DEFAULT_ATTACK_KNOCK_BACK_VECTOR,
		DEFAULT_ATTACK_SELF_KNOCK_BACK_STRENGTH,
		DEFAULT_DEFENSE_DAMAGE_RESISTANCE)


func update_positions(position: Vector2, global_position: Vector2):
	self.position = position
	self.global_position = global_position


func add_object(object):
	object_pick_up_started.emit(object)
