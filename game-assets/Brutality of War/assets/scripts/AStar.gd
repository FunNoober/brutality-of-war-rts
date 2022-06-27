extends Spatial

var grid_step : float = 1
var grid_y = 0.1
var points : Dictionary = {}
var astar = AStar.new()

func _ready() -> void:
	var pathables = get_tree().get_nodes_in_group("ground")
	_add_points(pathables)
	_connect_points()

func _add_points(pathables : Array):
	for pathable in pathables:
		var mesh : MeshInstance = pathable.get_node("MeshInstance")
		var aabb: AABB = mesh.get_transformed_aabb()
		
		var start_point = aabb.position
		
		var x_steps = aabb.size.x / grid_step
		var z_steps = aabb.size.z / grid_step
		
		for x in x_steps:
			for z in z_steps:
				var next_point = start_point + Vector3(x * grid_step, 0, z * grid_step)
				_add_point(next_point)

func _add_point(point : Vector3):
	point.y = grid_y
	
	var id = astar.get_available_point_id()
	astar.add_point(id, point)
	points[world_to_astar(point)] = id
	
func _connect_points():
	for point in points:
		var pos_str = point.split(",")
		var world_pos = Vector3(pos_str[0], pos_str[1], pos_str[2])
		var search_coords = [-grid_step, 0, grid_step]
		for x in search_coords:
			for z in search_coords:
				var search_offset = Vector3(x, 0, z)
				if search_offset == Vector3.ZERO:
					continue
					
				var potential_neighbor = world_to_astar(world_pos + search_offset)
				if points.has(potential_neighbor):
					var cur_id = points[point]
					var neighbor_id = points[potential_neighbor]
					if not astar.are_points_connected(cur_id, neighbor_id):
						astar.connect_points(cur_id, neighbor_id)

func find_path(from, to):
	var start_id = astar.get_closest_point(from)
	var end_id = astar.get_closest_point(to)
	return astar.get_point_path(start_id, end_id)

func world_to_astar(world_point : Vector3):
	var x = stepify(world_point.x, grid_step)
	var y = stepify(world_point.y, grid_step)
	var z = stepify(world_point.z, grid_step)

	return "%d,%d,%d" % [x, y, z]
