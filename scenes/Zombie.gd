extends KinematicBody2D


func _ready():
	$AnimatedSprite.play("idle")
	$AudioStreamPlayer2D.play()
