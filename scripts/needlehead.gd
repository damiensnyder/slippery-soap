extends CharacterBody2D

const SOAP = preload("res://scenes/soap.tscn")
@onready var sprite = $Sprite2D
@onready var collision_polygon_2d = $Area2D/CollisionPolygon2D

const SPEED = 2.0
const ROTATION_SPEED = 4

var speed

enum states {ALIVE, DYING}
var state = states.ALIVE

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = SPEED


func _physics_process(delta):
	match state:
		states.ALIVE: alive_state()
		states.DYING: dying_state()


func alive_state():
	if Globals.ammo <= 0 and Globals.player_popped == false:
		speed = lerp(speed, SPEED * 8.0, 0.02)
	else: speed = lerp(speed, SPEED, 0.02)
	
	if (Globals.player_position - position).length() > 1500:
		return
	var player_direction = Globals.player_position - position
	var angle_to_player = atan2(player_direction.y, player_direction.x)
	var direction = Vector2(cos(rotation), sin(rotation))
	
	rotation = rotate_toward(rotation, angle_to_player, 0.01 * ROTATION_SPEED)
	velocity = direction * speed
	
	var collision = move_and_collide(velocity)
	if collision:
		velocity = velocity.bounce(collision.get_normal())


func dying_state():
	sprite.modulate.a = lerp(sprite.modulate.a, 0.0, 0.2)
	scale = lerp(scale, Vector2(1.5,1.5), 0.1)
	
	if sprite.modulate.a < 0.01: queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player Projectiles") and body.state == body.states.INAIR and body.visible == true and state == states.ALIVE:
		die(body)


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
