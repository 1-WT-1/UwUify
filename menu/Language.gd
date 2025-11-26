extends "res://menu/Language.gd"

	#TODO: Somehow load en_HK.png into this script.
#onready var icons = {
#	"en_HK": preload("res://menu/i18n/en_HK.png"), 
#}


func fillInLanguages():
	if not "en_HK" in icons:
		icons.merge({"en_HK":preload("res://menu/i18n/en_HK.png")})
		.fillInLanguages()
		
