class_name Nucleon
extends StaticBody2D

enum TYPES {
	proton,
	neutron
}

export (TYPES) var nucleon_type setget set_nucleon_type
export (Texture) var neutron_sprite
export (Texture) var proton_sprite

onready var grid : TileMap = get_parent()

#func _init(posCase : Vector2):
#	var case : Vector2 = posCase

func _process(delta):
	if Engine.editor_hint:
		_editor_process(delta)	
		return
	update()

func _editor_process(delta):
	pass


func get_neighbors(not_used_dir=0):
	var case = grid.get_case_of(self)
	
	var neighbors_pos = []
	
	if(case.x > 0 and not_used_dir != 3):
		neighbors_pos.append(Vector2(case.x - 1, case.y))
	if(case.x < grid.SIDE_LENGTH - 1 and not_used_dir != 4):
		neighbors_pos.append(Vector2(case.x + 1, case.y))
	if(case.y > 0 and not_used_dir != 2):
		neighbors_pos.append(Vector2(case.x, case.y - 1))
	if(case.y < grid.SIDE_LENGTH - 1 and not_used_dir != 1):
		neighbors_pos.append(Vector2(case.x, case.y + 1))
	
	var neighbors = []
	
	for pos in neighbors_pos:
		var neighbor = grid.get_element_at_pos(pos)
		if(neighbor != null): neighbors.append(neighbor)
	
	return neighbors

func get_nb_neighbor_proton(not_used_dir=0):
	var nb_neighbor_protons = 0
	
	var neighbors = get_neighbors(not_used_dir)
	for neighbor in neighbors:
		if(neighbor.nucleon_type == TYPES.proton):
			nb_neighbor_protons += 1
	
	return nb_neighbor_protons

# If there's more than 1 proton next to a proton, it cannot be placed
func can_be_placed():
	if(nucleon_type == TYPES.neutron): return true
	
	var nb_neighbor_protons = get_nb_neighbor_proton()
	if(nb_neighbor_protons > 1): return false
	
	var neighbors = get_neighbors()
	for neighbor in neighbors:
		if(neighbor.nucleon_type == TYPES.proton):
			var not_used_dir
			var my_pos = grid.get_case_of(self)
			var neighbor_pos = grid.get_case_of(neighbor)
			if(my_pos.x < neighbor_pos.x):
				not_used_dir = 3
			elif(my_pos.x > neighbor_pos.x):
				not_used_dir = 4
			elif(my_pos.y < neighbor_pos.x):
				not_used_dir = 2
			elif(my_pos.y > neighbor_pos.x):
				not_used_dir = 1
			return neighbor.can_be_placed_recursivity(not_used_dir)
	
	return true

""" not_used_dir
none : 0
bottom : 1
top : 2
left : 3
right : 4
"""
func can_be_placed_recursivity(not_used_dir : int):
	var nb_neighbor_protons = get_nb_neighbor_proton()
	return nb_neighbor_protons <= 1

""" Setters """


func set_nucleon_type(value, assign=true):
	if value == TYPES.proton:
		$Sprite.texture = proton_sprite
	else:
		$Sprite.texture = neutron_sprite 
	nucleon_type = value

func get_class(): return "Nucleon"


"""func _draw():
	draw_line(position, $Raycast.cast_to, Color.blue)"""
