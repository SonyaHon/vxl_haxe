package vxl.world.generation;

import hxd.IndexBuffer;
import vxl.shaders.ChunkShader;
import h3d.col.Point;
import h3d.mat.Material;
import h3d.prim.Polygon;
import h3d.prim.Sphere;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import h3d.scene.Object;
import h3d.Vector;

class Chunk extends Object {
	private static final CHUNK_SIZE:Int = 16;

	private var _chunkPosition:Vector;

	private var heightMap:Array<Array<Float>>;
	private var points:Array<Array<Vector>>;
	private var primitive:Polygon;
	private var mesh:Mesh;
	private var material:Material;

	public function new(chunkPosition:Vector) {
		super();
		_chunkPosition = chunkPosition;
		setSelfPosition(_chunkPosition);
	}

	public function Generate() {
		GenerateHeightMap();
		GeneratePoints();

		GenerateDebugPoints();

		GenerateGeometry();
		// GenerateColliders();
	}

	private function setSelfPosition(pos:Vector) {
		setPosition(pos.x, pos.y, pos.z);
	}

	private function GenerateHeightMap() {
		heightMap = [];

		for (y in 0...CHUNK_SIZE) {
			heightMap.push([]);
			for (x in 0...CHUNK_SIZE) {
				heightMap[y].push(0);
			}
		}
	}

	private function GeneratePoints() {
		points = [];
		for (y in 0...CHUNK_SIZE) {
			points.push([]);
			for (x in 0...CHUNK_SIZE) {
				points[y].push(new Vector(x, y, heightMap[y][x]));
			}
		}
	}

	private function GenerateDebugPoints() {
		var prim = new Sphere();
		prim.addNormals();
		prim.scale(0.1);
		for (y in 0...CHUNK_SIZE) {
			for (x in 0...CHUNK_SIZE) {
				var dPoint = new Mesh(prim);
				var dPos = points[y][x];
				dPoint.material.shadows = false;
				dPoint.setPosition(dPos.x, dPos.y, dPos.z);
				addChild(dPoint);
			}
		}
	}

	private function pointsToArray():Array<Point> {
		var res:Array<Point> = [];

		for (y in 0...CHUNK_SIZE) {
			for (x in 0...CHUNK_SIZE) {
				var point = points[y][x];
				res.push(new Point(point.x, point.y, point.z));
			}
		}

		return res;
	}

	private function GenerateGeometry() {
		var verticies:Array<Point> = [];
		var indices:IndexBuffer = new IndexBuffer();
		primitive = new Polygon(verticies, indices);
		material = Material.create();
		material.mainPass.enableLights = false;
		// material.mainPass.addShader(new ChunkShader());
		mesh = new Mesh(primitive, material);
		addChild(mesh);
	}
}
