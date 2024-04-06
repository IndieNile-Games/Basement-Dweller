extends CharacterBody2D
class_name BaseEnemy

@export_category("Enemy Config")
@export var max_health: int = 5;
@export var link_code: int = -1;

@onready var actionables_box: Node2D = get_parent().get_parent().get_node("Interactables").get_node("Props")

var health: int = max_health;

var targeting: bool = false;
var target: Node2D;

signal enemy_killed();
