extends Node2D
class_name FallComponent

const DIRECTION_DOWN = Vector2.DOWN * Level.TILE_SIZE
const DIRECTION_LEFT = Vector2.LEFT * Level.TILE_SIZE
const DIRECTION_RIGHT = Vector2.RIGHT * Level.TILE_SIZE

@export var _move_component: MoveComponent = null

@onready var ray_cast_2d_dirt_gem = $RayCast2DDirtGem
@onready var ray_cast_2d_no_player = $RayCast2DNoPlayer
@onready var ray_cast_2d_no_player_no_dirt = $RayCast2DNoPlayerNoDirt

static func get_component(entity: Variant) -> FallComponent:
  if not is_instance_valid(entity) or not entity is Node:
    return null
  for child in entity.get_children():
    if child is FallComponent:
      return child as FallComponent
  return null


func update():
  if not _move_component or not _move_component.can_move or _move_component.moving():
    return

  if _can_fall_to(DIRECTION_DOWN):
    _move_component.move(DIRECTION_DOWN)
  elif _can_fall_to_side(DIRECTION_RIGHT):
    _move_component.move(DIRECTION_RIGHT)
  elif _can_fall_to_side(DIRECTION_LEFT):
    _move_component.move(DIRECTION_LEFT)


func _can_fall_to(offset: Vector2) -> bool:
  ray_cast_2d_no_player.target_position = offset
  ray_cast_2d_no_player.force_raycast_update()
  return not ray_cast_2d_no_player.is_colliding()


func _can_fall_to_side(offset: Vector2) -> bool:
  ray_cast_2d_no_player_no_dirt.target_position = DIRECTION_DOWN
  ray_cast_2d_no_player_no_dirt.force_raycast_update()
  if not ray_cast_2d_no_player_no_dirt.is_colliding():
    return false
  ray_cast_2d_no_player.target_position = offset
  ray_cast_2d_no_player.force_raycast_update()
  if ray_cast_2d_no_player.is_colliding():
    return false
  ray_cast_2d_no_player.position = offset
  ray_cast_2d_no_player.target_position = DIRECTION_DOWN
  ray_cast_2d_no_player.force_raycast_update()
  ray_cast_2d_no_player.position = Vector2.ZERO
  return not ray_cast_2d_no_player.is_colliding()
