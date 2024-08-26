## VillageState class
##
## This class is used to store global village state (like health)

extends Node

signal village_saved

## Represents the number of seconds it will take for the village to die
const DEFAULT_HEALTH_POINTS = 300
## The number of seconds the health decrease
const HEALTH_DECREASE_FREQUENCY: float = 1.0
## The number of seconds the health decrease
const HEALTH_DECREASE_AMOUNT = 1

var health: HealthStat
var timer: Timer
var saved = false

func _ready():
	init()

func init():
	health = HealthStat.new(DEFAULT_HEALTH_POINTS)
	if timer:
		remove_child(timer)
		timer.queue_free()
	timer = Timer.new()
	add_child(timer)
	timer.start(HEALTH_DECREASE_FREQUENCY)
	timer.timeout.connect(self._tick)

func _tick():
	health.damage(HEALTH_DECREASE_AMOUNT)
	if health.health_points == 0:
		timer.stop()

func save_village():
	village_saved.emit()
