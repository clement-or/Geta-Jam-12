extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(direction == -1 and position.x > 0):
		position.x -= 1
	elif(direction == 1 and position.x < get_viewport().get_visible_rect().size.x):
		position.x += 1
		


func move_left():
	scale.x = 1.6
	direction = -1

func move_right():
	scale.x = -1.6
	direction = 1

func stop_moving():
	direction = 0
