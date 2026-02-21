extends CharacterBody2D
class_name Player

signal attack

const SPEED = 250.0

var direction = "Down"

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hp_bar: ProgressBar = $HpBar
@onready var lives_lable:Label = $HpBar/Label
@export var inventory: Inv


func _ready() -> void:
	var fill_style := hp_bar.get_theme_stylebox("fill")
	fill_style.bg_color = Color.GREEN
func movement(_delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down") * SPEED
	move_and_slide()
func _attack()->void:
	emit_signal("attack")

func _physics_process(delta: float) -> void:
	movement(delta)


func _process(_delta: float) -> void:
	hp_bar.value = Globals.player_lives/float(Globals.player_max_lives) * 100
	lives_lable.text = str(Globals.player_lives) + "/" + str(Globals.player_max_lives)
	if Input.is_action_just_pressed("Action") and Engine.time_scale != 0:

		_attack()
	animation()

func animation():
	if velocity[0] == 0 and velocity[1] == 0 and direction == "Down":
		anim.play("Idle_Down")
	elif velocity[0] == 0 and velocity[1] == 0 and direction == "Up":
		anim.play("Idle_Up")
	elif velocity[0] == 0 and velocity[1] == 0 and direction == "Left":
		anim.play("Idle_Left")
	elif velocity[0] == 0 and velocity[1] == 0 and direction == "Right":
		anim.play("Idle_Right")
	elif velocity[0] < 0:
		anim.play("Walk__Left")
		direction = "Left"
	elif velocity[0] > 0:
		anim.play("Walk_Right")
		direction = "Right"
	elif velocity[1] < 0:
		anim.play("Walk_Up")
		direction = "Up"
	else:
		anim.play("Walk_Down")
		direction = "Down"
		
func take_damage(damage: int):
	Globals.player_lives -= damage
	var original_color = self_modulate
	$Sprite2D.modulate = Color.RED
	var fill_style := hp_bar.get_theme_stylebox("fill")
	if fill_style is StyleBoxFlat:
		fill_style.bg_color = Color.RED
	hp_bar.add_theme_stylebox_override("fill", fill_style)
	await get_tree().create_timer(0.2).timeout
	if Globals.player_lives > 0:
		$Sprite2D.modulate = original_color
		if fill_style is StyleBoxFlat:
			fill_style.bg_color = Color.GREEN
		hp_bar.add_theme_stylebox_override("fill", fill_style)

		
func _on_timer_timeout() -> void:
	check_damage()

func check_damage():
	for body in $DamegeArea.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			take_damage(body.damage)

func _on_damege_area_body_entered(Node2D) -> void:
	check_damage()
	$Timer.stop()
	$Timer.start()
