local M = {}

-- Tags stehen 4 Spalten eingerückt, passend zum "%le4" in autocmds.lua
local INDENT = "    "

-- Zerlegt eine Zeile in Tags, aber nur wenn sie *ausschließlich* aus Tags besteht.
-- "# Überschrift" ist damit keine Tag-Zeile, "#pasta #vegan" schon.
local function tags_in_line(line)
  local found = {}
  for token in line:gmatch("%S+") do
    if not token:match("^#%S") then
      return nil
    end
    found[#found + 1] = token
  end
  return #found > 0 and found or nil
end

--- Hängt ein Such-Tag an die letzte Zeile des aktuellen Buffers an.
--- Bereits am Dateiende vorhandene Tags werden eingesammelt und alle
--- gemeinsam, durch ein Space getrennt, in die letzte Zeile geschrieben.
---@param tag string z.B. "#vegetarisch" (das "#" darf auch fehlen)
function M.add(tag)
  tag = vim.trim(tag or "")
  if tag == "" then
    return
  end
  if not tag:match("^#") then
    tag = "#" .. tag
  end

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local tags, seen = {}, {}
  local function collect(t)
    if not seen[t] then
      seen[t] = true
      tags[#tags + 1] = t
    end
  end

  -- Rückwärts über den Tag-Block am Dateiende laufen; Leerzeilen zwischen den
  -- Tags gehören noch dazu, die erste echte Textzeile beendet die Suche.
  local body_end = #lines
  for i = #lines, 1, -1 do
    local line = lines[i]
    if vim.trim(line) == "" then
      body_end = i - 1
    else
      local found = tags_in_line(line)
      if not found then
        break
      end
      for _, t in ipairs(found) do
        collect(t)
      end
      body_end = i - 1
    end
  end

  collect(tag)
  table.sort(tags)

  local tail = { INDENT .. table.concat(tags, " ") }
  if body_end > 0 then
    table.insert(tail, 1, "") -- Leerzeile zwischen Rezept und Tags
  end
  vim.api.nvim_buf_set_lines(buf, body_end, -1, false, tail)

  -- Cursor kann im ersetzten Bereich gestanden haben
  local win = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(win)[1]
  local count = vim.api.nvim_buf_line_count(buf)
  if row > count then
    vim.api.nvim_win_set_cursor(win, { count, 0 })
  end
end

return M
