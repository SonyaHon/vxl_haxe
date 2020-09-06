package vxl.world.generation;

import h3d.scene.Mesh;
import h3d.prim.Cube;
import h3d.scene.Object;
import h3d.Vector;

class Chunk extends Object {
	private static final CHUNK_SIZE:Int = 16;

	private var _chunkPosition:Vector;

	private var heightMap:Array<Array<Float>>;
	private var points:Array<Array<Vector>>;

	public function new(chunkPosition:Vector) {
		super();
		_chunkPosition = chunkPosition;
		setSelfPosition(_chunkPosition);
	}

	public function Generate() {
		GenerateHeightMap();
		GeneratePoints();
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
}
