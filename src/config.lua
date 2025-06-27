local M = {}
local config_path = os.getenv("HOME") .. "/.ai-commit-config.json"

function M.load_config()
	local file = io.open(config_path, "r")
	if not file then
		return {} -- Return empty if config not found
	end
	local content = file:read("*a")
	file:close()

	local ok, json = pcall(function()
		return require("dkjson").decode(content)
	end)
	if ok then
		return json
	else
		return {}
	end
end

function M.save_config(config)
	local file = io.open(config_path, "w")
	if file then
		local json = require("dkjson").encode(config, { indent = true })
		file:write(json)
		file:close()
	end
end

function M.interactive_setup()
	print("Setting up ai-commit config:")

	io.write("Default provider (ollama) [ollama]: ")
	local provider = io.read()
	if provider == "" then
		provider = "ollama"
	end

	io.write("Default model (optional, e.g. llama3.2:1b): ")
	local model = io.read()

	io.write("Ollama host (default http://localhost:11434): ")
	local ollama_host = io.read()
	if ollama_host == "" then
		ollama_host = "http://localhost:11434"
	end

	local config = {
		default_provider = provider,
		default_model = model,
		ollama_host = ollama_host,
	}

	M.save_config(config)
	print("\n✅ Config saved at: " .. config_path)
end

return M
