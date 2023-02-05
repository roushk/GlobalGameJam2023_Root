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

# Called when the node enters the scene tree for the first time.
func _ready():
	exploitChain = get_node("ExploitChain");
	caesarCipher = get_node("CaesarCipher");
	rooty = get_node("Rooty");
	terminal = get_node("Terminal");
	enemy = get_node("EnemyPanel");
	
	caesarexe = get_node("EnemyPanel/Games/Caesar")
	exploitexe = get_node("EnemyPanel/Games/ExploitChain")
	
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
	
	numGamesLeft = numGames;
	pass # Replace with function body.

func set_game(game):
	#opening anim
	match game:
		0:
			caesarexe.set_process(true)
			caesarexe.visible = true;
			caesarCipher.get_tree().paused = false;
			caesarCipher.visible = true;
			#expectedPassword = caesarCipher.get_password();
		1:
			exploitexe.set_process(true)
			exploitexe.visible = true;
			exploitChain.get_tree().paused = false;
			exploitChain.visible = true;
			#expectedPassword = exploitChain.get_password();
		
func get_password():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(countdownStart == true):
		currDelayStart += delta
	if(currDelayStart > delayStart && countdownStart == true):
		set_game(1)
		countdownStart = false





