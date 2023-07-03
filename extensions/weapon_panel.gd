class_name WeaponBar
extends Control

var _weapon:Weapon
var _weapon_data:WeaponData
var _current_max_damage:int = 0

onready var _damage_label = $"%DamageLabel"
onready var _progress_bar:TextureProgress = $"%UIProgressBar"
onready var _pos_label:Label = $"%PosLabel"
onready var _icon:Button = $"%Icon"
onready var _killed_label:Label = $"%KilledLabel"

func _ready():
	_icon.icon = _weapon_data.icon
	_pos_label.text = str(_weapon.weapon_pos + 1)
	update_weapon_background_color()
	_killed_label.hide() # bugs here for nb_enemies_killed_this_wave

var _time_since_last_update = 0.0
const update_interval = 1.0

# check for every 1 sec
func _process(delta):
	_time_since_last_update += delta
	if  _time_since_last_update < update_interval:
		return
	if not visible:
		return
	_time_since_last_update = 0.0
	_damage_label.text = str(_weapon_data.dmg_dealt_last_wave)
	_killed_label.text = str(_weapon.nb_enemies_killed_this_wave)
	update_progress_ui()

func update_progress_ui():
	if _current_max_damage == 0:
		_progress_bar.value = 0
	else:
		_progress_bar.value = 100.0 * _weapon_data.dmg_dealt_last_wave / _current_max_damage

func update_weapon_background_color(p_color:int = - 1)->void :
	var tier = _weapon_data.tier
	var stylebox_color:StyleBoxFlat = _icon.get_stylebox("normal").duplicate()
	ItemService.change_inventory_element_stylebox_from_tier(stylebox_color, p_color if p_color != - 1 else tier, 0.25)
	_icon.add_stylebox_override("normal", stylebox_color)
