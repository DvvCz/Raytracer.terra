local Math = require "src.util.math"

struct Hit {
	t: Math.DECIMAL;
	pos: Vector3;
	normal: Vector3;
}

return Hit