local M = {}


function M.tostring(url)
	url = (type(url) == "string") and msg.url(url) or url
	return tostring(url.socket or 0) .. hash_to_hex(url.path or hash("")) .. hash_to_hex(url.fragment or hash(""))
end

return M