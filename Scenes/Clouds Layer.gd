extends CanvasLayer

@export var cloud_speed = 50
@export var player:CharacterBody2D
var cloud_offset = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_clouds(delta)
	
	


func spawn_obstacle():
	pass


func scroll_clouds(delta):
	for child in get_children():
		var obstacle := child as Node2D
		obstacle.position.x -= cloud_speed * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited(obstacle:Node2D):
	if obstacle.name.begins_with("BigClouds"):
		pass
	
