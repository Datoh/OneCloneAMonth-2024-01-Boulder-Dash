extends Node2D
class_name Level

const TILE_SIZE = 32

var _gem_collected = 0
var _node_up: Node2D = null
var _player: Player = null

var _explosion_scene = preload("res://scenes/explosion.tscn")

@onready var _explosions = $Explosions

func _ready():
  await get_tree().process_frame
  var players = get_tree().get_nodes_in_group("player")
  assert(players.size() == 1 and players[0] is Player)
  _player = players[0] as Player
  _player.area_entered.connect(_on_player_area_entered)
  _player.move.connect(_on_player_move)
  _player.moved.connect(_on_player_moved)
  for move_component in get_tree().get_nodes_in_group("can_move"):
    (move_component as MoveComponent).moved.connect(_on_moved)
  for fall_component in get_tree().get_nodes_in_group("can_fall"):
    (fall_component as FallComponent).update()


func _on_player_area_entered(area: Area2D):
  if area.is_in_group("gem"):
    area.queue_free()
    _gem_collected += 1
  elif area.is_in_group("boulder"):
    area.queue_free()
    _explosion(area.position)
  elif area.is_in_group("dirt"):
    area.queue_free()
  elif area.is_in_group("exit"):
    get_tree().call_deferred("reload_current_scene")


func _explosion(a_position: Vector2):
  var snapped_position = Vector2((int(a_position.x / TILE_SIZE) + 0.5) * TILE_SIZE, (int(a_position.y / TILE_SIZE) + 0.5) * TILE_SIZE)
  var explosion = _explosion_scene.instantiate()
  explosion.position = snapped_position
  explosion.explosion_done.connect(_on_explosion_done)
  _explosions.call_deferred("add_child", explosion)


func _get_move_component(node: Node2D) -> MoveComponent:
  if not node:
    return null
  for component in node.get_children():
    if component is MoveComponent:
      return component as MoveComponent
  return null


func _on_player_move(_node: Node2D, node_up: Node2D):
  _node_up = node_up


func _on_player_moved(_node: Node2D, node_up: Node2D):
  var previous_node_up_move_component := _get_move_component(_node_up) if is_instance_valid(_node_up) else null
  if previous_node_up_move_component:
    previous_node_up_move_component.can_move = true
  var node_up_move_component := _get_move_component(node_up) if is_instance_valid(node_up) else null
  if node_up_move_component:
    node_up_move_component.can_move = false


func _on_moved(_node: Node2D):
  for fall_component in get_tree().get_nodes_in_group("can_fall"):
    (fall_component as FallComponent).update()


func _on_explosion_done():
  if not is_instance_valid(_player):
    get_tree().reload_current_scene()
