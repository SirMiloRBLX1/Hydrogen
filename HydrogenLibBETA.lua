local HttpService = game:GetService("HttpService")

local Hydrogen = {}

Hydrogen.API_BASE = "https://hydrogen-key-system.vercel.app/api"
Hydrogen.KEY_FILE = "hydrogen.key"

function Hydrogen.GetKey()
	if isfile and isfile(Hydrogen.KEY_FILE) then
		return readfile(Hydrogen.KEY_FILE)
	end
	return nil
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
