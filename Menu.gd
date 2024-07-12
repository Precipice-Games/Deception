extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://node.tscn")







func _on_quit_button_pressed():
	get_tree().quit()


func _on_credits_button_pressed():
	var credits:PackedScene = load("res://Scenes/Credits.tscn")
	#get_tree().current_scene.add_child(credits)
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
