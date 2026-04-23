_G.Servers = {}

--stylua: ignore start
Servers.servers = {
  ["arduino-language-server"]   = "arduino_language_server",
	-- ["asm_lsp"]                   = "asm_lsp",
  ["bash-language-server"]      = "bashls",
  ["clangd"]                    = "clangd",
	-- ["cmake"]                     = "cmake-language-server",
  ["lua-language-server"]       = "lua_ls",
  -- ["matlab-language-server"]    = "matlab_ls",
  ["marksman"]                  = "marksman",
  -- ["pyright"]                   = "pyright",
	-- ["ruff"]                      = "ruff",
	-- ["rust_analyzer"]             = "rust-analyzer", -- install with rustup component add rust-analyzer
  ["rust_hdl"]                  = "vhdl_ls",
  ["svlangserver"]              = "svlangserver",
  ["verible"]                   = "verible",
}

Servers.formatters = {
	-- ["asmfmt"]      = "asmfmt",
	["beautysh"]    = "beautysh",
	-- ["latexindent"] = "latexindent",
	-- ["mdformat"]    = "mdformat", -- install it with pipx install mdformat && pipx inject mdformat mdformat-myst
	-- ["rustfmt"]     = "rustfmt", -- install with rustup component add rustfmt
	["stylua"]      = "latexindent",
}
--stylua: ignore end
