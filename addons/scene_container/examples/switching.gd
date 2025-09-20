extends Node

@onready var scene_container: SceneContainer = $SceneContainer

var switched := false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and not switched:
		scene_container.request_scene("res://addons/scene_container/examples/some_scene.tscn")
		
		# Alternatively, you can load using UID:
		#scene_container.request_scene("uid://lo6uhjkkeqnl")
		
		switched = true
