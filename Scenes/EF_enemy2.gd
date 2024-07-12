extends Area2D

@export var bulletshooter_scene: PackedScene

var canShoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.frame == 4:
		var bullet:Node2D = bulletshooter_scene.instantiate()
		add_child(bullet)
		bullet.global_position = $BulletSpawn.global_position
		
