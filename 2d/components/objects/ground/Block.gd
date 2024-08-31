@tool

extends StaticBody2D

class_name Block

@export var width: int = 32:
	set(new_val):
		width = new_val
		update_sprite_region_size()
@export var height: int = 32:
	set(new_val):
		height = new_val
		update_sprite_region_size()
@export var texture: Texture2D:
		set(new_texture):
			texture = new_texture
			if $Sprite2D:
				$Sprite2D.texture = texture

func update_sprite_region_size():
	$Sprite2D.region_rect.size.x = width
	$Sprite2D.region_rect.size.y = height
	$CollisionShape2D.shape.size.x = width
	$CollisionShape2D.shape.size.y = height
	$CollisionShape2D.transform.origin.x = width / 2
	$CollisionShape2D.transform.origin.y = height / 2

func _get_configuration_warnings():
	var warnings = []

	if not texture:
		warnings.append("The texture (Texture2D) is needed")

	# Returning an empty array means "no warning".
	return warnings
