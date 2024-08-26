extends StaticBody2D

func _on_save_village_area_2d_body_entered(body):
	if not body is Player:
		return
	if Constants.FlowerColor.BLUE in body.flowers:
		VillageState.save_village()
