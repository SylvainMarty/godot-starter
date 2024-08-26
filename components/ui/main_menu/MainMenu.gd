extends CanvasLayer
class_name MainMenu

@onready var start_menu_panel_container = $StartMenuPanelContainer
@onready var pause_menu_panel_container = $PauseMenuPanelContainer
@onready var player_died_panel_container = $PlayerDiedPanelContainer
@onready var village_died_panel_container = $VillageDiedPanelContainer
@onready var village_saved_menu_panel_container = $VillageSavedMenuPanelContainer

func _ready():
	hide_all_menus()

func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		if not get_tree().paused:
			show_pause_menu()
		else:
			resume_game()

func hide_all_menus():
	start_menu_panel_container.hide()
	pause_menu_panel_container.hide()
	player_died_panel_container.hide()
	village_died_panel_container.hide()
	village_saved_menu_panel_container.hide()

func show_pause_menu():
	pause_game()
	pause_menu_panel_container.show()

func show_start_menu():
	pause_game()
	start_menu_panel_container.show()

func show_player_died_menu():
	pause_game()
	player_died_panel_container.show()

func show_village_died_menu():
	pause_game()
	village_died_panel_container.show()

func show_village_saved_menu():
	pause_game()
	village_saved_menu_panel_container.show()

func pause_game():
	get_tree().paused = true

func resume_game():
	hide_all_menus()
	get_tree().paused = false

func restart_game():
	resume_game()
	BiomeManager.init()
	BiomeManager.has_game_restarted = true
	CharacterState.init()
	VillageState.init()
	get_tree().reload_current_scene()

func _on_start_game_button_pressed():
	resume_game()

func _on_start_new_game_button_pressed():
	restart_game()

func _on_restart_game_button_pressed():
	restart_game()
