extends CharacterBody2D

const SOAP = preload("res://scenes/soap.tscn")
@onready var sprite = $Sprite2D
@onready var collision_polygon_2d = $Area2D/CollisionPolygon2D

const SPEED = 1.5

var rotation_speed = 4
var original_rotation = 0

enum states {ALIVE, DYING}
var state = states.ALIVE

# Called when the node enters the scene tree for the first time.
func _ready():
	original_rotation = get_angle_to(Globals.player_position) + randf_range(-0.7, 0.7)
	rotation = original_rotation
	if randi() == 0:
		rotation_speed *= -1


func _physics_process(delta):
	match state:
		states.ALIVE: alive_state()
		states.DYING: dying_state()


func alive_state():
	var direction = Vector2(cos(original_rotation), sin(original_rotation))
	velocity = direction * SPEED
	rotation += rotation_speed * 0.01
	
	move_and_collide(velocity)


func dying_state():
	sprite.modulate.a = lerp(sprite.modulate.a, 0.0, 0.2)
	scale = lerp(scale, Vector2(0.9,0.9), 0.1)
	
	if sprite.modulate.a < 0.01: queue_free()


func _on_blade_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player Projectiles") and body.state == body.states.INAIR and state == states.ALIVE:
		die(body)
	elif body.is_in_group("Walls"):
		state = states.DYING

func die(body):
	AudioSuite.pshew_player.play()
	if body: body.state = body.states.POSTHIT
	var amt
	match Globals.gun_upgrade_lvl:
		0: amt = 3
		1: amt = 5
		
	for i in amt:
		var new_soap = SOAP.instantiate()
		new_soap.position = position
		new_soap.velocity = Vector2(
			randf_range(-10,10),
			randf_range(-10,10)
		)
		get_node("/root/GameManager").add_child(new_soap)
	collision_polygon_2d.disabled = true
	state = states.DYING
