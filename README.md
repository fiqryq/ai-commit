# AI-commit assistant powered by ollama 
`ai-commit` is a Lua-based, Ollama-driven Git commit message assistant that streamlines your workflow by generating commit messages for you.

https://github.com/user-attachments/assets/255532b9-d08a-4485-95c6-51f663398c97

## Installation

### Using Homebrew (macOS)

```bash
brew install fiqryq/ai-commit/ai-commit
```

### Manual Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/fiqryq/ai-commit.git
    cd ai-commit
    ```

2.  **Install dependencies:**

    Make sure you have Lua and LuaRocks installed. Then, install the required Lua modules:

    ```bash
    luarocks install argparse
    luarocks install dkjson
    luarocks install luasocket
    ```

3.  **Make the script executable:**

    ```bash
    chmod +x bin/ai-commit
    ```

4.  **Add to your PATH:**

    For ease of use, add the `bin` directory to your system's `PATH`:

    ```bash
    export PATH=$PATH:/path/to/ai-commit/bin
    ```

## Usage

To generate a commit message for your staged changes, simply run:

```bash
ai-commit
```

### Auto-Commit

To automatically commit the generated message, use the `--commit` flag:

```bash
ai-commit --commit
```

### Commands

| Command           | Description                                  |
| ----------------- | -------------------------------------------- |
| `ai-commit`       | Generate a commit message for staged changes |
| `ai-commit --commit` | Generate and automatically commit the message  |
| `ai-commit --config`  | Run the interactive configuration setup      |
| `ai-commit --show-config` | Show the current `ai-commit` configuration   |

## Configuration

`ai-commit` can be configured by running the interactive setup:

```bash
ai-commit --config
```

This will guide you through setting up:

-   **Default Provider**: The AI provider to use (e.g., `ollama`).
-   **Default Model**: The specific model to use for generating messages.
-   **Ollama Host**: The hostname or IP address of your Ollama instance.

Your configuration will be saved at `~/.config/ai-commit/config.json`.

## Local Development and Debugging

If you're contributing to `ai-commit` or need to debug it locally, follow these steps:

1.  **Clone the repository** and navigate into the directory.

2.  **Run the script directly:**

    You can run the `ai-commit` script from the `bin` directory to test your changes:

    ```bash
    lua bin/ai-commit
    ```

3.  **Build on local:**

    ```bash
    luarocks make
    ```


