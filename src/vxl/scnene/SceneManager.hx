package vxl.scnene;

import hxd.SceneEvents;
import hxd.SceneEvents.InteractiveScene;

enum SCENE {
	MAIN_MENU;
	GAME_WORLD;
}

class SceneManager {
	private var scenes:Map<SCENE, InteractiveScene>;
	private var currentScene:SCENE = SCENE.GAME_WORLD;

	public function new() {
		scenes = [SCENE.MAIN_MENU => new h2d.Scene(), SCENE.GAME_WORLD => new h3d.scene.Scene()];
	}

	public function GetCurrentScene():InteractiveScene {
		return scenes[currentScene];
	}

	public function SetScene(scene:SCENE) {
		currentScene = scene;
	}

	public function GetScene(scene:SCENE):InteractiveScene {
		return scenes[scene];
	}
}
