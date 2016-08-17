-- Returns the key of an element inside that table
function table.getKey(list, element)
    for index, value in pairs(list) do
        if value == element then
            return index
        end
    end
    return false
end

function table.count(list)
    local counter = 0
    for index, value in pairs(list) do
        counter = counter + 1
    end
    return counter
end

function table.appendList(a, b)
  local length = #a
  for i, v in ipairs(b) do
    a[length + i] = v
  end
  return a
end

function table.each(list, fn)
    for index, value in pairs(list) do
        fn(index, value)
    end
end

function table.find(list, pred)
    for i, v in pairs(list) do
        if pred(i, v) then
            return v
        end
    end
end

function table.where(list, props)
    local result = {}
    for _, item in pairs(list) do
        local hasEverything = true
        for key, wanted in pairs(props) do
            if not (item[key] == wanted) then
              hasEverything = false
            end
        end
        if hasEverything then table.insert(result, item) end
    end
    return result
end

function table.contains(list, element)
    for k, v in pairs(list) do
        if v == element then
            return true
        end
    end
    return false
end

function table.firstElement(list)
    for index, value in pairs(list) do
        return value
    end
end

function table.removeElement(list, element)
    for index, value in pairs(list) do
        if value == element then
          table.remove(list, index)
        end
    end
end

function table.getLowest(list)
    lowest = table.firstElement(list)
    for index, value in pairs(list) do
        if value < lowest then lowest = lowest end
    end
end

function table.deepcopy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.copy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

function table.resetIndice(thing)
    local newTable = {}
    if type(thing) == 'table' then
        for index, value in pairs(thing) do
            table.insert(newTable, value)
        end
    end
    return newTable
end

function table.describe(t)
  print(t)
  for k, v in pairs(t) do
    print(k, v)
  end
end
