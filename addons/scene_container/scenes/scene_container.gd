@icon("res://addons/scene_container/assets/icons/scene_container.svg")
## A container that can load, switch, and transition between scenes.
extends SubViewportContainer
class_name SceneContainer

## Root node of the loaded scene. It is removed and replaced by a new one when the scenes are switched.
@export var main_node: Node

## Current transition.
@export var transition: Transition 

var _subviewport: SubViewport

## Loads and then sets the scene of this [SceneContainer].[br][br]
## When [code]instant[/code] is true, causes the scene to load without async (might cause lag spike depending on the size and complexity of the scene).
func request_scene(path: String, instant: bool = false) -> void:
	var next_scene: PackedScene
	
	assert(ResourceLoader.exists(path), "Invalid scene path: " + path)
	
	if transition:
		await transition._on_load_start(self)
	
	match instant:
		false:
			ResourceLoader.load_threaded_request(path)
			
			var progress_ratio: Array
			
			while !(ResourceLoader.load_threaded_get_status(path, progress_ratio) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED):
				if transition:
					transition._on_progress_update(progress_ratio[0])
				await get_tree().process_frame
			
			if transition:
					transition._on_progress_update(progress_ratio[0])
			
			next_scene = ResourceLoader.load_threaded_get(path)
		true:
			next_scene = load(path)
	
	if transition:
		await transition._on_load_end(self)
	
	_swap(next_scene)

func _swap(scene: PackedScene) -> void:
	
	if main_node:
		main_node.queue_free()
	
	var instance: = scene.instantiate()
	main_node = instance
	
	for child in self.get_children():
		if child is SubViewport:
			_subviewport = child
			break
	
	_subviewport.add_child(instance)
