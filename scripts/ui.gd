extends CanvasLayer

@onready var AMMOSPRITE = preload("res://assets/bullet1.png")
@onready var ammo_origin = $AmmoPlace
#@onready var current_ammo = Globals.ammo
@onready var ammo_size = 40 #hardcoding sowwy
@onready var ammo_array = []
var ammo_check = Globals.ammo

func _ready() -> void:
	for i in Globals.ammo:
		var new_ammo_sprite = Sprite2D.new()
		new_ammo_sprite.texture = AMMOSPRITE
		new_ammo_sprite.global_position.y = ammo_origin.global_position.y
		new_ammo_sprite.global_position.x = ammo_origin.global_position.x + (ammo_size * i)
		new_ammo_sprite.scale = Vector2(0.3,0.3)
		ammo_array.push_back(new_ammo_sprite)
		add_child(new_ammo_sprite)
		
		i += 1

func _process(delta: float) -> void:
	if ammo_check != Globals.ammo:
		#print(ammo_array.size())
		if ammo_check > Globals.ammo: #decrease ammo
			#print(ammo_array)
			#print("")
			#print(ammo_array.size())
			for n in (ammo_check - Globals.ammo):
				var bullet = ammo_array[(ammo_array.size() - 1) - (n)]
				#print(ammo_array[(ammo_array.size() - 1) - (n)])
				bullet.queue_free()
				n += 1
			for m in (ammo_check - Globals.ammo):
				#print(m)
				#print((ammo_array.size() - 1))
				#ammo_array.pop_at((ammo_array.size() - 1) - (m))
				#print((ammo_array.size() - 1) - (m))
				ammo_array.pop_back()
				m += 1
				
			#print(ammo_array)
		elif ammo_check < Globals.ammo: #increase ammo
			pass
		ammo_check = Globals.ammo
		#print(ammo_array.size())
