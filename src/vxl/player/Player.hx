package vxl.player;

import vxl.scene.SceneManager.SCENE;
import hxd.Key;
import h3d.prim.Sphere;
import h3d.scene.Mesh;
import vxl.utils.VXLMath;
import hxd.Math;
import hxd.Window;
import h3d.scene.Scene;
import h3d.Camera;
import h3d.Vector;
import h3d.scene.Object;

class Player extends Object {
	private var camera:Camera;
	private var currentMouseXView:Float = 0;
	private var currentMouseYView:Float = 0;

	private var cameraPosition:Vector;
	private var MIN_VERTICAL_ANGLE:Float = 0.01;
	private var MAX_VERTICAL_ANGLE:Float = 179.99;
	private var cameraVerticalAngle:Float = 30;
	private var cameraHorizontalAngle:Float = 0;
	private var cameraDistance = 30;

	private var position:Vector;
	private var direction:Vector;
	private var moveSpeed:Float = 10;
	private var futureMove:Vector;
	private var isMoving:Bool = false;

	public function new(_position:Vector) {
		super();
		camera = new Camera();
		position = _position;
		direction = new Vector(1, 0, 0);
		futureMove = new Vector(0, 0, 0);

		setPosition(position.x, position.y, position.z);

		var playerPrim:Sphere = new Sphere();
		playerPrim.translate(-0.5, -0.5, -0.5);
		playerPrim.addNormals();
		var playerModel:Mesh = new Mesh(playerPrim, this);
		playerModel.material.shadows = false;
		playerModel.material.color.setColor(0xFF0000);

		Main.instance.sceneManager.get3dScene(SCENE.WORLD).camera = camera;
		Main.instance.sceneManager.get3dScene(SCENE.WORLD).addChild(this);
		Main.instance.sceneManager.get3dScene(SCENE.WORLD).addEventListener(OnInputEvent);
		UpdateCamera();
	}

	private function OnInputEvent(event:hxd.Event) {
		if (event.kind == EMove) { // Mouse events
			if (currentMouseXView == 0 && currentMouseYView == 0) {
				currentMouseXView = event.relX;
				currentMouseYView = event.relY;
			} else {
				var diffX:Float = currentMouseXView - event.relX;
				var diffY:Float = currentMouseYView - event.relY;
				currentMouseXView = event.relX;
				currentMouseYView = event.relY;
				cameraVerticalAngle += diffY;
				if (cameraVerticalAngle < MIN_VERTICAL_ANGLE) {
					cameraVerticalAngle = MIN_VERTICAL_ANGLE;
				} else if (cameraVerticalAngle > MAX_VERTICAL_ANGLE) {
					cameraVerticalAngle = MAX_VERTICAL_ANGLE;
				}
				cameraHorizontalAngle += diffX;
				if (cameraHorizontalAngle < 0) {
					cameraHorizontalAngle = 359.99;
				} else if (cameraHorizontalAngle > 360) {
					cameraHorizontalAngle = 0.01;
				}
			}
		}
	}

	private function UpdatePlayer(dt:Float) {
		var camX = cameraPosition.x;
		var camY = cameraPosition.y;
		var playerX = position.x;
		var playerY = position.y;
		direction = new Vector(-camX + playerX, -camY + playerY, 0);
		direction = direction.getNormalized();

		if (Key.isDown(Key.W)) {
			var temp = direction.clone();
			futureMove.x += temp.x;
			futureMove.y += temp.y;
			futureMove.z += temp.z;
		} else if (Key.isDown(Key.S)) {
			var temp = direction.clone();
			futureMove.x += temp.x * -1;
			futureMove.y += temp.y * -1;
			futureMove.z += temp.z * -1;
		}
		if (Key.isDown(Key.A)) {
			var temp = direction.clone();
			var horVector = temp.cross(new Vector(0, 0, 1));
			futureMove.x += horVector.x;
			futureMove.y += horVector.y;
			futureMove.z += horVector.z;
		} else if (Key.isDown(Key.D)) {
			var temp = direction.clone();
			var horVector = temp.cross(new Vector(0, 0, 1));
			futureMove.x += horVector.x * -1;
			futureMove.y += horVector.y * -1;
			futureMove.z += horVector.z * -1;
		}

		futureMove = futureMove.getNormalized();
		futureMove.x *= moveSpeed;
		futureMove.y *= moveSpeed;
		futureMove.z *= moveSpeed;

		position.x = position.x + (futureMove.x * dt);
		position.y = position.y + (futureMove.y * dt);
		position.z = position.z + (futureMove.z * dt);
		setPosition(position.x, position.y, position.z);
		futureMove = new Vector(0, 0, 0);
	}

	private function UpdateCamera() {
		cameraPosition = new Vector(-cameraDistance * Math.cos(VXLMath.DegToRad(cameraHorizontalAngle)) * Math.sin(VXLMath.DegToRad(cameraVerticalAngle)),
			cameraDistance * Math.sin(VXLMath.DegToRad(cameraHorizontalAngle)) * Math.sin(VXLMath.DegToRad(cameraVerticalAngle)),
			cameraDistance * Math.cos(VXLMath.DegToRad(cameraVerticalAngle)));
		cameraPosition = cameraPosition.add(position);
		camera.pos.set(cameraPosition.x, cameraPosition.y, cameraPosition.z);
		camera.target.set(position.x, position.y, position.z);
	}

	public function OnUpdate(dt:Float) {
		UpdatePlayer(dt);
		UpdateCamera();
	}
}
