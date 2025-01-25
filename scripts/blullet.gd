extends CharacterBody2D

enum states {INAIR, POSTHIT}
var state = states.INAIR

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match state:
		states.INAIR:   inair_state()
		states.POSTHIT: posthit_state()


func inair_state():
	var collision = move_and_collide(velocity)
	if collision: queue_free()
	

func posthit_state():
	move_and_collide(velocity)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
