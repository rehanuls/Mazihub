local Autocollect = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/rehanuls/Mazihub/main/scripts/MWB/functions/autocollect.lua"
))()

local Controller = {}

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
