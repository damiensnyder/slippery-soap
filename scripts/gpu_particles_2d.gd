extends GPUParticles2D

@onready var death_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	#print("particle explosion")
	death_timer.start()

func _on_timer_timeout():
	queue_free()
