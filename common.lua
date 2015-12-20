function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
function table.removeKey(t, k_to_remove)
	local new = {}
	for k, v in pairs(t) do
		new[k] = v
	end
	new[k_to_remove] = nil
	return new
end
function tableRemoveKey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end