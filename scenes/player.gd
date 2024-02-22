extends Area2D
class_name Player

@onready var move_component = $MoveComponent
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_2d = $RayCast2D
@onready var ray_cast_2d_all = $RayCast2DAll
@onready var sprite_2d = $Sprite2D

signal move(node: Node2D, node_up: Node2D)
signal moved(node: Node2D)

func _ready():
  move_component.can_move = true
  Input.set_use_accumulated_input(false)


func _physics_process(_delta: float):
  if move_component.moving():
    return

  if animation_player.current_animation != "idle":
      animation_player.play("idle")

  var offset := Vector2.ZERO
  if Input.is_action_pressed("ui_left"):
    offset.x = -Level.TILE_SIZE
  elif Input.is_action_pressed("ui_right"):
    offset.x = Level.TILE_SIZE
  elif Input.is_action_pressed("ui_up"):
    offset.y = -Level.TILE_SIZE
  elif Input.is_action_pressed("ui_down"):
    offset.y = Level.TILE_SIZE

  if _can_move_to(offset):
    move_component.move(offset)
    ray_cast_2d_all.target_position = Vector2(0.0, -Level.TILE_SIZE)
    ray_cast_2d_all.force_raycast_update()
    move.emit(self, ray_cast_2d_all.get_collider())


func _can_move_to(offset: Vector2) -> bool:
  if offset == Vector2.ZERO:
    return false
  ray_cast_2d.target_position = offset
  ray_cast_2d.force_raycast_update()
  return not ray_cast_2d.is_colliding()


func _on_move_component_move_to(direction: Vector2):
  if animation_player.current_animation != "walk":
    animation_player.play("walk")
  sprite_2d.scale.x = -1.0 if direction.x < 0.0 else 1.0 # flip_h animation


func _on_move_component_moved(_node: Node2D):
  ray_cast_2d_all.target_position = Vector2(0.0, -Level.TILE_SIZE)
  ray_cast_2d_all.force_raycast_update()
  moved.emit(self, ray_cast_2d_all.get_collider())
