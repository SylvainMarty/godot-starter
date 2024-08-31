extends Area2D
class_name MeleeWeapon

@export var stats: ActorStat
@export var weapon_holder_stat: ActorStat

@onready var animation = $AnimationPlayer
@onready var hit_audio_stream_player_2d = $HitAudioStreamPlayer2D


func _ready():
	animation.play("RESET")


func attack():
	animation.play("swing")


func _on_body_entered(body: Node):
	if body.has_method("handle_hit"):
		body.handle_hit(calculate_damage())
		play_hit_sound()

func calculate_damage():
	var damage = stats.attack_damage
	if weapon_holder_stat:
		damage += weapon_holder_stat.attack_damage
	return damage


func play_hit_sound():
	hit_audio_stream_player_2d.play()
