extends Node
const MOD_PRIORITY = 999999999
const MOD_NAME = "UwUify"
const MOD_VERSION_MAJOR = 0
const MOD_VERSION_MINOR = 2
const MOD_VERSION_BUGFIX = 0
const MOD_VERSION_METADATA = "UwU"
const MOD_IS_LIBRARY = false
var modPath:String = get_script().resource_path.get_base_dir() + "/"
var _savedObjects := []
var ConfigDriver = load("res://HevLib/pointers/ConfigDriver.gd")


func _init(modLoader = ModLoader):
	l("Initializing")
	loadDLC()

func _ready():
	l("Readying")
	UwU()
	l("Ready")

func UwU():
	
	updateTL("i18n/config.txt", "|")
	
	var config = ConfigDriver.__get_config("UwUify")
	l("Config loaded: %s" % str(config))
	
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableDialogue", true):
		updateTL("i18n/dialogue.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableEquipment", true):
		updateTL("i18n/equipment_descriptions.txt", "|")
		updateTL("i18n/equipment_manuals.txt", "|")
		updateTL("i18n/equipment_names.txt", "|")
		updateTL("i18n/equipment_specs.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableUI", true):
		updateTL("i18n/hud.txt", "|")
		updateTL("i18n/ui.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableTooltips", true):
		updateTL("i18n/tooltips.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableWorld", true):
		updateTL("i18n/misc.txt", "|")
		updateTL("i18n/oddities.txt", "|")
		updateTL("i18n/poi.txt", "|")
		updateTL("i18n/services.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableTips", true):
		updateTL("i18n/tips.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableTunes", true):
		updateTL("i18n/tunes.txt", "|")
		
	if config.get("UwUify_CONFIG_OPTIONS", {}).get("EnableShips", true):
		updateTL("i18n/ship_descriptions.txt", "|")
		updateTL("i18n/ship_names.txt", "|")
		updateTL("i18n/ship_specs.txt", "|")
	
	Settings.languages["en_HK"] = "Engwish (UwU)"


func updateTL(path:String, delim:String, useRelativePath:bool = true, fullLogging:bool = true):
	if useRelativePath:
		path = str(modPath + path)
	l("Adding translations from: %s" % path)
	var tlFile:File = File.new()
	if tlFile.open(path, File.READ) != OK:
		l("Failed to open translation file: %s" % path)
		return
	
	var translations := []
	
	var translationCount = 0
	var csvLine := tlFile.get_line().split(delim)
	if fullLogging:
		l("Adding translations as: %s" % csvLine)
	for i in range(1, csvLine.size()):
		var translationObject := Translation.new()
		translationObject.locale = csvLine[i]
		translations.append(translationObject)
	
	while not tlFile.eof_reached():
		csvLine = tlFile.get_csv_line(delim)
	
		if csvLine.size() > 1:
			var translationID := csvLine[0]
			for i in range(1, csvLine.size()):
				translations[i - 1].add_message(translationID, csvLine[i].c_unescape())
			if fullLogging:
				l("Added translation: %s" % csvLine)
			translationCount += 1
	
	tlFile.close()
	
	for translationObject in translations:
		TranslationServer.add_translation(translationObject)
	l("%s Translations Updated" % translationCount)


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
