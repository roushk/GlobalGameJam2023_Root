extends LineEdit

var click1 = preload("res://click1.wav")
var click2 = preload("res://click2.wav")
var click3 = preload("res://click3.wav")
var click4 = preload("res://click4.wav")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("text_entered", self, "_process_input")
	connect("text_changed", self, "_keypress")
	grab_focus()

func _process_input(input_text):
	# clear cmd line
	text = ""
	
	#parse command
	
func _keypress(input_text):
	rng.randomize()
	var i = rng.randi_range(0, 3)
	var click
	match i:
		0:
			click = click1
		1:
			click = click2
		2:
			click = click3
		3:
			var j = rng.randi_range(0, 3)
			if j == 3:
				click = click4
			else:
				click = click1
	$"../KeypressSoundEmitter".stream = click
	$"../KeypressSoundEmitter".pitch_scale = 0.94
	$"../KeypressSoundEmitter".volume_db = -12
	$"../KeypressSoundEmitter".play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
