extends LineEdit

var click1 = preload("res://click1.wav")
var click2 = preload("res://click2.wav")
var click3 = preload("res://click3.wav")
var clickSpace = preload("res://click4.wav")

var rng = RandomNumberGenerator.new()
var lastString = ""

var isCompletable = false
var completionString = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("text_entered", self, "_process_input")
	connect("text_changed", self, "_keypress")
	grab_focus()

func _process_input(input_text):
	# clear cmd line
	text = ""
	
	#parse command
	if isCompletable:
		if input_text == completionString:
			print("ya thats right")
	
func _keypress(input_text):
	var click
	var spaceCountNew = 0
	var spaceCountOld = 0
	for c in input_text:
		if c == ' ':
			spaceCountNew += 1
			
	for c in lastString:
		if c == ' ':
			spaceCountOld += 1
	
	if input_text.length() > 0 && spaceCountNew == spaceCountOld:
		rng.randomize()
		match rng.randi_range(0, 2):
			0:
				click = click1
			1:
				click = click2
			2:
				click = click3
	else:
		click = clickSpace
	$"../KeypressSoundEmitter".stream = click
	$"../KeypressSoundEmitter".pitch_scale = 0.94
	$"../KeypressSoundEmitter".volume_db = -12
	$"../KeypressSoundEmitter".play()
	
	lastString = input_text

func _set_password(line):
	isCompletable = true
	completionString = line

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
