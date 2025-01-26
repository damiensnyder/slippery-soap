extends CharacterBody2D

const SOAP = preload("res://scenes/soap.tscn")

const SPEED = 1.5

var rotation_speed = 4
var original_rotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	original_rotation = get_angle_to(Globals.player_position) + randf_range(-0.7, 0.7)
	rotation = original_rotation
	if randi() == 0:
		rotation_speed *= -1


func _physics_process(delta):
	var direction = Vector2(cos(original_rotation), sin(original_rotation))
	velocity = direction * SPEED
	rotation += rotation_speed * 0.01
	
	move_and_collide(velocity)


func _on_blade_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles") and body.state == body.states.INAIR:
		body.state = body.states.POSTHIT
		for i in 3:
			var new_soap = SOAP.instantiate()
			new_soap.position = position
			new_soap.velocity = Vector2(
				randf_range(-10,10),
				randf_range(-10,10)
			)
			get_node("/root/GameManager").add_child(new_soap)
		queue_free()
	elif body.is_in_group("Walls"):
		queue_free()
