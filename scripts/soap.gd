extends CharacterBody2D

enum states {BIRTH, LIFE, DEATH}
var state = states.BIRTH
@onready var lerp_speed = 0.05
@onready var player = $"/root/GameManager/Bubble"
@onready var rng = RandomNumberGenerator.new()
@onready var timer = $Timer
@onready var rand_speed_max_min = 7

var target_scale = Vector2(0.5,0.5)
var lifespan : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = target_scale
	velocity += Vector2(rng.randf_range(-rand_speed_max_min, rand_speed_max_min), rng.randf_range(-rand_speed_max_min, rand_speed_max_min))

func _physics_process(delta):
	match state:
		states.BIRTH: birth_state()
		states.LIFE: life_state()
		states.DEATH: death_state()
		#
func birth_state():
	move_and_collide(velocity)
	velocity = lerp(velocity, Vector2(0,0), 0.05)
	if velocity == Vector2(0,0):
		state = states.LIFE #this and timer trigger state change
	#pass

func life_state():
	global_position = lerp(global_position, player.global_position, lerp_speed)

func death_state():
	Globals.soap += 1
	queue_free()

func _on_area_2d_body_entered(body):
	if state == states.DEATH: return
	
	if body.has_method("is_bubble"):
		state = states.DEATH


func _on_timer_timeout() -> void:
	state = states.LIFE
