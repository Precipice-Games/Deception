#Might add: slide speed if there 
#is time.  More importantly, fix bugs in current stuff. Fix cloud movement when player moves bug. Fading between screens like Menu and Credits or Menu and Story then starting the game.  After dash, doesn't set speed to sprint when hits ground, 
#you don't slow down transitioning from dash to sprint when you hit ground.  Also dash not stoping after .2 seconds.  
#Sprint: Stop delay in speed boost after double tap, 
#immediately goes to speed acceloration.  Add momentum in air/ground too.  Make speed slow down/accelarate more smoothly, movement in general.  
#Dash: Horizontal travel same distance every time you air dash.  Could add pause menu, quit returns to Menu. Fix moving tommorow, use chatGPT for help.
extends CharacterBody2D


@export var walkSPEED = 300.0
@export var sprintSPEED =500.0
@export var JUMP_VELOCITY = -400.0
var dashing = false
var SPEED = sprintSPEED #was walkSPEED
var canDash= true
var isrunning = false
var direction = 0
var fall = 1000
var target_position = Vector2()



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprint = false

func _ready():
	target_position = position  # Initialize target position

func _physics_process(delta):
	# Smoothly move towards the target position
	var direction_dash = (target_position - position).normalized()
	velocity.x = direction_dash.x * sprintSPEED	

	if global_position.y > fall:
		print(global_position.y, " ", fall)
		game_over()
	
	
	
	if Input.is_action_pressed("dash") and not is_on_floor() and Input.is_action_pressed("move_right") and canDash==true:
		$AnimatedSprite2D.play("punch")
		target_position.x += 75
		canDash=false
		$canDashTimer.start(1)
	if Input.is_action_pressed("dash") and not is_on_floor() and Input.is_action_pressed("move_left") and canDash==true:
		$AnimatedSprite2D.play("punch")
		target_position.x -= 75
		canDash=false
		$canDashTimer.start(1)


	# Add the gravity.
	var facing_direction = 0
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _input(event):
	
	
	
	if event.is_action_pressed("move_left"):
		direction = -1
		isrunning = true
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("runbig")
		
		
	if event.is_action_pressed("move_right"):
		direction = 1
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("runbig")
		isrunning = true
		
	if direction == 0:
		$AnimatedSprite2D.play("idle3")
	
	if event.is_action_pressed("punch"):
		$AnimatedSprite2D.play("punch")
	
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump3")
		$JumpTimer.start()
		
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


#Add sprint code from ajay laptop computer
	

func game_over():
	get_tree().reload_current_scene()


func _on_can_dash_timer_timeout():
	canDash=true
	


func _on_damage_detector_area_entered(area):
	if area.is_in_group("harmful"):
		game_over()


func _on_direction_sprint_timer_timeout():
	if !Input.is_action_pressed("move_right") or !Input.is_action_pressed("move_left"):
		SPEED = walkSPEED
		isrunning=false
		


func _on_jump_timer_timeout():
	$AnimatedSprite2D.play("idle3")





func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
