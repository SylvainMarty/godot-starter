extends CharacterBody2D

@export var health: HealthStat
@export var stats: ActorStat
## The zone where the player can get the aggro
@export var aggro_shape: Shape2D

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var collision_polygon_2d = $CollisionPolygon2D
@onready var hit_box_area_2d = $HitBoxArea2D
@onready var health_bar = $HealthBar
@onready var walking_audio_stream_player_2d = $WalkingAudioStreamPlayer2D
@onready var aggro_collision_shape_2d = $AggroDetectionArea2D/AggroCollisionShape2D
@onready var attacking_audio_stream_player_2d = $AttackingAudioStreamPlayer2D
@onready var hurting_audio_stream_player_2d = $HurtingAudioStreamPlayer2D


var curr_direction = 1
var last_x_velocity = 0.0
var has_player_in_range = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	play_idle_animation()
	flip_direction()
	health.dead.connect(self._on_worm_dead)
	health_bar.health = health
	aggro_collision_shape_2d.shape = aggro_shape

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not has_player_in_range:
		play_idle_animation()
		stop_walking_sound()
		return
	
	flip_direction()
	last_x_velocity = stats.movement_speed * curr_direction
	velocity.x = last_x_velocity
	play_walking_animation()
	move_and_slide()
	
	if is_on_floor():
		play_walking_sound()
	else:
		stop_walking_sound()


func flip_direction():
	var direction
	if has_player_in_range:
		direction = (CharacterState.position - position).x
	else:
		direction = [1, -1][randi_range(0, 1)]
	var flip = false
	if direction > 0:
		curr_direction = 1
		flip = true
	if direction < 0:
		curr_direction = -1
		flip = false
	if sprite.flip_h != flip:
		sprite.flip_h = flip
		hit_box_area_2d.scale.x = -hit_box_area_2d.scale.x


func handle_hit(damage):
	play_hurting_sound()
	health.damage(max(damage - stats.defense_damage_resistance, 0))


func _on_worm_dead():
	# TODO: add death animation
	queue_free()

func play_walking_sound():
	if not walking_audio_stream_player_2d.playing:
		walking_audio_stream_player_2d.play()

func stop_walking_sound():
	if walking_audio_stream_player_2d.playing:
		walking_audio_stream_player_2d.stop()

func play_attacking_sound():
	if not attacking_audio_stream_player_2d.playing:
		attacking_audio_stream_player_2d.play()

func play_hurting_sound():
	if not hurting_audio_stream_player_2d.playing:
		hurting_audio_stream_player_2d.play()

func play_walking_animation():
	if animation_player.current_animation != "move":
		animation_player.play("move")

func play_idle_animation():
	if animation_player.current_animation != "idle":
		animation_player.play("idle")

func _on_hit_box_area_2d_body_entered(collider):
	var dealt_damage = false
	if collider.has_method("handle_hit"):
		collider.handle_hit(stats.attack_damage)
		dealt_damage = true
	if collider.has_method("handle_knock_back"):
		collider.handle_knock_back(Vector2(stats.attack_knock_back_vector.x * curr_direction, stats.attack_knock_back_vector.y))
	if dealt_damage:
		play_attacking_sound()
		# Enemy knock back
		velocity.x = -last_x_velocity * stats.attack_self_knock_back_strength
		move_and_slide()

func _on_aggro_detection_area_2d_body_entered(body):
	if body is Player:
		has_player_in_range = true

func _on_aggro_detection_area_2d_body_exited(body):
	if body is Player:
		has_player_in_range = false
