extends TileMap

export(PackedScene) var Nucleon

var SIDE_LENGTH = 12
var elements = []
var matrix = []

onready var CASE_WIDTH = round(get_viewport().get_visible_rect().size.x / SIDE_LENGTH)

func _ready():
	for x in range(SIDE_LENGTH):
		var row = []
		for y in range(SIDE_LENGTH):
			row.append(null)
		matrix.append(row)


func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		#var posPixel = get_local_mouse_position()
		var posPixel = event.position
		var posCaseX = ceil(posPixel.x / CASE_WIDTH) - 1
		var posCaseY = ceil(posPixel.y / CASE_WIDTH) - 1
		if(matrix[posCaseX][posCaseY] == null):
			spawn_nucleon(posPixel, Vector2(posCaseX, posCaseY))
		
		#$Raycast.cast_to = get_local_mouse_position()
		#if !$Raycast.get_collider():
		#	spawn_nucleon(get_local_mouse_position())

func spawn_nucleon(posPx : Vector2, posCase : Vector2):
	if !Nucleon: return
	var inst = Nucleon.instance()
	#inst.position = map_to_world(world_to_map(posPx))
	inst.position = map_to_world(world_to_map(Vector2((posCase.x + 1) * CASE_WIDTH, (posCase.y + 1) * CASE_WIDTH)))
	
	inst.grid = self
	
	add_child(inst)
	
	matrix[posCase.x][posCase.y] = inst
	
	if inst.can_be_placed():
		inst.set_nucleon_type(inst.TYPES.proton)
	else:
		inst.set_nucleon_type(inst.TYPES.neutron)



func get_case_of(elt : Nucleon):
	for x in range(SIDE_LENGTH):
		for y in range(SIDE_LENGTH):
			if(matrix[x][y] == elt):
				return Vector2(x, y)
	return null

func get_element_at_pos(pos : Vector2):
	return matrix[pos.x][pos.y]
	
func _draw():
	var i = 1
	while(i < SIDE_LENGTH):
	#	draw_line(Vector2(CASE_WIDTH * i, 0), Vector2(CASE_WIDTH * i, 1920), Color(255, 0, 0), 1)
	#	draw_line(Vector2(0, CASE_WIDTH * i), Vector2(1080, CASE_WIDTH * i), Color(255, 0, 0), 1)
		draw_line(Vector2(85 * i, 0), Vector2(85 * i, 1920), Color(255, 0, 0))
		draw_line(Vector2(0, 85 * i), Vector2(1080, 85 * i), Color(255, 0, 0))
		i += 1
