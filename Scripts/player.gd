extends CharacterBody2D


@export var walkSPEED = 300.0
@export var dashSPEED =500.0
@export var JUMP_VELOCITY = -400.0
var dashing = false
var SPEED = walkSPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash = false


func _physics_process(delta):
	# Add the gravity.
	var facing_direction =0
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _input(event):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# is dashing then return and ignore any input
	if dashing==true:
		return # returning gets out of the function immediately and does not process any of the following code


	if event.is_action_pressed("move_right"):
		if $GameTimer.is_stopped():
			print("one press")
			$GameTimer.start()
		else:
			print("dash")
			dash = true
			$GameTimer.stop()
			$dashTimer.start(2)
			SPEED=dashSPEED
	if event.is_action_released("move_right") and $dashTimer.is_stopped():
		SPEED = walkSPEED
	if event.is_action_pressed("move_left"):
		if $GameTimer.is_stopped():
			print("one press")
			$GameTimer.start()
		else:
			print("dash")
			dash = true
			$GameTimer.stop()
			$dashTimer.start(2)
			SPEED=dashSPEED
	if event.is_action_released("move_left") and $dashTimer.is_stopped():
		SPEED = walkSPEED
