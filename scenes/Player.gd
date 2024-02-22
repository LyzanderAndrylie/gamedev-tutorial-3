extends KinematicBody2D

export (int) var speed = 400
export (int) var GRAVITY = 1200
export (int) var jump_speed = -600

var velocity = Vector2()
const UP = Vector2(0,-1)
var jump_count = 0

func get_input():
	velocity.x = 0
	
	double_jump()
	if Input.is_action_pressed('right'):
		velocity.x += speed
	if Input.is_action_pressed('left'):
		velocity.x -= speed

func double_jump():
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed('up') and jump_count < 2:
		velocity.y = jump_speed
		jump_count += 1

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)
