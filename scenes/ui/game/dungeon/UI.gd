extends CanvasLayer
class_name UI

@export var tracked_player: Player;
@export var tracked_timer: RoomTimer;

@onready var money_label: Label = $GameUI/PlayerStats/StatList/MoneyStat/PlayerMoney;
@onready var time_label: Label = $GameUI/PlayerStats/StatList/TimeStat/PlayerTime

@onready var money_label_2: Label = $VictoryUI/CenterContainer/VBoxContainer/StatList/MoneyStat/PlayerMoney;
@onready var time_label_2: Label = $VictoryUI/CenterContainer/VBoxContainer/StatList/TimeStat/PlayerTime

var pause_wait: bool = false;

var now_restart: bool = false;

func _process(_delta):
	money_label.text = str(tracked_player.money);
	time_label.text = tracked_timer.get_time_string();
	money_label_2.text = str(tracked_player.money);
	time_label_2.text = tracked_timer.get_time_string();
	
	if (tracked_player.game_end):
		$GameUI.visible = false;
		$DeathUI.visible = false;
		$VictoryUI.visible = true;
		now_restart = true;
		get_tree().paused = true;
	
	if (tracked_player.dead):
		$GameUI.visible = false;
		$DeathUI.visible = true;
		$VictoryUI.visible = false;
	else:
		$DeathUI.visible = false;
	
	if (Input.is_action_just_pressed("ig_pause")):
		if (!now_restart): get_tree().quit()
		get_tree().paused = false;
		get_tree().change_scene_to_file("res://scenes/ui/menus/MainMenu.tscn")
		#if (get_tree().paused):
		#	$PauseUI.visible = false;
		#	get_tree().paused = false;
		#else:
		#	pause_wait = true;
		#	$PauseUI.visible = true;
		#	$PauseUI/PauseContainer/PauseItems/PauseButtons/PauseWait.start()
		#	get_tree().paused = true;

func _on_resume_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menus/MainMenu.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit();
