local function get_string(quoted)
    return quoted:match('^[_%w%p@?^]-[^\\]\"([_%w%p=@?^]+[^\\])\"');
end