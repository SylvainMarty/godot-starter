extends Resource
class_name HealthStat

signal health_updated(health_points: int)
signal healed(healing_points: int, health_points: int)
signal damaged(damages: int, health_points: int)
signal dead

@export var health_points: int
@export var invincible: bool = false

var is_dead = false

func _init(health_points: int = 0):
	set_health_points(health_points)
	is_dead = false

func damage(damages: int):
	set_health_points(self.health_points - damages)
	damaged.emit(damages, self.health_points)

func heal(healing_points: int):
	set_health_points(self.health_points + healing_points)
	healed.emit(healing_points, self.health_points)

func set_health_points(health_points: int):
	self.health_points = maxi(health_points, 0)
	health_updated.emit(self.health_points)
	if not is_dead and not invincible and self.health_points == 0:
		dead.emit()
