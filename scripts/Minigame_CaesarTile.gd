extends Sprite

var tileScene = preload("res://scenes/CaesarTile.tscn")
onready var dict = "res://5letterdict.txt"

var fill = preload("res://fill.png")
var correct = preload("res://correct.png")

var isDragging = false
var isMoving = false

var isMouseInside = false

var dragStart = Vector2()
var dragEnd = Vector2()

var lastMousePos = Vector2()

const originPoint = -60.7826

var tileList = []
var posList = []

var tileScale = 15

var rotateSens = 3.5

var cipherIndex = ord('N') - ord('A')
var isSolved
var cipherString
var cipherOffset
var wordDict = []

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT && !isSolved:
		if event.is_pressed() and isMouseInside:
			dragStart = event.position
			dragEnd = event.position
			isDragging = true
		if event.is_action_released("click") and isDragging:
			isDragging = false
			var closestTile = tileList[0]
			for index in tileList.size():
				var tile = tileList[index]
				posList[index] = tile.rect_position.y
				if tile.rect_position.y > originPoint + 10 * tileScale * 13:
					var newPos = tile.rect_position.y - 10 * tileScale * 26
					posList[index] = newPos
					tile.rect_position.y = newPos
				elif tile.rect_position.y < originPoint + 10 * tileScale * -13:
					var newPos = tile.rect_position.y + 10 * tileScale * 26
					posList[index] = newPos
					tile.rect_position.y = newPos
				
				if abs(originPoint - tile.rect_position.y) < abs(originPoint - closestTile.rect_position.y):
					closestTile = tile
					#print("new closest tile is ", tile.text, " at ", tile.rect_position, " vs ", originPoint)
					
			var distanceToCorrect = originPoint - closestTile.rect_position.y
			var tween = get_node("Tween")
			for index in tileList.size():
				var tile = tileList[index]
				tween.interpolate_property(tile, "rect_position:y", tile.rect_position.y, tile.rect_position.y + distanceToCorrect, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
				tween.start()
				posList[index] = tile.rect_position.y + distanceToCorrect
				#tile.rect_position.y += distanceToCorrect
#				if tile.rect_position.y > originPoint + 10 * tileScale * 13:
#					var newPos = tile.rect_position.y - 10 * tileScale * 26
#					posList[index] = newPos
#					tile.rect_position.y = newPos
#				elif tile.rect_position.y < originPoint + 10 * tileScale * -13:
#					var newPos = tile.rect_position.y + 10 * tileScale * 26
#					posList[index] = newPos
#					tile.rect_position.y = newPos
				#print(tile.rect_position, " ", originPoint)
					
			cipherIndex = ord(closestTile.text) - ord('A')
			#print("tile is ", closestTile.text, " with index ", cipherIndex)
			
func _process(_delta):
	var mousePos = get_global_mouse_position()
	isMoving = (mousePos != lastMousePos)
	
	if isDragging:
		dragEnd = mousePos
		var dragDelta = dragEnd - dragStart
		for index in tileList.size():
			var tile = tileList[index]
			var pos = posList[index]
			tile.rect_position.y = pos + dragDelta.y * rotateSens
		
	lastMousePos = mousePos
	
	var cipherViewString = cipherString
	for i in cipherString.length():
		var charVal = ord(cipherString[i])
		var AVal = ord('A')
		var c = (charVal - AVal + cipherOffset) % 26
		var n = (c + cipherIndex) % 26
		var output = n + AVal
		cipherViewString[i] = output
	
	get_parent().get_parent().get_parent().get_node("CypherText/ReferenceRect/Sprite/Cipher").text = cipherViewString
	if (26 - cipherOffset) % 26 == cipherIndex && !isSolved:
		get_parent().get_parent().get_parent().get_node("CypherText/ReferenceRect/Sprite").texture = correct
		var solutionString = "salad -i" + str(cipherOffset) + " -r -qx --fast -word=" + cipherString
		$"/root/RootGame/Root/Terminal/LineEdit"._set_password(solutionString)
		$"/root/RootGame/Root/FinalCommand".visible = true
		isSolved = true
		
func _reset():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	cipherString = wordDict[rng.randi_range(0, wordDict.size() - 1)].to_upper()
	cipherOffset = rng.randi_range(0, 25)
	while cipherOffset < 15 and cipherOffset > 10:
		cipherOffset = rng.randi_range(0, 25)
	get_parent().get_parent().get_parent().get_node("CypherText/ReferenceRect/Sprite").texture = fill
	isSolved = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(26):
		var instance = tileScene.instance()
		tileList.append(instance)
		posList.append(originPoint - 10 * tileScale * (13 - i))
		
		add_child(instance)
		
		instance.text = char(ord("A") + i)
		
		instance.rect_scale.x = tileScale
		instance.rect_scale.y = tileScale
		instance.rect_position.x = -46
		instance.rect_position.y = originPoint - 10 * tileScale * (13 - i)
	
	var f = File.new()
	f.open(dict, File.READ)
	while not f.eof_reached():
		var line = f.get_line()
		wordDict.append(line)
	
	f.close()
	
	if wordDict.size() > 0:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		cipherString = wordDict[rng.randi_range(0, wordDict.size() - 1)].to_upper()
		cipherOffset = rng.randi_range(0, 25)
		while cipherOffset < 15 and cipherOffset > 10:
			cipherOffset = rng.randi_range(0, 25)

func _on_Area2D_mouse_entered():
	isMouseInside = true

func _on_Area2D_mouse_exited():
	isMouseInside = false
