extends CharacterBody2D

enum {HOVER, FALL, LAND, RISE}

var state = HOVER

@onready var start_position = global_position
@onready var timer = $Timer
@onready var raycast: = $RayCast2D

func _physics_process(delta):
	match state:
		HOVER: hover_state()
		FALL: fall_state()
		LAND: pass
		RISE: pass
		
	
func hover_state():
	if timer.time_left == 0: timer.start
	state = FALL
	
func fall_state():
	position.y += 10
	if raycast .is_colliding():
		var collision_point = raycast.get_collision_point()
		position.y = collision_point.y
		state = LAND
		
		func land_state():
			pass 
