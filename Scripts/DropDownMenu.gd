extends Control

onready var popup = $PopupMenu
func _ready():
	get_node("../../YSort/Player").connect("dropmenu", self, "drop_down")

func drop_down():
	popup.visible = !popup.visible
	get_tree().set_pause(!get_tree().paused)
