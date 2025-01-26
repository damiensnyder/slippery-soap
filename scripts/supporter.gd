extends CharacterBody2D

const EXTRA_AMMO = preload("res://scenes/extra_ammo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	pass


func _on_extra_ammo_timer_timeout():
	var new_extra_ammo = EXTRA_AMMO.instantiate()
	new_extra_ammo.position = position
	new_extra_ammo.velocity = Vector2(0,2)
	get_node("/root/GameManager").add_child(new_extra_ammo)
