local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Hydrogen = {}

Hydrogen.API_BASE = "https://hydrogen-key-system.vercel.app/api"
Hydrogen.KEY_FILE = "hydrogen.key"

local function getClientInfo()
	local player = Players.LocalPlayer

	return {
		UserId = player and player.UserId or 0,
		Username = player and player.Name or "Unknown",
		HWID = game:GetService("RbxAnalyticsService"):GetClientId() or "Unavailable"
	}
end

function Hydrogen.GetKey()
	local info = getClientInfo()
	local url = string.format(
		"https://hydrogen-key-system.vercel.app/generate.html?uid=%s&user=%s&hwid=%s",
		tostring(info.UserId),
		HttpService:UrlEncode(info.Username),
		HttpService:UrlEncode(info.HWID)
	)
	return url
end

function Hydrogen.ValidateKey(key)
	if not key or key == "" then
		return false, "No key provided"
	end

	local url = Hydrogen.API_BASE .. "/validate-key.js?k=" .. key

	local success, response = pcall(function()
		return game:HttpGet(url)
	end)

	if not success then
		return false, "Request failed"
	end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(response)
	end)

	if not ok or not data or not data.data or not data.data.expiresAt then
		return false, "Invalid or expired key"
	end

	return true, data.data.expiresAt
end

return Hydrogen
