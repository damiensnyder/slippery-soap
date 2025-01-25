extends CharacterBody2D

const SOAP = preload("res://scenes/soap.tscn")

const SPEED = 2
const ROTATION_SPEED = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var player_direction = Globals.player_position - position
	var angle_to_player = atan2(player_direction.y, player_direction.x)
	var direction = Vector2(cos(rotation), sin(rotation))
	
	rotation = rotate_toward(rotation, angle_to_player, 0.01 * ROTATION_SPEED)
	velocity = direction * SPEED
	
	move_and_collide(velocity)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player Projectiles"):
		for i in 3:
			var new_soap = SOAP.instantiate()
			new_soap.position = position
			new_soap.velocity = Vector2(
				randf_range(-10,10),
				randf_range(-10,10)
			)
			get_node("/root/GameManager").add_child(new_soap)
		queue_free()
