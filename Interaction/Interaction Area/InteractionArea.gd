extends Area2D
class_name Interactable

@export var interact_label = "none"
@export var interact_data =  Vector2(0, 0)
@export var interact_value = "none"
@export var can_interact = true

var interact: Callable = func():
	print("DEFAULT INTERACT FUNCTION CALLED")
	can_interact = true
