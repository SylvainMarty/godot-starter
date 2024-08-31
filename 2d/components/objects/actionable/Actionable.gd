@tool

extends Node2D
class_name Actionable

signal actionable(is_actionable: bool)

## The translation key for this object (see res://assets/contents/inspectable_content.csv)
@export var actions: Array[String]
@export var action_labels: Array[String]
@export var content_position: Marker2D

var area_2D: Area2D
@onready var hint_popup_panel = $HintPopupPanel
@onready var hint_label = $HintPopupPanel/HintLabel

func _ready():
	prepare_hints()
	hide_hint_popup()
	area_2D = Utils.get_child_of_type(self, Area2D)
	if area_2D:
		area_2D.body_entered.connect(self._on_body_entered)
		area_2D.body_exited.connect(self._on_body_exited)
	_on_ready()

func prepare_hints():
	var label_texts = []
	for i in range(actions.size()):
		label_texts.append(action_labels[i] % Utils.get_key_name(actions[i]))
	hint_label.text = "\n".join(label_texts)

func _on_body_entered(body):
	show_hint_popup()
	actionable.emit(true)

func _on_body_exited(body):
	hint_popup_panel.hide()
	actionable.emit(false)

func show_hint_popup():
	if content_position:
		hint_popup_panel.global_position = content_position.global_position
	hint_popup_panel.show()

func hide_hint_popup():
	hint_popup_panel.hide()

func _get_configuration_warnings():
	var warnings = []
	if actions.is_empty():
		warnings.append("Actionable node needs at least one actions value")
	if action_labels.is_empty():
		warnings.append("Actionable node needs at least one action_labels value")
	if actions.size() != action_labels.size():
		warnings.append("Actionable node: actions and action_labels must have the same size")
	if not area_2D:
		warnings.append("Actionable node needs an Area2D child")
	# Returning an empty array means "no warning".
	return warnings

func _on_ready():
	return
