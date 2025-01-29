extends Area2D

@onready var curtain = $Curtain
@onready var ui = $"../UI" #bad practice!!

func _on_body_entered(body):
	if body.has_method("is_bubble"):
		Globals.state = Globals.states.WIN
		ui.visible = false

func _physics_process(delta):
	if Globals.state == Globals.states.WIN:
		if curtain.modulate.a == 1:
			Globals.state = Globals.states.PRELAUNCH
			Globals.won_game = true
			get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
		curtain.modulate.a = lerp(curtain.modulate.a, 1.0, 0.05)
		if curtain.modulate.a > 0.99:
			curtain.modulate.a = 1
