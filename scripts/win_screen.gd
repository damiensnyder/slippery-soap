extends AnimatedSprite2D

@onready var curtain = $WinScreenCurtain

enum states {IN, OUT}
var state = states.IN

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("AudioPlayers", "stop")
	Globals.first_round = true
	frame = 0
	animation = "default"
	play()
	AudioSuite.victory_theme_player.play()

func _physics_process(delta):
	match state:
		states.IN:
			curtain.modulate.a = lerp(curtain.modulate.a, 0.0, 0.05)
			
		states.OUT:
			if curtain.modulate.a == 1:
				AudioSuite.victory_theme_player.stop()
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			curtain.modulate.a = lerp(curtain.modulate.a, 1.0, 0.05)
			if curtain.modulate.a > 0.99:
				curtain.modulate.a = 1.0
	
	if Input.is_action_just_pressed("next"):
		state = states.OUT
	
	if not is_playing():
		animation = "loop"
		play()
