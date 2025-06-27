#!/usr/bin/env lua

local success = pcall(require, "luarocks.loader")
if not success then
	-- Fallback: manually fix package.path for local development
	local current_dir = debug.getinfo(1).source:match("@?(.*/)")
	package.path = current_dir .. "../src/?.lua;" .. package.path
end

local argparse = require("argparse")
local config = require("config")
local generator = require("commit_generator")
local ollama = require("ollama_provider")

-- Load user config
local user_config = config.load_config()

-- Argument parser setup
local parser = argparse("ai-commit", "AI-assisted Git commit generator")
parser:flag("--commit", "Auto commit with generated message")
parser:flag("--config", "Run interactive config setup")
parser:flag("--show-config", "Show current ai-commit configuration")

local args = parser:parse()

-- Run config setup if requested
if args.config then
	config.interactive_setup()
	os.exit()
end

-- Show current config if requested
if args.show_config then
	print("\n🔧 Current ai-commit configuration:\n")
	for key, value in pairs(user_config) do
		print(string.format("%s: %s", key, value))
	end
	os.exit()
end

-- Determine provider and model from CLI or config
local provider = args.provider or user_config.default_provider or "local"
local model = args.model or user_config.default_model or ""

-- Fetch staged Git diff
local handle = io.popen("git diff --staged")
local diff = handle:read("*a")
handle:close()

local commit_message

if provider == "ollama" then
	commit_message = ollama.generate_commit(diff, model, user_config.ollama_host)
else
	commit_message = generator.generate_commit(diff)
end

print("\nSuggested commit message:\n" .. commit_message .. "\n")

-- Auto commit if requested
if args.commit then
	os.execute('git commit -m "' .. commit_message .. '"')
end
