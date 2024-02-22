extends KinematicBody2D

export (int) var speed = 400
export (int) var GRAVITY = 1200
export (int) var jump_speed = -600
export (int) var dash_multiplier = 20
export (int) var max_jump = 2

var velocity = Vector2()
const UP = Vector2(0,-1)
var jump_count = 0

const DASH_ACTIVE_TIME = 0.1
const DASH_COOLDOWN_TIME = 0.5
var current_dash_active_time = 0
var current_dash_cooldown_time = 0
var right_dash_enable = false
var left_dash_enable = false

func get_input():
	velocity.x = 0
	
	double_jump()
	move_right()
	move_left()
	dash()

func move_right():
	if !Input.is_action_pressed('right'):
		return
	velocity.x += speed

func move_left():
	if !Input.is_action_pressed('left'):
		return
	velocity.x -= speed

func double_jump():
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed('up') and jump_count < max_jump:
		velocity.y = jump_speed
		jump_count += 1
		
func dash():
	if Input.is_action_just_released('right') and current_dash_cooldown_time == 0:
		right_dash_enable = true
		left_dash_enable = false
		current_dash_active_time = DASH_ACTIVE_TIME

	if Input.is_action_just_released('left') and current_dash_cooldown_time == 0:
		left_dash_enable = true
		right_dash_enable = false
		current_dash_active_time = DASH_ACTIVE_TIME
	
	if Input.is_action_just_pressed("right") and right_dash_enable and current_dash_active_time > 0:
		velocity.x = 0
		velocity.x += speed * dash_multiplier
		right_dash_enable = false
		current_dash_cooldown_time = DASH_COOLDOWN_TIME
	
	if Input.is_action_just_pressed("left") and left_dash_enable and current_dash_active_time > 0:
		velocity.x = 0
		velocity.x -= speed * dash_multiplier
		left_dash_enable = false
		current_dash_cooldown_time = DASH_COOLDOWN_TIME

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	current_dash_active_time = current_dash_active_time - delta if current_dash_active_time > 0 else 0
	current_dash_cooldown_time = current_dash_cooldown_time - delta if current_dash_cooldown_time > 0 else 0
	get_input()
	velocity = move_and_slide(velocity, UP)
	
	
