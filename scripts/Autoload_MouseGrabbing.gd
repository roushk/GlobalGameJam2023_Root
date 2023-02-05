extends Node

class_name MouseGrabbing
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grabbedNode = "None";
var isGrabbing = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_grabbing():
	return isGrabbing;
	
func set_grabbing(nodeName):
	grabbedNode = nodeName;
	isGrabbing = true;
	
func reset_grabbing():
	isGrabbing = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
