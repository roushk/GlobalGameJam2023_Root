extends ReferenceRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var exploitChain;
var caesarCipher;
var rooty;
var terminal;
var enemy;

var caesarexe;	#0
var exploitexe;	#1

var numGames = 5;
var numGamesLeft;

var delayStart = 2.0
var currDelayStart = 0
var countdownStart = true

var expectedPassword = ""
var nextGame = -1
var caesarCipherScript;
var rng

onready var enemylinesdict = "res://enemydamagedlines.txt"
var enemylines = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	rng = RandomNumberGenerator.new()
	rng.randomize()
		
	exploitChain = get_node("ExploitChain");
	caesarCipher = get_node("CaesarCipher");
	caesarCipherScript = get_node("CaesarCipher/Sprite/Roulette/ReferenceRect/RouletteWindow")
	
	rooty = get_node("Rooty");
	terminal = get_node("Terminal");
	enemy = get_node("EnemyPanel");
	
	caesarexe = get_node("EnemyPanel/Games/Caesar")
	exploitexe = get_node("EnemyPanel/Games/ExploitChain")
	
	$"EnemyPanel/Timer".connect("timeout", self, "hide_enemy_text")
	
	var f = File.new()
	f.open(enemylinesdict, File.READ)
	while not f.eof_reached():
		var line = f.get_line()
		enemylines.append(line)
	
	f.close()

	numGamesLeft = numGames;
	set_next_game(1);
	$"FinalCommand".visible = false
	$"FinalCommand".set_process(false)
	pass # Replace with function body.

func reset_games():	
	#Disable games
	caesarCipher.get_tree().paused = true;
	exploitChain.get_tree().paused = true;
	
	caesarCipher.visible = false;
	exploitChain.visible = false;
	
	#disable UI
	caesarexe.set_process(false)
	exploitexe.set_process(false)
	caesarexe.visible = false;
	exploitexe.visible = false;
	$"FinalCommand".visible = false
	
func set_next_game(game):
	nextGame = game
	countdownStart = true
	currDelayStart = 0
	if numGames != numGamesLeft:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		show_enemy_text(enemylines[rng.randi_range(0, enemylines.size() - 1)])

	numGamesLeft -= 1;
	if(numGamesLeft < 0):
		$"AccessGranted".visible = true
		$"EnemyPanel/Timer".connect("timeout", self, "quit")
		$"EnemyPanel/Timer".wait_time = 5
		$"EnemyPanel/Timer".start()
		return
	
	reset_games();
	
	match game:
		0:
			caesarexe.visible = true;
		1:
			exploitexe.visible = true;
	
func set_game(game):
	#opening anim
	match game:
		0:
			caesarCipherScript._reset()
			caesarexe.set_process(true)
			caesarexe.visible = true;
			caesarCipher.get_tree().paused = false;
			caesarCipher.visible = true;
			#expectedPassword = caesarCipher.get_password();
		1:
			exploitChain.setup_level(rng.randi_range(4, 8))
			exploitexe.set_process(true)
			exploitexe.visible = true;
			exploitChain.get_tree().paused = false;
			exploitChain.visible = true;
			#expectedPassword = exploitChain.get_password();
		
func get_password():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"EnemyPanel/GamesLeft/GamesLeftNum".text = str(numGamesLeft)
	if(countdownStart == true):
		currDelayStart += delta
	if(currDelayStart > delayStart && countdownStart == true):
		set_game(nextGame)
		countdownStart = false

func show_enemy_text(text):
	$"EnemyPanel/TextBox".visible = true
	$"EnemyPanel/TextBox/RichTextLabel".text = text
	$"EnemyPanel/Timer".start()

func hide_enemy_text():
	$"EnemyPanel/TextBox".visible = false

func quit():
	get_tree().quit()
