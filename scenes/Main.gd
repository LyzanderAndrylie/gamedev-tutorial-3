extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/JumpLeft.text = "Jump Left: %s" % ($Player.max_jump - $Player.jump_count)
	$Control/RightDashState.text = "Right Dash Active: %s" % $Player.right_dash_enable
	$Control/LeftDashState.text = "Left Dash Active: %s" % $Player.left_dash_enable
	$Control/DashCooldown.text = "Dash Cooldown: %.2f" % $Player.current_dash_cooldown_time
	$Control/CrouchState.text = "Crouch Active: %s" % $Player.crouch_active
