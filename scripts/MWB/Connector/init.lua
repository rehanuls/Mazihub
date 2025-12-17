local Autocollect = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/rehanuls/Mazihub/main/scripts/MWB/functions/autocollect.lua"
))()
local AutoOpenCrate = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/rehanuls/Mazihub/main/scripts/MWB/functions/autoopencrate.lua"
))()

local Controller = {}

function Controller.toggleAutoOpen(state)
	if state then
		AutoOpenCrate.start()
	else
		AutoOpenCrate.stop()
	end
end

function Controller.toggleAutoCollect(state, delay)
	if state then
		Autocollect.start(delay)
	else
		Autocollect.stop()
	end
end

function Controller.stopAll()
	Autocollect.stop()
end

return Controller
