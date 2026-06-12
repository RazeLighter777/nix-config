-- Hyprland main config (Lua, 0.55+).
-- Sub-modules live alongside this file and are loaded via require().
-- The optional helper below skips require() when the module isn't installed,
-- avoiding the noisy config-error overlay Hyprland would otherwise show.

local function maybe_require(mod)
	if package.searchpath(mod, package.path) then
		require(mod)
	end
end

require("look_and_feel")
require("input")
require("autostart")
require("binds")

-- Optional Lua bundles populated by other modules / external tools.
maybe_require("binds_brightness") -- only when my.brightnessctl.enable = true

-- nwg-displays still writes legacy hyprlang syntax (monitors.conf / workspaces.conf).
-- Translate each line into the typed Lua API so `hyprctl reload` picks up edits.
local function load_nwg_conf(filename)
	local path = os.getenv("HOME") .. "/.config/hypr/" .. filename
	local f = io.open(path, "r")
	if not f then return end
	for raw in f:lines() do
		local line = raw:gsub("#.*$", ""):match("^%s*(.-)%s*$")
		if line ~= "" then
			local key, value = line:match("^([^=]+)=(.*)$")
			key = key and key:match("^%s*(.-)%s*$")
			if key == "monitor" then
				local fields = {}
				for tok in value:gmatch("[^,]+") do
					fields[#fields + 1] = tok
				end
				hl.monitor({
					output   = fields[1] or "",
					mode     = fields[2] or "preferred",
					position = fields[3] or "auto",
					scale    = tonumber(fields[4]) or fields[4] or "auto",
				})
			elseif key == "workspace" then
				local fields = {}
				for tok in value:gmatch("[^,]+") do
					fields[#fields + 1] = tok
				end
				local rule = { workspace = fields[1] }
				for i = 2, #fields do
					local k, v = fields[i]:match("^([^:]+):(.*)$")
					if k then
						if v == "true" then v = true
						elseif v == "false" then v = false
						elseif tonumber(v) then v = tonumber(v) end
						rule[k] = v
					end
				end
				hl.workspace_rule(rule)
			end
		end
	end
	f:close()
end

load_nwg_conf("monitors.conf")
load_nwg_conf("workspaces.conf")
