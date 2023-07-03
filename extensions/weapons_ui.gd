extends Control

var _weapons_data: Array = []  # WeaponData
var _weapons:Array = []
var _player:Player
var weapon_panels: Array = []

onready var _weapon_ui = $WeaponUI
onready var _weapons_node:VBoxContainer = $"%Weapons"
onready var weapon_bar_scene = preload("res://mods-unpacked/Crimson-WeaponDamage/extensions/weapon_panel.tscn")
onready var _button:Button = $Button




func _ready():
	ModLoaderLog.info("Weapons ui ready", "WeaponDamage")
	_player = get_node("/root/Main/Entities/Player")
	_weapons_data = RunData.weapons
	_weapons = _player.current_weapons
	
	add_panels()
	_button.connect("toggled", self, "_on_button_toggled")
	
func _on_button_toggled(should_hide:bool):
	if should_hide &&  _weapon_ui.visible:
		_weapon_ui.hide()
	elif !should_hide && !_weapon_ui.visible:
		_weapon_ui.show()
		check_update()
		
	if should_hide:
		_button.rect_scale.y = -1
		_button.rect_position.y += _button.rect_size.y
	else:
		_button.rect_scale.y = 1
		_button.rect_position.y -= _button.rect_size.y
	
func add_panels():
	for i in _weapons.size():
		var weapon = _weapons[i]
		var weapon_data = _weapons_data[i]
		var weapon_panel = weapon_bar_scene.instance()
		weapon_panel._weapon = weapon
		weapon_panel._weapon_data = weapon_data
		weapon_panels.append(weapon_panel)
	
	for weapon_panel in weapon_panels:
		_weapons_node.add_child(weapon_panel)
		
var _time_since_last_update = 0.0
const update_interval = 1.0

func check_update():
	var max_dmg = 0
	for weapon in _weapons_data:
		max_dmg = max(max_dmg, weapon.dmg_dealt_last_wave)
		
	for panel in weapon_panels:
		panel._current_max_damage = max_dmg
	_sort_weapons_by_damage()

		
# check for every 1 sec
func _process(delta):
	_time_since_last_update += delta
	if  _time_since_last_update < update_interval:
		return
	_time_since_last_update = 0.0
	if $"/root/Main"._wave_timer.time_left < .05:
		if visible:
			hide()
			
	if not _weapon_ui.visible:
		return
		
	check_update()
	

func sort_func(a, b):
	return a._weapon_data.dmg_dealt_last_wave > b._weapon_data.dmg_dealt_last_wave
	
func _sort_weapons_by_damage():
	var children = _weapons_node.get_children() # const ref
	var sortable = []
	for child in children:
		sortable.append(child)
	sortable.sort_custom(self, "sort_func")
	for i in sortable.size():
		var child:Node = sortable[i]
		_weapons_node.move_child(child, i)
	

