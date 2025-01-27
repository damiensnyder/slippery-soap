extends CanvasLayer

@onready var AMMOSPRITE = preload("res://assets/bullet1.png")
@onready var PROGRESSMARKER = preload("res://assets/bubble_placeholder.png")
@onready var ammo_origin = $AmmoPlace
@onready var soap_text = $SoapCounter
#@onready var current_ammo = Globals.ammo
@onready var ammo_size = 40 #hardcoding sowwy
@onready var max_ammo_in_line = (1920/40) - 2
@onready var ammo_array = []
@onready var player_sprite = null
@onready var progress_line = $Line2D
@onready var player_marker_start = $PlayerMarkerStart
@onready var win_position = $"../FinishLine"
var ammo_check = Globals.ammo

func _ready() -> void:
	for p in Globals.ammo:
		var new_ammo_sprite = Sprite2D.new()
		new_ammo_sprite.texture = AMMOSPRITE
		if p > max_ammo_in_line:
			new_ammo_sprite.global_position.y = ammo_origin.global_position.y - 40
			new_ammo_sprite.global_position.x = ammo_origin.global_position.x + (ammo_size * (p-(max_ammo_in_line+1)))
		else:
			new_ammo_sprite.global_position.y = ammo_origin.global_position.y
			new_ammo_sprite.global_position.x = ammo_origin.global_position.x + (ammo_size * p)
		new_ammo_sprite.scale = Vector2(0.3,0.3)
		ammo_array.push_back(new_ammo_sprite)
		add_child(new_ammo_sprite)

		p += 1

func _physics_process(_delta: float) -> void:
	var player = get_node_or_null("../Bubble")
	soap_text.text = "= " + str(Globals.soap)
	if Globals.ammo <= 0:
		for n in (ammo_check - Globals.ammo):
			if (ammo_array.size() - 1) - (n) >= 0:
				var bullet = ammo_array[(ammo_array.size() - 1) - (n)]
				bullet.queue_free()
			n += 1
		for m in (ammo_check - Globals.ammo):
			ammo_array.pop_back()
			m += 1
		pass
	if ammo_check != Globals.ammo:
		if ammo_check > Globals.ammo: #decrease ammo
			for n in (ammo_check - Globals.ammo):
				if (ammo_array.size() - 1) - (n) >= 0:
					var bullet = ammo_array[(ammo_array.size() - 1) - (n)]
					bullet.queue_free()
				n += 1
			for m in (ammo_check - Globals.ammo):
				ammo_array.pop_back()
				m += 1

		elif ammo_check < Globals.ammo: #increase ammo
			#im tired, delete all remake all
			for z in (ammo_array.size()):
				if (ammo_array.size() - 1) - (z) >= 0:
					var bullet = ammo_array[(ammo_array.size() - 1) - (z)]
					bullet.queue_free() 
				z += 1
			ammo_array.clear()
			
			for p in Globals.ammo:
				var new_ammo_sprite = Sprite2D.new()
				new_ammo_sprite.texture = AMMOSPRITE
				if p > max_ammo_in_line:
					new_ammo_sprite.global_position.y = ammo_origin.global_position.y - 40
					new_ammo_sprite.global_position.x = ammo_origin.global_position.x + (ammo_size * (p-(max_ammo_in_line+1)))
				else:
					new_ammo_sprite.global_position.y = ammo_origin.global_position.y
					new_ammo_sprite.global_position.x = ammo_origin.global_position.x + (ammo_size * p)
				new_ammo_sprite.scale = Vector2(0.3,0.3)
				ammo_array.push_back(new_ammo_sprite)
				add_child(new_ammo_sprite)
				
				p += 1
		ammo_check = Globals.ammo

	if player != null and player_sprite == null: #progress bar
		player_sprite = Sprite2D.new()
		player_sprite.texture = PROGRESSMARKER
		player_sprite.scale = Vector2(0.2, 0.2)
		player_sprite.global_position = player_marker_start.global_position
		add_child(player_sprite)
		#player.global_position
		print(player_sprite)
	if player_sprite != null:
		var total_dist = abs(win_position.global_position.y) + 760 #760 is start, winposition is negative
		var current_position_percent = (player.global_position.y - win_position.global_position.y)/total_dist
		var line_total_dist = progress_line.global_position.y - player_marker_start.global_position.y
		current_position_percent = (1 - current_position_percent)
		player_sprite.global_position.y = player_marker_start.global_position.y + (line_total_dist * current_position_percent)
		print(player_sprite.global_position.y)
		player_sprite.global_position.y = clamp(player_sprite.global_position.y, progress_line.global_position.y, player_marker_start.global_position.y)
