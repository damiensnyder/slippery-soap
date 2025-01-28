extends Camera2D

@export var random_shake_strength: float = 40.0
@export var decay: float = 0.6 #how quickly shaking will stop
@onready var rand = RandomNumberGenerator.new()
@onready var shake = 0.0 #the shake being applied
@onready var res_x = 1920
@onready var res_y = 1080

func _ready() -> void:
	rand.randomize()
	Globals.connect("shake_screen", apply_shake)
	if Globals.first_round: position.y = -10500

func apply_shake():
	shake = random_shake_strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#always be making shake strength lerp to zero
	match Globals.state:
		Globals.states.GAMEPLAY: gameplay_state()
		Globals.states.START_AND_PAN: start_and_pan_state()


func gameplay_state():
	shake = lerp(shake, 0.0, decay)
	offset = _get_random_offset()
	if Input.is_action_pressed("ui_left"):
		apply_shake()
		
	if Globals.player_position.y < 0 or lerp(position.y, Globals.player_position.y, 0.05) > position.y:
		
		if Globals.player_popped == false:
			position = lerp(position, Vector2(Globals.player_position.x, Globals.player_position.y - 200), 0.05)
		else:
			position = lerp(position, Vector2(Globals.player_position.x, Globals.player_position.y + 200), 0.05)
			
		position.x = clamp(position.x, limit_left + res_x/2, limit_right - res_x/2)
		position.y = clamp(position.y, limit_top + res_y/2, limit_bottom - res_y/2)


func start_and_pan_state():
	if position.y < 418: position.y += 35
	else:
		position.y = 418
		Globals.state = Globals.states.PRELAUNCH


func _get_random_offset():
	var rand_move = Vector2(
		rand.randf_range(-shake, shake),
		rand.randf_range(-shake, shake)
	)
	return rand_move
