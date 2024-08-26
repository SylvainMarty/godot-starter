@tool

extends Actionable

const INTERACT_ACTION = "interact"

## The translation key for this object (see res://assets/contents/inspectable_content.csv)
@export var inspectable_object_key: String
## If enabled, the content of the inspectable object is displayed automatically
@export var display_content_automatically: bool = false
## The content panel minimum width in pixels.
##
## Change this value if you want to display more text before line break.
@export var panel_minimum_width: float
## Set a Marker2D for the inspectable content (if not provided, it uses content_position).
@export var custom_content_position: Marker2D

@onready var inspectable_content_popup_panel = $InspectableContentPopupPanel
@onready var inspectable_content_label: RichTextLabel = $InspectableContentPopupPanel/InspectableContent

var can_be_interacted_with: bool = false

func _on_ready():
	inspectable_content_label.text = tr(inspectable_object_key)
	if panel_minimum_width and panel_minimum_width > 0:
		inspectable_content_label.custom_minimum_size = Vector2(panel_minimum_width, 0.0)
	hide_content_popup()
	actionable.connect(self._on_actionable)

func _on_actionable(is_actionable):
	if display_content_automatically and is_actionable:
		show_content_popup()
	else:
		can_be_interacted_with = is_actionable
	if not is_actionable:
		hide_content_popup()

func show_content_popup():
	hide_hint_popup()
	if custom_content_position:
		inspectable_content_popup_panel.global_position = custom_content_position.global_position
	elif content_position:
		inspectable_content_popup_panel.global_position = content_position.global_position
	inspectable_content_popup_panel.show()

func hide_content_popup():
	inspectable_content_popup_panel.hide()

func _process(delta):
	if can_be_interacted_with and Input.is_action_pressed(INTERACT_ACTION):
		show_content_popup()
