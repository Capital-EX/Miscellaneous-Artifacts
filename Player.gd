extends KinematicBody2D
enum State { Walking, Digging }
enum Dir { Right = 0, Left = 1 }

const ACCEL = 1000.0

var speed := 0.0
var state = State.Walking
var direction = Dir.Right
var animations = [
	{ idle = "idle_right", walk = "walk_right", dig = "dig_right" },
	{ idle = "idle_left", walk = "walk_left", dig = "dig_left" }
]

onready var current_sprite := $Right


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var motion = Vector2.ZERO
	var velocity: Vector2
	
	if Input.is_action_just_pressed("dig") and state == State.Walking:
		state = State.Digging
		$Sprite.play(animations[direction]["dig"])
		$Sprite.connect("animation_finished", self, "_on_dig_finish", [], CONNECT_ONESHOT)
		
	elif state == State.Walking:
		if Input.is_action_pressed("move_right"):
			direction = Dir.Right
			motion.x = 1.0
			
		elif Input.is_action_pressed("move_left"):
			direction = Dir.Left
			motion.x = -1.0
			
		if Input.is_action_pressed("move_up"):
			motion.y = -1.0
			
		elif Input.is_action_pressed("move_down"):
			motion.y = 1.0
		
		if motion != Vector2.ZERO:
			if current_sprite.animation != "walk":
				current_sprite.play("walk_%s" % direction)
			speed += ACCEL * delta
			speed = min(speed, 500)
		else:
			if current_sprite.animation != "idle":
				current_sprite.play("idle")
			if speed >= ACCEL * delta:
				speed -= ACCEL * delta
			else:
				speed = 0.0
			
		move_and_slide(motion.normalized() * speed) 

func _on_dig_finish():
	state = State.Walking