package vxl.player;

import h3d.prim.Sphere;
import h3d.scene.Mesh;
import vxl.utils.VXLMath;
import hxd.Math;
import hxd.Window;
import h3d.scene.Scene;
import vxl.scnene.SceneManager.SCENE;
import h3d.Camera;
import h3d.Vector;
import h3d.scene.Object;

class Player extends Object {
	private var camera:Camera;
	private var currentMouseXView:Float = 0;
	private var currentMouseYView:Float = 0;

	private var cameraPosition:Vector;
	private var cameraVerticalAngle:Float = 30;
	private var cameraHorizontalAngle:Float = 0;
	private var cameraDistance = 10;

	private var position:Vector;
	private var playerSpeed:Float = 2;

	public function new(_position:Vector) {
		super();
		camera = new Camera();
		// cameraPosition = new Vector(0, 0, 0);
		position = _position;
		trace(cameraPosition);

		setPosition(position.x, position.y, position.z);

		var playerPrim:Sphere = new Sphere();
		playerPrim.translate(-0.5, -0.5, -0.5);
		var playerModel:Mesh = new Mesh(playerPrim, this);
		playerModel.material.color.setColor(0xFF0000);

		cast(Main.instance.sceneManager.GetScene(SCENE.GAME_WORLD), Scene).camera = camera;
		cast(Main.instance.sceneManager.GetScene(SCENE.GAME_WORLD), Scene).addChild(this);
		UpdateCamera();
		Window.getInstance().addEventTarget(OnInputEvent);
	}

	private function OnInputEvent(event:hxd.Event) {
		if (event.kind == EMove) {
			if (currentMouseXView == 0 && currentMouseYView == 0) {
				currentMouseXView = event.relX;
				currentMouseYView = event.relY;
			} else {
				var diffX:Float = currentMouseXView - event.relX;
				var diffY:Float = currentMouseYView - event.relY;
				currentMouseXView = event.relX;
				currentMouseYView = event.relY;

				cameraVerticalAngle += diffY;
				if (cameraVerticalAngle < 0) {
					cameraVerticalAngle = 359;
				} else if (cameraVerticalAngle > 360) {
					cameraVerticalAngle = 0;
				}

				cameraHorizontalAngle += diffX;
				if (cameraHorizontalAngle < 0) {
					cameraHorizontalAngle = 360;
				} else if (cameraHorizontalAngle > 360) {
					cameraHorizontalAngle = 0;
				}
			}
		} else if (event.kind == EKeyDown) {
			trace(event.toString());
			if (event.keyCode == 83) {
				position.x += playerSpeed;
				cameraPosition.x -= playerSpeed;
			} else if (event.keyCode == 87) {
				position.x -= playerSpeed;
			}
		}
	}

	private function UpdatePlayer() {
		setPosition(position.x, position.y, position.z);
	}

	private function UpdateCamera() {
		cameraPosition = new Vector(cameraDistance * Math.cos(VXLMath.DegToRad(cameraHorizontalAngle)) * Math.sin(VXLMath.DegToRad(cameraVerticalAngle)),
			-cameraDistance * Math.sin(VXLMath.DegToRad(cameraHorizontalAngle)) * Math.sin(VXLMath.DegToRad(cameraVerticalAngle)),
			cameraDistance * Math.cos(VXLMath.DegToRad(cameraVerticalAngle)));
		// cameraPosition.x += position.x;
		// cameraPosition.y += position.y;
		// cameraPosition.z += position.z;
		cameraPosition = cameraPosition.add(position);
		camera.pos.set(cameraPosition.x, cameraPosition.y, cameraPosition.z);
		camera.target.set(position.x, position.y, position.z);
	}

	public function OnUpdate(dt:Float) {
		UpdatePlayer();
		UpdateCamera();
	}
}
