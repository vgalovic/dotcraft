-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    spacing = 2,
    prefix = Icons.diagnostics.prefix,
    current_line = true,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
  signs = {
    text = vim.g.have_nerd_font and {
      [vim.diagnostic.severity.ERROR] = Icons.diagnostics.error,
      [vim.diagnostic.severity.WARN] = Icons.diagnostics.warn,
      [vim.diagnostic.severity.INFO] = Icons.diagnostics.info,
      [vim.diagnostic.severity.HINT] = Icons.diagnostics.hint,
    } or {},
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
})
