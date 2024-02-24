extends Node2D
class_name Level

const TILE_SIZE = 32

var _gem_collected = 0
var _node_up: Node2D = null
var _player: Player = null

var _explosion_scene = preload("res://scenes/explosion.tscn")

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
  for monster in get_tree().get_nodes_in_group("monster"):
    monster.player = _player
    monster.area_entered.connect(_on_monster_area_entered)
  _set_camera_limits()


func _set_camera_limits():
    var map_limits = %TileMap.get_used_rect()
    _player.camera.limit_left = map_limits.position.x * TILE_SIZE
    _player.camera.limit_right = map_limits.end.x * TILE_SIZE
    _player.camera.limit_top = map_limits.position.y * TILE_SIZE
    _player.camera.limit_bottom = map_limits.end.y * TILE_SIZE


func _on_monster_area_entered(area: Area2D):
  if area.is_in_group("boulder"):
    area.queue_free()
    _explosion(area.position)


func _on_player_area_entered(area: Area2D):
  if area.is_in_group("gem"):
    area.queue_free()
    _gem_collected += 1
    %Gems.text = str(_gem_collected)
  elif area.is_in_group("boulder"):
    area.queue_free()
    _explosion(area.position)
  elif area.is_in_group("monster"):
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
  %Explosions.call_deferred("add_child", explosion)


func _on_player_move(_node: Node2D, node_up: Node2D):
  _node_up = node_up


func _on_player_moved(_node: Node2D, node_up: Node2D):
  var previous_node_up_move_component := MoveComponent.get_component(_node_up)
  if previous_node_up_move_component:
    previous_node_up_move_component.can_move = true
  var node_up_move_component := MoveComponent.get_component(node_up)
  if node_up_move_component:
    node_up_move_component.can_move = false


func _on_moved(_node: Node2D):
  for fall_component in get_tree().get_nodes_in_group("can_fall"):
    (fall_component as FallComponent).update()


func _on_explosion_done():
  var player_alive = is_instance_valid(_player)
  if not player_alive:
    get_tree().reload_current_scene()
  if player_alive:
    for fall_component in get_tree().get_nodes_in_group("can_fall"):
      (fall_component as FallComponent).update()

