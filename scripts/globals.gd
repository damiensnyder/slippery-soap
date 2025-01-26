extends Node2D

signal shake_screen()

enum states {LAUNCH, GAMEPLAY, STORE, TRANSITION_TO_STORE}
var state

var player_position = Vector2(0,0)
var max_ammo = 26
var ammo = max_ammo
var soap = 3000
var first_round = true
var ammo_upgrade_lvl = 0
var shield_upgrade_lvl = 0
var gun_upgrade_lvl = 0

var recoil = 5
var bullet_speed = 10
var lateral_air_friction = 1
var angular_air_friction = 1

func _ready() -> void:
	#print(state)
	pass

func emit_screenshake():
	emit_signal("shake_screen")
