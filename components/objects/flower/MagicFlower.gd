extends Node2D
class_name MagicFlower

@export var color: Constants.FlowerColor
@export var stats: ActorStat

const BLUE_FLOWER = preload("res://assets/art/objects/blue_flower.png")
const RED_FLOWER = preload("res://assets/art/objects/red_flower.png")

@onready var flower_sprite = $FlowerSprite

func _ready():
	if color == Constants.FlowerColor.BLUE:
		flower_sprite.texture = BLUE_FLOWER
	else:
		flower_sprite.texture = RED_FLOWER
		stats.movement_speed = 200
		stats.jump_velocity = 200
		stats.attack_damage = 100
		stats.defense_damage_resistance = 50

