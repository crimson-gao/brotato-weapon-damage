extends "res://main.gd"

var _size = Vector2(434, 490)

func _ready():
	var scene = preload("res://mods-unpacked/Crimson-WeaponDamage/extensions/weapons_ui.tscn")
	var _crimson_weapon_ui = scene.instance()
	var scale = 0.5
	_crimson_weapon_ui.rect_scale = Vector2(scale, scale)
	$UI.add_child_below_node($UI/HUD, _crimson_weapon_ui)
	var x = 1920 - 434 * scale
	_crimson_weapon_ui.rect_position = Vector2(x,600)
	
