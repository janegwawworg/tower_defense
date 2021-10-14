extends Control
class_name UIUpgradeShop

export(PackedScene) var upgrade_button_scene

onready var _panel := $Panel
onready var _container := $Panel/VBoxContainer
onready var _anim_player := $AnimationPlayer

var player := Player


func _on_TowerPlacer_tower_placed(tower: Tower) -> void:
	tower.connect("selected", self, "_on_Tower_selected", [tower])
	tower.connect("sold", self, "_on_Tower_sold")


func _on_Tower_selected(selected: bool, tower: Tower) -> void:
	_get_update(tower)
	if selected:
		appear()
	else:
		disappear()


func _on_Tower_sold(cost: int, place: Vector2) -> void:
	disappear()


func _get_update(tower) -> void:
	rect_global_position = tower.global_position

	for button in _container.get_children():
		button.queue_free()

	for upgrade in tower.get_upgrades():
		_add_upgrade_button(upgrade)



func _add_upgrade_button(upgrade) -> void:
	var button: UIUpgradeButton = upgrade_button_scene.instance()
	button._upgrade_display(upgrade, player.gold)
	button.connect("pressed", self, "_on_UpgradeButton_pressed", [button, upgrade])

	_container.add_child(button)


func _on_UpgradeButton_pressed(button: UIUpgradeButton, upgrade: Upgrade) -> void:
	if player.gold < upgrade.cost:
		return
	player.gold -= upgrade.cost
	upgrade.apply()
	button._upgrade_display(upgrade, player.gold)


func disappear() -> void:
	_anim_player.play("disappear")


func appear() -> void:
	rect_rotation = -90
	_panel.rect_rotation = 90
	if get_viewport_rect().encloses(_panel.get_global_rect()):
		_fit_panel_in_view()
	_anim_player.play("appear")


func _fit_panel_in_view() -> void:
	var center := get_viewport_rect().size * 0.5
	var angle := center.angle_to_point(rect_global_position - rect_pivot_offset)
	angle = round(angle / (PI / 4)) * (PI / 4)
	rect_rotation = rad2deg(angle)
	_panel.rect_rotation = -rect_rotation
