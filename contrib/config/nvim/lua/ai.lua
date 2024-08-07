local M = {}

-- Save visible lines, handling folds
function M.SaveVisibleLines(dest)
  local visibleLines = {}
  local lnum = 1
  while lnum <= vim.api.nvim_buf_line_count(0) do
    local foldclosed = vim.fn.foldclosed(lnum)
    if foldclosed == -1 then
      table.insert(visibleLines, vim.api.nvim_buf_get_lines(0, lnum-1, lnum, false)[1])
      lnum = lnum + 1
    else
      table.insert(visibleLines, vim.api.nvim_buf_get_lines(0, foldclosed-1, foldclosed, false)[1])
      table.insert(visibleLines, "...")
      table.insert(visibleLines, vim.api.nvim_buf_get_lines(0, vim.fn.foldclosedend(lnum)-1, vim.fn.foldclosedend(lnum), false)[1])
      lnum = vim.fn.foldclosedend(lnum) + 1
    end
  end
  vim.fn.writefile(visibleLines, dest)
end

-- Fill holes using different models
function M.FillHoles(model)
  local tmpFile
  if vim.fn.bufname('%') == '' then
    tmpFile = vim.fn.tempname()
    vim.cmd("w " .. tmpFile)
  else
    vim.cmd('w')
    tmpFile = vim.fn.expand('%:p')
  end
  M.SaveVisibleLines('.fill.tmp')
  vim.fn.system('NODE_NO_WARNINGS=1 holefill ' .. tmpFile .. ' .fill.tmp ' .. model)
  vim.fn.system('rm .fill.tmp')
  vim.cmd('edit!')
end

return M
