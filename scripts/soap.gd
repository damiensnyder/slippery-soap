extends CharacterBody2D

enum states {BIRTH, LIFE, DEATH}
var state = states.BIRTH

var target_scale = Vector2(0.5,0.5)
var lifespan : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match state:
		states.BIRTH: birth_state()
		states.LIFE: life_state()
		states.DEATH: death_state()
		
	velocity = lerp(velocity, Vector2(0,0), 0.05)
	var collision = move_and_collide(velocity)
	if collision: velocity = velocity.bounce(collision.get_normal())


func birth_state():
	scale = lerp(scale, target_scale, 0.05)
	modulate.a = scale.x / target_scale.x # so that the relative opacity is the same as relative size
	if scale.x > target_scale.x - 0.01: #if it's close enough, that is
		scale = target_scale
		state = states.LIFE
	
	
func life_state():
	modulate.a -= 1.0 / 100 / lifespan
	if modulate.a <= 0: queue_free()


func death_state():
	scale = lerp(scale, target_scale*2, 0.05)
	if scale.x > target_scale.x * 2 - 0.01: queue_free()
	modulate.a -= 1.0 / 25


func _on_area_2d_body_entered(body):
	if state == states.DEATH: return
	
	if body.has_method("is_bubble"):
		state = states.DEATH
