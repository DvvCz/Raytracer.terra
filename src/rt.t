local PPM = require "src.util.ppm"

local C = terralib.includecstring [[
	#include <stdio.h>
]]

local WIDTH, HEIGHT = 512, 512

terra main()
	var ppm = PPM.new(WIDTH, HEIGHT)

	for y = 0, HEIGHT do
		for x = 0, WIDTH do
			ppm:writePixel( [uint8]([float](x) / WIDTH * 255.0), [uint8]([float](y) / HEIGHT * 255.0), 0 )
		end
	end

	ppm:export("out.ppm")
end

main()
