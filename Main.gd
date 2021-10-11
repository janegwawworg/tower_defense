extends Node

onready var _player := $Player
onready var _level := $Level1
onready var _hud := $UILayer/UI/HUD
onready var _tower_shop := $UILayer/UI/HUD/UITowerShop
onready var _screen_overlay := $UILayer/UI/UIScreenOverlay
onready var _mouse_barrier := $UILayer/UI/MouseBarrier
onready var _retry_button := $UILayer/UI/HUD/RetryButton
onready var _start_button := $UILayer/UI/HUD/StartButton
onready var _gold_panel := $UILayer/UI/HUD/UIGoldPanel


func _ready() -> void:
	_tower_shop.player = _player
	_gold_panel.player = _player
	_setup_level1()
	_level.start()
	
	
func _setup_level1() -> void:
	_level.connect("base_destroyed", self, "_on_Level_base_destroyed")
	_level.connect("finished", self, "_on_Level_finished")
	_level.connect("gold_earned", self, "_on_Level_gold_earned")
	_level.connect("round_finished", self, "_on_Level_round_finished")
	
	_level.tower_placer.connect("tower_placed", _tower_shop, "_on_TowerPlacer_tower_placed")
	_tower_shop.connect("tower_purchased", _level.tower_placer, "add_new_tower")


func _toggle_interface() -> void:
	_hud.visible = not _hud.visible
	_toggle_mouse_barrier()


func _toggle_mouse_barrier() -> void:
	_mouse_barrier.visible = not _mouse_barrier.visible


func _on_StartButton_pressed() -> void:
	_toggle_interface()
	get_tree().call_group("selected", "set_selected", false)
	yield(_screen_overlay.play_wave_start_async(), "completed")
	_level.start()


func _on_Level_round_finished() -> void:
	_toggle_interface()
	_level.show_walkable_path()


func _on_Level_finished() -> void:
	_screen_overlay.play_win()


func _on_Level_base_destroyed() -> void:
	_start_button.hide()
	_tower_shop.hide()
	_retry_button.show()
	yield(_screen_overlay.play_lost(), "completed")
	_toggle_interface()


func _on_RetryButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_Level_gold_earned(gold_amount) -> void:
	_player.gold += gold_amount
