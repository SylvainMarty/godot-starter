extends PanelContainer

@onready var health_points_label: Label = $MarginContainer/VBoxContainer/HealthGridContainer/HealthPoints
@onready var health_input: LineEdit = $MarginContainer/VBoxContainer/HealthGridContainer/HealthInput
@onready var invincible_switch = $MarginContainer/VBoxContainer/HealthGridContainer/InvincibleSwitch
@onready var level_list = $MarginContainer/VBoxContainer/LevelGridContainer/LevelList
@onready var tower_list = $MarginContainer/VBoxContainer/LevelGridContainer/HBoxContainer/TowerList
@onready var village_health_points = $MarginContainer/VBoxContainer/VillageHealthGridContainer2/VillageHealthPoints
@onready var village_invincible_switch = $MarginContainer/VBoxContainer/VillageHealthGridContainer2/VillageInvincibleSwitch

func _unhandled_input(event: InputEvent):
	if event is InputEventKey:
		return
	var current_focus_control = get_viewport().gui_get_focus_owner()
	if current_focus_control:
		get_viewport().gui_release_focus()

func _ready():
	set_healh_options()
	set_village_healh_options()
	set_level_options()
	CharacterState.health.health_updated.connect(self._on_character_health_updated)
	VillageState.health.health_updated.connect(self._on_village_health_updated)
	LevelManager.current_level_changed.connect(self._on_level_changed)

func _on_character_health_updated(hp):
	health_points_label.text = str(hp)

func _on_village_health_updated(hp):
	village_health_points.text = str(hp)

func set_healh_options():
	_on_character_health_updated(CharacterState.health.health_points)
	invincible_switch.button_pressed = CharacterState.health.invincible

func set_village_healh_options():
	_on_village_health_updated(VillageState.health.health_points)
	invincible_switch.button_pressed = VillageState.health.invincible

func set_level_options():
	_on_level_changed(LevelManager.curr_index, LevelManager.TowerId.TOWER_1)
	for tower_id in LevelManager.TowerId.values():
		tower_list.add_item("Tower %d" % (tower_id + 1), tower_id)

func _on_level_changed(current_level_index: int, tower_id: LevelManager.TowerId):
	tower_list.select(tower_id)
	level_list.select(current_level_index)

func _on_heal_button_pressed():
	CharacterState.health.heal(int(health_input.text))

func _on_damage_button_pressed():
	CharacterState.health.damage(int(health_input.text))

func _on_teleport_button_pressed():
	LevelManager.set_level(
		level_list.get_selected(),
		tower_list.get_selected()
	)

func _on_invincible_switch_toggled(toggled_on):
	invincible_switch.button_pressed = toggled_on
	CharacterState.health.invincible = invincible_switch.button_pressed

func _on_village_invincible_switch_toggled(toggled_on):
	village_invincible_switch.button_pressed = toggled_on
	VillageState.health.invincible = village_invincible_switch.button_pressed

func _on_kill_village_button_pressed():
	VillageState.health.set_health_points(0)

func _on_save_village_button_pressed():
	VillageState.save_village()

func _on_mute_sound_switch_toggled(toggled_on):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, toggled_on)
