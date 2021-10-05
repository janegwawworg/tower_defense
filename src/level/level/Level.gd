extends Node2D

const WALKABLE_CELLS_ID := 2

onready var _path_preview := $PathPreview
onready var _astar_grid := $AStarGrid

onready var _tilemap := $TileMap
onready var _start_point := $StartPoint
onready var _goal_point := $GoalPoint
