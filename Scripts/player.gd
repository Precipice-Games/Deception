#Might add: slide speed if there 
#is time.  More importantly, fix bugs in current stuff.  After dash, doesn't set speed to sprint when hits ground, 
#you don't slow down transitioning from dash to sprint when you hit ground.  Also dash not stoping after .2 seconds.  
#Sprint: Stop delay in speed boost after double tap, 
#immediately goes to speed acceloration.  Add momentum in air/ground too.  Make speed slow down/accelarate more smoothly, movement in general.  
#Dash: Horizontal travel same distance every time you air dash.
extends CharacterBody2D


@export var walkSPEED = 300.0
@export var sprintSPEED =500.0
@export var JUMP_VELOCITY = -400.0
var dashing = false
var SPEED = walkSPEED
var canDash= true
var isrunning = false
var direction = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprint = false

func _physics_process(delta):
	if Input.is_action_pressed("dash") and not is_on_floor() and Input.is_action_pressed("move_right") and canDash==true:
		position.x += 50
		canDash=false
		$canDashTimer.start(1)
	if Input.is_action_pressed("dash") and not is_on_floor() and Input.is_action_pressed("move_left") and canDash==true:
		position.x -= 50
		canDash=false
		$canDashTimer.start(1)

	# Add the gravity.
	var facing_direction = 0
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _input(event):
	if direction == 0:
		$AnimatedSprite2D.play("idle2")
	
	if event.is_action_pressed("punch"):
		$AnimatedSprite2D.play("punch")
	
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("JUMP")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# is dashing then return and ignore any input
	if dashing==true:
		return # returning gets out of the function immediately and does not process any of the following code


		if is_on_floor():
			SPEED = sprintSPEED
	if event.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("running")
		isrunning = true
		if $GameTimer.is_stopped():
			print("one press")
			$GameTimer.start()
		else:
			print("sprint")
			sprint = true
			$GameTimer.stop()
			$sprintTimer.start(2)
			SPEED=sprintSPEED
	if event.is_action_released("move_right") and $sprintTimer.is_stopped():
		SPEED = walkSPEED
	if event.is_action_pressed("move_left"):
		isrunning = true
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("running")
		if $GameTimer.is_stopped():
			#print("one press")
			$GameTimer.start()
		else:
			print("dash")
			sprint = true
			$GameTimer.stop()
			$sprintTimer.start(2)
			SPEED=sprintSPEED
	if event.is_action_released("move_left") and $sprintTimer.is_stopped():
		SPEED = walkSPEED
	





func _on_can_dash_timer_timeout():
	canDash=true
	


func _on_damage_detector_area_entered(area):
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
