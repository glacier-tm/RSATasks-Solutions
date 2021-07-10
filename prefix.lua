-- prefix task solution for "RSA" Challenges

local operator_precedence_pattern = '[&+-]';

local enum_token_types = {
    _sum = 0;
    _add = 1;
    _sub = 2;
    _number = 3;
};

local operator_token_map = {
    ['&'] = enum_token_types._sum;
    ['+'] = enum_token_types._add;
    ['-'] = enum_token_types._sub;
};

-- expression tree
local expression_tree = { }; -- kinda type of an abstract syntax tree
expression_tree.__index = expression_tree;

local sum_all = function(n) -- partial sum formula is shit so O(n)
    local total = 0;
    for i = 1, n, 1 do
        total = total + i;
    end
    return total;
end

function expression_tree.init(operated_token)
    return setmetatable({
        _operated_token = operated_token;
        _left = nil;
        _right = nil;
    }, expression_tree);
end

function expression_tree:fill_node(leaf) -- precedence for every operation is always left > right
    if (self._left == nil) then
        self._left = leaf;
    elseif (self._right == nil) then
        self._right = leaf;
    end
end

function expression_tree:build_tree(token_stack) -- simple method to build our tree
    local tree_root = expression_tree.init(table.remove(token_stack, 1)); -- always read an operation first ( PN aka polish notation )
    while (#token_stack > 0) do -- try read all tokens & build recursivly from bottom
        local current_token = token_stack[1]; -- peek for each token
        if (tonumber(current_token._token_value)) then
            tree_root:fill_node(expression_tree.init(table.remove(token_stack, 1))); -- pop token
        elseif (current_token._token_type == enum_token_types._add or current_token._token_type == enum_token_types._sub or current_token._token_type == enum_token_types._sum) then
            tree_root:fill_node(expression_tree:build_tree(token_stack)); -- construct a new node for our tree root if we hit a token and keep it as either left/right
        end
    end
    return tree_root;
end

function expression_tree:to_number() -- recursivly visit each node in the graph.
    local operated_token = self._operated_token;
    if (operated_token._token_type == enum_token_types._number) then
        return operated_token._token_value;
    end

    if (operated_token._token_type == enum_token_types._sum) then
        return sum_all(self._left:to_number());
    elseif (operated_token._token_type == enum_token_types._add) then
        return self._left:to_number() + self._right:to_number();
    elseif (operated_token._token_type == enum_token_types._sub) then
        return self._left:to_number() - self._right:to_number();
    end
end

-- token type
local token = { };
token.__index = token;

function token.construct(type, value)
    return setmetatable({
        _token_type = type;
        _token_value = value;
    }, token);
end


-- tokenizer
local tokenizer = { }; -- lex tokens
tokenizer.__index = tokenizer;

function tokenizer.init(str)
    return setmetatable({
        _tokens = { unpack({}, 1, #str) }; --table.create(#str, nil); -- initial re-hashings.
        _to_tokenize = str;
    }, tokenizer);
end

function tokenizer:reset()
    table.clear(self._tokens);
    self._to_tokenize = nil;
end

function tokenizer:get_tokens()
    return self._tokens;
end

function tokenizer:tokenize()
    -- yes i did not add a stream class with peek etc yet im lazy
    for _, current_char in ipairs(self._to_tokenize:split('')) do -- read all tokens till eof
        --local token;
        if (current_char:match(operator_precedence_pattern)) then -- slower but good once there will be more ops
            table.insert(self._tokens, token.construct(operator_token_map[current_char]));
        elseif (tonumber(current_char)) then -- is num?
            table.insert(self._tokens, token.construct(enum_token_types._number, tonumber(current_char)));
        end
    end
end

local eval = function(str)
    local tokenizer_job = tokenizer.init(str);
    tokenizer_job:tokenize();
    local tokens = tokenizer_job:get_tokens();
    local root = expression_tree.init();
    return root:build_tree(tokens):to_number();
end

print(eval('&+4&&+65'));
