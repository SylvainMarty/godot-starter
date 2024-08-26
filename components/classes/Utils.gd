extends Object
class_name Utils

static func get_nodes_in_group(node: Node, groupName: String):
	var nodes_in_group = []
	for child in node.get_children():
		if child.is_in_group(groupName):
			nodes_in_group.append(child)
	return nodes_in_group

## Find the first child of a node with the given type
## Optionally, you can ask for the first nested children
## Code from https://github.com/godotengine/godot-proposals/issues/3661#issuecomment-1765329487
static func get_child_of_type(node: Node, child_type, nested := false):
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if is_instance_of(child, child_type):
			return child
		if nested:
			var child_node = get_child_of_type(child, child_type, nested)
			if child_node:
				return child_node
	return null

## Find the children of a node with the given type
## Optionally, you can ask for the nested children
## From https://github.com/godotengine/godot-proposals/issues/3661#issuecomment-1765329487
static func get_children_of_type(node: Node, child_type, nested := false):
	var list = []
	for i in range(node.get_child_count()):
		var child = node.get_child(i)
		if is_instance_of(child, child_type):
			list.append(child)
		if nested:
			list += get_children_of_type(child, child_type, nested)
	return list

## Get the name of the input based on the InputMap action and the current layout
static func get_key_name(action: StringName):
	# Gets the first input event attached to an action.
	var events = InputMap.action_get_events(action)
	if events.is_empty():
		return
	var event = events[0]
	# Returns if the event is not a key.
	if not event is InputEventKey:
		return
	return OS.get_keycode_string(
		DisplayServer.keyboard_get_label_from_physical(
			event.physical_keycode
		)
	)

static func load_async(path_to_resource: String, scene_tree: SceneTree) -> Resource:
	ResourceLoader.load_threaded_request(path_to_resource)
	var load_status
	while true:
		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		await scene_tree.create_timer(0.1).timeout
		load_status = ResourceLoader.load_threaded_get_status(path_to_resource)
	return ResourceLoader.load_threaded_get(path_to_resource)
