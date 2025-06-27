local M = {}
local json = require("dkjson")
local socket = require("socket")

function M.generate_commit(diff, model, ollama_host)
	if diff == "" then
		return "chore: no changes staged for commit"
	end

	local start_time = socket.gettime()

	local prompt = [[
You are an AI that generates git commit messages.
Produce exactly one single-line message in lowercase (max 72 characters).
Use the format: <type>: <description>
Allowed types: feat, fix, chore, docs, refactor, test, style, perf, build, ci, revert.
Do not include any other text, punctuation, or quotes.

Diff:
]]

	local full_input = prompt .. diff

	local payload = {
		model = model ~= "" and model or "llama3.2:1b",
		stream = false,
		messages = {
			{
				role = "system",
				content = [[
You are an AI that generates exactly one single-line Git commit message.
Output must be lowercase, max 72 characters, in the format <type>: <description>.
Allowed types: feat, fix, chore, docs, refactor, test, style, perf, build, ci, revert.
Do not include any explanations, extra punctuation, or quotes.
]],
			},
			{ role = "user", content = full_input },
		},
	}

	local payload_json = json.encode(payload)

	-- Save JSON to a temporary file
	local tmpfile = os.tmpname()
	local file = io.open(tmpfile, "w")
	file:write(payload_json)
	file:close()

	-- Build safe curl command using @file for POST data
	local cmd = string.format(
		[[curl -s -X POST %s/api/chat -H "Content-Type: application/json" --data @%s]],
		ollama_host,
		tmpfile
	)

	local handle = io.popen(cmd)
	local response = handle:read("*a")
	handle:close()

	-- Remove temporary file
	os.remove(tmpfile)

	local ok, data = pcall(function()
		return json.decode(response)
	end)
	if not ok or not data or not data.message or not data.message.content then
		return "feat: update"
	end

	local commit_message = data.message.content:gsub("\n", " "):gsub('"', ""):gsub("'", ""):gsub("^%s*(.-)%s*$", "%1")

	if #commit_message > 72 then
		commit_message = commit_message:sub(1, 72)
	end

	local elapsed_time = string.format("%.2f", socket.gettime() - start_time)

	-- Estimate token counts (1 token ≈ 4 characters)
	local token_input = math.floor(#full_input / 4)
	local token_output = math.floor(#commit_message / 4)

	print(string.format("Model: %s", payload.model))
	print(string.format("Token Input: %d", token_input))
	print(string.format("Token Output: %d", token_output))
	print(string.format("Generated in: %s seconds", elapsed_time))

	return commit_message
end

return M
