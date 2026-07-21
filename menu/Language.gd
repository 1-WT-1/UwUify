extends "res://menu/Language.gd"

const MOD_NAME = "UwUify"

func fillInLanguages():
	Settings.languages["en_HK"] = "Engwish (UwU)"
	if not icons.has("en_HK"):
		var tex = load_external_tex("res://UwUify/menu/i18n/en_HK.png")
		if tex:
			icons["en_HK"] = tex
			l("Added en_HK icon")	
	.fillInLanguages()

func load_external_tex(path) -> Texture:
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex

func l(msg:String, title:String = MOD_NAME):
	Debug.l("[%s]: %s" % [title, msg])
