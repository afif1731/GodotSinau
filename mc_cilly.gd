extends CharacterBody3D

@onready var camera_mount = $playerCam
@onready var gun_anim = $playerCam/Camera3D/tembak/AnimationPlayer
@onready var gun_barrel = $playerCam/Camera3D/tembak/RayCast3D

var SPEED = 5.0
const JUMP_VELOCITY = 5.5

var walk_sped = 5.0
var run_sped = 10.0

@export var sens_hrzntal = 0.5
@export var sens_vrtical = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var bullet = load("res://bullet.tscn")
var instance

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_hrzntal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vrtical))

func _physics_process(delta):
	
	if Input.is_action_pressed("running"):
		SPEED = run_sped
	else:
		SPEED = walk_sped
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("shot"):
		if !gun_anim.is_playing():
			gun_anim.play("shooting")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
	
	move_and_slide()


func _on_area_3d_body_entered(body):
	pass # Replace with function body.
