Changelog:
```
1.1.0:
- Reworked parameters of the `request_scene()` function
  - Now this function takes only one parameter, which can be either String (for path or UID) or PackedScene
  - Passing PackedScene allows to be more versatile about loading the scenes, as now you can use already-loaded scenes
  - If you used the second parameter and need to migrate from the previous version, consider removing the second parameter and adding `load()` to the path:
    Before:
      `request_scene("path/to/scene.tscn", true)`
    After:
      `request_scene(load("path/to/scene.tscn"))`
- Updated documentation
- Fixed wrong path for `scene_container.tscn`
```
```
1.0.0:
- Initial release
```