extends CharacterBody2D


enum states {NORMAL, COLLECTED}
var state = states.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match state:
		states.NORMAL: normal_state()
		states.COLLECTED: collected_state()


func normal_state():
	scale = lerp(scale, Vector2(0.2,0.2), 0.05)
	modulate.a -= 0.002
	if modulate.a <= 0: queue_free()
	move_and_collide(velocity)
	

func collected_state():
	scale = lerp(scale, Vector2(0.4,0.4), 0.1)
	modulate.a -= 0.05
	if modulate.a < 0.01:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("is_bubble") and state == states.NORMAL:
		Globals.ammo += 1
		AudioSuite.ammo_player.play()
		state = states.COLLECTED
