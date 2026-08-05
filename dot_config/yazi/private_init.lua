-- adopted from https://yazi-rs.github.io/docs/configuration/yazi
-- function Linemode:de_mtime()
-- 	local year = os.date("%Y")
-- 	local time = (self._file.cha.mtime or 0)

function Linemode:de_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		-- time = os.date("%b %d %H:%M", time)
		time = os.date("%e %b %H:%M", time)
	else
		time = os.date("%e %b  %Y", time)
	end

	-- local size = self._file:size()
	-- return string.format("%s %s", size and ya.readable_size(size) or "-", time)
	return ui.Line(string.format(" %s ", time))
end

function Linemode:size_and_de_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		-- time = os.date("%b %d %H:%M", time)
		time = os.date("%e %b %H:%M", time)
	else
		time = os.date("%e %b  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

function Linemode:de_ctime()
	local time = math.floor(self._file.cha.ctime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		-- time = os.date("%b %d %H:%M", time)
		time = os.date("%e %b %H:%M", time)
	else
		time = os.date("%e %b  %Y", time)
	end

	return ui.Line(string.format(" %s ", time))
end

-- show user:group in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end, 500, Status.RIGHT)
