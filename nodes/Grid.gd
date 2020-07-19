extends TileMap


export(PackedScene) var Nucleon

var elements = []

func _ready():
	var matrix = []
	for x in range(50):
		matrix.append([])
		for y in range(50):
			matrix[x].append(null)


func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		$Raycast.cast_to = get_local_mouse_position()
		if !$Raycast.get_collider():
			spawn_nucleon(get_local_mouse_position())

func spawn_nucleon(pos : Vector2):
	if !Nucleon: return
	var inst = Nucleon.instance()
	inst.position = map_to_world(world_to_map(pos))
	
	inst.grid = self
	
	add_child(inst)
	
	
	inst.nucleon_type = inst.TYPES.proton if inst.check_neighbors() else inst.set_nucleon_type(inst.TYPES.neutron)
