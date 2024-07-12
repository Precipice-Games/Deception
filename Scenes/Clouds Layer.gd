extends CanvasLayer

@export var cloud_speed = 250
var cloud_offset = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		var notifier := child.get_node("./VisibleOnScreenNotifier2D") as VisibleOnScreenNotifier2D
		notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited.bind(notifier.get_parent()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_clouds(delta)
	
	


func spawn_obstacle():
	pass


func scroll_clouds(delta):
	for child in get_children():
		var obstacle := child as Node2D
		obstacle.position.x -= cloud_speed * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited(cloud):
	print(cloud.name, " is off screen")
	cloud.position.x += 3 * (cloud.get_rect().size.x)*10
	#$Clouds.position.x += 1152
	#$BigClouds.position.x += 1152
	#$BigClouds2.position.x += 1152
	#$BigClouds3.position.x += 1152
	
	
	
	
