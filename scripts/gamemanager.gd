extends Node2D

const SOAP = preload("res://scenes/soap.tscn")
const NEEDLEHEAD = preload("res://scenes/needlehead.tscn")
const BUBBLE = preload("res://scenes/bubble.tscn")
const DODGE_BLADE = preload("res://scenes/dodge_blade.tscn")

@onready var launch_seqeunce = $LaunchSeqeunce
@onready var store = $Store
@onready var ui = $UI
@onready var camera = $Camera2D
@onready var once = true #fuck it sorry
@onready var poopy = false #sorry again, this is for instore()

func _ready():
	if Globals.first_round == true:
		launch_seqeunce.play()
		Globals.first_round = false
		Globals.state = Globals.states.LAUNCH
	
func _physics_process(delta):
	match Globals.state:
		Globals.states.LAUNCH: launch_state()
		Globals.states.GAMEPLAY: pass
		Globals.states.STORE: in_store()
		Globals.states.TRANSITION_TO_STORE: transition_to_store()

func in_store():
	#just in case delete player if exits
	var player_check = get_node_or_null("res://scenes/bubble.tscn")
	if player_check != null:
		player_check.queue_free()
	
	if once == true: #fuck it
		store.fade = true
		store.in_ = true
		ui.visible = false
		once = false
	
	if Input.is_action_just_pressed("ui_accept"):
		store.fade = true
		store.in_ = false
		poopy = true
	if store.fade_index <= 0 and poopy == true:
			Globals.state = Globals.states.LAUNCH
			launch_seqeunce.play()
			ui.visible = true
	pass

func transition_to_store():
	#bubble pop and shit
	Globals.state = Globals.states.STORE


func launch_state():
	once = true #for fading in shop, i lazy rn
	poopy = false #ahhh
	if launch_seqeunce.frame == 26:
		var new_bubble = BUBBLE.instantiate()
		new_bubble.position = Vector2(0,650)
		Globals.player_position = new_bubble.position
		new_bubble.rotation = -PI/2
		new_bubble.velocity = Vector2(0,-50)
		add_child(new_bubble)

		Globals.state = Globals.states.GAMEPLAY

func _on_soap_spawn_timer_timeout():
	#safe_spawn(SOAP, "Soaps", 0)
	pass

func _on_enemy_spawn_timer_timeout():
	if Globals.state == Globals.states.STORE: return
	
	if Globals.ammo > 0:
		safe_spawn(NEEDLEHEAD, "Enemies", 2000)
	else:
		var new_node = NEEDLEHEAD.instantiate()
		new_node.position = Globals.player_position + Vector2(0, -900)
		add_child(new_node)
	pass

func _on_dodge_blade_spawn_timer_timeout():
	if Globals.state == Globals.states.STORE: return
	safe_spawn(DODGE_BLADE, "DodgeBlades", 2000)

func safe_spawn(scene : PackedScene, group : String, min_spawn_distance_to_player : float):
	var new_node = scene.instantiate()
	
	var ready_to_spawn: bool = false
	var loop_count = 0 # this is so that if you loop too many times everything stops. this will probably only happen if there is no legal place for soap to spawn
	while not ready_to_spawn: # generates random position until one is sufficiently far from the player and other soaps
		loop_count += 1
		if loop_count > 1000: return
		
		new_node.position = Globals.player_position + Vector2(randf_range(-1000, 1000), randf_range(-3000, 600))
		if new_node.position.distance_to(Globals.player_position) < min_spawn_distance_to_player: continue
		
		var too_close = false # set to true if we find something too close
		var group_members = get_tree().get_nodes_in_group(group)
		for group_member in group_members:
			if new_node.position.distance_to(group_member.position) < 200: too_close = true
		if too_close: continue
		
		ready_to_spawn = true
		
	add_child(new_node)
