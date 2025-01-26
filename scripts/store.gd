extends Node2D

@onready var fade = false
@onready var sprite = $Background
@onready var selected_item = ""
@onready var item_text = [
	"Gun: Upgrade your gun",
	"Shield: Get some protection",
	"Ammo: Increase your sweet sweet ammo"
	
]
@onready var shown_item = ""
var fade_index = 0
var fade_speed = 0.01
var in_ = true
var mouse_in_gun = false #fuck ittttttttt this is not the way to do this
var mouse_in_shield = false
var mouse_in_ammo = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade == true:
		if in_ == true and fade_index < 1:
			sprite.modulate.a = fade_index
			fade_index += fade_speed
		elif in_ == false and fade_index > 0:
			sprite.modulate.a = fade_index
			fade_index -= fade_speed

	if Input.is_action_just_pressed("click"):
		match selected_item:
			"": pass
			"Gun": 
				print("gun")
			"Shield":
				print("sh")
			"Ammo": 
				print("ammo")
		#if mouse_in_ammo:
			#print("ammo")
		#if mouse_in_gun:
			#print("gun")
		#if mouse_in_shield:
			#print("shield")

#fuck it im tired im making 6 of these
func _on_area_2d_mouse_entered() -> void: #gun
	#mouse_in_gun = true
	selected_item = "Gun"

func _on_area_2d_mouse_exited() -> void: #gun
	#mouse_in_gun = false
	selected_item = ""

func _on_shield_area_2d_mouse_entered() -> void:
	#mouse_in_shield = true
	selected_item = "Shield"

func _on_shield_area_2d_mouse_exited() -> void:
	#mouse_in_shield = false
	selected_item = ""

func _on_ammo_area_2d_mouse_entered() -> void:
	#mouse_in_ammo = true
	selected_item = "Ammo"

func _on_ammo_area_2d_mouse_exited() -> void:
	#mouse_in_ammo = false
	selected_item = ""
