extends TileMap

const NEIGHBOR_DIRECTIONS := [
	Vector2.UP,
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.DOWN
	]

export var start_point := Vector2.ZERO
export var goal_point := Vector2.ZERO
export var offset := Vector2(32, 32)

var _astar := AStar2D.new()
var walkable_cells: PoolVector2Array

var _start_id := 0
var _goal_id := 0

func _create_astar_points() -> void:
	var cell_id := 0
	for cell in walkable_cells:
		_astar.add_point(cell_id, cell)

		if cell == world_to_map(start_point):
			_start_id = cell_id
		if cell == world_to_map(goal_point):
			_goal_id = cell_id

		cell_id += 1


func _connect_neighbor_cells():
	var walkable_cells_array := Array(walkable_cells)

	for point in _astar.get_points():
		var cell = _astar.get_point_position(point)

		for direction in NEIGHBOR_DIRECTIONS:
			var neighbor_cell_id = walkable_cells_array.find(cell + direction)

			if neighbor_cell_id == -1:
				continue

			_astar.connect_points(point, neighbor_cell_id)


func _get_astar_path() -> PoolVector2Array:
	var astar_path: PoolVector2Array

	_create_astar_points()
	_connect_neighbor_cells()

	astar_path = _astar.get_point_path(_start_id, _goal_id)
	return astar_path


func get_walkable_path() -> PoolVector2Array:
	var walkable_path := PoolVector2Array()

	var astar_path = _get_astar_path()

	for cell in astar_path:
		var point := map_to_world(cell)

		walkable_path.append(to_global(point) + offset)
	return walkable_path
