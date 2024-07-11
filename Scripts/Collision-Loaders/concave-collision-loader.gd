extends CollisionShape3D

@onready var mesh : Mesh =  get_node("../MeshInstance3D").mesh

func _ready():
	var collision : ConcavePolygonShape3D = mesh.create_trimesh_shape()
	shape = collision
