extends Node2D

signal shake_screen()

enum states {LAUNCH, GAMEPLAY, STORE}
var state

var player_position = Vector2(0,0)
var max_ammo = 26
var ammo = max_ammo
var soap = 0

var recoil = 5
var bullet_speed = 10
var lateral_air_friction = 1
var angular_air_friction = 1


func emit_screenshake():
	emit_signal("shake_screen")
