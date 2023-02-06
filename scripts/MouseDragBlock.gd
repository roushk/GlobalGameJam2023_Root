extends Area2D

var mouseIsInside = false;
var offset;
var setOffset = false;
var grabbed = false;
var insideArea = false;
var dragBlockOrigin =  Vector2();
var origionalPos = Vector2();
var enteredArea;
var MouseNode;
var animSprite;
var solution = -1;

var frameDict = [
	"delta",
	"omega",
	"phi",
	"pi",
	"psi",
	"sigma",
	"gamma",
	"lambda",
]
# Called when the node enters the scene tree for the first time.
func _ready():
	MouseNode = get_node("/root/AutoloadMouseGrabbing")
	animSprite = get_node("TypeSprite")
	origionalPos = global_position;
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_mouse_button_pressed(BUTTON_LEFT) && mouseIsInside == true && MouseNode.is_grabbing() == false):
		MouseNode.set_grabbing(get_name());
		grabbed = true;
		
	if (grabbed):
		if setOffset == false:
			offset = global_transform.origin - get_global_mouse_position();
			setOffset = true;
		#dragStart = get_global_mouse_position();
		global_position = get_global_mouse_position() + offset;
		
		if (!Input.is_mouse_button_pressed(BUTTON_LEFT)):
			setOffset = false;
			grabbed = false;
			MouseNode.reset_grabbing();
			if(insideArea):
				global_position = dragBlockOrigin;
	if(!insideArea):
		var areas = get_overlapping_areas();
		for ar in areas:
			_on_MouseDragBlock_area_entered(ar)

func resetPos():
	global_position = origionalPos;
#	pass
func _on_MouseDragBlock_mouse_entered():
	mouseIsInside = true;
	
func _on_MouseDragBlock_mouse_exited():
	mouseIsInside = false;

func set_frame(frame):
	solution = frame
	animSprite.frame = frame

func get_value():
	return solution
	
func _on_MouseDragBlock_area_entered(area):
	if area.get_parent() != null && area.get_parent().get_name().left(16) == "DragDropLocation":
		insideArea = true;
		dragBlockOrigin = area.get_global_transform().origin + Vector2(9.5,9.55);
	#print ("Area " + str(area.get_parent().get_name()) + " Entered " + str(get_name()))
	enteredArea = area.get_parent().get_name();
	pass # Replace with function body.

func _on_MouseDragBlock_area_exited(area):
	#print ("Area " + str(area.get_parent().get_name()) + " Exited " + str(get_name()))
	if(area.get_parent().get_name() == enteredArea):
		insideArea = false;
	pass # Replace with function body.
