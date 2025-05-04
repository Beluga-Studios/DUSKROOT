extends Control

@onready var credits_label = $CreditsLabel

var version = ProjectSettings.get_setting("application/config/version")
var scroll_speed := 70  # pixels per second
var start_position := Vector2()


@export var p=["Name (username)",
	"Louis Pinel (rupoo04)","Angus Hammond (goose_man99)","Aman Jesly",
	"Ryan Falla (pikklchip)","Eddie Wright (3ddi3)","Marcus Ng (-zod-)"
]
# Hierarchical credits structure
var credits_data := {
	"Development Team": {
		"Game Design": [p[1]],
		"Programming": [p[1]],
		"Art & Animation": [p[0]],
		"Music & Sound": [p[4]],
		"Writing & Dialogue": [p[0]]
	},
	"Special Thanks": {
		"Playtesters": [p[3]],
		"Tools Used": ["Godot Engine", "VS Code"]
	},
	"Publishing": {
		"Studio": ["Beluga Studios"],
		#"Website": ["yourwebsite.com"]
	}
}

func _ready():
	credits_label.bbcode_enabled = true
	credits_label.text = generate_credits()
	start_position = credits_label.position
	set_process(true)

func generate_credits() -> String:
	var text := "[center][b]=== CREDITS ===[/b]\n\nDUSKROOT[/center]\n
[b]Version:[/b] %s\n\n" % version

	for section in credits_data.keys():
		text += "\n\n[center][b]%s[/b][/center]\n\n" % section
		for role in credits_data[section].keys():
			var names = credits_data[section][role]
			if names.size() <= 2:
				# One-liner if 1 or 2 names
				text += "[b]%s:[/b] %s\n" % [role, ", ".join(names)]
			else:
				# Multi-line with tab indentation
				text += "[b]%s:[/b]\n" % role
				for name in names:
					text += "\t• %s\n" % name
			text+="\n"
		text += "\n"

	text += "[i]Thanks for playing![/i]\n"
	return text



func _process(delta):
	credits_label.position.y -= scroll_speed * delta

	# Optional: quit or change scene when scrolled off screen
	if credits_label.position.y + credits_label.size.y < 0:
		SceneTransition.fade_scene_to_file("res://scenes/menu/main_menu.tscn",.0)
