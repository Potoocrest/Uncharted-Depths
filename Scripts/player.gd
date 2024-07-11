extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5
const GRAVITY : float = 4.9

var bouyancyMultiplier : float = 1.5
var camMode : int = 0

@onready var firstPersonCam : Camera3D = $FirstPersonCamera


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * (delta/bouyancyMultiplier)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate(Vector3(0, -1, 0),event.relative.x * get_process_delta_time() * Global.xSensitivity)
		if camMode == 0:
			firstPersonCam.rotate(Vector3(-1, 0, 0), event.relative.y * get_process_delta_time() * Global.ySensitivity)
			firstPersonCam.rotation.x = clamp(firstPersonCam.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))



