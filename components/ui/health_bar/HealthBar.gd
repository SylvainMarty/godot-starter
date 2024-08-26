@tool

extends Node2D
class_name HealthBar

@export var health: HealthStat:
	set(new_health):
		health = new_health
		init_health()
@export var debug_health_bar = false

@onready var progress_bar_container = $ProgressBarContainer
@onready var progress_bar = $ProgressBarContainer/ProgressBar
@onready var timer = $Timer

var max_health_points: int

func _ready():
	hide_health_bar()
	if health:
		init_health()

func init_health():
	max_health_points = health.health_points
	health.health_updated.connect(self._on_health_updated)
	update_health_bar(health.health_points)

func _on_health_updated(health_points: int):
	max_health_points = max(max_health_points, health_points)
	update_health_bar(health_points)
	show_health_bar()

func update_health_bar(health_points: int):
	progress_bar.max_value = max_health_points
	progress_bar.value = health_points

func show_health_bar():
	progress_bar_container.show()
	timer.start()

func hide_health_bar():
	timer.stop()
	progress_bar_container.hide()

func _on_timer_timeout():
	progress_bar_container.hide()

func _process(delta):
	if Engine.is_editor_hint():
		if debug_health_bar and not progress_bar_container.visible:
			progress_bar_container.show()
		elif progress_bar_container.visible:
			progress_bar_container.hide()
