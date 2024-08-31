extends Resource
class_name ActorStat

signal stat_updated

@export var movement_speed: float:
	set(new_value):
		movement_speed = new_value
		stat_updated.emit()
@export var jump_velocity: float:
	set(new_value):
		jump_velocity = new_value
		stat_updated.emit()
@export var attack_speed: float:
	set(new_value):
		attack_speed = new_value
		stat_updated.emit()
@export var attack_range: float:
	set(new_value):
		attack_range = new_value
		stat_updated.emit()
@export var attack_damage: int:
	set(new_value):
		attack_damage = new_value
		stat_updated.emit()
@export var attack_knock_back_vector: Vector2:
	set(new_value):
		attack_knock_back_vector = new_value
		stat_updated.emit()
@export var attack_self_knock_back_strength: float:
	set(new_value):
		attack_self_knock_back_strength = new_value
		stat_updated.emit()
@export var defense_damage_resistance: int:
	set(new_value):
		defense_damage_resistance = new_value
		stat_updated.emit()

func _init(
		movement_speed: float = 0.0,
		jump_velocity: float = 0.0,
		attack_speed: float = 0.0,
		attack_range: float = 0.0,
		attack_damage: int = 0.0,
		attack_knock_back_vector: Vector2 = Vector2(0, 0),
		attack_self_knock_back_strength: float = 0.0,
		defense_damage_resistance: int = 0):
	self.movement_speed = movement_speed
	self.jump_velocity = jump_velocity
	self.attack_speed = attack_speed
	self.attack_range = attack_range
	self.attack_damage = attack_damage
	self.attack_knock_back_vector = attack_knock_back_vector
	self.attack_self_knock_back_strength = attack_self_knock_back_strength
	self.defense_damage_resistance = defense_damage_resistance
