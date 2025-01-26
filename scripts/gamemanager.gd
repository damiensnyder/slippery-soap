extends Node2D

const SOAP = preload("res://scenes/soap.tscn")
const NEEDLEHEAD = preload("res://scenes/needlehead.tscn")
const BUBBLE = preload("res://scenes/bubble.tscn")

@onready var launch_seqeunce = $LaunchSeqeunce
const DODGE_BLADE = preload("res://scenes/dodge_blade.tscn")

func _ready():
	#Globals.player_position = Vector2(0,300)
	launch_seqeunce.play()
	Globals.state = Globals.states.LAUNCH
	

func _physics_process(delta):
	match Globals.state:
		Globals.states.LAUNCH: launch_state()
		Globals.states.GAMEPLAY: pass


func launch_state():
	if not launch_seqeunce.is_playing():
		var new_bubble = BUBBLE.instantiate()
		new_bubble.position = Vector2(0,720)
		new_bubble.rotation = -PI/2
		add_child(new_bubble)

		Globals.state = Globals.states.GAMEPLAY
		

func _on_soap_spawn_timer_timeout():
	#safe_spawn(SOAP, "Soaps", 0)
	pass


func _on_enemy_spawn_timer_timeout():
	safe_spawn(NEEDLEHEAD, "Enemies", 1000)
	pass

func _on_dodge_blade_spawn_timer_timeout():
	safe_spawn(DODGE_BLADE, "DodgeBlades", 1000)

func safe_spawn(scene : PackedScene, group : String, min_spawn_distance_to_player : float):
	var new_node = scene.instantiate()
	
	var ready_to_spawn: bool = false
	var loop_count = 0 # this is so that if you loop too many times everything stops. this will probably only happen if there is no legal place for soap to spawn
	while not ready_to_spawn: # generates random position until one is sufficiently far from the player and other soaps
		loop_count += 1
		if loop_count > 1000: return
		
		new_node.position = Globals.player_position + Vector2(randf_range(-1000, 1000), randf_range(-1000, 600))
		if new_node.position.distance_to(Globals.player_position) < min_spawn_distance_to_player: continue
		
		var too_close = false # set to true if we find something too close
		var group_members = get_tree().get_nodes_in_group(group)
		for group_member in group_members:
			if new_node.position.distance_to(group_member.position) < 200: too_close = true
		if too_close: continue
		
		ready_to_spawn = true
		
	add_child(new_node)
