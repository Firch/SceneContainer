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
## If [code]scene[/code] is a [String], scene will be asynchronously loaded from the file path or UID. Loading can take some time depending on the size and complexity of the scene.[br]
## If [code]scene[/code] is a [PackedScene], scene won't take any time to load.[br][br]
## During the loading process, this function will notify assigned [Transition] of this [SceneContainer] for each phase. See [Transition] for more details.[br][br]
## [i]Function's parameter only accepts [String] or [PackedScene] as the valid types. Godot currently doesn't support function overloading.[/i]
func request_scene(scene: Variant) -> void:
	var next_scene: PackedScene
	
	assert((scene is String or scene is PackedScene), "Invalid scene type: " + type_string(typeof(scene)) + " (Requested scene must be String or PackedScene)")
	if scene is String:
		assert(ResourceLoader.exists(scene), "Invalid scene path or UID: " + scene)
	
	if transition:
		await transition._on_load_start(self)
	
	if scene is String:
		ResourceLoader.load_threaded_request(scene)
		
		var progress_ratio: Array
		
		while !(ResourceLoader.load_threaded_get_status(scene, progress_ratio) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED):
			if transition:
				transition._on_progress_update(progress_ratio[0])
			await get_tree().process_frame
		
		if transition:
				transition._on_progress_update(progress_ratio[0])
		
		next_scene = ResourceLoader.load_threaded_get(scene)
	elif scene is PackedScene:
		next_scene = scene
	
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
