extends Resource
class_name FightStat

@export var speed: int
@export var range: int
@export var damage: int
@export var knock_back_vector: Vector2
@export var self_knock_back_strength: int

func _init(
		speed: int = 0,
		range: int = 0,
		damage: int = 0,
		knock_back_vector: Vector2 = Vector2(0, 0),
		self_knock_back_strength: int = 0):
	self.speed = speed
	self.range = range
	self.damage = damage
	self.knock_back_vector = knock_back_vector
	self.self_knock_back_strength = self_knock_back_strength
