extends Node

const MYMODNAME_MOD_DIR = "Crimson-WeaponDamage/"
const MYMODNAME_LOG = "Crimson-WeaponDamage"

var dir = ""


func _init(modLoader = ModLoader):
	name = "WeaponDamage"
	ModLoaderLog.info("Init", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR

	# Add extensions
	ModLoaderMod.install_script_extension(dir + "extensions/main.gd")
	

func _ready():
	ModLoaderLog.info("Mod WeaponDamage ready", MYMODNAME_LOG)
