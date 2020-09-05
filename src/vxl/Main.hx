package vxl;

import sdl.Sdl;
import hxd.Window;
import h3d.Vector;
import vxl.scnene.SceneManager;
import vxl.world.World;
import vxl.player.Player;
import hxd.App;

class Main extends App {
	public static final instance:Main = new Main();

	public var sceneManager:SceneManager;
	public var world:World;
	public var player:Player;

	override function init() {
		super.init();

		sceneManager = new SceneManager();
		world = new World();
		player = new Player(new Vector(0, 0, 0));

		this.setScene(sceneManager.GetCurrentScene());
		Sdl.setRelativeMouseMode(true);
	}

	override function update(dt:Float) {
		player.OnUpdate(dt);
	}

	static function main() {}
}
