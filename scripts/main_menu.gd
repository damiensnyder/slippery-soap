extends AnimatedSprite2D

var starting = false #whether game is currently starting
@onready var curtain = $Curtain
@onready var intro_scenes = $IntroScenes

@onready var left_gun = $LeftGun
@onready var right_gun = $RightGun

enum states {MAIN, INTROSCENES, OUT}
var state = states.MAIN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match state:
		states.MAIN: main_state()
		states.INTROSCENES: introscenes_state()
		states.OUT: out_state()


func main_state():
	curtain.modulate.a = lerp(curtain.modulate.a, 0.0, 0.05)
	intro_scenes.modulate.a = lerp(intro_scenes.modulate.a, 0.0, 0.05)
	if Input.is_key_pressed(KEY_SPACE):
		state = states.INTROSCENES
		intro_scenes.frame = 0 #don't think this line is necessary but i dont feel like finding out
	
	if Input.is_action_just_pressed("shoot left") and not left_gun.is_playing():
		left_gun.play()
		AudioSuite.loud_gunshot_player.play()
	
	if Input.is_action_just_pressed("shoot right") and not right_gun.is_playing():
		right_gun.play()
		AudioSuite.loud_gunshot_player.play()
		
	if Input.is_action_just_pressed("shoot forward") and not left_gun.is_playing() and not right_gun.is_playing():
		left_gun.play()
		right_gun.play()
		AudioSuite.loud_gunshot_player.play()


func introscenes_state():
	curtain.modulate.a = lerp(curtain.modulate.a, 0.0, 0.05)
	intro_scenes.modulate.a = lerp(intro_scenes.modulate.a, 1.0, 0.05)
	if Input.is_action_just_pressed("next")     and intro_scenes.frame == 10: state = states.OUT
	if Input.is_action_just_pressed("previous") and intro_scenes.frame == 0 : state = states.MAIN
	
	if Input.is_action_just_pressed("next")     and intro_scenes.frame < 10: intro_scenes.frame += 1
	if Input.is_action_just_pressed("previous") and intro_scenes.frame > 0 : intro_scenes.frame -= 1
	
	

func out_state():
	curtain.modulate.a = lerp(curtain.modulate.a, 1.0, 0.05)
	if curtain.modulate.a > 0.99:
		intro_scenes.modulate.a = 0.0
		get_tree().change_scene_to_file("res://scenes/game.tscn")
