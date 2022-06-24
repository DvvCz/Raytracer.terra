local C = terralib.includec "stdio.h"
local FLT_MAX = 1e37

local PPM = require "src.util.ppm"
local Vector3 = require "src.util.vec3"

local Ray = require "src.object.ray"
local Hit = require "src.object.hit"
local Object = require "src.object.object"
local Sphere = require "src.object.sphere"

local COORD = Vector3.COORD
local WIDTH, HEIGHT = 128, 128

terra color(r: Ray)
	var normalized = r.dir:normalized()
	var t = 0.5 * ( normalized.y + 1 );
	return Vector3.new(1.0, 1.0, 1.0) * (1 - t) + Vector3.new(0.5, 0.7, 1.0) * t
end

local List = require "terralist"

terra main()
	var ppm = PPM.new(WIDTH, HEIGHT)

	var sphere: Object = [Object]( Sphere.new( Vector3.new(1, 1, 1), Vector3.new(255, 0, 0), 2 ) )

	var objects: Object[1];
	objects[0] = [Object]( Sphere.new( Vector3.new(0, 0, -1), Vector3.new(255, 0, 0), 0.5 ) )

	var lower_left_corner = Vector3.new(-2, -1, -1);
	var horizontal = Vector3.new(4, 0, 0);
	var vertical = Vector3.new(0, 2, 0);
	var origin = Vector3.new(0, 0, 0);

	for y = HEIGHT, 0, -1 do
		for x = 0, WIDTH do
			var u = [COORD](x) / [COORD](WIDTH);
			var v = [COORD](y) / [COORD](HEIGHT);

			var ray = Ray.new(origin, lower_left_corner + horizontal * u + vertical * v);
			var hit: Hit;
			for i = 0, 1 do
				-- C.printf("uh %d", i);
				var obj = objects[i];
				var out = obj:intersect(ray, 0, FLT_MAX, hit);

				if out then
					C.printf("Hit!", hit.t);
				end
			end

			var col = color(ray);

			ppm:writePixel( [uint8](col.x * 255), [uint8](col.y * 255), [uint8](col.z * 255) );
		end
	end

	ppm:export("out.ppm")
end

main()
