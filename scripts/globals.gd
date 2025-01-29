extends Node2D

signal shake_screen()

enum states {LOAD_IN, START_AND_PAN, PRELAUNCH, LAUNCH, GAMEPLAY, STORE, TRANSITION_TO_STORE, WIN, EXIT_TO_MENU}
var state

var player_position = Vector2(0,0)
var max_ammo = 26
var ammo = max_ammo
var player_popped = false
var soap = 0 # INITIAL SOAP
var first_round = true
var won_game = false # this is so you skip cutscenes if you've won
var ammo_upgrade_lvl = 0
var ammo_upgrade_tiers = [26, 36, 46, 54, 72, 85, 100, 115, 130, 150] #there r 6 INCLUDING the one u start on
var shield_upgrade_lvl = 0
var shield = 0 #shield_upgrade_lvl serves as a max shields, "shield" is how many there are currently
var gun_upgrade_lvl = 0

var recoil = 5
var bullet_speed = 10
var lateral_air_friction = 1
var angular_air_friction = 1

func _ready() -> void:
	pass

func emit_screenshake():
	emit_signal("shake_screen")
