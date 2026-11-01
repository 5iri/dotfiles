local M = {}
local buffer

function M.toggle()
  if buffer and vim.api.nvim_buf_is_valid(buffer) then
    local window = vim.fn.bufwinid(buffer)
    if window ~= -1 then
      -- Hide the window, keeping the shell and its scrollback alive.
      if #vim.api.nvim_list_wins() == 1 then
        vim.cmd.enew()
        vim.wo.number = true
        vim.wo.signcolumn = "yes"
      else
        vim.api.nvim_win_close(window, false)
      end
      return
    end
    local job = vim.b[buffer].terminal_job_id
    if not job or vim.fn.jobwait({ job }, 0)[1] ~= -1 then
      buffer = nil
    end
  else
    buffer = nil
  end

  local height = math.max(3, math.floor(vim.o.lines * 0.3))
  vim.cmd("botright " .. height .. "split")
  if buffer then
    vim.api.nvim_win_set_buf(0, buffer)
  else
    vim.cmd.enew()
    buffer = vim.api.nvim_get_current_buf()
    vim.fn.jobstart(vim.o.shell, { term = true })
    vim.bo[buffer].bufhidden = "hide"
  end
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.cmd.startinsert()
end

return M
