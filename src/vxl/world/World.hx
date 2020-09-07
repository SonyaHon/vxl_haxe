package vxl.world;

import h3d.scene.Object;
import vxl.scene.SceneManager.SCENE;
import h3d.scene.fwd.DirLight;
import h3d.Vector;
import vxl.world.generation.Chunk;

/**
 * Controls everething about world
 * chunk building, global lighting, entities position etc
 */
class World extends h3d.scene.Object {
	private var sun:DirLight;
	private var sunPosition:Vector;

	private var ambientLight:Vector;

	private var worldTransform:Object;
	private var loadedChunks:Array<Chunk>;

	public function new() {
		super();
		setPosition(0, 0, 0);
		Main.instance.sceneManager.get3dScene(SCENE.WORLD).addChild(this);

		worldTransform = new Object(this);
		worldTransform.setPosition(0, 0, 0);

		InitializeChunks();
		InitializeLight();
	}

	private function InitializeLight() {
		sun = new DirLight(new Vector(0.5, -0.3, -0.2), Main.instance.sceneManager.get3dScene(SCENE.WORLD));
		sunPosition = new Vector(0, 0, 10);
		ambientLight = new Vector(0.1, 0.1, 0.1);
		UpdateLight();
	}

	private function UpdateLight() {
		Main.instance.s3d.lightSystem.ambientLight.set(ambientLight.x, ambientLight.y, ambientLight.z);
		// sun.setPosition(sunPosition.x, sunPosition.y, sunPosition.z);
		// sun.setDirection(new Vector(0, 0, 0));
	}

	private function ClearWorldTransform() {
		worldTransform.removeChildren();
	}

	private function UpdateLoadedChunks() {
		for (chunk in loadedChunks) {
			worldTransform.addChild(chunk);
		}
	}

	private function InitializeChunks() {
		loadedChunks = [];

		for (y in 0...1) {
			for (x in 0...1) {
				var chunk = new Chunk(new Vector(x, y));
				chunk.Generate();
				loadedChunks.push(chunk);
			}
		}

		ClearWorldTransform();
		UpdateLoadedChunks();
	}
}
