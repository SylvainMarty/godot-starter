extends Actionable

var can_pick_up = false
var pickable_object

func _on_ready():
	actionable.connect(self._on_pick_up_actionable)
	var children = get_children()
	for child in children:
		if child.is_in_group("pickable"):
			pickable_object = child
			break


func _on_pick_up_actionable(is_actionable):
	can_pick_up = is_actionable


func _process(delta):
	if can_pick_up and Input.is_action_pressed("interact"):
		remove_child(pickable_object)
		CharacterState.add_object(pickable_object)
		queue_free()
