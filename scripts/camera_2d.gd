extends Camera2D

@export var random_shake_strength: float = 40.0
@export var decay: float = 0.6 #how quickly shaking will stop
@onready var rand = RandomNumberGenerator.new()
@onready var shake = 0.0 #the shake being applied

func _ready() -> void:
	rand.randomize()
	Globals.connect("shake_screen", apply_shake)

func apply_shake():
	shake = random_shake_strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#always be making shake strength lerp to zero
	shake = lerp(shake, 0.0, decay)
	
	offset = _get_random_offset()
	
	if Input.is_action_pressed("ui_left"):
		apply_shake()
	
	if Globals.state == Globals.states.GAMEPLAY: position = lerp(position, Globals.player_position, 0.05)

func _get_random_offset():
	var rand_move = Vector2(
		rand.randf_range(-shake, shake),
		rand.randf_range(-shake, shake)
	)
	return rand_move
