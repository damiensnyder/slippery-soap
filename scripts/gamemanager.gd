extends Node2D

const SOAP = preload("res://scenes/soap.tscn")

func _ready():
	pass

func _physics_process(delta):
	pass

func _on_soap_spawn_timer_timeout():
	var new_soap = SOAP.instantiate()
	
	var ready_to_spawn: bool = false
	var loop_count = 0 # this is so that if you loop too many times everything stops. this will probably only happen if there is no legal place for soap to spawn
	while not ready_to_spawn: # generates random position until one is sufficiently far from the player and other soaps
		loop_count += 1
		if loop_count > 1000: return
		
		
		new_soap.position = Vector2(randf_range(-900, 900), randf_range(-480,480))
		if new_soap.position.distance_to(Globals.player_position) < 400: continue
		
		var too_close = false # set to true if we find something too close
		var soaps = get_tree().get_nodes_in_group("Soaps")
		for soap in soaps:
			if new_soap.position.distance_to(soap.position) < 200: too_close = true
		if too_close: continue
		
		ready_to_spawn = true
		
	add_child(new_soap)
	
