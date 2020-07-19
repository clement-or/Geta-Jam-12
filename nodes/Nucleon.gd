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

func _process(delta):
	if Engine.editor_hint:
		_editor_process(delta)
		return
	update()

func _editor_process(delta):
	pass


# If there's more than 1 proton next to a proton, it cannot be placed
func check_neighbors():
	if nucleon_type == TYPES.neutron: return true
	
	var grid_pos : Vector2 = grid.world_to_map(position)
	var pos_to_check = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(1, 0),
		Vector2(-1, 0)
	]
	var neighbor_protons = 0
	
	for pos in pos_to_check:
		$Raycast.cast_to = position + (pos * grid.cell_size)
		if $Raycast.is_colliding() && $Raycast.get("nucleon_type") && $Raycast.get_collider().nucleon_type == TYPES.proton:
			neighbor_protons += 1
	
	print(neighbor_protons)
	return neighbor_protons <= 1


""" Setters """


func set_nucleon_type(value, assign=true):
	if value == TYPES.proton:
		$Sprite.texture = proton_sprite
	else:
		$Sprite.texture = neutron_sprite 
	nucleon_type = value

func get_class(): return "Nucleon"


func _draw():
	draw_line(position, $Raycast.cast_to, Color.blue)
