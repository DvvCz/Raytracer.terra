local Vector3 = require "src.util.vec3"

struct Ray {
	pos: Vector3;
	dir: Vector3;
}

terra Ray.methods.new(pos: Vector3, dir: Vector3)
	return Ray {
		pos = pos,
		dir = dir
	}
end

terra Ray:point_at(param: Vector3.COORD)
	return self.pos + self.dir * param
end

-- Inline ray operations for performance.
for name, method in pairs(Ray.methods) do
	method:setinlined()
end

return Ray