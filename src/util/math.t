local Math = {}

-- Could maybe swap to double in case of precision loss.
local DECIMAL = float
Math.DECIMAL = DECIMAL

Math.sqrt = terralib.intrinsic("llvm.sqrt." .. (DECIMAL == float and "f32" or "f64"), DECIMAL -> DECIMAL)

return Math