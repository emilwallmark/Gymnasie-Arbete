extends CharacterBody2D
class_name Player

signal attack

var speed = 250.0
var direction = "Down"

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hp_bar: ProgressBar = $HpBar
@onready var lives_lable:Label = $HpBar/Label
@onready var invincibility_bar: ProgressBar = $InvincibilityBar
@onready var slow_down_time_bar: ProgressBar = $SlowDownTimeBar
@onready var dash_bar: ProgressBar = $DashBar

@export var inventory: Inv

var invinibility: bool = false
var slowmotion: bool = false
var can_slow_down_time : bool = false
var can_dash: bool = false

const DASH_SPEED = 2000
const DASH_DURATION = 0.15

var is_dashing = false
var dash_timer = 0.0
var dash_dir = Vector2.ZERO

var damage_boost = false

func _ready() -> void:
	var fill_style := hp_bar.get_theme_stylebox("fill")
	fill_style.bg_color = Color.GREEN
	$InvincibilityBar.value = 100
"""
Syfte: Återställer färgen på hp_bar så att den är grön i början
	   Utan är den röd om man skulle dö och sedan börja om
"""

func movement(_delta: float) -> void:
	var length = (dash_dir[0]**2 + dash_dir[1]**2)**0.5
	if Input.is_action_just_pressed("Dash") and can_dash and dash_bar.value == 100 and Engine.time_scale != 0:
		start_dash()
	if is_dashing:
		dash_timer -= _delta
		velocity = dash_dir * DASH_SPEED
		if dash_timer <= 0:
			is_dashing = false
			set_collision_mask_value(3, true)
			set_collision_layer_value(2, true)
	else:
		velocity = Input.get_vector("Left", "Right", "Up", "Down") * speed
	move_and_slide()
"""
Syfte: Läser av då det är en input och sätter velocity och dashar spelaren om den ska göra det
"""
	
func _physics_process(delta: float) -> void:
	movement(delta)
"""
Syfte: Kör movement varje frame
"""

func _process(_delta: float) -> void:
	hp_bar.value = Globals.player_lives/float(Globals.player_max_lives) * 100
	lives_lable.text = str(Globals.player_lives) + "/" + str(Globals.player_max_lives)
	if Input.is_action_just_pressed("Action") and Engine.time_scale != 0:
		emit_signal("attack")
	if Input.is_action_just_pressed("Invincibility") and invinibility and Engine.time_scale != 0 and invincibility_bar.value == 100:
		invinibility_ability()
	if Input.is_action_just_pressed("SlowDownTime") and can_slow_down_time and Engine.time_scale != 0 and slow_down_time_bar.value == 100:
		slowmotion = true
		AudioController.play_slow_down_time_sound()
		$SlowmoTimer.start()
		var tween = create_tween()
		tween.tween_property(slow_down_time_bar, "value", 0, 5.0)
		await get_tree().create_timer(5).timeout
		tween = create_tween()
		tween.tween_property(slow_down_time_bar, "value", 100, 20.0)

	if slowmotion:
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.time_scale = 0.5
		for enemy_bullet in get_tree().get_nodes_in_group("enemy_bullets"):
			enemy_bullet.time_scale = 0.5
		
	if velocity != Vector2(0,0):
		AudioController.play_walking_sound()
	if invincibility_bar.visible == false:
		print("S1")
		slow_down_time_bar.position.y = 30
	else: 
		slow_down_time_bar.position.y = 50
		print("S2")
	if slow_down_time_bar.visible == true and invincibility_bar.visible == true:
		dash_bar.position.y = 70
	elif slow_down_time_bar.visible == true or invincibility_bar.visible == true:
		dash_bar.position.y = 50
	else: 
		dash_bar.position.y = 30
	animation()
"""
Syfte: Updaterar allt som behöver updateras varje frame
Komentar: Updaterar hp_bar så den har rätt värde på allt,
		  skickar även en signal till level då man attackerar, kör animation()
		  och spelar upp gåjlud om man rör sig och kolla om spelaren försöker andvända en 
		  ability
"""	

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
"""
Syfte: Spelar upp rätt animation beronde på vad spelaren gör
"""

func take_damage(damage: int):
	AudioController.play_player_hurt_sound()
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
"""
Syfte: Gör allt som ska göras om spelaren tar skada
Parameter: damage: hur mycket skada som spelaren ska ta
"""

func _on_timer_timeout() -> void:
	check_damage()
"""
Syfte: Körs då timer har tagit slut
"""

func check_damage():
	for body in $DamegeArea.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			if !is_dashing:
				take_damage(body.damage)
			else:
				body.on_take_dmg()
				if !damage_boost:
					body.lives -= 10
				else:
					body.lives -= 15
			
"""
Syfte: Kollar om spelaren ska ta skada och om spelaren dashar skada fienden
"""

func _on_damege_area_body_entered(Node2D) -> void:
	check_damage()
	$Timer.stop()
	$Timer.start()
"""
Syfte: Kollar om något har gått in i spelaren och kör check_damage()
	   Startar även en timer så att spelaren ska forstätta ta skada om den 
	   står kvar i fienden över tid
"""

func invinibility_ability():
	$DamegeArea.monitoring = false
	AudioController.play_invinsibility_sound()
	var tween = create_tween()
	tween.tween_property(invincibility_bar, "value", 0, 5.0)
	await get_tree().create_timer(5).timeout
	$DamegeArea.monitoring = true
	tween = create_tween()
	tween.tween_property(invincibility_bar, "value", 100, 20.0)
"""
Syfte: Aktivera invincibility abilityn
"""
	

func _on_slowmo_timer_timeout() -> void:
	slowmotion = false
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.time_scale = 1
	for enemy_bullet in get_tree().get_nodes_in_group("enemy_bullets"):
		enemy_bullet.time_scale = 1
"""
Syfte: Få fiednerna att återgå till sina normalla hastigheter
"""

func start_dash():
	dash_dir = get_local_mouse_position().normalized()
	set_collision_mask_value(3, false)
	set_collision_layer_value(2, false)
	is_dashing = true
	dash_timer = DASH_DURATION
	var tween = create_tween()
	tween.tween_property(dash_bar, "value", 0, 0.2)
	await get_tree().create_timer(0.2).timeout
	tween = create_tween()
	tween.tween_property(dash_bar, "value", 100, 5)
"""
Syfte: Få spelaren att börja dasha
"""
