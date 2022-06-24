local Math = require "src.util.math"
local Vector3 = require "src.util.vec3"
local COORD = Vector3.COORD

local Hit = require "src.object.hit"

struct Sphere {
	radius: COORD;
	color: Vector3;
	pos: Vector3;
}

terra Sphere.methods.new(pos: Vector3, color: Vector3, radius: COORD)
	return {
		kind = 1,
		sphere = Sphere {
			pos = pos,
			color = color,
			radius = radius
		}
	}
end

terra Sphere:intersect(ray: Ray, t_min: float, t_max: float, hit: Hit)
	-- Intersect sphere with ray using quadratic equation
	var oc = ray.pos - self.pos;

	var a = ray.dir:dot(ray.dir);
	var b = 2 * oc:dot(ray.dir);
	var c = oc:dot(oc) - self.radius * self.radius;

	var discriminant = b * b - 4 * a * c;
	if discriminant > 0 then
		var temp = (-b - Math.sqrt(b * b - a * c)) / a;
		if temp < t_max and temp > t_min then
			hit.t = temp;
			hit.pos = ray:point_at(temp);
			hit.normal = (hit.pos - self.pos) / self.radius;
			return true;
		end

		temp = (-b + Math.sqrt(b * b - a * c)) / a;
		if temp < t_max and temp > t_min then
			hit.t = temp;
			hit.pos = ray:point_at(temp);
			hit.normal = (hit.pos - self.pos) / self.radius;
			return true;
		end
	end
	return false;
end

return Sphere