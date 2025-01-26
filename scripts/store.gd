extends Node2D

@onready var fade = false
@onready var gun = preload("res://assets/store_gun.png")
@onready var shield = preload("res://assets/store_shield.png")
@onready var ammo = preload("res://assets/store_ammo.png")
@onready var sprite = $Background
@onready var description = $RichTextLabel
@onready var price_label = $PriceLabel
@onready var selected_sprite = $SelectedSprite
@onready var soap_text = $SoapText
@onready var selected_item = ""
@onready var selected_buy = false
@onready var selected_price = 0
@onready var item_text = [
	"Gun: Upgrade them gunz",
	"Shield: Get some much needed protection",
	"Ammo: Increase your sweet sweet ammo"
	
]
@onready var item_prices = {
	"_Gun" : [50],
	"_Shield" : [30, 40, 50],
	"_Ammo" : [10, 20, 30]
}
@onready var shown_item = ""
var fade_index = 0
var fade_speed = 0.01
var in_ = true
var mouse_in_gun = false #fuck ittttttttt this is not the way to do this
var mouse_in_shield = false
var mouse_in_ammo = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#selected_sprite.texture
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	soap_text.text = "= " + str(Globals.soap)
	if fade == true:
		if in_ == true and fade_index < 1:
			self.modulate.a = fade_index
			fade_index += fade_speed
			print(fade_index)
		elif in_ == false and fade_index > 0:
			self.modulate.a = fade_index
			fade_index -= fade_speed

	if Input.is_action_just_pressed("click") and fade_index >= 1:
		match selected_item:
			"": pass
			"Gun": 
				description.text = str(item_text[0])
				price_label.text = "Price: " + str(item_prices["_Gun"][0])
				selected_price = item_prices["_Gun"][0]
				selected_sprite.texture = gun
			"Shield":
				description.text = item_text[1]
				price_label.text = "Price: " + str(item_prices["_Shield"][0])
				selected_price = item_prices["_Gun"][0]
				selected_sprite.texture = shield
			"Ammo": 
				description.text = item_text[2]
				price_label.text = "Price: " + str(item_prices["_Ammo"][0])
				selected_price = item_prices["_Gun"][0]
				selected_sprite.texture = ammo
			"Buy":
				if Globals.soap >= selected_price and selected_price != 0:
					print("BUY")
					Globals.soap -= selected_price
					selected_item = ""
					selected_price = 0

#fuck it im tired im making 6 of these
func _on_area_2d_mouse_entered() -> void: #gun
	#mouse_in_gun = true
	selected_item = "Gun"

func _on_area_2d_mouse_exited() -> void: #gun
	#mouse_in_gun = false
	selected_item = ""
	selected_price = 0

func _on_shield_area_2d_mouse_entered() -> void:
	#mouse_in_shield = true
	selected_item = "Shield"

func _on_shield_area_2d_mouse_exited() -> void:
	#mouse_in_shield = false
	selected_item = ""
	selected_price = 0

func _on_ammo_area_2d_mouse_entered() -> void:
	#mouse_in_ammo = true
	selected_item = "Ammo"

func _on_ammo_area_2d_mouse_exited() -> void:
	#mouse_in_ammo = false
	selected_item = ""
	selected_price = 0

func _on_buy_mouse_entered() -> void:
	selected_buy = true

func _on_buy_mouse_exited() -> void:
	selected_buy = false
