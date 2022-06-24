local C = terralib.includec "math.h"

local Math = require "src.util.math"
local COORD = Math.DECIMAL

struct Vector3 {
	x: COORD;
	y: COORD;
	z: COORD;
}

Vector3.COORD = COORD

terra Vector3.methods.new(x: COORD, y: COORD, z: COORD)
	return Vector3 {
		x = x,
		y = y,
		z = z
	};
end

-- Overloaded mathematical operations for both single number and to another vector.
-- Vector3.metamethods.__add = OPERATOR(__add, +)
Vector3.metamethods.__add = terralib.overloadedfunction(
	"__add",
	{
		terra(self: Vector3, other: Vector3)
			return Vector3.new(
				self.x + other.x,
				self.y + other.y,
				self.z + other.z
			)
		end,

		terra(self: Vector3, other: COORD)
			return Vector3.new(
				self.x + other,
				self.y + other,
				self.z + other
			)
		end
	}
)

Vector3.metamethods.__sub = terralib.overloadedfunction(
	"__sub",
	{
		terra(self: Vector3, other: Vector3)
			return Vector3.new(
				self.x - other.x,
				self.y - other.y,
				self.z - other.z
			)
		end,

		terra(self: Vector3, other: COORD)
			return Vector3.new(
				self.x - other,
				self.y - other,
				self.z - other
			)
		end
	}
)

Vector3.metamethods.__mul = terralib.overloadedfunction(
	"__mul",
	{
		terra(self: Vector3, other: Vector3)
			return Vector3.new(
				self.x * other.x,
				self.y * other.y,
				self.z * other.z
			)
		end,

		terra(self: Vector3, other: COORD)
			return Vector3.new(
				self.x * other,
				self.y * other,
				self.z * other
			)
		end
	}
)

Vector3.metamethods.__div = terralib.overloadedfunction(
	"__div",
	{
		terra(self: Vector3, other: Vector3)
			return Vector3.new(
				self.x / other.x,
				self.y / other.y,
				self.z / other.z
			)
		end,

		terra(self: Vector3, other: COORD)
			return Vector3.new(
				self.x / other,
				self.y / other,
				self.z / other
			)
		end
	}
)

terra Vector3:clone()
	return Vector3.new (
		self.x,
		self.y,
		self.z
	)
end

terra Vector3:length_sqr()
	return self.x * self.x + self.y * self.y + self.z * self.z;
end

terra Vector3:length()
	return Math.sqrt( self:length_sqr() );
end

terra Vector3:dot(other: Vector3)
	return self.x * other.x + self.y * other.y + self.z * other.z
end

terra Vector3:cross(other: Vector3)
	return Vector3.new(
		self.y * other.z - self.z * other.y,
		-self.x * other.z - self.z * other.x,
		self.x * other.y - self.y * other.x
	)
end

terra Vector3:normalized()
	return @self / self:length()
end

-- Inline vector operations for performance.
for name, method in pairs(Vector3.methods) do
	if method.setinlined then -- Cannot inline overloaded functions unfortunately.
		method:setinlined()
	end
end

return Vector3