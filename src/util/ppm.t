local HEADER = 9

local C = terralib.includecstring [[
	#include <stdio.h>
	#include <stdlib.h>
]]

struct PPM {
	width: uint16;
	height: uint16;

	ptr: uint32;
	header_size: uint32;

	buffer_size: uint32;
	buffer: &uint8;
}

terra PPM.methods.new(width: uint16, height: uint16)
	var header_size = HEADER + digit_size(width) + digit_size(height);
	var size = sizeof(uint8) * 3 * width * height;

	return PPM {
		width = width,
		height = height,

		ptr = 0;

		header_size = header_size;
		buffer_size = size,
		buffer = [&uint8](C.malloc(size))
	};
end

terra PPM:writePixel(r: uint8, g: uint8, b: uint8)
	-- C.printf("writing to %u-%u\n", self.ptr * 3, self.ptr * 3 + 2);
	self.buffer[self.ptr] = r;
	self.buffer[self.ptr + 1] = g;
	self.buffer[self.ptr + 2] = b;

	self.ptr = self.ptr + 3;
end

-- Get ascii character size using the digits of a number.
-- Used in allocating the size of the PPM buffer
terra digit_size(num: uint16)
	var digits = 0;

	while num ~= 0 do
		digits = digits + 1;
		num = num / 10;
	end

	return sizeof(int8) * digits;
end

terra PPM:export(path: &int8)
	var f = C.fopen(path, "wb")
	if f == nil then
		C.printf("Failed to open %s", path)
		return false
	end

	C.fwrite("P6\n", 1, 3, f);

	-- Either C or Terra are very unhappy with using any form of traditional printf, and so fprintf crashes or doesn't do anything.
	-- So need to manually use sprintf with fwrite since those don't buffer the output (assuming that is the issue.)
	var width_size = digit_size(self.width);
	var width = [&int8](C.malloc(width_size));
	C.sprintf(width, "%d", self.width);
	C.fwrite(width, 1, width_size, f);

	C.fwrite(" ", 1, 1, f);

	var height_size = digit_size(self.height);
	var height = [&int8](C.malloc(height_size));
	C.sprintf(height, "%d", self.height);
	C.fwrite(height, 1, height_size, f);

	C.fwrite("\n255\n", 1, 5, f);
	C.fwrite(self.buffer, 1, self.buffer_size, f)

	C.fflush(f);
	C.fclose(f)

	return true
end

return PPM