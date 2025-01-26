extends Label

@onready var bubble = preload("res://scenes/bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "hehe"
	#text = "Gravity (R/F): " + str(bubble.gravity) + "\n Lateral recoil (T/G): " + str(bubble.lateral_recoil) + "\n Angular recoil (Y/H) " + str(bubble.angular_recoil) + "\n Bullet speed (U/J): " + str(bubble.bullet_speed) + "\n Lateral air friction (I/K): " + str(bubble.lateral_air_friction) + "\n Angular air friction (O/L): " + str(bubble.angular_air_friction)
