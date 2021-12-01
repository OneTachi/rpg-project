extends Node


func splash_over():
	get_tree().change_scene("res://Scenes/World/MainMenu.tscn")

func menu_start():
	get_tree().change_scene("res://Scenes/World/World.tscn")
func menu_quit():
	get_tree().quit()





