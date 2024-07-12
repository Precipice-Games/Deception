extends CharacterBody2D

enum {HOVER, FALL, LAND, RISE}

var state = HOVER

@onready var start_position = global_position
@onready var timer = $Timer
@onready var raycast: = $RayCast2D
@onready var animatedsprite = $AnimatedSprite2D

func _physics_process(delta):
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)
	move_and_slide()
		
	
func hover_state():
	if timer.time_left == 0: timer.start
	state = FALL
	velocity.y = 0
	
func fall_state(delta):
	animatedsprite.play("Falling")
	velocity.y += 3000 * delta
	if is_on_floor():
	#if raycast .is_colliding():
		#var collision_point = raycast.get_collision_point()
		#position.y = collision_point.y
		state = LAND
		timer.start(1.0)

func land_state():
	animatedsprite.play("Ground")
	if timer.time_left == 0:
		state = RISE
	
func rise_state(delta):
	animatedsprite.play("Rising")
	velocity.y = 5000 * delta
	if position.y == start_position.y:
		state = HOVER
