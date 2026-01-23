extends Node
const MOD_PRIORITY = -999999999
const MOD_NAME = "UwUify"
const MOD_VERSION_MAJOR = 0
const MOD_VERSION_MINOR = 3
const MOD_VERSION_BUGFIX = 1
const MOD_VERSION_METADATA = "UwU"
const MOD_IS_LIBRARY = false
var modPath:String = get_script().resource_path.get_base_dir() + "/"
var _savedObjects := []


func _init(modLoader = ModLoader):
	l("Initializing")
	#replaceScene("menu/i18n/en_HK.png")
	installScriptExtension("menu/Language.gd")
	loadDLC()

func _ready():
	l("Readying")
	Settings.languages["en_HK"] = "Engwish (UwU)"
	l("Ready")



func installScriptExtension(path:String, p_parentPath:String = ""):
	var childPath:String = str(modPath + path)
	var childScript:Script = ResourceLoader.load(childPath)

	childScript.new()

	var parentScript:Script = childScript.get_base_script()
	var parentPath:String = parentScript.resource_path
	
	if parentPath == null or parentPath.empty():
		if not p_parentPath.empty():
			parentPath = p_parentPath
		else:
			l("Failed to get parent path for %s (parentScript is null?) and no manual path provided" % childPath)
			return

	l("Installing script extension: %s <- %s" % [parentPath, childPath])

	childScript.take_over_path(parentPath)


func replaceScene(newPath:String, oldPath:String = ""):
	l("Updating scene: %s" % newPath)

	if oldPath.empty():
		oldPath = str("res://" + newPath)

	newPath = str(modPath + newPath)

	var scene := load(newPath)
	scene.take_over_path(oldPath)
	_savedObjects.append(scene)
	l("Finished updating: %s" % oldPath)


func loadDLC():
	l("Preloading DLC as workaround")
	var DLCLoader:Settings = preload("res://Settings.gd").new()
	DLCLoader.loadDLC()
	DLCLoader.queue_free()
	l("Finished loading DLC")


func l(msg:String, title:String = MOD_NAME):
	Debug.l("[%s]: %s" % [title, msg])
