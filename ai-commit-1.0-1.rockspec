rockspec_format = "3.0"

package = "ai-commit"
version = "1.0-1"
source = {
	url = "https://github.com/fiqryq/ai-commit.git",
}

description = {
	summary = "AI-assisted Git commit message generator in Lua",
	detailed = "A CLI tool to generate Git commit messages automatically.",
	homepage = "https://github.com/fiqryq/ai-commit",
	license = "MIT",
}

dependencies = {
	"lua >= 5.1",
	"argparse",
	"dkjson",
	"luasocket",
}

build = {
	type = "builtin",
	modules = {
		["commit_generator"] = "src/commit_generator.lua",
		["config"] = "src/config.lua",
		["ollama_provider"] = "src/ollama_provider.lua",
	},
	install = {
		bin = {
			["ai-commit"] = "bin/ai-commit.lua",
		},
	},
}
