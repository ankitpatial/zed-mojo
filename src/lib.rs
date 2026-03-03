use zed_extension_api::{self as zed, LanguageServerId, Result};

struct MojoExtension;

struct LspCommand {
    command: String,
    args: Vec<String>,
}

impl MojoExtension {
    fn find_lsp_command(
        &self,
        worktree: &zed::Worktree,
        shell_env: &[(String, String)],
    ) -> Result<LspCommand> {
        // 1. Check PATH (covers pip, conda, magic, and globally installed mojo)
        if let Some(path) = worktree.which("mojo-lsp-server") {
            return Ok(LspCommand {
                command: path,
                args: vec![],
            });
        }

        // 2. Check pixi environment — use `pixi run` so the LSP gets the
        //    correct environment (MODULAR_HOME, stdlib paths, etc.)
        if worktree.read_text_file("pixi.toml").is_ok()
            || worktree.read_text_file("pixi.lock").is_ok()
        {
            if let Some(pixi) = worktree.which("pixi") {
                return Ok(LspCommand {
                    command: pixi,
                    args: vec!["run".into(), "mojo-lsp-server".into()],
                });
            }
        }

        // 3. Check MODULAR_HOME env var
        if let Some((_, modular_home)) = shell_env.iter().find(|(k, _)| k == "MODULAR_HOME") {
            return Ok(LspCommand {
                command: format!(
                    "{}/pkg/packages.modular.com_mojo/bin/mojo-lsp-server",
                    modular_home
                ),
                args: vec![],
            });
        }

        // 4. Fall back to default ~/.modular location
        if let Some((_, home)) = shell_env.iter().find(|(k, _)| k == "HOME") {
            return Ok(LspCommand {
                command: format!(
                    "{}/.modular/pkg/packages.modular.com_mojo/bin/mojo-lsp-server",
                    home
                ),
                args: vec![],
            });
        }

        Err(
            "mojo-lsp-server not found. Please:\n\
             1. Install Mojo: https://docs.modular.com/mojo/\n\
             2. Ensure mojo-lsp-server is in your PATH, or\n\
             3. Add max to your pixi project: pixi add max, or\n\
             4. Set a custom path in Zed settings:\n\
                \"lsp\": { \"mojo-lsp-server\": { \"binary\": { \"path\": \"/path/to/mojo-lsp-server\" } } }"
                .into(),
        )
    }
}

impl zed::Extension for MojoExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let env = worktree.shell_env();
        let lsp = self.find_lsp_command(worktree, &env)?;

        Ok(zed::Command {
            command: lsp.command,
            args: lsp.args,
            env,
        })
    }
}

zed::register_extension!(MojoExtension);
