extends CanvasLayer
class_name TransitionScreen

@onready var animation_player = $AnimationPlayer

func fade_in():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("fade_to_normal")
	await animation_player.animation_finished
