extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5
const GRAVITY : float = 4.9

@export var buoyancyMultiplier : float = 1.5
@export var dragWeight : float = 0.075
@export var offGroundDragWeight : float = 0.008
@export var accelerationWeight : float = 0.15
@export var offGroundAccelerationWeight : float = 0.05

var camMode : int = 0

@onready var cameras : Array = [$FirstPersonCamera, $SpringArm/ThirdPersonCamera]
@onready var springArm = $SpringArm


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if Input.is_action_just_pressed("switch_cam_mode"):
		_switch_cam_mode()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * (delta/buoyancyMultiplier)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if !Input.is_action_pressed("jump") and !is_on_floor() and velocity.y > 0:
		velocity.y = lerpf(velocity.y, 0, 0.03)
		

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			velocity.x = lerpf(velocity.x, direction.x * SPEED, accelerationWeight)
			velocity.z = lerpf(velocity.z, direction.z * SPEED, accelerationWeight)
		else:
			velocity.x = lerpf(velocity.x, direction.x * SPEED, offGroundAccelerationWeight)
			velocity.z = lerpf(velocity.z, direction.z * SPEED, offGroundAccelerationWeight)
	else:
		if is_on_floor():
			if (velocity.x < 0.01 and velocity.x > 0) or (velocity.x > -0.01 and velocity.x < 0):
				velocity.x = 0
			else:
				velocity.x = lerpf(velocity.x, 0, dragWeight)
			if (velocity.z < 0.01 and velocity.z > 0) or (velocity.z > -0.01 and velocity.z < 0):
				velocity.z = 0
			else:
				velocity.z = lerpf(velocity.z, 0, dragWeight)
		else:
			velocity.x = lerpf(velocity.x, 0, offGroundDragWeight)
			velocity.z = lerpf(velocity.z, 0, offGroundDragWeight)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate(Vector3(0, -1, 0),event.relative.x * get_process_delta_time() * Global.xSensitivity)
		if !camMode:
			cameras[0].rotate(Vector3(-1, 0, 0), event.relative.y * get_process_delta_time() * Global.ySensitivity)
			cameras[0].rotation.x = clamp(cameras[0].rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
		else:
			springArm.rotate(Vector3(-1, 0, 0), event.relative.y * get_process_delta_time() * Global.ySensitivity)
			springArm.rotation.x = clamp(springArm.rotation.x, deg_to_rad(-70.0), deg_to_rad(50.0))
	
func _switch_cam_mode():
	camMode = !camMode
	cameras[camMode].current = true

