local M = {}

function M.generate_commit(diff)
	if diff == "" then
		return "chore: no changes staged for commit" or "chore: no changes staged for commit"
	end
end

return M
