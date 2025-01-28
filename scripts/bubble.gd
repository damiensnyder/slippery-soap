extends CharacterBody2D

const BLULLET = preload("res://scenes/blullet.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var angular_velocity = 0

var lateral_recoil = 10
var angular_recoil = 12
var bullet_speed = 10
var lateral_air_friction = 0.6
var angular_air_friction = 2.6
var is_popped = false
var has_run_out_of_ammo = false #this is so you don't get the "oh no" sound effect multiple times
var shots_fired = 0
var shields = 0

@onready var left_gun_anim = $LeftGun/LeftGunAnim
@onready var right_gun_anim = $RightGun/RightGunAnim
@onready var left_timer = $LeftTimer
@onready var right_timer = $RightTimer
@onready var floating_sprite: AnimatedSprite2D = $Sprite2D
@onready var popped_sprite: Sprite2D = $popped
@onready var left_gun = $LeftGun
@onready var right_gun = $RightGun
@onready var shield_sprite = $Shield

# Called when the node enters the scene tree for the first time.
func _ready():
	# velocity = Vector2(0, -50)
	floating_sprite.visible = true
	popped_sprite.visible = false
	shields = Globals.shield_upgrade_lvl
		
	if Globals.gun_upgrade_lvl > 0:
		left_gun_anim.animation = "upgraded"
		right_gun_anim.animation = "upgraded"
		left_gun_anim.scale = Vector2(1.25,1.25)
		right_gun_anim.scale = Vector2(1.25,1.25)
		left_gun_anim.rotation -= PI/4 + PI/8
		right_gun_anim.rotation += PI/4 + PI/8
		left_gun_anim.position.y += 225
		right_gun_anim.position.y += 225

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#debug_controls()
	
	if is_popped:
		angular_velocity = 0
		rotation += 0.05
		left_gun.rotation += 0.05
		right_gun.rotation += 0.05
		
		velocity += Vector2(0, 0.2)
		var collision = move_and_collide(velocity * 2)
		Globals.player_position = position
		if position.y > 700 and collision and (collision.get_collider().is_in_group("Walls")): #idk why groups alone don't work here
			AudioSuite.scream_player.stop()
			AudioSuite.ouch_player.play()
			if collision: velocity = velocity.bounce(collision.get_normal())
			Globals.ammo = Globals.max_ammo
			Globals.state = Globals.states.STORE #STORE
			get_tree().reload_current_scene()
		elif collision:
			velocity = velocity.bounce(collision.get_normal())
	
	shield_sprite.modulate.a = 0.2 * shields
	if Globals.ammo <= 0: shields = 0
	
	var direction = Vector2(cos(rotation), sin(rotation))
	var leftgun_rotation = atan2(direction.y, direction.x) # + PI/4
	var rightgun_rotation = atan2(direction.y, direction.x) # - PI/4
	var leftgun_direction = Vector2(cos(leftgun_rotation), sin(leftgun_rotation))
	var rightgun_direction = Vector2(cos(rightgun_rotation), sin(rightgun_rotation))
	
	if Globals.ammo > 0:
		if Input.is_action_just_pressed("shoot left") and left_timer.is_stopped():
			left_timer.start()
			shoot(leftgun_direction, direction, left_gun_anim, 1)

		if Input.is_action_just_pressed("shoot right") and right_timer.is_stopped():
			right_timer.start()
			shoot(rightgun_direction, direction, right_gun_anim, -1)
		
		if Input.is_action_just_pressed("shoot forward") and left_timer.is_stopped() and right_timer.is_stopped():
			left_timer.start()
			right_timer.start()
			shoot(leftgun_direction, direction, left_gun_anim, 1)
			shoot(rightgun_direction, direction, right_gun_anim, -1)
	
	angular_velocity = clampf(angular_velocity, -0.25, 0.25)
	velocity += Vector2(0, gravity * 0.0025)
	
	if Globals.ammo > 0:
		# tap moves less, brake moves way less
		if Input.is_action_pressed("shoot left") or Input.is_action_pressed("shoot right") or Input.is_action_pressed("shoot forward"):
			velocity = lerp(velocity, Vector2(0, 0), 0.008 * velocity.length() * lateral_air_friction)
		elif Input.is_action_pressed("brake"):
			velocity = lerp(velocity, Vector2(0, 0), 0.1 * velocity.length() * lateral_air_friction)
		else:
			velocity = lerp(velocity, Vector2(0, 0), 0.015 * velocity.length() * lateral_air_friction)
		# tap rotates less
		if Input.is_action_pressed("shoot left") or Input.is_action_pressed("shoot right") or Input.is_action_pressed("shoot forward"):
			angular_velocity = lerp(angular_velocity, 0.0, 0.008 * angular_air_friction)
		else:
			angular_velocity = lerp(angular_velocity, 0.0, 0.02 * angular_air_friction)
	else:
		angular_velocity = lerp(angular_velocity, 0.0, 0.02 * angular_air_friction)
		velocity = lerp(velocity, Vector2(0, 0), 0.015 * velocity.length() * lateral_air_friction)
		
	if Globals.ammo <= 0:
		if Input.is_action_just_pressed("shoot left") or Input.is_action_just_pressed("shoot right") or Input.is_action_just_pressed("shoot forward"):
			AudioSuite.dry_fire_player.play()
		
	rotation += angular_velocity
	rotation = fmod(rotation + TAU, TAU)
	
	if not is_popped:
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


func shoot(gun_direction: Vector2, own_direction: Vector2, gun_anim, flip: int):
	gun_anim.frame = 0
	gun_anim.play()
	shots_fired += 1
	Globals.ammo -= 1
	if Globals.ammo <= 0 and has_run_out_of_ammo == false and is_popped == false:
		AudioSuite.oh_no_player.play()
		has_run_out_of_ammo = true
	
	var new_blullet = BLULLET.instantiate()
	new_blullet.position = position + 80 * flip * Vector2(own_direction.y, -own_direction.x) - 70 * own_direction
	
	if Globals.gun_upgrade_lvl == 0:
		AudioSuite.gunshot_player.play()
	elif Globals.gun_upgrade_lvl >= 1:
		AudioSuite.loud_gunshot_player.play()
	
	var enemies = get_tree().get_nodes_in_group("Enemies") + get_tree().get_nodes_in_group("Dodge Blades")
	var best_angle = 100
	var average_gun_position = position - 30 * own_direction
	for enemy in enemies:
		if (enemy.position - position).length() < 800:
			var angle_to_enemy = average_gun_position.angle_to_point(enemy.position) - rotation
			while angle_to_enemy > PI:
				angle_to_enemy -= TAU
			while angle_to_enemy < -PI:
				angle_to_enemy += TAU
			if abs(angle_to_enemy) < abs(best_angle - rotation) and enemy.position.length() > 0 and not enemy.is_queued_for_deletion():
				best_angle = angle_to_enemy
	new_blullet.velocity = -gun_direction * bullet_speed
	var threshold = PI / 8
	if Globals.gun_upgrade_lvl > 0:
		threshold = PI / 3
	if abs(PI - abs(best_angle)) < threshold:
		new_blullet.velocity = gun_direction.rotated(best_angle) * bullet_speed
	
	get_node("/root/GameManager").add_child(new_blullet)
	Globals.emit_signal("shake_screen")
	angular_velocity += 0.005 * flip * angular_recoil
	velocity += gun_direction * lateral_recoil
	if Input.is_action_pressed("brake"):
		# double the angular velocity change
		angular_velocity += 0.005 * flip * angular_recoil


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Dodge Blades") or body.is_in_group("Enemies"):
		if shields > 0:
			shields -= 1
			if shields == 0:
				pass # shield_sprite.visible = false
			if body.has_method("die"): body.die(null)
			else: body.queue_free()
		else:
			#Globals.ammo = 0
			floating_sprite.visible = false
			popped_sprite.visible = true
			is_popped = true
			Globals.player_popped = true #this one is just for the camera, added later. yeah yeah i know its a jam
			if not AudioSuite.scream_player.playing:
				AudioSuite.oh_no_player.stop()
				AudioSuite.scream_player.play()
				AudioSuite.pop_player.play()


func is_bubble():
	pass #dw about it
