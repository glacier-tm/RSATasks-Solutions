local function get_string(quoted)
    return quoted:match('^[%w%p@?^]-[^\\]\"([%w%p=@?^]+[^\\])\"');
end
