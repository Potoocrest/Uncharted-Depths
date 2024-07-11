extends CollisionShape3D

@onready var mesh : Mesh =  get_node("../MeshInstance3D").mesh

func _ready():
	var collision : ConvexPolygonShape3D = mesh.create_convex_shape()
	shape = collision
