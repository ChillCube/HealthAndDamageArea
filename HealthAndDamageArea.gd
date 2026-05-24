@icon("res://addons/HealthAndDamageArea/heart_outline.png")
extends DamageReceiver
class_name HealthAndDamageArea2D

@export var stats : LevelUpResource;
@export var damage_formula : DamageFormula;
@export var destroy_on_0 : bool = true;
var hp : float;
var max_hp : float;

signal health_lost(damage : float)
signal out_of_health

func _ready() -> void:
	self.connect("take_damage", _on_take_damage)
	stats.load_level_health_and_stats(name)
	hp = stats.max_hp;
	max_hp = stats.max_hp;

func _on_take_damage(damage : float):
	var prev_health = hp
	var defense := stats.stats.get("Defense", 0.0) as float
	var effective := damage_formula.calculate(damage, stats) if damage_formula else damage
	hp -= effective;
	if hp < prev_health:
		emit_signal("health_lost", effective)
	if hp < 0:
		emit_signal("out_of_health")
		if destroy_on_0:
			get_parent().queue_free();
