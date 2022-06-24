local Enum = require "src.util.enum"

local Sphere = require "src.object.sphere"

local ObjectKind = Enum("Sphere")

struct Object {
	kind: ObjectKind.type;
	union {
		sphere: Sphere
	}
}

local List = require "terralist"

Object.List = List()
Object.Kind = ObjectKind

terra Object.methods.new(kind: ObjectKind.type)
	return Object {
		kind = kind
	}
end

-- Do our own dynamic dispatch :p
terra Object:intersect(ray: Ray, t_min: float, t_max: float, hit: Hit)
	switch self.kind do
		case ObjectKind.Sphere then
			return self.sphere:intersect(ray, t_min, t_max, hit)
		end
	else
		return false
	end
end

return Object