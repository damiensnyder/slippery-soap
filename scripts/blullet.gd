extends CharacterBody2D

@onready var bubble_explosion = preload("res://scenes/gpu_particles_2d.tscn")
@onready var explosion_parent = $"/root/GameManager"
enum states {INAIR, POSTHIT, KILLSELF}
var state = states.INAIR

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match state:
		states.INAIR:   inair_state()
		states.POSTHIT: posthit_state() # this state change happens in the script for the node the blullet hits. sorry!

func inair_state():
	var collision = move_and_collide(velocity)
	if collision: state = states.POSTHIT

func posthit_state():
	#move_and_collide(velocity)
	#scale = lerp(scale, Vector2(2,2), 0.2)
	#velocity = lerp(velocity, Vector2(0,0), 0.05)
	#modulate.a = lerp(modulate.a, 0.0, 0.2)
	#if modulate.a < 0.01:
	var explosion = bubble_explosion.instantiate()
	explosion_parent.add_child(explosion)
	explosion.global_position = self.global_position
	self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()
