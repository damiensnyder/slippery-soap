extends Sprite2D

var starting = false #whether game is currently starting
@onready var curtain = $Curtain

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if not starting:
		if Input.is_key_pressed(KEY_SPACE):
			starting = true
	elif starting:
		curtain.modulate.a = lerp(curtain.modulate.a, 1.0, 0.1)
		if curtain.modulate.a > 0.99:
			get_tree().change_scene_to_file("res://scenes/game.tscn")
