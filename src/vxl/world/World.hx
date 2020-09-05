package vxl.world;

import h3d.Vector;
import h3d.scene.pbr.DirLight;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import h3d.scene.Scene;
import vxl.scnene.SceneManager;

/**
 * Controls everething about world
 * chunk building, global lighting, entities position etc
 */
class World extends h3d.scene.Object {
	private var sun:DirLight;
	private var sunPosition:Vector;

	private var ambientLight:Vector;

	public function new() {
		super();
		setPosition(0, 0, 0);
		cast(Main.instance.sceneManager.GetScene(SCENE.GAME_WORLD), Scene).addChild(this);

		InitializeChunks();
	}

	private function InitializeLight() {
		sun = new DirLight(new Vector(0.3, 0.2, 0.5));
		// sunPosition = new Vector(0, 0, 10);
		ambientLight = new Vector(0.4, 0.3, 0.2);
		addChild(sun);
		UpdateLight();
	}

	private function UpdateLight() {
		// sun.setPosition(sunPosition.x, sunPosition.y, sunPosition.z);
		// sun.setDirection(new Vector(0, 0, 0));
	}

	private function InitializeChunks() {
		var cube:Cube = new Cube();
		cube.translate(-0.5, -0.5, -0.5);
		cube.addNormals();
		var mesh:Mesh = new Mesh(cube);
		mesh.material.shadows = false;
		mesh.material.color.setColor(0x0055FF);
		mesh.setPosition(0, 0, 0);
		addChild(mesh);

		var floor:Mesh = new Mesh(cube);
		floor.material.color.setColor(0xFF00FF);
		floor.scaleX = 10;
		floor.scaleY = 10;
		floor.scaleZ = 0.2;
		floor.setPosition(0, 0, -0.2);
		addChild(floor);

		var cola:Mesh = new Mesh(cube);
		cola.scaleX = 0.5;
		cola.scaleY = 0.5;
		cola.scaleZ = 4;
		cola.material.color.setColor(0x00FF00);
		cola.setPosition(2.5, 0, 3);
		addChild(cola);
	}
}
