extends Node2D
class_name AutoMoveComponent

@export var player: Player = null
@export var move_component: MoveComponent = null
@onready var ray_cast_2d = $RayCast2D

var rng = RandomNumberGenerator.new()
var _previous_offset := Vector2.ZERO

static var DIRS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

func _physics_process(_delta):
  if not move_component.moving():
    random_move()


func random_move():
  var offset = _previous_offset if _previous_offset != Vector2.ZERO else DIRS[rng.randi_range(0, DIRS.size() - 1)] * Level.TILE_SIZE
  ray_cast_2d.target_position = offset
  ray_cast_2d.force_raycast_update()
  var can_move_to_offset = not ray_cast_2d.is_colliding()
  _previous_offset = offset if can_move_to_offset else Vector2.ZERO
  if can_move_to_offset:
    move_component.move(offset)
