extends CharacterBody2D

const BLULLET = preload("res://scenes/blullet.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var angular_velocity = 0

var lateral_recoil = 5
var angular_recoil = 10
var bullet_speed = 10
var lateral_air_friction = 1
var angular_air_friction = 2

@onready var left_gun_anim = $LeftGun/LeftGunAnim
@onready var right_gun_anim = $RightGun/RightGunAnim


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	debug_controls()
	
	var direction = Vector2(cos(rotation), sin(rotation))
	var leftgun_rotation = atan2(direction.y, direction.x) # + PI/4
	var rightgun_rotation = atan2(direction.y, direction.x) # - PI/4
	var leftgun_direction = Vector2(cos(leftgun_rotation), sin(leftgun_rotation))
	var rightgun_direction = Vector2(cos(rightgun_rotation), sin(rightgun_rotation))
	
	if Input.is_action_just_pressed("shoot left"):
		shoot(leftgun_direction, direction, left_gun_anim, 1)

	if Input.is_action_just_pressed("shoot right"):
		shoot(rightgun_direction, direction, right_gun_anim, -1)
	
	if Input.is_action_just_pressed("shoot forward"):
		shoot(leftgun_direction, direction, left_gun_anim, 1)
		shoot(rightgun_direction, direction, right_gun_anim, -1)
	
	angular_velocity = clampf(angular_velocity, -0.05, 0.05)
	velocity += Vector2(0, gravity * 0.004)
	velocity = lerp(velocity, Vector2(0, 0), 0.01 * velocity.length() * lateral_air_friction)
	angular_velocity = lerp(angular_velocity, 0.0, 0.01 * angular_air_friction)
	
	rotation += angular_velocity
	rotation = fmod(rotation + TAU, TAU)
	var collision = move_and_collide(velocity)
	
	if collision and collision.get_collider().has_method("is_wall"):
		velocity = velocity.bounce(collision.get_normal())
	
	Globals.player_position = position
	

func debug_controls():
	if Input.is_action_just_pressed("gravity up"): gravity += 0.7
	if Input.is_action_just_pressed("gravity down"): gravity -= 0.7

	if Input.is_action_just_pressed("lateral recoil up"): lateral_recoil += 0.5
	if Input.is_action_just_pressed("lateral recoil down"): lateral_recoil -= 0.5
	
	if Input.is_action_just_pressed("angular recoil up"): angular_recoil += 0.5
	if Input.is_action_just_pressed("angular recoil down"): angular_recoil -= 0.5

	if Input.is_action_just_pressed("bullet speed up"): bullet_speed += 1
	if Input.is_action_just_pressed("bullet speed down"): bullet_speed -= 1

	if Input.is_action_just_pressed("lateral friction up"): lateral_air_friction += 0.2
	if Input.is_action_just_pressed("lateral friction down"): lateral_air_friction -= 0.2

	if Input.is_action_just_pressed("angular friction up"): angular_air_friction += 0.2
	if Input.is_action_just_pressed("angular friction down"): angular_air_friction -= 0.2


func shoot(gun_direction, own_direction, gun_anim, flip):
	angular_velocity += 0.005 * flip * lateral_recoil
	velocity += gun_direction * lateral_recoil
	
	gun_anim.frame = 0
	gun_anim.play()
	
	var new_blullet = BLULLET.instantiate()
	new_blullet.velocity = -gun_direction * bullet_speed
	new_blullet.position = position + 80 * flip * Vector2(own_direction.y, -own_direction.x) - 70 * own_direction
	get_node("/root/GameManager").add_child(new_blullet)


func is_bubble():
	pass #im a bubble wahoo
