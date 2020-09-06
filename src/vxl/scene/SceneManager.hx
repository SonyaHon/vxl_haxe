package vxl.scene;

enum SCENE {
	WORLD;
}

class SceneManager {
	private var scenes:Map<SCENE, hxd.SceneEvents.InteractiveScene>;
	private var currentScene:SCENE = SCENE.WORLD;

	public function new() {
		scenes = [SCENE.WORLD => new h3d.scene.Scene()];
	}

	public function getCurrentScene():hxd.SceneEvents.InteractiveScene {
		return scenes[currentScene];
	}

	public function get3dScene(scene:SCENE):h3d.scene.Scene {
		return cast(scenes[scene], h3d.scene.Scene);
	}
}
