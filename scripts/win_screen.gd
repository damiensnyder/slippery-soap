extends Sprite2D

@onready var curtain = $WinScreenCurtain

enum states {IN, OUT}
var state = states.IN

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.first_round = true


func _physics_process(delta):
	match state:
		states.IN:
			curtain.modulate.a = lerp(curtain.modulate.a, 0.0, 0.05)
			
		states.OUT:
			curtain.modulate.a = lerp(curtain.modulate.a, 1.0, 0.05)
			if curtain.modulate.a > 0.99:
				curtain.modulate.a = 1.0
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	if Input.is_key_pressed(KEY_SPACE):
		state = states.OUT
