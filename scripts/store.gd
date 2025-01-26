extends Node2D

@onready var fade = false
@onready var gun = preload("res://assets/store_gun.png")
@onready var shield = preload("res://assets/store_shield.png")
@onready var ammo = preload("res://assets/store_ammo.png")
@onready var sold_out = preload("res://assets/sold.png")
@onready var sprite = $Background
@onready var description = $RichTextLabel
@onready var price_label = $PriceLabel
@onready var selected_sprite = $SelectedSprite
@onready var soap_text = $SoapText
@onready var buy_sprite = $BuySprite
@onready var gun_sprite = $Gun
@onready var shield_sprite = $Shield
@onready var ammo_sprite = $Ammo
@onready var selected_item = ""
@onready var selected_buy = false
@onready var selected_price = 0
@onready var item_text = [
	"Gun: Upgrade them gunz, homing projectiles",
	"Shield: Get some much needed protection",
	"Ammo: Increase your sweet sweet ammo"
]
@onready var rand_shop_text = [
	#"I'm so tired I feel like popping some bubbles if you knwo what I mean",
	#"Oh my fuck",
	#"You ever been to the you ever do the thing where you have you",
	#"Radiation",
	#"Hold on a second... Have I met you before?",
	#"Don't.. just don't look at me right now please",
	#"Hey hoooooo look at this bubble go!",
	#"AHHHHHHHHHHHHHH",
	#"penis",
	#"Once upon a time there was a... damn are you going to buy something?",
	#"Now with 50% more flavor!!",
	"Click on the items you want to buy, and press space when you're done!"
]
@onready var shop_talker = $Bubble_talk
@onready var item_prices = {
	"_Gun" : [17],
	"_Shield" : [10, 12, 14, 16, 18],
	"_Ammo" : [3, 5, 7, 9, 11, 13, 15, 17, 19]
}
@onready var shown_item = ""
var fade_index = 0
var fade_speed = 0.05
var in_ = true
var mouse_in_gun = false #fuck ittttttttt this is not the way to do this
var mouse_in_shield = false
var mouse_in_ammo = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_random_number = rng.randf_range(0, rand_shop_text.size()-1)
	var string = str(rand_shop_text[my_random_number])
	shop_talker.text = "[wave amp=50.0 freq=5.0 connected=1]" + string + "[/wave]"

func _physics_process(delta: float) -> void:
	soap_text.text = "= " + str(Globals.soap)
	if fade == true:
		if in_ == true and fade_index < 1:
			self.modulate.a = fade_index
			fade_index += fade_speed
		elif in_ == false and fade_index > 0:
			self.modulate.a = fade_index
			fade_index -= fade_speed
		#persistant sold out signs
		if Globals.ammo_upgrade_lvl >= item_prices["_Ammo"].size():
			ammo_sprite.texture = sold_out	
		if Globals.shield_upgrade_lvl >= item_prices["_Shield"].size():
			shield_sprite.texture = sold_out
		if Globals.gun_upgrade_lvl >= item_prices["_Gun"].size():
			gun_sprite.texture = sold_out

	if Input.is_action_just_pressed("click") and fade_index >= 1:
		match selected_item:
			"": pass
			"Gun": 
				if Globals.gun_upgrade_lvl < 1:
					description.text = str(item_text[0])
					price_label.text = "Price: " + str(item_prices["_Gun"][0])
					selected_price = item_prices["_Gun"][0]
					selected_sprite.texture = gun
					buy_sprite.visible = true
			"Shield":
				if Globals.shield_upgrade_lvl < item_prices["_Shield"].size():
					description.text = item_text[1]
					price_label.text = "Price: " + str(item_prices["_Shield"][Globals.shield_upgrade_lvl])
					selected_price = item_prices["_Shield"][Globals.shield_upgrade_lvl]
					selected_sprite.texture = shield
					buy_sprite.visible = true
			"Ammo":
				if Globals.ammo_upgrade_lvl < item_prices["_Ammo"].size():
					description.text = item_text[2]
					price_label.text = "Price: " + str(item_prices["_Ammo"][Globals.ammo_upgrade_lvl])
					selected_price = item_prices["_Ammo"][Globals.ammo_upgrade_lvl]
					selected_sprite.texture = ammo
					buy_sprite.visible = true
		if selected_buy:
			if Globals.soap >= selected_price and selected_price != 0:
				AudioSuite.chaching_player.play()
				match selected_sprite.texture: #upgrades
					ammo:
						if Globals.ammo_upgrade_lvl + 1 <= item_prices["_Ammo"].size():
							#if there's another upgrade
							Globals.ammo_upgrade_lvl += 1
							Globals.max_ammo = Globals.ammo_upgrade_tiers[Globals.ammo_upgrade_lvl]
							Globals.ammo = Globals.max_ammo
							if Globals.ammo_upgrade_lvl >= item_prices["_Ammo"].size():
								ammo_sprite.texture = sold_out
					shield:
						if Globals.shield_upgrade_lvl + 1 <= item_prices["_Shield"].size():
							#if there's another upgrade
							Globals.shield_upgrade_lvl += 1
							if Globals.shield_upgrade_lvl >= item_prices["_Shield"].size():
								shield_sprite.texture = sold_out
					gun:
						if Globals.gun_upgrade_lvl < 1:
							#if there's another upgrade
							Globals.gun_upgrade_lvl += 1
							if Globals.gun_upgrade_lvl >= item_prices["_Gun"].size():
								gun_sprite.texture = sold_out
				Globals.soap -= selected_price
				selected_sprite.texture = null
				selected_item = ""
				description.text = ""
				price_label.text = ""
				selected_price = 0
				buy_sprite.visible = false

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

func _on_buy_mouse_entered() -> void:
	selected_buy = true

func _on_buy_mouse_exited() -> void:
	selected_buy = false
