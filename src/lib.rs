use zed_extension_api::{self as zed, LanguageServerId, Result};

struct MojoExtension;

impl MojoExtension {
    fn find_lsp_binary(&self, worktree: &zed::Worktree) -> Result<String> {
        // 1. Check PATH (covers pip, conda, magic, and globally installed mojo)
        if let Some(path) = worktree.which("mojo-lsp-server") {
            return Ok(path);
        }

        // 2. Check pixi environment in the project directory
        //    Use worktree API to detect pixi project (WASM can't access fs directly)
        if worktree.read_text_file("pixi.toml").is_ok()
            || worktree.read_text_file("pixi.lock").is_ok()
        {
            let root = worktree.root_path();
            return Ok(format!("{}/.pixi/envs/default/bin/mojo-lsp-server", root));
        }

        // 3. Check MODULAR_HOME env var — try known subdirectory paths
        let shell_env = worktree.shell_env();
        if let Some((_, modular_home)) = shell_env.iter().find(|(k, _)| k == "MODULAR_HOME") {
            return Ok(format!(
                "{}/pkg/packages.modular.com_mojo/bin/mojo-lsp-server",
                modular_home
            ));
        }

        // 4. Fall back to default ~/.modular location
        if let Some((_, home)) = shell_env.iter().find(|(k, _)| k == "HOME") {
            return Ok(format!(
                "{}/.modular/pkg/packages.modular.com_mojo/bin/mojo-lsp-server",
                home
            ));
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
        let command = self.find_lsp_binary(worktree)?;

        Ok(zed::Command {
            command,
            args: vec![],
            env: worktree.shell_env(),
        })
    }
}

zed::register_extension!(MojoExtension);
