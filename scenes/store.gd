extends Node2D

@onready var fade = false
var fade_index = 0
var fade_speed = 0.01
var in_ = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade == true:
		if in_ == true and fade_index < 1:
			modulate.a = fade_index
			fade_index += fade_speed
		elif in_ == false and fade_index > 0:
			modulate.a = fade_index
			fade_index -= fade_speed
