type SourceNode__DARKLUA_TYPE_a<T> = {
    cache: T,
    [number]: Node__DARKLUA_TYPE_b<T>
}

type Node__DARKLUA_TYPE_b<T> =  {
    cache: T,
    effect:  ((T) -> T) | false,
    cleanups: { () -> () } | false,

    context: { [number]: unknown } | false,

    owned: { Node__DARKLUA_TYPE_b<T> } | false,
    owner: Node__DARKLUA_TYPE_b<T> | false,

    parents: { SourceNode__DARKLUA_TYPE_a<T> },
    [number]: Node__DARKLUA_TYPE_b<T> -- children
}

type Node__DARKLUA_TYPE_c<T> = Node__DARKLUA_TYPE_b<T>

type Node__DARKLUA_TYPE_d<T> = Node__DARKLUA_TYPE_b<T>

type Node__DARKLUA_TYPE_e<T> = Node__DARKLUA_TYPE_b<T>

type Action__DARKLUA_TYPE_f = {
    priority: number,
    callback: (Instance) -> ()
}

type Node__DARKLUA_TYPE_g<T> = Node__DARKLUA_TYPE_b<T>

type Array__DARKLUA_TYPE_h<V> = { V }

type ArrayOrV__DARKLUA_TYPE_i<V> = {ArrayOrV__DARKLUA_TYPE_i<V>} | V

type Map__DARKLUA_TYPE_j<K, V> = { [K]: V }

type Cache__DARKLUA_TYPE_k = {
    -- event listeners to connect after properties are set
    events: Array__DARKLUA_TYPE_h<
        | string -- 1. event name
        | (() -> () -- 2. listener
)    >,

    -- actions to run after events are connected
    actions: Map__DARKLUA_TYPE_j<
        number, -- priority
        Array__DARKLUA_TYPE_h<(Instance) -> ()> -- action callbacks
    >,

    -- what to parent the instance to after running actions
    parent: unknown,

    -- cache to detect duplicate property setting at same nesting depth
    nested_debug: Map__DARKLUA_TYPE_j<
        number, -- depth
        Map__DARKLUA_TYPE_j<string, true> -- set of property names
    >,

    -- each nested layer occupies two indexes: 1. table ref 2. nested depth
    -- e.g. { t1 = { t3 = {} }, t2 = {} } -> { t1, 1, t2, 1, t3, 2 }
    nested_stack: { {} | number }
}

type Instances__DARKLUA_TYPE_l = {
    Folder: Folder,
    BillboardGui: BillboardGui,
    CanvasGroup: CanvasGroup,
    Frame: Frame,
    ImageButton: ImageButton,
    ImageLabel: ImageLabel,
    ScreenGui: ScreenGui,
    ScrollingFrame: ScrollingFrame,
    SurfaceGui: SurfaceGui,
    TextBox: TextBox,
    TextButton: TextButton,
    TextLabel: TextLabel,
    UIAspectRatioConstraint: UIAspectRatioConstraint,
    UICorner: UICorner,
    UIGradient: UIGradient,
    UIGridLayout: UIGridLayout,
    UIListLayout: UIListLayout,
    Camera: Camera,
    WorldModel: WorldModel,
}

type function Properties__DARKLUA_TYPE_m(instance: type?)
    local properties = types.newtable()

    while instance do
        for i, v in instance:properties() do
            local connector = v.read and v.read.tag == "table" and v.read:readproperty(types.singleton("Connect"))
            if connector then
                if not connector then continue end
                local params = connector:parameters().head
                if not params then continue end
                local listener = params[2]
                if not listener then continue end
                properties:setproperty(i, types.optional(listener))
            elseif v.write then
                properties:setproperty(i, types.optional(types.unionof(
                    v.write,
                    types.newfunction({}, { head = { v.write } })
                )))
            end
        end

        instance = instance:readparent()
    end

    properties:setindexer(types.number, types.any)

    return properties
end

type AnyProps__DARKLUA_TYPE_n = { [any]: any }

type Create__DARKLUA_TYPE_o = (
    (Instance) -> (AnyProps__DARKLUA_TYPE_n) -> Instance
) & (
    (string, AnyProps__DARKLUA_TYPE_n) -> Instance
) & (
    <Name>(Name|keyof<Instances__DARKLUA_TYPE_l>) -> (Properties__DARKLUA_TYPE_m<index<Instances__DARKLUA_TYPE_l, Name>>) -> index<Instances__DARKLUA_TYPE_l, Name>
)

type Node__DARKLUA_TYPE_p<T> = Node__DARKLUA_TYPE_b<T>

type Source__DARKLUA_TYPE_q<T> = (() -> T) & ((value: T) -> T)

type Destroyable__DARKLUA_TYPE_r = { destroy: (any) -> () } | { Destroy: (any) -> () }

type Disconnectable__DARKLUA_TYPE_s = { disconnect: (any) -> () } | { Disconnect: (any) -> () }

type Node__DARKLUA_TYPE_t<T> = Node__DARKLUA_TYPE_b<T>

type Node__DARKLUA_TYPE_u<T> = Node__DARKLUA_TYPE_b<T>

type Context__DARKLUA_TYPE_v<T> = (() -> T) & (<U>(T, () -> U) -> U)

type Array__DARKLUA_TYPE_w<T> = { T }

type Map__DARKLUA_TYPE_x<K, V> = { [K]: V }

type Source__DARKLUA_TYPE_y<T> = () -> T

type Component__DARKLUA_TYPE_z<T> = (Source__DARKLUA_TYPE_y<boolean>) -> (T, ...number)

type Array__DARKLUA_TYPE_A<T> = { T }

type Source__DARKLUA_TYPE_B<T> = () -> T

type Array__DARKLUA_TYPE_C<T> = { T }

type Map__DARKLUA_TYPE_D<K, V> = { [K]: V }

type Source__DARKLUA_TYPE_E<T> = () -> T

type Array__DARKLUA_TYPE_F<T> = { T }

type Map__DARKLUA_TYPE_G<K, V> = { [K]: V }

type Source__DARKLUA_TYPE_H<T> = () -> T

type Node__DARKLUA_TYPE_I<T> = Node__DARKLUA_TYPE_b<T>

type SourceNode__DARKLUA_TYPE_J<T> = SourceNode__DARKLUA_TYPE_a<T>

type Animatable__DARKLUA_TYPE_K = number | CFrame | Color3 | UDim | UDim2 | Vector2 | Vector3

--[[
Unsupported datatypes:
- bool
- Vector2int16
- Vector3int16
- EnumItem
]]

type SpringState__DARKLUA_TYPE_L<T> = {
    k: number, -- spring constant
    c: number, -- damping coeff

    x0_123: vector, x0_456: vector, -- initial position
    x_123: vector, x_456: vector, -- current position
    x1_123: vector, x1_456: vector, -- target position
    v_123: vector, v_456: vector, -- current velocity

    source_value: T -- current value of spring input source
}

type SpringSettings__DARKLUA_TYPE_M<T> = ({
    position: T?,
    velocity: T?,
    impulse: T?
}) -> ()

type TypeToVec6__DARKLUA_TYPE_N<T> = (T) -> (vector, vector)
type Vec6ToType__DARKLUA_TYPE_O<T> = (vector, vector) -> T
type Source__DARKLUA_TYPE_P<T> = Source__DARKLUA_TYPE_q<T>
type source__DARKLUA_TYPE_Q<T> = Source__DARKLUA_TYPE_P<T>
type Context__DARKLUA_TYPE_R<T> = Context__DARKLUA_TYPE_v<T>
type context__DARKLUA_TYPE_S<T> = Context__DARKLUA_TYPE_R<T>
type Handle__DARKLUA_TYPE_T = {
	Type: string,
	Flag: string?,

	Get: (Handle__DARKLUA_TYPE_T) -> any,
	Set: (Handle__DARKLUA_TYPE_T, any) -> (),
	SetSilent: (Handle__DARKLUA_TYPE_T, any) -> (),
	SetName: (Handle__DARKLUA_TYPE_T, string) -> (),
	SetVisible: (Handle__DARKLUA_TYPE_T, boolean) -> (),
	Destroy: (Handle__DARKLUA_TYPE_T) -> (),
}
local __DARKLUA_BUNDLE_MODULES={cache={}::any}do do local function __modImpl()local function inline_test(): string
    return debug.info(1, "n")
end

local is_O2 = inline_test() ~= "inline_test"

return {
    strict = not is_O2,
    defaults = true,
    defer_nested_properties = true,
    batch = false,
}
end function __DARKLUA_BUNDLE_MODULES.a():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end do local function __modImpl()local flags = __DARKLUA_BUNDLE_MODULES.a ()




















local scopes = { n = 0 } :: { [number]: Node__DARKLUA_TYPE_b<any>, n: number } -- scopes stack

local function efn(err: string)
    local trace = debug.traceback(err, 2)

    if string.find(err, "^effect error stacktrace") then -- if effect error is nested
        trace = string.gsub("    " .. trace, "\n", function() -- indent entire error
            return "\n    "
        end)
    end

    trace ..= "\nsource update stacktrace:"
return trace
end

local function ycall<T, U>(fn: (T) -> U, arg: T): (boolean, string|U)

    local thread = coroutine.create(xpcall)
    --local function efn(err: string) return debug.traceback(err, 3) end
    local resume_ok, run_ok, result = coroutine.resume(thread, fn, efn, arg)

    assert(resume_ok)
        
    if coroutine.status(thread) ~= "dead" then
        return false, debug.traceback(thread, "attempt to yield in reactive scope")
    end

    return run_ok, result
end

local function get_scope(): Node__DARKLUA_TYPE_b<unknown>?
    return scopes[scopes.n]
end

local function assert_stable_scope(): Node__DARKLUA_TYPE_b<unknown>
    local scope = get_scope()

    if not scope then
        local caller_name = debug.info(2, "n")
        return error(`cannot use {caller_name}() outside a stable or reactive scope`, 0)
    elseif scope.effect then
        error("cannot create a new reactive scope inside another reactive scope", 0)
    end

    return scope
end

local function push_child<T>(parent: SourceNode__DARKLUA_TYPE_a<any>, child: Node__DARKLUA_TYPE_b<any>)
    table.insert(parent, child)
    table.insert(child.parents, parent)
end

local function push_scope<T>(node: Node__DARKLUA_TYPE_b<T>)
    local n = scopes.n + 1
    scopes.n = n
    scopes[n] = node
end

local function pop_scope()
    local n = scopes.n
    scopes.n = n - 1
    scopes[n] = nil
end

local function push_cleanup<T>(node: Node__DARKLUA_TYPE_b<T>, cleanup: () -> ())
    if node.cleanups then
        table.insert(node.cleanups, cleanup)
    else
        node.cleanups = { cleanup }
    end
end

local function flush_cleanups<T>(node: Node__DARKLUA_TYPE_b<T>)
    if node.cleanups then
        for _, fn in node.cleanups do
            local ok, err: string? = xpcall(fn, debug.traceback)
            if not ok then error(`cleanup error: {err}`, 0) end
        end

        table.clear(node.cleanups)
    end
end

local function find_and_swap_pop<T>(t: { T }, v: T)
    local i = table.find(t, v) :: number
    local n = #t
    t[i] = t[n]
    t[n] = nil
end

local function unparent<T>(node: Node__DARKLUA_TYPE_b<T>)
    local parents = node.parents

    for i, parent in parents do
        find_and_swap_pop(parent, node)
        parents[i] = nil
    end
end

local function destroy<T>(node: Node__DARKLUA_TYPE_b<T>)
    if flags.strict and table.find(scopes, node) then
        error("attempt to destroy an active scope", 0)
    end

    flush_cleanups(node)
    unparent(node)
    
    if node.owner then
        find_and_swap_pop(node.owner.owned :: { Node__DARKLUA_TYPE_b<T> }, node)
        node.owner = false
    end

    if node.owned then
        local owned = node.owned
        while owned[1] do destroy(owned[1]) end
    end
end

local function destroy_owned<T>(node: Node__DARKLUA_TYPE_b<T>)
    if node.owned then
        local owned = node.owned
        while owned[1] do destroy(owned[1]) end
    end
end

local update_queue = { n = 0 } :: { n: number, [number]: Node__DARKLUA_TYPE_b<any> }

local function evaluate_node<T>(node: Node__DARKLUA_TYPE_b<T>)
    if flags.strict then
        if table.find(scopes, node) then
            error("a scope, that should rerun due to the update of a source, is already active", 0)
        end

        local initial_value = node.cache

        for i = 1, 2 do
            local cur_value = node.cache

            flush_cleanups(node)
            destroy_owned(node)
    
            push_scope(node)
            local ok, new_value = ycall(node.effect :: (T) -> T, cur_value)
            pop_scope()
            
            if not ok then
                table.clear(update_queue)
                update_queue.n = 0
                error(`effect error stacktrace\n{new_value :: string}`, 0)
            end

            node.cache = new_value :: T
        end

        return initial_value ~= node.cache
    else
        local cur_value = node.cache

        flush_cleanups(node)
        destroy_owned(node)

        push_scope(node)
        local ok, new_value = pcall(node.effect :: (T) -> T, node.cache)
        pop_scope()

        if not ok then
            table.clear(update_queue)
            update_queue.n = 0
            error(`effect error:\n{new_value}\n`, 0)
        end
    
        node.cache = new_value
        return cur_value ~= new_value
    end
end

local function queue_children_for_update<T>(node: SourceNode__DARKLUA_TYPE_a<T>)
    local i = update_queue.n
    while node[1] do
        i += 1
        update_queue[i] = node[1]
        unparent(node[1])
    end
    update_queue.n = i
end

local function get_update_queue_length()
    return update_queue.n
end

local function flush_update_queue(from: number)
    local i = from + 1
    while i <= update_queue.n do
        local node = update_queue[i]
        --assert(node.effect)

        if node.owner and evaluate_node(node) then
            queue_children_for_update(node)
        end

        update_queue[i] = false :: any
        i += 1
    end
    
    update_queue.n = from
end

local function update_descendants<T>(root: SourceNode__DARKLUA_TYPE_a<T>)
    local n0 = update_queue.n
    queue_children_for_update(root)

    if flags.batch then return end

    local i = n0 + 1
    while i <= update_queue.n do
        local node = update_queue[i]
        --assert(node.effect)

        -- check if node is still owned in case destroyed after queued
        if node.owner and evaluate_node(node) then
            queue_children_for_update(node)
        end

        update_queue[i] = false :: any -- false instead of nil to avoid sparse
        i += 1
    end

    update_queue.n = n0
end

local function push_scope_as_child_of<T>(node: SourceNode__DARKLUA_TYPE_a<T>)
    local scope = get_scope()
    if scope and scope.effect then -- do not track nodes with no effect
        push_child(node, scope)
    end
end

local function create_node<T>(owner: false | Node__DARKLUA_TYPE_b<any>, effect: false | ((T) -> T), value: T): Node__DARKLUA_TYPE_b<T>
    local node: Node__DARKLUA_TYPE_b<T> = {
        cache = value,
        effect = effect,
        cleanups = false,

        context = false,

        owner = owner,
        owned = false,

        parents = {},
    }

    if owner then
        if owner.owned then
            table.insert(owner.owned, node)
        else
            owner.owned = { node }
        end
    end

    return node
end

local function create_source_node<T>(value: T): SourceNode__DARKLUA_TYPE_a<T>
    return { cache = value }
end

local function get_children<T>(node: Node__DARKLUA_TYPE_b<T>): { Node__DARKLUA_TYPE_b<unknown> }
    return { unpack(node) } :: { Node__DARKLUA_TYPE_b<any> }
end

local function set_context<T>(node: Node__DARKLUA_TYPE_b<T>, key: number, value: unknown)
    if node.context then
        node.context[key] = value
    else
        node.context = { [key] = value }
    end
end

return table.freeze {
    push_scope = push_scope,
    pop_scope = pop_scope,
    evaluate_node = evaluate_node,
    get_scope = get_scope,
    assert_stable_scope = assert_stable_scope,
    push_cleanup = push_cleanup,
    destroy = destroy,
    flush_cleanups = flush_cleanups,
    push_scope_as_child_of = push_scope_as_child_of,
    update_descendants = update_descendants,
    push_child = push_child,
    create_node = create_node,
    create_source_node = create_source_node,
    get_children = get_children,
    flush_update_queue = flush_update_queue,
    get_update_queue_length = get_update_queue_length,
    set_context = set_context,
    scopes = scopes,

    q = update_queue
}
end function __DARKLUA_BUNDLE_MODULES.b():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.b if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local create_node = graph.create_node
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local destroy = graph.destroy

local refs = {}

local function root<T...>(fn: (destroy: () -> ()) -> T...): (() -> (), T...)
    local node = create_node(false, false, false)

    refs[node] = true -- prevent gc of root node

    local destroy = function()
        if not refs[node] then error "root already destroyed" end
        refs[node] = nil
        destroy(node)
    end

    push_scope(node)

    local result = { xpcall(fn, debug.traceback, destroy) }

    pop_scope()

    if not result[1] then
        destroy()
        error(`error while running root():\n\n{result[2]}`, 0)
    end

    return destroy, unpack(result :: any, 2)
end

return root :: <T...>(fn: (destroy: () -> ()) -> T...) -> (() -> (), T...)
end function __DARKLUA_BUNDLE_MODULES.c():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.c if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local create_node = graph.create_node
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local destroy = graph.destroy
local get_scope = graph.get_scope

local function branch<T>(fn: () -> T): (() -> (), T)
    local current = get_scope()
    if not current then
        error(`cannot use branch() outside a stable or reactive scope`, 0)
    end

    local parent = current.owner
    if not parent or parent.effect then
        error(`current scope is not owned by a stable scope`, 0)
    end

    local node = create_node(parent, false, false)

    local destroy = function()
        destroy(node)
    end

    push_scope(node)

    local ok, result = xpcall(fn, debug.traceback)

    pop_scope()

    if not ok then
        destroy()
        error(`error while running branch():\n\n{result}`, 0)
    end

    return destroy, result
end

return branch
end function __DARKLUA_BUNDLE_MODULES.d():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function __modImpl()-- Stub so a bundler can statically resolve the `require "../test/mock"` fallback in vide's
-- source. That fallback only runs OUTSIDE Roblox (guarded by `game and ... or ...`); inside
-- Roblox `game` is truthy, so this file's contents are never executed.

return {
	typeof = typeof,
	Instance = Instance,
	Enum = Enum,
	Color3 = Color3,
}
end function __DARKLUA_BUNDLE_MODULES.e():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local create_node = graph.create_node
local assert_stable_scope = graph.assert_stable_scope
local get_scope = graph.get_scope
local evaluate_node = graph.evaluate_node
local push_cleanup = graph.push_cleanup

local function update_property_effect(p: {
    instance: Instance,
    property: string,
    source: () -> unknown  
})
    (p.instance :: any)[p.property] = p.source()
    return p
end

local function update_parent_effect(p: {
    instance: Instance,
    source: () -> Instance
})
    p.instance.Parent = p.source()
    return p
end

-- todo: investigate if "count" method used in indexes() and values() can improve performance here
local function update_children_effect(p: {
    instance: Instance,
    cur_children_set: { [Instance]: true },
    new_children_set: { [Instance]: true },
    source: () -> Instance | { Instance }
})
    local cur_children_set: { [Instance]: true } = p.cur_children_set -- cache of all children parented before update
    local new_children_set: { [Instance]: true } = p.new_children_set -- cache of all children parented after update

    local new_children = p.source() -- all (and only) children that should be parented after this update
    
    local function process_child(child: Instance | { Instance })
        if type(child) == "userdata" then
            if new_children_set[child] then return end -- stops redundant reparenting

            new_children_set[child] = true -- record child set from this update
            
            if not cur_children_set[child] then
                child.Parent = p.instance -- if child wasn't already parented then parent it
            else 
                cur_children_set[child] = nil -- remove child from cache if it was already in cache
            end  
        elseif type(child) == "table" then
            for _, child in child do
                process_child(child)
            end
        elseif type(child) == "function" then
            local node = create_node(assert(get_scope()), update_children_effect, {
                instance = p.instance,
                cur_children_set = {},
                new_children_set = {},
                source = child   
            })
    
            evaluate_node(node)

            push_cleanup(assert(get_scope()), function()
                for child in node.cache.cur_children_set do
                    child.Parent = nil
                end
            end)
        end
    end

    process_child(new_children)

    for child in cur_children_set do
        child.Parent = nil -- unparent all children that weren't in the new children set
    end

    table.clear(cur_children_set) -- clear cache, preserve capacity
    p.cur_children_set, p.new_children_set = new_children_set, cur_children_set

    return p
end

return {
    property = function(instance, property, source)
        local node = create_node(assert_stable_scope(), update_property_effect, {
            instance = instance,
            property = property,
            source = source
        })

        evaluate_node(node)

        return node
    end,

    parent = function(instance, parent)
        local node = create_node(assert_stable_scope(), update_parent_effect, {
            instance = instance,
            source = parent
        })

        evaluate_node(node)
        
        return node
    end,

    children = function(instance, children)
        local node = create_node(assert_stable_scope(), update_children_effect, {
            instance = instance,
            cur_children_set = {},
            new_children_set = {},
            source = children
        })

        evaluate_node(node)

        push_cleanup(assert_stable_scope(), function()
            for child in node.cache.cur_children_set do
                child.Parent = nil
            end
        end)

        return node
    end
}
end function __DARKLUA_BUNDLE_MODULES.f():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.f if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end do local function __modImpl()





local ActionMT = table.freeze {}

local function is_action(v: any)
    return getmetatable(v) == ActionMT
end

local function action(callback: (Instance) -> (), priority: number?): Action__DARKLUA_TYPE_f
    local a = {
        priority = priority or 1,
        callback = callback
    }

    setmetatable(a :: any, ActionMT)

    return table.freeze(a)
end

return function()
    return action, is_action
end
end function __DARKLUA_BUNDLE_MODULES.g():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.g if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end do local function __modImpl()
local typeof = game and typeof or __DARKLUA_BUNDLE_MODULES.e ().typeof :: never

local flags = __DARKLUA_BUNDLE_MODULES.a ()
local implicit_effect = __DARKLUA_BUNDLE_MODULES.f ()
local _, is_action = __DARKLUA_BUNDLE_MODULES.g ()()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

































local free_cache: Cache__DARKLUA_TYPE_k?

local function borrow_cache(): Cache__DARKLUA_TYPE_k
    if free_cache then
        local cache = free_cache
        free_cache = nil
        return cache
    else
        return {
            events = {},
            actions = setmetatable({} :: any, { -- lazy init
                __index = function(self, i) self[i] = {}; return self[i] end
            }),
            parent = nil,
            nested_debug = setmetatable({} :: any, {
                __index = function(self, i: number) self[i] = {}; return self[i] end
            }),
            nested_stack = {}
        }
    end
end

local function return_cache(cache: Cache__DARKLUA_TYPE_k )
    free_cache = cache
end

local function process_properties(properties: Map__DARKLUA_TYPE_j<unknown, unknown>, instance: Instance, cache: Cache__DARKLUA_TYPE_k, depth: number)
    for property, value in properties do
        if type(property) == "string" then
            if flags.strict then -- check for duplicate property assignment at nesting depth
                if cache.nested_debug[depth][property] then
                    error(`duplicate property {property} at depth {depth}`, 0)
                end
                cache.nested_debug[depth][property] = true
            end

            if property == "Parent" then
                cache.parent = value
                continue
            end

            if type(value) == "function" then 
                if typeof((instance :: any)[property]) == "RBXScriptSignal" then
                    table.insert(cache.events, property) -- add event name to buffer
                    table.insert(cache.events, value :: () -> ()) -- add event listener to buffer
                else
                    implicit_effect.property(instance, property, value :: () -> ()) -- create implicit effect for property
                end
            else
                (instance :: any)[property] = value -- set property
            end    
        elseif type(property) == "number" then
            if type(value) == "function" then
                implicit_effect.children(instance, value :: () -> ArrayOrV__DARKLUA_TYPE_i<Instance>) -- bind children
            elseif type(value) == "table" then
                if is_action(value) then
                    table.insert(cache.actions[(value :: any).priority], (value :: any).callback :: () -> ()) -- add action to buffer
                elseif flags.defer_nested_properties then
                    table.insert(cache.nested_stack, value :: {})
                    table.insert(cache.nested_stack, depth + 1) -- push table to stack for later processing
                else
                    process_properties(value :: Map__DARKLUA_TYPE_j<unknown, unknown>, instance, cache, depth + 1)
                end
            elseif type(value) == "userdata" then
                (value :: Instance).Parent = instance -- parent child
            end
        end
    end
end

-- applies table of nested properties to an instance using full vide semantics
local function apply<T>(instance: T & Instance, properties: { [unknown]: unknown }): T
    if not properties then
        error "attempt to call a constructor returned by create() with no properties"
    end

    local caches = borrow_cache()
    local events = caches.events
    local actions = caches.actions
    local nested_debug = caches.nested_debug
    local nested_stack = caches.nested_stack

    -- process all properties
    local depth = 1
    repeat
        process_properties(properties, instance, caches, depth)
        depth = table.remove(nested_stack) :: number
        properties = table.remove(nested_stack) :: {}
    until not properties

    for i = 1, #events, 2 do
        local event_name = events[i]
        local event_listener = events[i + 1]
        ;(instance :: any)[event_name]:Connect(event_listener)
    end

    for _, queued in actions do
        for _, callback in queued do
            callback(instance)
        end
    end

    local parent = caches.parent
    if parent then
        if type(parent) == "function" then
            implicit_effect.parent(instance, parent :: () -> Instance)
        else
            instance.Parent = parent :: Instance
        end
    end

    table.clear(events)
    for _, queued in actions do table.clear(queued) end
    caches.parent = nil
    if flags.strict then table.clear(nested_debug) end
    table.clear(nested_stack)

    return_cache(caches)

    return instance
end

return apply
end function __DARKLUA_BUNDLE_MODULES.h():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.h if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.h=v end return v.c end end do local function __modImpl()
local root = __DARKLUA_BUNDLE_MODULES.c ()
local apply = __DARKLUA_BUNDLE_MODULES.h ()

local function mount<T>(component: () -> T, target: Instance?): () -> ()
    return root(function()
        local result = component()
        if target then apply(target, { result }) end
    end)
end

return mount :: (<T>(component: () -> T, target: Instance) -> () -> ()) & ((component: () -> ()) -> () -> ())
end function __DARKLUA_BUNDLE_MODULES.i():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.i if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.i=v end return v.c end end do local function __modImpl()
local Enum = game and Enum or __DARKLUA_BUNDLE_MODULES.e ().Enum :: never
local Color3 = game and Color3 or __DARKLUA_BUNDLE_MODULES.e ().Color3 :: never

return {
    Part = {
        Material = Enum.Material.SmoothPlastic,
        Size = vector.create(1, 1, 1),
        Anchored = true
    },

    BillboardGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },

    CanvasGroup = nil,

    Frame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    },

    ImageButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutoButtonColor = false
    },

    ImageLabel = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
    },

    ScreenGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },

    ScrollingFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ScrollBarImageColor3 = Color3.new(0, 0, 0)
    },
    
    SurfaceGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

        PixelsPerStud = 50,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    },
    
    TextBox = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },

    TextButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },
    
    TextLabel = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },
    
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },
   
    UIGridLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UITableLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UIPageLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },
    
    VideoFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    },
    
    ViewportFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    }
}
end function __DARKLUA_BUNDLE_MODULES.j():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.j if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.j=v end return v.c end end do local function __modImpl()
local typeof = game and typeof or __DARKLUA_BUNDLE_MODULES.e ().typeof :: never
local Instance = game and Instance or __DARKLUA_BUNDLE_MODULES.e ().Instance :: never

local defaults = __DARKLUA_BUNDLE_MODULES.j ()
local apply = __DARKLUA_BUNDLE_MODULES.h ()
local flags = __DARKLUA_BUNDLE_MODULES.a ()

local ctor_cache = {} :: { [string]: (AnyProps__DARKLUA_TYPE_n) -> Instance }
local function lazy_init(_, class: string)
    local function ctor(properties: AnyProps__DARKLUA_TYPE_n): Instance
        local ok, instance: Instance = pcall(Instance.new, class :: any)
        if not ok then error(`invalid class name { class }`, 0) end

        if flags.defaults then
            local default: { [string]: unknown }? = defaults[class]
            if default then
                for i, v in default do
                    (instance :: any)[i] = v
                end
            end
        end

        return apply(instance, properties)
    end

    ctor_cache[class] = ctor
    return ctor
end
setmetatable(ctor_cache, { __index = lazy_init })

-- todo: remove support for different overloads
local function create(class_or_instance: string|Instance, properties: AnyProps__DARKLUA_TYPE_n?): ((AnyProps__DARKLUA_TYPE_n) -> Instance) | Instance
    if type(class_or_instance) ~= "string" and typeof(class_or_instance) ~= "Instance" then
        error("bad argument #1, expected string or instance, got " .. typeof(class_or_instance), 0)
    end

    local ctor = if type(class_or_instance) == "string"
        then ctor_cache[class_or_instance]
        else function(properties)
            local clone = class_or_instance:Clone()
            if not clone then error "attempt to clone a non-archivable instance" end
            return apply(clone, properties)
        end

    return if properties
        then ctor(properties)
        else ctor
end





























































return (create :: any) :: Create__DARKLUA_TYPE_o
end function __DARKLUA_BUNDLE_MODULES.k():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.k if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.k=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local create_source_node = graph.create_source_node
local push_scope_as_child_of = graph.push_scope_as_child_of
local update_descendants = graph.update_descendants



local function source<T>(initial_value: T): Source__DARKLUA_TYPE_q<T>
    local node = create_source_node(initial_value)

    local function update_source(...): T
        if select("#", ...) == 0 then -- no args were given
            push_scope_as_child_of(node)
            return node.cache
        end

        local v = ... :: T
        if node.cache == v and (type(v) ~= "table" or table.isfrozen(v)) then 
            return v
        end

        node.cache = v
        update_descendants(node)
        return v
    end

    return update_source
end

return source :: (<T>(initial_value: T) -> Source__DARKLUA_TYPE_q<T>) & (<T>() -> Source__DARKLUA_TYPE_q<T>)
end function __DARKLUA_BUNDLE_MODULES.l():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.l if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.l=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()
local create_node = graph.create_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

local function effect<T>(callback: (T) -> T, initial_value: T)
    local node = create_node(assert_stable_scope(), callback, initial_value)

    evaluate_node(node)
end

return effect :: (<T>(callback: (T) -> T, initial_value: T) -> ()) & ((callback: () -> ()) -> ())
end function __DARKLUA_BUNDLE_MODULES.m():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.m if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.m=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()
local create_node = graph.create_node
local push_scope_as_child_of = graph.push_scope_as_child_of
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node

local function derive<T>(source: () -> T): () -> T
    local node = create_node(assert_stable_scope(), source, false :: any)

    evaluate_node(node)

    return function()
        push_scope_as_child_of(node)
        return node.cache
    end
end

return derive
end function __DARKLUA_BUNDLE_MODULES.n():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.n if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.n=v end return v.c end end do local function __modImpl()
local typeof = game and typeof or __DARKLUA_BUNDLE_MODULES.e ().typeof :: never

local graph = __DARKLUA_BUNDLE_MODULES.b ()
local get_scope = graph.get_scope
local push_cleanup = graph.push_cleanup

local function helper(obj: any)
    return
        if typeof(obj) == "RBXScriptConnection" then function() obj:Disconnect() end
        elseif type(obj) == "thread" then function() task.cancel(obj) end
        elseif typeof(obj) == "Instance" then function() obj:Destroy() end
        elseif obj.destroy then function() obj:destroy() end
        elseif obj.disconnect then function() obj:disconnect() end
        elseif obj.Destroy then function() obj:Destroy() end
        elseif obj.Disconnect then function() obj:Disconnect() end
        else error "cannot cleanup given object"
end

local function cleanup(value: unknown)
    local scope = get_scope()

    if not scope then
        error "cannot cleanup outside a stable or reactive scope"
    end; assert(scope)

    if type(value) == "function" then
        push_cleanup(scope, value :: () -> ())
    else
        push_cleanup(scope, helper(value))
    end
end




return cleanup ::
    ( (callback: () -> ()) -> () ) &
    ( (thread: thread) -> () ) &
    ( (instance: Destroyable__DARKLUA_TYPE_r) -> () ) &
    ( (connection: Disconnectable__DARKLUA_TYPE_s) -> () ) &
    ( (instance: Instance) -> () ) &
    ( (connection: RBXScriptConnection) -> () )

end function __DARKLUA_BUNDLE_MODULES.o():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.o if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.o=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local get_scope = graph.get_scope

local function untrack<T>(source: () -> T): T
    local scope = get_scope()
    
    if scope then
        -- sources are only tracked if the node in scope has an effect
        local effect = scope.effect
        scope.effect = false

        local ok, result = xpcall(source, debug.traceback)

        scope.effect = effect :: () -> ()

        if not ok then error(result, 0) end

        return result :: T
    else
        return source()
    end
end

return untrack :: ( <T>(fn: () -> T) -> T ) & ( (fn: () -> ()) -> () )
end function __DARKLUA_BUNDLE_MODULES.p():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.p if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.p=v end return v.c end end do local function __modImpl()
local function read<T>(value: T | (() -> T)): T
    return if type(value) == "function" then value() else value
end

return read
end function __DARKLUA_BUNDLE_MODULES.q():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.q if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.q=v end return v.c end end do local function __modImpl()
local flags = __DARKLUA_BUNDLE_MODULES.a ()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local function batch(setter: () -> ())
    local already_batching = flags.batch
    local from

    if not already_batching then
        flags.batch = true
        from = graph.get_update_queue_length()
    end

    local ok, err: string? = xpcall(setter, debug.traceback)

    if not already_batching then
        flags.batch = false
        graph.flush_update_queue(from)
    end

    if not ok then error(`error occured while batching updates: {err}`, 0) end
end

return batch
end function __DARKLUA_BUNDLE_MODULES.r():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.r if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.r=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()

local create_node = graph.create_node
local get_scope = graph.get_scope
local push_scope = graph.push_scope
local pop_scope = graph.pop_scope
local set_context = graph.set_context



local nil_symbol = newproxy()
local count = 0

local function context<T>(...: T): Context__DARKLUA_TYPE_v<T>
    count += 1
    local id = count

    local has_default = select("#", ...) > 0
    local default_value = ...

    return function<T>(...): any -- todo: fix type error
        local scope: (Node__DARKLUA_TYPE_u<unknown>? )| false = get_scope()

        if select("#", ...) == 0 then -- get
            while scope do
                local ctx = scope.context
    
                if not ctx then
                    scope = scope.owner
                    continue
                end

                local value = (ctx :: { unknown })[id]

                if value == nil then
                    scope = scope.owner
                    continue
                end
                
                return (if value ~= nil_symbol then value else nil) :: T
            end

            if has_default ~= nil then
                return default_value
            else
                error("attempt to get context when no context is set and no default context is set", 0)
            end
        else -- set
            if not scope then return error("attempt to set context outside of a vide scope", 0) end

            local value, component = ...
            
            local new_scope = create_node(scope, false, false)
            set_context(new_scope, id, if value == nil then nil_symbol else value)

            push_scope(new_scope)

            local function efn(err: string) return debug.traceback(err, 3) end
            local ok, result = xpcall(component, efn)

            pop_scope()

            if not ok then
                error(`error while running context:\n\n{result}`, 0)
            end

            return result
        end

        return nil :: any
    end
end

return context
end function __DARKLUA_BUNDLE_MODULES.s():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.s if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.s=v end return v.c end end do local function __modImpl()
local queue = {} :: {
    { t: number, fn: () -> (), cancel: boolean }
}

local function timeout(t: number, fn: () -> ())
    local handle = { t = t, fn = fn, cancel = false }
    table.insert(queue, handle)
    return handle
end

local function update_timeouts(dt: number)
    for i = #queue, 1, -1 do
        local handle = queue[i]
        handle.t -= dt
        
        if handle.cancel or handle.t <= 0 then
            queue[i] = queue[#queue]
            queue[#queue] = nil

            if not handle.cancel then
                handle.fn()
            end
        end
    end
end

return function() return timeout, update_timeouts end
end function __DARKLUA_BUNDLE_MODULES.t():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.t if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.t=v end return v.c end end do local function __modImpl()
local branch = __DARKLUA_BUNDLE_MODULES.d ()
local source = __DARKLUA_BUNDLE_MODULES.l ()
local effect = __DARKLUA_BUNDLE_MODULES.m ()
local timeout = __DARKLUA_BUNDLE_MODULES.t () ()






local function switch_map<K, Obj>(
    input: Source__DARKLUA_TYPE_y<K>,
    map: Map__DARKLUA_TYPE_x<K, Component__DARKLUA_TYPE_z<Obj>>
): Source__DARKLUA_TYPE_y<nil | Obj | Array__DARKLUA_TYPE_w<Obj>>
    local scopes = {} :: Map__DARKLUA_TYPE_x<K, {
        destroy: () -> (),
        object: Obj,
        delay: number,
        present: (boolean?) -> boolean,
        timeout: { cancel: boolean }?
    }>

    local output = source(nil :: nil | Obj | Array__DARKLUA_TYPE_w<Obj>)
    local function update_output()
        local objects = {}

        for _, scope in scopes do
            table.insert(objects, scope.object)
        end

        output(
            if objects[2] then objects
            elseif objects[1] then objects[1]
            else nil
        )
    end

    effect(function()
        local key: K? = input()

        -- destroy (or queue destroy) all scopes not associated with the input key
        for k, scope in scopes do
            if k == key then continue end

            scope.present(false)

            if scope.delay == 0 then
                scope.destroy()
                scopes[k] = nil
            else
                if scope.timeout == nil then
                    scope.timeout = timeout(scope.delay, function()
                        scope.destroy()
                        scopes[k] = nil
                        update_output()
                    end)
                end
            end
        end

        -- create new scope or abort destruction of existing scope if key exists
        if key ~= nil then
            local scope = scopes[key]

            if scope then
                scope.present(true)

                if scope.timeout then
                    scope.timeout.cancel = true
                    scope.timeout = nil
                end
            else
                local component = map[key]

                if component ~= nil then
                    if type(component) ~= "function" then
                        error("map must map a value to a function", 0)
                    end

                    local present = source(false)

                    local delay = nil :: number?
                    local destroy, object = branch(function()
                        local object, t = component(present)
                        delay = t
                        return object
                    end)

                    present(true)

                    scopes[key] = {
                        destroy = destroy,
                        object = object,
                        delay = delay or 0,
                        present = present,
                        timeout = nil
                    }
                end
            end
        end

        update_output()
    end)

    return output
end

local function switch<K, Obj>(input: Source__DARKLUA_TYPE_y<K>): (map: Map__DARKLUA_TYPE_x<K, Component__DARKLUA_TYPE_z<Obj>>) -> Source__DARKLUA_TYPE_y<nil | Obj | Array__DARKLUA_TYPE_w<Obj>>
    return function(map)
        return switch_map(input, map)
    end
end

return switch
end function __DARKLUA_BUNDLE_MODULES.u():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.u if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.u=v end return v.c end end do local function __modImpl()
local source = __DARKLUA_BUNDLE_MODULES.l ()
local derive = __DARKLUA_BUNDLE_MODULES.n ()
local effect = __DARKLUA_BUNDLE_MODULES.m ()
local untrack = __DARKLUA_BUNDLE_MODULES.p ()
local switch = __DARKLUA_BUNDLE_MODULES.u ()




local function show<T, Obj>(
    input: Source__DARKLUA_TYPE_B<T?>,
    component: (Source__DARKLUA_TYPE_B<T>, Source__DARKLUA_TYPE_B<boolean>) -> (Obj, ...number),
    fallback: ((Source__DARKLUA_TYPE_B<boolean>) -> (Obj, ...number))?
): Source__DARKLUA_TYPE_B<nil | Obj | Array__DARKLUA_TYPE_A<Obj>>
    local filtered_input = source()

    effect(function()
        local v = input() 
        if v then
            filtered_input(v)
        end
    end)

    local input_is_truthy = derive(function()
        return not not input()
    end)

    return switch(input_is_truthy) {
        [true] = function(present)
            return component(filtered_input, present)
        end,
        [false] = fallback
    }
end

return show
end function __DARKLUA_BUNDLE_MODULES.v():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.v if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.v=v end return v.c end end do local function __modImpl()
local flags = __DARKLUA_BUNDLE_MODULES.a ()
local branch = __DARKLUA_BUNDLE_MODULES.d ()
local source = __DARKLUA_BUNDLE_MODULES.l ()
local effect = __DARKLUA_BUNDLE_MODULES.m ()
local timeout = __DARKLUA_BUNDLE_MODULES.t () ()





local function indexes<K, V, Obj>(
    input: Source__DARKLUA_TYPE_E<Map__DARKLUA_TYPE_D<K, V>>,
    component: (Source__DARKLUA_TYPE_E<V>, K, Source__DARKLUA_TYPE_E<boolean>) -> (Obj, ...number)
): Source__DARKLUA_TYPE_E<Array__DARKLUA_TYPE_C<Obj>>
    local update_count = 0
    local scopes = {} :: Map__DARKLUA_TYPE_D<K, {
        destroy: () -> (),
        object: Obj,
        value: V?,
        value_source: (V?) -> V,
        count: number,
        delay: number,
        present: (boolean?) -> boolean,
        timeout: { cancel: boolean }?,
    }>

    local output = source({} :: Array__DARKLUA_TYPE_C<Obj>)
    local function update_output()
        local objects = table.create(4)

        for _, scope in scopes do
            table.insert(objects, scope.object)
        end

        output(objects)
    end

    effect(function()
        local data = input()

        local count = update_count
        update_count += 1

        local children_need_update = false -- set to true if a scope is created or destroyed

        -- create or update scopes
        for i, v in data do
            local scope = scopes[i]

            if scope == nil then -- create new scope and create component
                local value_source = source(v)
                local present = source(false)

                local delay = nil :: number?
                local destroy, object = branch(function()
                    local object, t = component(value_source, i, present)
                    delay = t
                    return object
                end)

                present(true)
                
                children_need_update = true

                scopes[i] = {
                    destroy = destroy,
                    object = object,
                    value = v,
                    value_source = value_source,
                    count = count,
                    delay = delay or 0,
                    present = present,
                    timeout = nil,
                }
            else -- update scope
                scope.count = count

                if scope.value ~= v then
                    if scope.timeout then -- index is in input table again; cancel destruction
                        scope.timeout.cancel = true
                        scope.timeout = nil
                        scope.present(true)
                    end
                    
                    scope.value = v
                    scope.value_source(v)
                end
            end
        end

        -- destroy scopes
        for i, scope in scopes do
            if scope.count < count then -- if count is not latest then index is no longer in the input table
                scope.present(false)

                if scope.delay == 0 then
                    scope.destroy()
                    scopes[i] = nil
                    children_need_update = true
                else
                    scope.value = nil -- set to nil for the `scope.value ~= v` check
                    if scope.timeout == nil then
                        scope.timeout = timeout(scope.delay, function() -- todo: possible redundant updates
                            scope.destroy()
                            scopes[i] = nil
                            update_output()
                        end)
                    end
                end
            end
        end

        if children_need_update then
            update_output()
        end
    end)

    return output
end

return indexes
end function __DARKLUA_BUNDLE_MODULES.w():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.w if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.w=v end return v.c end end do local function __modImpl()
local flags = __DARKLUA_BUNDLE_MODULES.a ()
local branch = __DARKLUA_BUNDLE_MODULES.d ()
local source = __DARKLUA_BUNDLE_MODULES.l ()
local effect = __DARKLUA_BUNDLE_MODULES.m ()
local timeout = __DARKLUA_BUNDLE_MODULES.t () ()





local function values<K, V, Obj>(
    input: Source__DARKLUA_TYPE_H<Map__DARKLUA_TYPE_G<K, V>>,
    component: (V, Source__DARKLUA_TYPE_H<K>, Source__DARKLUA_TYPE_H<boolean>) -> (Obj, ...number)
): Source__DARKLUA_TYPE_H<Array__DARKLUA_TYPE_F<Obj>>
    local update_count = 0
    local scopes = {} :: Map__DARKLUA_TYPE_G<V, {
        destroy: () -> (),
        object: Obj,
        index: K?,
        index_source: (K?) -> K,
        count: number,
        delay: number,
        present: (boolean?) -> boolean,
        timeout: { cancel: boolean }?,
    }>

    local output = source({} :: Array__DARKLUA_TYPE_F<Obj>)
    local function update_output()
        local objects = table.create(4)

        for _, scope in scopes do
            table.insert(objects, scope.object)
        end

        output(objects)
    end

    effect(function()
        local data = input()

        local count = update_count
        update_count += 1

        local children_need_update = false -- set to true if a scope is created or destroyed

        if flags.strict then -- check for duplicate values
            local map = {}
            for _, v in data do
                if map[v] then
                    error("table source passed to `values()` contains duplicate values", 0)
                end
                map[v] = true
            end
        end

        -- create or update scopes
        for i, v in data do
            local scope = scopes[v]

            if scope == nil then -- create new scope and create component
                local index_source = source(i)
                local present = source(false)

                local delay = nil :: number?
                local destroy, object = branch(function()
                    local object, t = component(v, index_source, present)
                    delay = t
                    return object
                end)

                present(true)
                
                children_need_update = true

                scopes[v] = {
                    destroy = destroy,
                    object = object,
                    index = i,
                    index_source = index_source,
                    count = count,
                    delay = delay or 0,
                    present = present,
                    timeout = nil,
                }
            else -- update scope
                scope.count = count

                if scope.index ~= i then
                    if scope.timeout then -- value is in input table again; cancel destruction
                        scope.timeout.cancel = true
                        scope.timeout = nil
                        scope.present(true)
                    end
                    
                    scope.index = i
                    scope.index_source(i)
                end
            end
        end

        -- destroy scopes
        for v, scope in scopes do
            if scope.count < count then -- if count is not latest then value is no longer in the input table
                scope.present(false)

                if scope.delay == 0 then
                    scope.destroy()
                    scopes[v] = nil
                    children_need_update = true
                else
                    scope.index = nil -- set to nil for the `scope.index ~= i` check
                    if scope.timeout == nil then
                        scope.timeout = timeout(scope.delay, function() -- todo: possible redundant updates
                            scope.destroy()
                            scopes[v] = nil
                            update_output()
                        end)
                    end
                end
            end
        end

        if children_need_update then
            update_output()
        end
    end)

    return output
end

return values
end function __DARKLUA_BUNDLE_MODULES.x():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.x if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.x=v end return v.c end end do local function __modImpl()
local graph = __DARKLUA_BUNDLE_MODULES.b ()


local create_node = graph.create_node
local create_source_node = graph.create_source_node
local assert_stable_scope = graph.assert_stable_scope
local evaluate_node = graph.evaluate_node
local update_descendants = graph.update_descendants
local push_scope_as_child_of = graph.push_scope_as_child_of

local UPDATE_RATE = 120
local TOLERANCE_FACTOR = 10_000
































local type_to_vec6 = {
    number = function(v)
        return vector.create(v, 0, 0), vector.zero
    end :: TypeToVec6__DARKLUA_TYPE_N<number>,

    CFrame = function(v)
        return v.Position, vector.create(v:ToEulerAnglesXYZ())
    end :: TypeToVec6__DARKLUA_TYPE_N<CFrame>,

    Color3 = function(v)
        -- todo: hsv, oklab?
        return vector.create(v.R, v.G, v.B), vector.zero
    end :: TypeToVec6__DARKLUA_TYPE_N<Color3>,

    UDim = function(v)
        return vector.create(v.Scale, v.Offset, 0), vector.zero
    end :: TypeToVec6__DARKLUA_TYPE_N<UDim>,
    
    UDim2 = function(v)
        return vector.create(v.X.Scale, v.X.Offset, v.Y.Scale), vector.create(v.Y.Offset, 0, 0)
    end :: TypeToVec6__DARKLUA_TYPE_N<UDim2>,

    Vector2 = function(v)
        return vector.create(v.X, v.Y, 0), vector.zero
    end :: TypeToVec6__DARKLUA_TYPE_N<Vector2>,

    Vector3 = function(v)
        return v, vector.zero
    end :: TypeToVec6__DARKLUA_TYPE_N<Vector3>,

    Rect = function(v)
        return vector.create(v.Min.X, v.Min.Y, v.Max.X), vector.create(v.Max.Y, 0, 0)
    end :: TypeToVec6__DARKLUA_TYPE_N<Rect>,

    table = function(v)
        return vector.create(v[1] or 0, v[2] or 0, v[3] or 0), vector.create(v[4] or 0, 0, 0)
    end :: TypeToVec6__DARKLUA_TYPE_N<{ number }>
}

local vec6_to_type = {
    number = function(a, b)
        return a.X
    end :: Vec6ToType__DARKLUA_TYPE_O<number>,

    CFrame = function(a, b)
        return CFrame.new(a) * CFrame.fromEulerAnglesXYZ(b.X, b.Y, b.Z)
    end :: Vec6ToType__DARKLUA_TYPE_O<CFrame>,

    Color3 = function(v)
        return Color3.new(math.clamp(v.X, 0, 1), math.clamp(v.Y, 0, 1), math.clamp(v.Z, 0, 1))
    end :: Vec6ToType__DARKLUA_TYPE_O<Color3>,

    UDim = function(v)
        return UDim.new(v.X, math.round(v.Y))
    end :: Vec6ToType__DARKLUA_TYPE_O<UDim>,
    
    UDim2 = function(a, b)
        return UDim2.new(a.X, math.round(a.Y), a.Z, math.round(b.X))
    end :: Vec6ToType__DARKLUA_TYPE_O<UDim2>,

    Vector2 = function(v)
        return Vector2.new(v.X, v.Y)
    end :: Vec6ToType__DARKLUA_TYPE_O<Vector2>,

    Vector3 = function(v)
        return v
    end :: Vec6ToType__DARKLUA_TYPE_O<Vector3>,

    Rect = function(a, b)
        return Rect.new(a.X, a.Y, a.Z, b.X)
    end :: Vec6ToType__DARKLUA_TYPE_O<Rect>,

    table = function(a, b)
        return { a.X, a.Y, a.Z, b.X }
    end :: Vec6ToType__DARKLUA_TYPE_O<{ number }>
}

local invalid_type = {
    __index = function(_, t: string)
        error(`cannot spring type {t}`, 0)
    end
}

setmetatable(type_to_vec6, invalid_type)
setmetatable(vec6_to_type, invalid_type)

-- maps spring data to its corresponding output node
-- lifetime of spring data is tied to output node
local springs: { [SpringState__DARKLUA_TYPE_L<unknown>]: SourceNode__DARKLUA_TYPE_J<unknown> } = {}
setmetatable(springs :: any, { __mode = "v" })

local function spring<T>(source: () -> T, period: number?, damping_ratio: number?): (() -> T, SpringSettings__DARKLUA_TYPE_M<T>)
    local owner = assert_stable_scope()

    -- https://en.wikipedia.org/wiki/Damping
    local w_n = 2*math.pi / (period or 1)
    local z = damping_ratio or 1
    local k = w_n^2
    local c_c = 2*w_n
    local c = z * c_c

    -- todo: is there a solution other than reducing step size?
    -- todo: this does not catch all solver exploding cases
    if c > UPDATE_RATE*2 then -- solver will explode if this is true
        error("spring damping too high, consider reducing damping or increasing period", 0)
    end

    local data: SpringState__DARKLUA_TYPE_L<T> = {
        k = k,
        c = c,

        x0_123 = vector.zero,
        x_123 = vector.zero,
        x1_123 = vector.zero,
        v_123 = vector.zero,

        x0_456 = vector.zero,
        x_456 = vector.zero,
        x1_456 = vector.zero,
        v_456 = vector.zero,

        source_value = false :: any,
    }
    
    local output = create_source_node(false :: any)

    local function updater_effect()
        local value = source()
        data.x1_123, data.x1_456 = type_to_vec6[typeof(value)](value)
        data.source_value = value
        springs[data] = output
        return value
    end

    local updater = create_node(owner, updater_effect, false :: any)
    evaluate_node(updater)

    -- set initial position to goal
    data.x_123, data.x_456 = data.x1_123, data.x1_456

    -- set output to goal
    output.cache = data.source_value

    local config = function(p)
        local x = p.position
        local v = p.velocity
        local dv = p.impulse

        if x then
            local x_123, x_456 = type_to_vec6[typeof(x)](x)
            data.x_123, data.x_456 = x_123, x_456
            data.x0_123, data.x0_456 = x_123, x_456
        end

        if v then
            data.v_123, data.v_456 = type_to_vec6[typeof(v)](v)
        end

        if dv then
            local dv_123, dv_456 = type_to_vec6[typeof(dv)](dv)
            data.v_123 += dv_123
            data.v_456 += dv_456
        end

        -- schedule spring
        springs[data] = output
    end :: SpringSettings__DARKLUA_TYPE_M<T>

    return function(...)
        if select("#", ...) == 0 then -- no args were given
            push_scope_as_child_of(output)
            return output.cache
        end

        -- set current position to value
        local v = ... :: T
        data.x_123, data.x_456 = type_to_vec6[typeof(v)](v)

        -- reset velocity
        data.v_123 = vector.zero
        data.v_456 = vector.zero

        -- schedule spring
        springs[data] = output

        -- set output to value
        output.cache = v

        return v
    end, config
end

-- calculates a float tolerance, based on the magnitude of the float
local function get_min_step(x: number): number
    return x/TOLERANCE_FACTOR
end
local function get_min_vector_step(direction: vector): vector
    return vector.create(
        get_min_step(direction.x),
        get_min_step(direction.y),
        get_min_step(direction.z)
    )
end

local function step_springs(dt: number)
    for s in springs do
        local k = s.k
        local c = s.c
        local x_123, x_456 = s.x_123, s.x_456
        local x1_123, x1_456 = s.x1_123, s.x1_456
        local u_123, u_456 = s.v_123, s.v_456

        -- calculate displacement from target
        local dx_123 = x_123 - x1_123
        local dx_456 = x_456 - x1_456

        -- calculate spring force
        local fs_123 = dx_123*-k
        local fs_456 = dx_456*-k

        -- calculate friction force
        local ff_123 = u_123*-c
        local ff_456 = u_456*-c

        -- calculate acceleration
        local a_123 = (fs_123 + ff_123)
        local a_456 = (fs_456 + ff_456)

        -- step acceleration
        local v_123 = u_123 + a_123*dt
        local v_456 = u_456 + a_456*dt

        -- step velocity
        local y_123 = x_123 + v_123*dt
        local y_456 = x_456 + v_456*dt

        s.x_123, s.x_456 = y_123, y_456
        s.v_123, s.v_456 = v_123, v_456
    end
end

local function update_spring_sources()
    for data, output in springs do
        local x0_123, x0_456 = data.x0_123, data.x0_456
        local x_123, x_456 = data.x_123, data.x_456
        local x1_123, x1_456 = data.x1_123, data.x1_456
        local v_123, v_456 = data.v_123, data.v_456

        local tol_123 = vector.abs(get_min_vector_step(x0_123 - x1_123))
        local tol_456 = vector.abs(get_min_vector_step(x0_456 - x1_456))

        if
            -- position is at goal (within tolerance)
            vector.max(vector.abs(x_123 - x1_123), tol_123) == tol_123
            and vector.max(vector.abs(x_456 - x1_456), tol_456) == tol_456

            -- velocity is at 0 (within tolerance)
            and vector.max(vector.abs(v_123/10), tol_123) == tol_123
            and vector.max(vector.abs(v_456/10), tol_456) == tol_456
        then
            springs[data] = nil
            output.cache = data.source_value
        else
            output.cache = vec6_to_type[typeof(data.source_value)](x_123, x_456)
        end

        update_descendants(output)
    end
end

return function()
    local time_elapsed = 0

    return spring, function(dt: number)
        time_elapsed += dt

        while time_elapsed > 1 / UPDATE_RATE do
            time_elapsed -= 1 / UPDATE_RATE
            step_springs(1 / UPDATE_RATE)
        end

        update_spring_sources()
    end
end
end function __DARKLUA_BUNDLE_MODULES.y():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.y if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.y=v end return v.c end end do local function __modImpl()
local action = __DARKLUA_BUNDLE_MODULES.g ()()
local cleanup = __DARKLUA_BUNDLE_MODULES.o ()

local function changed<T>(property: string, callback: (T) -> ())
    return action(function(instance)
        local con = instance:GetPropertyChangedSignal(property):Connect(function()
            callback((instance :: any)[property])
        end)

        cleanup(function()
            con:Disconnect()
        end)

        callback((instance :: any)[property])
    end)
end

return changed
end function __DARKLUA_BUNDLE_MODULES.z():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.z if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.z=v end return v.c end end do local function __modImpl()
local version = { major = 0, minor = 4, patch = 0 }

local root = __DARKLUA_BUNDLE_MODULES.c ()
local branch = __DARKLUA_BUNDLE_MODULES.d ()
local mount = __DARKLUA_BUNDLE_MODULES.i ()
local create = __DARKLUA_BUNDLE_MODULES.k ()
local apply = __DARKLUA_BUNDLE_MODULES.h ()
local source = __DARKLUA_BUNDLE_MODULES.l ()
local effect = __DARKLUA_BUNDLE_MODULES.m ()
local derive = __DARKLUA_BUNDLE_MODULES.n ()
local cleanup = __DARKLUA_BUNDLE_MODULES.o ()
local untrack = __DARKLUA_BUNDLE_MODULES.p ()
local read = __DARKLUA_BUNDLE_MODULES.q ()
local batch = __DARKLUA_BUNDLE_MODULES.r ()
local context = __DARKLUA_BUNDLE_MODULES.s ()
local switch = __DARKLUA_BUNDLE_MODULES.u ()
local show = __DARKLUA_BUNDLE_MODULES.v ()
local indexes = __DARKLUA_BUNDLE_MODULES.w ()
local values = __DARKLUA_BUNDLE_MODULES.x ()
local spring, update_springs = __DARKLUA_BUNDLE_MODULES.y ()()
local action = __DARKLUA_BUNDLE_MODULES.g ()()
local changed = __DARKLUA_BUNDLE_MODULES.z ()
local timeout, update_timeouts = __DARKLUA_BUNDLE_MODULES.t () ()
local flags = __DARKLUA_BUNDLE_MODULES.a ()






local function step(dt: number)
    if game then debug.profilebegin("VIDE STEP") end

    if game then debug.profilebegin("VIDE SPRING") end
    update_springs(dt)
    if game then debug.profileend() end

    if game then debug.profilebegin("VIDE SCHEDULER") end
    update_timeouts(dt)
    if game then debug.profileend() end

    if game then debug.profileend() end
end

local stepped = game and game:GetService("RunService").Heartbeat:Connect(function(dt: number)
    task.defer(step, dt)
end)

local vide = {
    version = version,

    -- core
    root = root,
    --branch = branch,
    mount = mount,
    create = create,
    source = source,
    effect = effect,
    derive = derive,
    switch = switch,
    show = show,
    indexes = indexes,
    values = values,

    -- util
    cleanup = cleanup,
    untrack = untrack,
    read = read,
    batch = batch,
    context = context,

    -- animations
    spring = spring,

    -- actions
    action = action,
    changed = changed,

    -- flags
    strict = (nil :: any) :: boolean,
    defaults = (nil :: any) :: boolean,
    defer_nested_properties = (nil :: any) :: boolean,

    -- temporary
    apply = function(instance: Instance)
        return function(props: { [any]: any })
            apply(instance, props)
            return instance
        end
    end,

    -- runtime
    step = function(dt: number)
        if stepped then
            stepped:Disconnect()
            stepped = nil
        end
        step(dt)
    end
}

setmetatable(vide :: any, {
    __index = function(_, index: unknown): ()
        if flags[index] == nil then
            error(`{tostring(index)} is not a valid member of vide`, 0)
        else
            return flags[index]
        end
    end,

    __newindex = function(_, index: unknown, value: unknown)
        if flags[index] == nil then
            error(`{tostring(index)} is not a valid member of vide, 0`)
        else
            flags[index] = value
        end
    end
})

return vide
end function __DARKLUA_BUNDLE_MODULES.A():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.A if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.A=v end return v.c end end do local function __modImpl()
return {
	-- surfaces (dark -> light)
	bg = Color3.fromRGB(14, 17, 22), -- window + panel base
	surface = Color3.fromRGB(24, 28, 36), -- rows, controls
	surfaceHover = Color3.fromRGB(32, 37, 47),
	surfaceActive = Color3.fromRGB(38, 44, 56), -- active tab
	stroke = Color3.fromRGB(42, 48, 60), -- 1px row borders
	surfaceHigh2 = Color3.fromRGB(64, 72, 88), -- topmost interactive step (e.g. button hover)

	-- accent
	accent = Color3.fromRGB(123, 97, 255),
	accentSoft = Color3.fromRGB(157, 139, 255),
	cyan = Color3.fromRGB(56, 224, 255), -- slider thumb only

	-- text
	textPrimary = Color3.fromRGB(236, 238, 245),
	textSecondary = Color3.fromRGB(162, 168, 184),
	textMuted = Color3.fromRGB(110, 117, 133),
}
end function __DARKLUA_BUNDLE_MODULES.B():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.B if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.B=v end return v.c end end do local function __modImpl()-- Icons by name, so callers never have to paste an asset id.
--
-- Rayfield solves this by downloading Lucide's ~200 KB sprite atlas at runtime and slicing it
-- with ImageRectOffset/ImageRectSize. We keep the curated set below instead: they are whole
-- assets, need no slicing, and cost nothing to ship. Anything not in the list can still be
-- passed straight through as an asset id or an rbxassetid:// string, so nothing is locked
-- away behind the table.

local Icons = {}

Icons.Named = {
	-- topbar
	minimize = 71627683074088,
	close = 91413233063028,
	logo = 120561115194230,

	-- tabs
	settings = 87867412432006,
	egg = 15637367451,
	webhook = 122219359034661,
	automatic = 15637369009,
	minigames = 15637376993,
	optimization = 94231924171549,
	bell = 15642579187,
	daycare = 106673690772800,
	mailbox = 15637375511,
	house = 15637376279,
	misc = 15637356511,
	farm = 15637359494,
	farming = 84837573349427,
	player = 15637355840,
	window = 16259403210,
	quest = 15637379637,
	fishing = 91895975011561,
	shop = 15637380284,

	-- misc
	lock = 126141499544212,
	fingerprint = 16089599792,
	chevron = 16093555964,
}

-- Turns whatever a caller passed into an Image string.
--   "farming"                -> a name from the table above
--   15637359494              -> a raw asset id
--   "rbxassetid://123"       -> passed through untouched (also rbxthumb://, rbxasset://)
--   nil / unknown name       -> nil, so the caller can decide on its own fallback
function Icons.resolve(icon: (string | number)?): string?
	if icon == nil then
		return nil
	end

	if type(icon) == "number" then
		return "rbxassetid://" .. icon
	end

	if type(icon) == "string" then
		if string.match(icon, "^rbx%a+://") then
			return icon
		end

		local id = Icons.Named[string.lower(icon)]
		if id then
			return "rbxassetid://" .. id
		end

		warn(`[PixlLib] unknown icon "{icon}" - pass an asset id, or add it to Icons.Named`)
	end

	return nil
end

return Icons
end function __DARKLUA_BUNDLE_MODULES.C():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.C if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.C=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()

local source = vide.source

-- The shell every element shares. It owns the parts that are the same everywhere - the
-- handle you get back from Tab:CreateX, its name, whether it is visible, how it is removed
-- again - so the element files below only describe what makes them different: their value
-- and how they look.
--
-- Value semantics (Toggle, Slider, Input, Dropdown, Keybind):
--   :Set(value)        applies it AND fires the callback, like a user interaction would
--   :SetSilent(value)  applies it without firing - used when restoring a saved config
--   :Get()             reads it back
--
-- Display elements (Button, Label, Section, Paragraph, Divider) hold no value, so :Set falls
-- back to their text - the only thing they *have*. Button:Set("Go") therefore keeps working,
-- and :Set never silently does nothing.
local Element = {}
Element.__index = Element

-- kind:   "Toggle", "Slider", ... - what the element is, mirrored on the handle as .Type
-- config: the table the user passed to Tab:CreateX
-- impl:   { get = function() -> value, set = function(value, fire: boolean) }
--         `set` is what actually applies a value; `fire` tells it whether to run the
--         user's callback. Omit both for a display-only element.












function Element.new(kind: string, config, impl)
	local self = setmetatable({}, Element)

	self.Type = kind
	self.Flag = config.Flag

	-- Tab and the config store index elements by `.flag`; keep the lowercase field as the
	-- one they read so there is a single spelling in the internals.
	self.flag = config.Flag

	self.name = source(config.Name or "")
	self.visible = source(true)

	-- No value of its own -> its text stands in for one, so Button:Set("Go") relabels it
	self._get = impl and impl.get or self.name
	self._set = impl and impl.set or function(text)
		self.name(tostring(text))
	end

	-- Optional: called when the whole UI is torn down. An element that represents something
	-- running (a Toggle that is on) uses it to stop that thing - WITHOUT touching its value,
	-- so the saved config is left as the user left it. Elements that run nothing leave it nil.
	self._teardown = impl and impl.teardown

	-- Filled in by Tab:addChild, which is the only thing that can take us out of the tree
	self._remove = nil

	return self
end

function Element:Get(): any
	return self._get()
end

-- Applies the value and fires the callback, the same way clicking the element would. This is
-- what you want for "turn this feature on from code".
function Element:Set(value)
	self._set(value, true)
end

-- Applies the value without firing the callback. Restoring a saved config uses this when
-- Configuration.FireCallbacksOnLoad is off, so loading a file cannot start features behind
-- the user's back.
function Element:SetSilent(value)
	self._set(value, false)
end

function Element:SetName(name: string)
	self.name(name)
end

function Element:SetVisible(visible: boolean)
	self.visible(visible)
end

function Element:IsVisible(): boolean
	return self.visible()
end

-- Removes the element from its tab. Vide tears the rendered instances down with the scope,
-- and any connection the element registered via vide.cleanup goes with it.
function Element:Destroy()
	if self._remove then
		self._remove()
		self._remove = nil
	end
end

-- Called once, when the UI is being torn down. Stops whatever the element started; does not
-- touch its value.
function Element:Teardown()
	if self._teardown then
		self._teardown()
	end
end

return Element
end function __DARKLUA_BUNDLE_MODULES.D():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.D if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.D=v end return v.c end end do local function __modImpl()
local UserInputService = game:GetService("UserInputService")

local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create
local source = vide.source
local spring = vide.spring

local Keybind = {}

-- How many keybinds are currently waiting for their new key. While that is above zero the
-- next keypress belongs to the rebind and to nothing else - without this, rebinding onto the
-- window's own toggle key would minimise the window in the same breath.
local capturing = 0

function Keybind.IsCapturing(): boolean
	return capturing > 0
end

-- Keys a badge refuses to bind, by KeyCode name. The window registers its own toggle key
-- here, so a rebind can never steal it - pressing it during capture cancels instead.
local reservedKeys = {}

function Keybind.Reserve(keyName: string)
	reservedKeys[keyName] = true
end

function Keybind.Unreserve(keyName: string)
	reservedKeys[keyName] = nil
end

-- The reusable half of a keybind: the key it holds, the listeners that watch for it, and the
-- pill you click to rebind. It owns no row, so a Toggle (or anything else) can place it next
-- to its own controls - the standalone Keybind element below is just this badge in a row.
--
-- config:    { CurrentKeybind = "L", HoldToInteract = false }
-- onFire:    runs when the key is pressed. With HoldToInteract it also runs on release, with
--            `false` - the same contract the standalone element's Callback has.
-- onChanged: config persistence hook, fired when the key itself is rebound
function Keybind.newBadge(config, onFire, onChanged)
	local holdToInteract = config.HoldToInteract or false

	local key = source(config.CurrentKeybind or "K")
	local listening = source(false) -- waiting for the user to press the new key
	local held = source(false)

	local function setListening(value: boolean)
		if value == listening() then
			return
		end

		listening(value)

		if value then
			capturing += 1
		else
			-- Release on the NEXT frame, not now. The keypress that ends a rebind is still
			-- being handed to the other InputBegan listeners - the window's toggle-key
			-- handler among them - and they must all still see the lock, whatever order they
			-- run in. Dropping it here would let a handler that runs after us act on the very
			-- key we just consumed.
			task.defer(function()
				capturing -= 1
			end)
		end
	end

	local function setValue(newKey, fire)
		if type(newKey) == "EnumItem" then
			newKey = newKey.Name
		end

		if type(newKey) ~= "string" or not Enum.KeyCode[newKey] then
			warn(`[PixlLib] "{tostring(newKey)}" is not a KeyCode name, keybind unchanged`)
			return
		end

		if newKey == key() then
			return
		end

		key(newKey)

		if fire and onChanged then
			onChanged()
		end
	end

	local badge = {
		key = key,
		get = key,
		set = setValue,
	}

	-- The pill. Whoever embeds it decides where it sits; it brings its own listeners.
	function badge.render()
		local beganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			-- Rebinding takes priority, and deliberately ignores gameProcessed: the user is
			-- typing INTO our element, not into the game.
			if listening() then
				setListening(false)

				-- Escape cancels and keeps the old key (nobody means to farm on the pause
				-- key), and so does any reserved key - the window's toggle key can never be
				-- stolen by a rebind.
				if input.KeyCode ~= Enum.KeyCode.Escape and not reservedKeys[input.KeyCode.Name] then
					setValue(input.KeyCode.Name, true)
				end
				return
			end

			if gameProcessed or input.KeyCode.Name ~= key() then
				return
			end

			if holdToInteract then
				held(true)
				onFire(true)
			else
				onFire()
			end
		end)
		vide.cleanup(beganConn)

		local endedConn = UserInputService.InputEnded:Connect(function(input)
			if not holdToInteract or input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			-- Only release what we actually caught pressing: a key let go over the UI or in a
			-- text box must not fire a ghost `false`.
			if input.KeyCode.Name == key() and held() then
				held(false)
				onFire(false)
			end
		end)
		vide.cleanup(endedConn)

		-- Destroying the element mid-rebind must not leave the capture lock stuck on
		vide.cleanup(function()
			setListening(false)
		end)

		local hovered = source(false)

		local boxColor = spring(function() -- lights up while it waits for the new key
			if listening() then
				return Colors.accent
			end
			return if hovered() then Colors.surfaceHigh2 else Colors.bg
		end, 0.2)

		return create("Frame")({
			Size = UDim2.fromOffset(70, 34),
			BackgroundColor3 = boxColor,
			ZIndex = 2, -- above the row's click overlay, so the pill takes its own clicks

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
			create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),

			create("TextLabel")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 2,

				Text = function()
					return if listening() then "..." else key()
				end,
				TextColor3 = Colors.textPrimary,
				TextSize = 20,
				TextTruncate = "AtEnd",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("TextButton")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 3,

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,

				Activated = function()
					setListening(not listening()) -- click again to cancel
				end,
			}),
		})
	end

	return badge
end

-- The standalone element: the badge, in a row of its own.
function Keybind.new(config, onChanged)
	local callback = config.Callback

	local badge = Keybind.newBadge(config, function(...)
		if callback then
			callback(...)
		end
	end, onChanged)

	local keybind = Element.new("Keybind", config, {
		get = badge.get,
		set = badge.set,
	})

	local name = keybind.name

	function keybind:render()
		local hovered = source(false)

		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = keybind.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -110, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("TextButton")({ -- row hover; the badge sits above it and eats its own clicks
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,
			}),

			create("Frame")({ -- anchors the badge to the right edge
				Size = UDim2.fromOffset(70, 34),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -16, 0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 2,

				badge.render(),
			}),
		})
	end

	return keybind
end

return Keybind
end function __DARKLUA_BUNDLE_MODULES.E():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.E if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.E=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Icons = __DARKLUA_BUNDLE_MODULES.C()

local create = vide.create
local spring = vide.spring

local Notification = {}

function Notification.new(config, present)
	local notification = {}

	local offset = spring(function()
		return if present() then 0 else 350 -- slides in from +350px right
	end, 0.3)

	local transparency = spring(function()
		return if present() then 0 else 1
	end, 0.3)

	notification.node = create("Frame")({ -- wrapper: the layout child, stays put
		Size = UDim2.new(0, 300, 0, 0),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,

		create("Frame")({ -- the actual card, slides freely inside the wrapper
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			Position = function()
				return UDim2.fromOffset(offset(), 0)
			end,
			BackgroundColor3 = Colors.surfaceHover,
			BackgroundTransparency = transparency,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIStroke")({ -- subtle outer border, fades with the card
				Color = Colors.surface,
				Thickness = 4,
				Transparency = function()
					return 0.7 + transparency() * 0.3 -- 0.7 visible -> 1.0 gone
				end,
			}),

			create("UIPadding")({ -- inner spacing from the frame edges
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
			}),

			create("UIListLayout")({
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
			}),

			create("Frame")({ -- title row
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 1,
				AutomaticSize = "Y",
				BackgroundTransparency = 1,

				create("UIListLayout")({
					FillDirection = "Horizontal", -- icon then title, side by side
					VerticalAlignment = "Center",
					Padding = UDim.new(0, 8),
					SortOrder = "LayoutOrder",
				}),

				create("ImageLabel")({
					Size = UDim2.fromOffset(32, 32), -- fixed, square; no scale coupling
					BackgroundTransparency = 1,
					Image = Icons.resolve(config.Icon) or Icons.resolve("bell"),
					ImageColor3 = Colors.textPrimary,
					ImageTransparency = transparency,
				}),

				create("TextLabel")({ -- title
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = "Y",
					BackgroundTransparency = 1,
					Text = config.Title,
					TextWrapped = true,
					TextColor3 = Colors.textPrimary,
					TextTransparency = transparency,
					TextSize = 24,
					TextXAlignment = "Left",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold),

					create("UIFlexItem")({ FlexMode = "Fill" }),
				}),
			}),

			create("TextLabel")({ -- content
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 2,
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Text = config.Content,
				TextWrapped = true,
				TextColor3 = Colors.textSecondary,
				TextTransparency = transparency,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		}),
	})

	return notification
end

return Notification
end function __DARKLUA_BUNDLE_MODULES.F():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.F if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.F=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()
local Icons = __DARKLUA_BUNDLE_MODULES.C()

local create = vide.create
local source = vide.source
local spring = vide.spring

local Button = {}

function Button.new(config)
	local button = Element.new("Button", config)

	local name = button.name
	local icon = source(Icons.resolve(config.Icon) or Icons.resolve("fingerprint"))

	local callback = config.Callback

	function button:render()
		local hovered = source(false)
		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 44),
			BackgroundColor3 = bgColor,
			Visible = button.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -64, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("ImageLabel")({ -- icon on the right
				Size = UDim2.fromScale(0.6, 0.6),
				SizeConstraint = "RelativeYY",
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -20, 0.5, 0),
				BackgroundTransparency = 1,

				Image = icon,
				ImageColor3 = Colors.textMuted,
			}),

			create("TextButton")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,

				Activated = function()
					if callback then
						callback()
					end
				end,
			}),
		})
	end

	function button:SetIcon(newIcon)
		icon(Icons.resolve(newIcon) or "")
	end

	return button
end

return Button
end function __DARKLUA_BUNDLE_MODULES.G():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.G if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.G=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create

local Divider = {}

-- A drawn line, not just empty space: it is the thing you reach for to say "the group above
-- ended here". Blank spacers cannot do that, they just look like a layout accident.
function Divider.new(config)
	local divider = Element.new("Divider", config or {})

	function divider:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 9), -- the line plus breathing room above and below
			BackgroundTransparency = 1,
			Visible = divider.visible,

			create("Frame")({
				Size = UDim2.new(1, 0, 0, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Colors.stroke,
				BorderSizePixel = 0,
			}),
		})
	end

	return divider
end

return Divider
end function __DARKLUA_BUNDLE_MODULES.H():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.H if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.H=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create
local source = vide.source
local indexes = vide.indexes
local spring = vide.spring
local changed = vide.changed

-- The open panel is measured, not guessed: it is exactly as tall as the rows it holds - the
-- search row plus one row per option that survives the search - and stops growing at
-- MAX_ROWS, from where the list scrolls. A fixed height left a two-option dropdown with two
-- empty slots below it.
local ROW_HEIGHT = 60
local ROW_GAP = 12 -- UIListLayout padding between the rows
local PANEL_PADDING = 8 -- the scroll frame's own UIPadding, top + bottom
local HEADER_GAP = 10 -- the panel starts 10px below the 60px header
local MAX_ROWS = 4 -- search row + 3 options before it scrolls

local function panelHeightFor(rowCount: number): number
	local rows = math.min(rowCount, MAX_ROWS)
	return rows * ROW_HEIGHT + (rows - 1) * ROW_GAP + PANEL_PADDING + HEADER_GAP
end

local Dropdown = {}

function Dropdown.new(config, onChanged)
	local multiple = if config.MultipleOptions == nil then true else config.MultipleOptions
	local callback = config.Callback

	local optionList = source(config.Options or {})
	local selected = source({})

	local function toArray(set)
		local arr = {}
		for name in set do
			table.insert(arr, name)
		end
		table.sort(arr) -- stable output: :Get() and the saved config keep one order
		return arr
	end

	local function setSelected(newSet, fire)
		selected(newSet)

		if fire then
			if callback then
				callback(toArray(newSet))
			end
			if onChanged then
				onChanged()
			end
		end
	end

	local dropdown = Element.new("Dropdown", config, {
		get = function()
			return toArray(selected())
		end,

		set = function(options, fire)
			local new = {}

			-- Accept a bare string as well as a list; a single-select dropdown restored from
			-- a config is the obvious case where one value shows up on its own.
			if type(options) == "string" then
				options = { options }
			end

			for _, name in options or {} do
				new[name] = true
			end

			setSelected(new, fire)
		end,
	})

	local name = dropdown.name

	if config.CurrentOption then
		dropdown:SetSilent(config.CurrentOption)
	end

	function dropdown:render()
		local open = source(false) -- panel expanded?

		local searchText = source("")

		local searchFocused = source(false)

		local searchBoxColor = spring(function() -- inset field: darkest at rest, lifts on focus
			return if searchFocused() then Colors.surfaceActive else Colors.bg
		end, 0.3)

		local searchStrokeColor = spring(function() -- accent border while focused
			return if searchFocused() then Colors.accent else Colors.stroke
		end, 0.3)

		local hovered = source(false)
		local bgColor = spring(function() -- drives the HEADER only (the visible hull when closed)
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local chevronRotation = spring(function()
			return if open() then 180 else 0
		end, 0.3)

		-- The options the search leaves standing. Both the row list and the panel height read
		-- this, so they can never disagree about how many rows there are.
		local function visibleOptions()
			local query = searchText():lower()
			local matches = {}

			for _, optionName in optionList() do
				if string.find(optionName:lower(), query, 1, true) then
					table.insert(matches, optionName)
				end
			end

			return matches
		end

		local panelHeight = spring(function() -- single height source for the whole expand/collapse
			if not open() then
				return 0
			end

			-- +1 for the fixed search row, which is a row like any other
			return panelHeightFor(1 + #visibleOptions())
		end, 0.3)

		local function allSelected()
			local count = 0
			for _ in selected() do
				count += 1
			end
			return count > 0 and count == #optionList() -- count > 0 guards the empty list
		end

		local allHovered = source(false)
		local allBgColor = spring(function() -- one step up the ladder on hover, like every row
			return if allHovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local allBoxColor = spring(function() -- fills with accent when everything is selected
			return if allSelected() then Colors.accent else Colors.bg
		end, 0.2)

		local searchHovered = source(false)
		local searchBgColor = spring(function() -- mirrors the option rows' / All button's hover
			return if searchHovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		return create("Frame")({
			-- one frame, one animated height: header (60) + panel; clips the scroll frame as it grows/shrinks
			Size = function()
				return UDim2.new(0.98, 0, 0, 60 + panelHeight())
			end,
			BackgroundColor3 = Colors.bg, -- fixed dark backdrop the options rest on
			ClipsDescendants = true,
			Visible = dropdown.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("Frame")({ -- header row, pinned to the top; this is the hoverable hull
				Size = UDim2.new(1, 0, 0, 60),
				Position = UDim2.fromScale(0, 0),
				BackgroundColor3 = bgColor,

				create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

				create("TextLabel")({ -- name on the left
					Size = UDim2.new(0.5, -16, 1, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 16, 0.5, 0),
					BackgroundTransparency = 1,

					Text = name,
					TextColor3 = Colors.textPrimary,
					TextSize = 22,
					TextXAlignment = "Left",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
				}),

				create("TextLabel")({ -- summary on the right, derived from selection
					Size = UDim2.new(0.4, -48, 1, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -55, 0.5, 0),
					BackgroundTransparency = 1,

					Text = function()
						if not multiple then
							return next(selected()) or "Select Option"
						end
						local count = 0

						for _ in selected() do
							count += 1
						end

						if count > 0 and count == #optionList() then
							return "All selected"
						elseif count > 0 then
							return count .. " selected"
						else
							return "Select options"
						end
					end,
					TextColor3 = Colors.textMuted,
					TextSize = 20,
					TextXAlignment = "Right",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
				}),

				create("ImageLabel")({ -- chevron, flips when open
					Size = UDim2.fromOffset(30, 30),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -16, 0.5, 0),
					BackgroundTransparency = 1,

					Image = "rbxassetid://16093555964",
					ImageColor3 = Colors.textMuted,
					Rotation = chevronRotation,
				}),

				create("TextButton")({ -- click overlay toggles open
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Text = "",

					Activated = function()
						open(not open())
					end,
				}),

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,
			}),

			create("ScrollingFrame")({ -- pinned below the header; height is the animated panel height
				Size = function()
					return UDim2.new(0.975, 0, 0, panelHeight() - 10) -- gap subtracted so the bottom stays flush
				end,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 70), -- 10px below the header instead of pulling up
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Colors.textMuted,
				AutomaticCanvasSize = "Y",
				CanvasSize = UDim2.new(),

				create("UIListLayout")({ Padding = UDim.new(0, 12), HorizontalAlignment = "Left", SortOrder = "LayoutOrder" }),
				create("UIPadding")({
					PaddingTop = UDim.new(0, 2),
					PaddingBottom = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
				}),

				create("Frame")({ -- fixed top row: search (full InputBox element) + select-all
					Size = UDim2.new(0.98, 0, 0, 60),
					LayoutOrder = 0,
					BackgroundTransparency = 1,

					create("Frame")({ -- search
						Size = if multiple then UDim2.new(0.8325, 0, 1, 0) else UDim2.new(1, 0, 1, 0),
						BackgroundColor3 = searchBgColor,

						MouseEnter = function()
							searchHovered(true)
						end,
						MouseLeave = function()
							searchHovered(false)
						end,

						create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

						create("TextLabel")({ -- name
							Size = UDim2.new(0.45, -16, 0.6, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 16, 0.5, 0),
							BackgroundTransparency = 1,

							Text = "Browse Options",
							TextColor3 = Colors.textPrimary,
							TextSize = 22,
							TextXAlignment = "Left",
							FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
						}),

						create("Frame")({ -- input field background
							Size = if multiple then UDim2.new(0, 250, 0.6, 0) else UDim2.new(0, 300, 0.6, 0),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundColor3 = searchBoxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({
								Color = searchStrokeColor,
								Thickness = 1.5,
							}),
							create("UIPadding")({
								PaddingLeft = UDim.new(0, 10),
								PaddingRight = UDim.new(0, 10),
							}),

							create("TextBox")({
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								ClearTextOnFocus = false,

								Text = "",
								PlaceholderText = "Option Name Here",
								PlaceholderColor3 = Colors.textMuted,
								TextColor3 = Colors.textPrimary,
								TextSize = 22,
								TextXAlignment = "Left",
								FontFace = Font.fromName("Montserrat"),

								Focused = function()
									searchFocused(true)
								end,
								FocusLost = function()
									searchFocused(false)
								end,

								changed("Text", function(text)
									searchText(text)
								end),
							}),
						}),
					}),

					create("Frame")({ -- select-all button
						Size = UDim2.new(0.15, 0, 1, 0),
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						Visible = multiple,
						BackgroundColor3 = allBgColor,

						create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

						create("TextLabel")({ -- "All" label
							Size = UDim2.new(1, -56, 1, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 16, 0.5, 0),
							BackgroundTransparency = 1,

							Text = "All",
							TextColor3 = Colors.textPrimary,
							TextSize = 22,
							TextXAlignment = "Left",
							FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
						}),

						create("Frame")({ -- checkbox
							Size = UDim2.fromOffset(24, 24),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundColor3 = allBoxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),
						}),

						create("TextButton")({ -- click overlay: hover + toggle all on/off
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							Text = "",

							MouseEnter = function()
								allHovered(true)
							end,
							MouseLeave = function()
								allHovered(false)
							end,
							Activated = function()
								if allSelected() then
									setSelected({}, true)
								else
									local new = {}
									for _, optionName in optionList() do
										new[optionName] = true -- otherwise fill the whole list
									end
									setSelected(new, true)
								end
							end,
						}),
					}),
				}),

				indexes(visibleOptions, function(option, i)
					local optionHovered = source(false)
					local optionBg = spring(function() -- rests on surface over the dark backdrop, hovers one step up
						return if optionHovered() then Colors.surfaceHover else Colors.surface
					end, 0.3)

					local boxColor = spring(function() -- inset checkbox, fills with accent when checked
						return if selected()[option()] then Colors.accent else Colors.bg
					end, 0.2)

					local markColor = spring(function()
						return if selected()[option()] then Colors.accent else Colors.textMuted
					end, 0.2)

					return create("Frame")({
						Size = UDim2.new(0.98, 0, 0, 60),
						LayoutOrder = i + 1,
						BackgroundColor3 = optionBg,

						create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

						create("TextLabel")({ -- option name, leaves room for the box on the right
							Size = UDim2.new(1, -80, 1, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 16, 0.5, 0),
							BackgroundTransparency = 1,

							Text = option,
							TextColor3 = Colors.textPrimary,
							TextSize = 22,
							TextXAlignment = "Left",
							FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
						}),

						create("Frame")({ -- checkbox
							Size = UDim2.fromOffset(26, 26),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							Visible = multiple,
							BackgroundColor3 = boxColor,

							create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
							create("UIStroke")({ Color = Colors.stroke, Thickness = 1.5 }),
						}),

						create("ImageLabel")({ -- fingerprint marker (single-select)
							Size = UDim2.fromOffset(24, 24),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -16, 0.5, 0),
							BackgroundTransparency = 1,
							Visible = not multiple,

							Image = "rbxassetid://16089599792",
							ImageColor3 = markColor,
						}),

						create("TextButton")({ -- click overlay: hover + toggle the box
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							Text = "",

							MouseEnter = function()
								optionHovered(true)
							end,
							MouseLeave = function()
								optionHovered(false)
							end,
							Activated = function()
								if multiple then
									local new = table.clone(selected())
									new[option()] = if new[option()] then nil else true
									setSelected(new, true)
								else
									if selected()[option()] then
										setSelected({}, true)
									else
										setSelected({ [option()] = true }, true)
									end
								end
							end,
						}),
					})
				end),
			}),
		})
	end

	-- Swap the option list at runtime. This is what you need when the options are not known
	-- when the UI is built - a game directory that is still loading, a list that depends on
	-- what the player owns. Selected options that survive the swap stay selected; the rest
	-- are dropped, because keeping a selection the list no longer offers means :Get() returns
	-- something the user cannot see or undo.
	function dropdown:Refresh(options: { string })
		optionList(options or {})

		local kept = {}
		local dropped = false

		for _, optionName in options or {} do
			if selected()[optionName] then
				kept[optionName] = true
			end
		end

		for optionName in selected() do
			if not kept[optionName] then
				dropped = true
				break
			end
		end

		if dropped then
			-- Silent: the option vanished from the game, the user did not deselect it
			setSelected(kept, false)
		end
	end

	function dropdown:GetOptions(): { string }
		return table.clone(optionList())
	end

	return dropdown
end

return Dropdown
end function __DARKLUA_BUNDLE_MODULES.I():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.I if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.I=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create
local source = vide.source
local spring = vide.spring

local InputBox = {}

function InputBox.new(config, onChanged)
	local isNumber = config.IsNumber
	local callback = config.Callback

	local value = source(config.CurrentValue or "") -- committed value, single source of truth

	local function setValue(newValue, fire)
		if isNumber then
			newValue = tonumber(newValue)
			if not newValue then
				return -- a number box never holds a non-number, not even from a config file
			end
		end

		if newValue == value() then
			return
		end

		value(newValue)

		if fire then
			if callback then
				callback(newValue)
			end
			if onChanged then
				onChanged()
			end
		end
	end

	local input = Element.new("Input", config, {
		get = value,
		set = setValue,
	})

	local name = input.name

	function input:render()
		local focused = source(false)
		local hovered = source(false)

		local bgColor = spring(function() -- the row itself
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local boxColor = spring(function() -- inset field: darkest at rest, lifts on focus
			return if focused() then Colors.surfaceActive else Colors.bg
		end, 0.3)

		local strokeColor = spring(function() -- accent border only while focused
			return if focused() then Colors.accent else Colors.stroke
		end, 0.3)

		local textColor = spring(function() -- brightens on focus
			return if focused() then Colors.textPrimary else Colors.textSecondary
		end, 0.3)

		local box
		box = create("TextBox")({
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClearTextOnFocus = true,

			-- Text follows the committed value; vide only rewrites it on commit/:Set,
			-- never mid-typing -> no cursor jumps
			Text = function()
				return tostring(value())
			end,
			PlaceholderText = config.Placeholder or "",
			PlaceholderColor3 = Colors.textMuted,

			TextColor3 = textColor,
			TextSize = 22,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),

			Focused = function()
				focused(true)
			end,

			FocusLost = function() -- (enterPressed, inputObject)
				focused(false)

				if isNumber and not tonumber(box.Text) then
					box.Text = tostring(value()) -- reject: snap box back to last good value
					return
				end

				setValue(box.Text, true)
			end,
		})

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = input.visible,

			MouseEnter = function()
				hovered(true)
			end,
			MouseLeave = function()
				hovered(false)
			end,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name
				Size = UDim2.new(0.45, -16, 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("Frame")({ -- input field background
				Size = UDim2.new(0.5, 0, 0.6, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -16, 0.5, 0),
				BackgroundColor3 = boxColor,

				create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

				create("UIStroke")({
					Color = strokeColor,
					Thickness = 1.5,
				}),

				create("UIPadding")({
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
				}),

				box,
			}),
		})
	end

	return input
end

return InputBox
end function __DARKLUA_BUNDLE_MODULES.J():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.J if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.J=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create

local Label = {}

function Label.new(config)
	local label = Element.new("Label", config)

	local name = label.name
	local color = config.Color or Colors.textPrimary

	function label:render()
		return create("TextLabel")({
			Size = UDim2.new(0.98, 0, 0, 28),
			BackgroundTransparency = 1,
			Visible = label.visible,

			Text = name,
			TextColor3 = color,
			TextSize = 32,
			TextXAlignment = "Left",
			TextYAlignment = "Bottom",

			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		})
	end

	return label
end

return Label
end function __DARKLUA_BUNDLE_MODULES.K():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.K if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.K=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create
local source = vide.source

local Paragraph = {}

function Paragraph.new(config)
	-- The paragraph's heading is the element name, so :SetName() retitles it like every
	-- other element; the body gets its own source.
	local paragraph = Element.new("Paragraph", { Name = config.Title })
	local title = paragraph.name
	local content = source(config.Content or "")

	function paragraph:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 0),
			BackgroundColor3 = Colors.surface,
			AutomaticSize = "Y",
			Visible = paragraph.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIPadding")({ -- inner spacing from the frame edges
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
			}),

			create("UIListLayout")({ -- stacks children, frame sums their height
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
			}),

			create("TextLabel")({ -- title
				Size = UDim2.new(1, 0, 0, 28),
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = title,
				TextColor3 = Colors.textPrimary,
				TextSize = 24,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("TextLabel")({ -- content
				Size = UDim2.new(1, 0, 0, 0), -- X fixed, Y grows with text
				LayoutOrder = 2,
				AutomaticSize = "Y",
				BackgroundTransparency = 1,

				Text = content,
				TextWrapped = true,
				TextColor3 = Colors.textSecondary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		})
	end

	function paragraph:SetContent(newContent: string)
		content(newContent)
	end

	return paragraph
end

return Paragraph
end function __DARKLUA_BUNDLE_MODULES.L():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.L if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.L=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create

-- A section belongs to what comes AFTER it, not before. So it carries its breathing room on
-- top: a wide gap that separates it from the previous group, and only the list's normal
-- spacing below, which glues it to the elements it heads.
--
-- The exception is the first element of a tab. There is no previous group to separate from,
-- so the gap would just be a dent at the top of the page - it is dropped in that case.
local ROW_HEIGHT = 30
local TOP_GAP = 16

local Section = {}

function Section.new(config)
	local section = Element.new("Section", config)
	local name = section.name

	function section:render()
		-- isFirst is handed to us by Tab:addChild and reads the tab's child list, so this
		-- follows along if the element order changes later.
		local function topGap()
			return if section.isFirst and section.isFirst() then 0 else TOP_GAP
		end

		return create("Frame")({
			Size = function()
				return UDim2.new(0.98, 0, 0, ROW_HEIGHT + topGap())
			end,
			BackgroundTransparency = 1,
			Visible = section.visible,

			-- The padding below shrinks the content area from the top, so centering inside it
			-- keeps the heading exactly as it looked - the gap simply appears above it.
			create("UIListLayout")({
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 10),
				SortOrder = "LayoutOrder",
			}),

			create("UIPadding")({
				PaddingTop = function()
					return UDim.new(0, topGap())
				end,
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
			}),

			create("TextLabel")({
				Size = UDim2.fromOffset(0, 20), -- X grows with the text
				AutomaticSize = "X",
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textMuted,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("Frame")({ -- rule filling the rest of the row
				Size = UDim2.new(1, 0, 0, 3),
				LayoutOrder = 2,
				BackgroundColor3 = Colors.stroke,
				BorderSizePixel = 0,

				create("UIFlexItem")({ FlexMode = "Fill" }),
			}),
		})
	end

	return section
end

return Section
end function __DARKLUA_BUNDLE_MODULES.M():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.M if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.M=v end return v.c end end do local function __modImpl()
local UserInputService = game:GetService("UserInputService")

local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()

local create = vide.create
local source = vide.source
local spring = vide.spring

local Slider = {}

function Slider.new(config, onChanged)
	local min, max = config.Range[1], config.Range[2]
	local increment = config.Increment or 1
	local suffix = config.Suffix
	local callback = config.Callback

	local value = source(math.clamp(config.CurrentValue or min, min, max))

	local function snap(raw)
		return math.clamp(math.round(raw / increment) * increment, min, max)
	end

	local function setValue(raw, fire)
		raw = tonumber(raw)
		if not raw then
			return
		end

		local snapped = snap(raw)
		if snapped == value() then
			return
		end

		value(snapped)

		if fire and callback then
			callback(snapped)
		end
	end

	local slider = Element.new("Slider", config, {
		get = value,
		set = function(raw, fire)
			setValue(raw, fire)

			-- Dragging saves once on release (see below); a programmatic Set has no release,
			-- so it has to persist itself.
			if fire and onChanged then
				onChanged()
			end
		end,
	})

	local name = slider.name

	local function fraction()
		return (value() - min) / (max - min)
	end

	function slider:render()
		local dragging = source(false)
		local hovered = source(false)

		local bgColor = spring(function()
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)
		local thumbScale = spring(function()
			return if dragging() then 1.2 else 1
		end, 0.2)
		local fillFraction = spring(fraction, 0.15)

		local track
		local function updateFromX(mouseX)
			local f = (mouseX - track.AbsolutePosition.X) / track.AbsoluteSize.X
			setValue(min + f * (max - min), true)
		end

		track = create("Frame")({ -- track
			Size = UDim2.new(0.95, 0, 0, 10),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -10),
			BackgroundColor3 = Colors.bg,

			create("UICorner")({ CornerRadius = UDim.new(1, 0) }),

			create("Frame")({ -- fill
				Size = function()
					return UDim2.fromScale(fillFraction(), 1) -- springed, lags slightly behind
				end,
				BackgroundColor3 = Colors.accent,

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
			}),

			create("Frame")({ -- thumb
				Size = function()
					local s = thumbScale()
					return UDim2.fromOffset(18 * s, 18 * s)
				end,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = function()
					return UDim2.fromScale(fillFraction(), 0.5) -- same springed fraction as the fill
				end,
				BackgroundColor3 = Colors.textPrimary,

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
			}),
		})

		local moveConn = UserInputService.InputChanged:Connect(function(input)
			if dragging() and input.UserInputType == Enum.UserInputType.MouseMovement then
				updateFromX(input.Position.X)
			end
		end)
		vide.cleanup(moveConn)

		local endConn = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				-- Save once, on release: a drag walks through dozens of values and each one
				-- would otherwise be written to disk.
				if dragging() and onChanged then
					onChanged()
				end
				dragging(false)
			end
		end)
		vide.cleanup(endConn)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = slider.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name
				Size = UDim2.new(0.5, 0, 0.4, 0),
				Position = UDim2.new(0, 16, 0.1, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("TextLabel")({ -- value, reacts to the state
				Size = UDim2.new(0.35, 0, 0.4, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -16, 0.1, 0),
				BackgroundTransparency = 1,

				Text = function()
					return if suffix then value() .. " " .. suffix else tostring(value())
				end,
				TextColor3 = Colors.textSecondary,
				TextSize = 22,
				TextXAlignment = "Right",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			track,

			create("TextButton")({ -- full-element overlay: hover + drag start anywhere
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,

				InputBegan = function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging(true)
						updateFromX(input.Position.X)
					end
				end,
			}),
		})
	end

	-- Retarget the slider without rebuilding it. The value is clamped into the new range, so
	-- a slider that pointed past the new maximum lands on it rather than showing a value it
	-- can no longer reach.
	function slider:SetRange(newMin: number, newMax: number)
		min, max = newMin, newMax
		setValue(math.clamp(value(), min, max), false)
	end

	return slider
end

return Slider
end function __DARKLUA_BUNDLE_MODULES.N():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.N if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.N=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Element = __DARKLUA_BUNDLE_MODULES.D()
local Keybind = __DARKLUA_BUNDLE_MODULES.E()

local create = vide.create
local source = vide.source
local spring = vide.spring

-- thumb positions inside the track (scale, so it scales with the track)
local THUMB_OFF = UDim2.fromScale(0.28, 0.5)
local THUMB_ON = UDim2.fromScale(0.72, 0.5)

local SWITCH_WIDTH = 52
local BADGE_WIDTH = 70
local GAP = 12 -- between the badge and the switch

local Toggle = {}

function Toggle.new(config, onChanged)
	local on = source(config.CurrentValue or false) -- the actual bool state
	local callback = config.Callback

	local function setValue(value, fire)
		value = value and true or false -- a saved config can hand us anything

		if value == on() then
			return
		end

		on(value)

		if fire then
			if callback then
				callback(value)
			end
			if onChanged then
				onChanged()
			end
		end
	end

	local toggle = Element.new("Toggle", config, {
		get = on,
		set = setValue,

		-- On teardown, an on-toggle stops its feature. We call the callback directly with
		-- false rather than setValue(false), so the toggle's stored value stays true and a
		-- saved config still reflects what the user had on - the feature stops, the setting
		-- survives.
		teardown = function()
			if on() and callback then
				callback(false)
			end
		end,
	})

	local name = toggle.name

	-- Optional inline keybind. The key drives the TOGGLE, not the feature behind it, so the
	-- switch always shows what is really running - same reason :Set() fires callbacks.
	--   HoldToInteract = false -> the key flips the toggle
	--   HoldToInteract = true  -> the toggle is on only while the key is held
	local badge = nil

	if config.Keybind then
		local keyConfig = config.Keybind

		badge = Keybind.newBadge(keyConfig, function(held)
			if keyConfig.HoldToInteract then
				setValue(held, true)
			else
				setValue(not on(), true)
			end
		end, onChanged)

		-- A handle of its own, so the key is saved and reachable like any other value:
		-- PixlLib.Flags.AutoFarmKey:Get() -> "L"
		toggle.keybind = Element.new("Keybind", keyConfig, {
			get = badge.get,
			set = badge.set,
		})
	end

	function toggle:render()
		local hovered = source(false)
		local bgColor = spring(function() -- one step up the depth ladder on hover
			return if hovered() then Colors.surfaceHover else Colors.surface
		end, 0.3)

		local trackColor = spring(function() -- off-track sits on surfaceActive so it reads on both row states
			return if on() then Colors.accent else Colors.surfaceActive
		end, 0.3)

		local thumbPos = spring(function()
			return if on() then THUMB_ON else THUMB_OFF
		end, 0.3)

		-- What the name has to give up on the right: the switch always, the badge only if
		-- there is one. No keybind, no gap - the row looks exactly as it did before.
		local rightInset = 20 + SWITCH_WIDTH + (if badge then GAP + BADGE_WIDTH else 0)

		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 60),
			BackgroundColor3 = bgColor,
			Visible = toggle.visible,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("TextLabel")({ -- name on the left
				Size = UDim2.new(1, -(rightInset + 32), 0.6, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.5, 0),
				BackgroundTransparency = 1,

				Text = name,
				TextColor3 = Colors.textPrimary,
				TextSize = 22,
				TextXAlignment = "Left",
				TextTruncate = "AtEnd",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),

			create("Frame")({ -- switch track
				Size = UDim2.fromOffset(SWITCH_WIDTH, 28),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -20, 0.5, 0),
				BackgroundColor3 = trackColor,

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }), -- pill

				create("Frame")({ -- thumb
					Size = UDim2.fromScale(0.78, 0.78),
					SizeConstraint = "RelativeYY", -- square, based on track height
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = thumbPos,
					BackgroundColor3 = Colors.textPrimary,

					create("UICorner")({ CornerRadius = UDim.new(1, 0) }), -- round
				}),
			}),

			create("TextButton")({ -- click anywhere on the row flips it
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",

				MouseEnter = function()
					hovered(true)
				end,
				MouseLeave = function()
					hovered(false)
				end,

				Activated = function()
					setValue(not on(), true)
				end,
			}),

			-- Left of the switch, and created AFTER the click overlay on purpose: the badge
			-- must sit on top of it, or the overlay swallows the click meant for rebinding.
			if badge
				then create("Frame")({
					Size = UDim2.fromOffset(BADGE_WIDTH, 34),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -(20 + SWITCH_WIDTH + GAP), 0.5, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,

					badge.render(),
				})
				else nil,
		})
	end

	return toggle
end

return Toggle
end function __DARKLUA_BUNDLE_MODULES.O():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.O if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.O=v end return v.c end end do local function __modImpl()
local vide = __DARKLUA_BUNDLE_MODULES.A()

local Button = __DARKLUA_BUNDLE_MODULES.G()
local Divider = __DARKLUA_BUNDLE_MODULES.H()
local Dropdown = __DARKLUA_BUNDLE_MODULES.I()
local InputBox = __DARKLUA_BUNDLE_MODULES.J()
local Keybind = __DARKLUA_BUNDLE_MODULES.E()
local Label = __DARKLUA_BUNDLE_MODULES.K()
local Paragraph = __DARKLUA_BUNDLE_MODULES.L()
local Section = __DARKLUA_BUNDLE_MODULES.M()
local Slider = __DARKLUA_BUNDLE_MODULES.N()
local Toggle = __DARKLUA_BUNDLE_MODULES.O()

local source = vide.source

local Tab = {}

function Tab.new(name, icon, flags, onChanged)
	local tab = {
		name = name,
		icon = icon,
		flags = flags,
		onChanged = onChanged,
		children = source({}),
	}

	-- Every Create* funnels through here: the element goes into the tab's child list (which
	-- vide renders), into the flag registry if it carries a Flag, and gets handed the way
	-- back out again so :Destroy() can remove it.
	local function addChild(handle)
		local new = table.clone(tab.children())
		table.insert(new, handle)
		tab.children(new)

		-- Reads the child list, so it re-evaluates on its own when elements come and go.
		-- A Section uses it to drop the gap it would otherwise put above itself: that gap
		-- exists to separate it from the group before it, and at the top of a tab there is
		-- no group before it.
		handle.isFirst = function()
			return tab.children()[1] == handle
		end

		local function register(element)
			if not (element and element.flag) then
				return
			end

			if flags[element.flag] then
				warn(`[PixlLib] duplicate Flag "{element.flag}" - the config will only keep one of them`)
			end
			flags[element.flag] = element
		end

		register(handle)

		-- An element may carry an inline keybind (a Toggle with Keybind = {...}). It is a
		-- value in its own right, so it gets its own flag entry and is saved and reachable
		-- like any other: PixlLib.Flags.AutoFarmKey:Get()
		register(handle.keybind)

		handle._remove = function()
			local remaining = {}
			for _, child in tab.children() do
				if child ~= handle then
					table.insert(remaining, child)
				end
			end
			tab.children(remaining)

			for _, element in { handle, handle.keybind } do
				if element.flag and flags[element.flag] == element then
					flags[element.flag] = nil
				end
			end
		end

		return handle
	end

	function tab:CreateButton(config)
		return addChild(Button.new(config))
	end

	function tab:CreateLabel(config)
		-- Historically the text was positional: CreateLabel("Text")
		if type(config) == "string" then
			config = { Name = config }
		end
		return addChild(Label.new(config))
	end

	function tab:CreateSection(config)
		if type(config) == "string" then
			config = { Name = config }
		end
		return addChild(Section.new(config))
	end

	function tab:CreateDivider()
		return addChild(Divider.new({}))
	end

	function tab:CreateParagraph(config)
		return addChild(Paragraph.new(config))
	end

	function tab:CreateToggle(config)
		return addChild(Toggle.new(config, onChanged))
	end

	function tab:CreateSlider(config)
		return addChild(Slider.new(config, onChanged))
	end

	function tab:CreateInput(config)
		return addChild(InputBox.new(config, onChanged))
	end

	function tab:CreateDropdown(config)
		return addChild(Dropdown.new(config, onChanged))
	end

	function tab:CreateKeybind(config)
		return addChild(Keybind.new(config, onChanged))
	end

	return tab
end

return Tab
end function __DARKLUA_BUNDLE_MODULES.P():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.P if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.P=v end return v.c end end do local function __modImpl()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local vide = __DARKLUA_BUNDLE_MODULES.A()
local Colors = __DARKLUA_BUNDLE_MODULES.B()
local Icons = __DARKLUA_BUNDLE_MODULES.C()
local Keybind = __DARKLUA_BUNDLE_MODULES.E()
local Notification = __DARKLUA_BUNDLE_MODULES.F()
local Tab = __DARKLUA_BUNDLE_MODULES.P()

local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local playerName = localPlayer and localPlayer.Name or "Player"
local userId = localPlayer and localPlayer.UserId or 1

local source = vide.source
local create = vide.create
local spring = vide.spring
local indexes = vide.indexes

local OPENED_POSITION = UDim2.new(0.5, 0, 0.5, 0)
local CLOSED_POSITION = UDim2.new(0.5, 0, 1.5, 0)
local UI_SCALE = 0.85

-- layout raster (px, inside the mainframe) -- change PAD to tighten/loosen everywhere
local PAD = 8
local TOPBAR_H = 66
local TABLIST_W = 220
local ROW_Y = PAD + TOPBAR_H + PAD -- top of the tablist/content row

local Window = {}
Window.__index = Window

local function makeDraggable(positionSource, scale, locked)
	local dragging = false
	local dragStart = nil
	local startOffset = nil
	local wasDragged = false

	local conn = UserInputService.InputChanged:Connect(function(input)
		if dragging and not (locked and locked()) and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = (input.Position - dragStart) / scale()

			if delta.Magnitude > 5 then
				wasDragged = true
			end

			local newX = startOffset.X + delta.X
			local newY = startOffset.Y + delta.Y

			local current = positionSource()
			local newPosition = UDim2.new(current.X.Scale, newX, current.Y.Scale, newY)

			positionSource(newPosition)
		end
	end)
	vide.cleanup(conn)

	local function began(input)
		if locked and locked() then
			wasDragged = false
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			wasDragged = false
			dragging = true

			dragStart = input.Position
			startOffset = Vector2.new(positionSource().X.Offset, positionSource().Y.Offset)
		end
	end

	local function ended(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end

	return {
		began = began,
		ended = ended,

		wasDragged = function()
			return wasDragged
		end,
	}
end

local function createTopbar(props)
	local minimizeHovered = source(false)
	local minimizeColor = spring(function()
		return if minimizeHovered() then Colors.surfaceHigh2 else Colors.surfaceHover
	end, 0.3)

	local settingsHovered = source(false)
	local settingsColor = spring(function()
		if props.settingsOpen() then
			return Colors.accent -- clearly "on" while the settings view is showing
		end
		return if settingsHovered() then Colors.surfaceHigh2 else Colors.surfaceHover
	end, 0.3)

	return create("Frame")({ -- floating panel: PAD inset on top/left/right, fixed height
		Size = UDim2.new(1, -PAD * 2, 0, TOPBAR_H),
		Position = UDim2.fromOffset(PAD, PAD),
		BackgroundColor3 = Colors.bg, -- panel, same family as tablist/content

		create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

		create("TextLabel")({
			Size = UDim2.fromScale(0.5, 0.7),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.02, 0.5),
			BackgroundTransparency = 1,

			Text = props.title,
			TextSize = 38,
			TextColor3 = Colors.textPrimary,
			TextXAlignment = "Left",
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold),
		}),

		create("Frame")({ -- player display
			Size = UDim2.fromOffset(0, 40), -- X grows with content, Y fixed
			AutomaticSize = "X",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.98, -96, 0.5, 0), -- left of both settings + minimize buttons
			BackgroundColor3 = Colors.surfaceHover, -- control resting on the bg panel

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			create("UIListLayout")({ -- icon then name, side by side
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
			}),

			create("UIPadding")({ -- inner spacing so content isn't flush to the edges
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 10),
			}),

			create("Frame")({ -- avatar, fixed square, no manual position (layout places it)
				Size = UDim2.fromOffset(32, 32),
				LayoutOrder = 1,
				BackgroundColor3 = Colors.surface,

				create("UICorner")({ CornerRadius = UDim.new(1, 0) }),

				create("ImageLabel")({
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Image = "rbxthumb://type=AvatarHeadShot&id=" .. props.userId .. "&w=420&h=420",

					create("UICorner")({ CornerRadius = UDim.new(1, 0) }),
				}),
			}),

			create("TextLabel")({ -- name, width grows with text
				Size = UDim2.fromOffset(0, 35),
				AutomaticSize = "X",
				LayoutOrder = 2,
				BackgroundTransparency = 1,

				Text = props.playerName,
				TextSize = 28,
				TextColor3 = Colors.textSecondary,
				TextXAlignment = "Left",
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
			}),
		}),

		create("ImageButton")({ -- settings button
			Size = UDim2.fromOffset(40, 40),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.98, -48, 0.5, 0), -- left of the minimize button (40px + 8px gap)
			BackgroundColor3 = settingsColor,
			Image = "", -- glyph lives on the inner label so it can be scaled down

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			create("ImageLabel")({ -- gear glyph, inset so it doesn't fill the whole button
				Size = UDim2.fromScale(0.78, 0.78),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,

				Image = Icons.resolve("settings"),
				ImageColor3 = Colors.textPrimary,
			}),

			MouseButton1Click = props.onSettings,

			MouseEnter = function()
				settingsHovered(true)
			end,
			MouseLeave = function()
				settingsHovered(false)
			end,
		}),

		create("ImageButton")({ -- minimize button
			Size = UDim2.fromOffset(40, 40),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(0.98, 0.5),
			BackgroundColor3 = minimizeColor,

			Image = "rbxassetid://71627683074088",
			ImageColor3 = Colors.textPrimary,

			create("UICorner")({ CornerRadius = UDim.new(0, 8) }),

			MouseButton1Click = props.onMinimize,

			MouseEnter = function()
				minimizeHovered(true)
			end,
			MouseLeave = function()
				minimizeHovered(false)
			end,
		}),

		InputBegan = props.onDragBegan,
		InputEnded = props.onDragEnded,
	})
end

local function createTopButton(props)
	local iconTransparency = spring(function()
		return if props.locked() then 0 else 1
	end, 0.3)

	return create("Frame")({
		Size = UDim2.fromOffset(140, 40),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = props.position,
		BackgroundColor3 = Colors.surfaceHover, -- floating pill, lifted off the mainframe
		ZIndex = 9999,

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),

		create("UIStroke")({ -- subtle outer border
			Color = Colors.surface,
			Thickness = 4,
			Transparency = 0.7,
		}),

		create("TextLabel")({
			Size = UDim2.fromScale(0.9, 0.8),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,

			Text = function()
				return if props.minimized() then "Open" else "Close"
			end,

			TextColor3 = Colors.textPrimary,
			TextSize = 34,
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		}),

		create("TextButton")({
			Size = UDim2.fromScale(1, 1),
			Transparency = 1,

			MouseButton1Click = props.onToggle,

			InputBegan = function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton2 then
					props.onToggleLock()
				else
					props.onDragBegan(input)
				end
			end,
			InputEnded = props.onDragEnded,
		}),

		create("ImageLabel")({
			Size = UDim2.fromScale(0.6, 0.6),
			SizeConstraint = "RelativeYY",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.95, 0, 0.5, 0),
			BackgroundTransparency = 1,

			Image = "rbxassetid://126141499544212",
			ImageColor3 = Colors.textMuted,
			ImageTransparency = iconTransparency,

			Visible = function()
				return props.locked()
			end,
		}),
	})
end

local function createTabList(props)
	return create("Frame")({ -- tablist: left column, below the topbar row
		Size = UDim2.new(0, TABLIST_W, 1, -(ROW_Y + PAD)),
		Position = UDim2.fromOffset(PAD, ROW_Y),
		BackgroundColor3 = Colors.bg,

		create("ScrollingFrame")({
			Size = UDim2.fromScale(0.925, 0.95),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),

			ScrollBarThickness = 4,
			VerticalScrollBarPosition = "Left",

			ScrollBarImageColor3 = Colors.textMuted,
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(),

			Transparency = 1,

			create("UIListLayout")({
				Padding = UDim.new(0, 4),
				HorizontalAlignment = "Center",
				SortOrder = "LayoutOrder",
			}),

			indexes(props.tabs, function(tab, i)
				local hovered = source(false)

				local function targetBgColor()
					if props.activeTab() == tab() then
						return Colors.surfaceActive -- active: brightest static step
					elseif hovered() then
						return Colors.surfaceHover -- real hover
					else
						return Colors.bg -- idle: blends into the tablist panel
					end
				end
				local bgColor = spring(targetBgColor, 0.3)

				local function targetTextColor()
					if props.activeTab() == tab() then
						return Colors.textPrimary
					else
						return Colors.textMuted
					end
				end
				local textColor = spring(targetTextColor, 0.3)

				return create("Frame")({
					Size = UDim2.new(0.925, 0, 0.1, 0),
					BackgroundColor3 = bgColor,

					create("UICorner")({
						CornerRadius = UDim.new(0, 12),
					}),

					create("TextButton")({
						Size = UDim2.fromScale(1, 1),

						BackgroundTransparency = 1,
						Text = "",

						Activated = function()
							props.onSelect(tab())
						end,

						MouseEnter = function()
							hovered(true)
						end,

						MouseLeave = function()
							hovered(false)
						end,
					}),

					create("ImageLabel")({
						Size = UDim2.fromScale(0.6, 0.6),
						SizeConstraint = "RelativeYY",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 8, 0.5, 0),
						BackgroundTransparency = 1,

						Image = function()
							return tab().icon or Icons.resolve("misc")
						end,

						ImageColor3 = textColor,
					}),

					create("TextLabel")({
						Size = UDim2.new(1, -48, 0.6, 0),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						BackgroundTransparency = 1,

						Text = function()
							return tab().name
						end,

						TextColor3 = textColor,

						TextXAlignment = "Left",
						TextSize = 24,
						FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
					}),
				})
			end),
		}),

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),
	})
end

local function createCurrentTab(props)
	return create("Frame")({ -- content: fills the rest of the row, right of the tablist
		Size = UDim2.new(1, -(PAD + TABLIST_W + PAD + PAD), 1, -(ROW_Y + PAD)),
		Position = UDim2.fromOffset(PAD + TABLIST_W + PAD, ROW_Y),
		BackgroundColor3 = Colors.bg,

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),

		indexes(props.tabs, function(tab, i)
			return create("Frame")({
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = function()
					return props.activeTab() == tab() and not props.settingsOpen()
				end,

				create("ScrollingFrame")({
					Size = UDim2.fromScale(0.975, 0.95),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1,
					ScrollBarThickness = 4,
					ScrollBarImageColor3 = Colors.textMuted,
					AutomaticCanvasSize = "Y",
					CanvasSize = UDim2.new(),

					create("UIListLayout")({
						Padding = UDim.new(0, 12),
						HorizontalAlignment = "Left",
						SortOrder = "LayoutOrder",
					}),

					indexes(function()
						return tab().children()
					end, function(child)
						return child():render()
					end),
				}),
			})
		end),
	})
end

local function createSettingsPanel(props)
	return create("Frame")({ -- shares the content area, shown instead of the active tab
		Size = UDim2.new(1, -(PAD + TABLIST_W + PAD + PAD), 1, -(ROW_Y + PAD)),
		Position = UDim2.fromOffset(PAD + TABLIST_W + PAD, ROW_Y),
		BackgroundColor3 = Colors.bg,
		Visible = props.settingsOpen,

		create("UICorner")({
			CornerRadius = UDim.new(0, 12),
		}),

		create("ScrollingFrame")({
			Size = UDim2.fromScale(0.975, 0.95),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = Colors.textMuted,
			AutomaticCanvasSize = "Y",
			CanvasSize = UDim2.new(),

			create("UIListLayout")({
				Padding = UDim.new(0, 12),
				HorizontalAlignment = "Left",
				SortOrder = "LayoutOrder",
			}),

			create("TextLabel")({ -- panel heading
				Size = UDim2.new(1, 0, 0, 44),
				LayoutOrder = 1,
				BackgroundTransparency = 1,

				Text = "Settings",
				TextColor3 = Colors.textPrimary,
				TextXAlignment = "Left",
				TextSize = 30,
				FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
			}),

			create("Frame")({ -- change UI keybind: label left, rebind pill right
				Size = UDim2.new(0.98, 0, 0, 60),
				LayoutOrder = 2,
				BackgroundColor3 = Colors.surface,

				create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

				create("TextLabel")({
					Size = UDim2.new(1, -110, 0.6, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 16, 0.5, 0),
					BackgroundTransparency = 1,

					Text = "Change UI keybind",
					TextColor3 = Colors.textPrimary,
					TextSize = 22,
					TextXAlignment = "Left",
					FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
				}),

				create("Frame")({ -- anchors the pill to the right edge
					Size = UDim2.fromOffset(70, 34),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -16, 0.5, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,

					props.keyBadge.render(),
				}),
			}),

			(function() -- unload UI: destructive, so it reads red and needs a confirming second click
				local hovered = source(false)
				local armed = source(false) -- first click arms; a second click within the timeout unloads
				local armToken = 0

				local bgColor = spring(function()
					if armed() then
						return Color3.fromRGB(150, 40, 48) -- brighter alarm once armed
					end
					return if hovered() then Color3.fromRGB(122, 48, 56) else Color3.fromRGB(46, 28, 32)
				end, 0.3)

				return create("Frame")({
					Size = UDim2.new(0.98, 0, 0, 48),
					LayoutOrder = 3,
					BackgroundColor3 = bgColor,

					create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

					create("TextLabel")({
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,

						Text = function()
							return if armed() then "Click again to confirm" else "Unload UI"
						end,
						TextColor3 = Color3.fromRGB(255, 180, 186),
						TextSize = 22,
						FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
					}),

					create("TextButton")({
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Text = "",

						MouseEnter = function()
							hovered(true)
						end,
						MouseLeave = function()
							hovered(false)
						end,

						Activated = function()
							if armed() then
								armed(false)
								if props.onUnload then
									props.onUnload()
								end
								return
							end

							-- Arm, then disarm on a timeout unless it was pressed again first.
							armed(true)
							armToken += 1
							local myToken = armToken
							task.delay(3, function()
								if armToken == myToken then
									armed(false)
								end
							end)
						end,
					}),
				})
			end)(),
		}),
	})
end

local function createNotificationStack(props)
	return create("Frame")({
		Size = UDim2.new(0, 350, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,

		create("UIListLayout")({
			HorizontalAlignment = "Right",
			VerticalAlignment = "Bottom",
			Padding = UDim.new(0, 16),
			SortOrder = "LayoutOrder",
		}),

		create("UIPadding")({
			PaddingBottom = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
		}),

		indexes(props.notifications, function(entry, id, present)
			return Notification.new(entry(), present).node, 0.4
		end),
	})
end

function Window.new(config, notifications, flags, onChanged, onUnload)
	config = config or {}

	local self = setmetatable({}, Window)

	self.flags = flags
	self.onChanged = onChanged

	self.tabs = source({})
	self.activeTab = source(nil)

	-- Held as a source so the settings panel can rebind the open/close key at runtime.
	local initialKey = config.ToggleKey or "K"
	if not Enum.KeyCode[initialKey] then
		initialKey = "K"
	end
	local toggleKeyName = source(initialKey)

	-- Off-limits for keybind elements: a rebind pressing this key cancels instead of stealing
	-- the shortcut that opens and closes the whole window. The reservation follows a live rebind.
	Keybind.Reserve(toggleKeyName())
	vide.cleanup(function()
		Keybind.Unreserve(toggleKeyName())
	end)

	-- Swaps the reserved key and the live toggle in one step. Fed by the settings keybind pill.
	local function setToggleKey(newName)
		if newName == toggleKeyName() or not Enum.KeyCode[newName] then
			return
		end
		Keybind.Unreserve(toggleKeyName())
		toggleKeyName(newName)
		Keybind.Reserve(newName)
	end

	local scale = source(1)
	local minimized = source(false)
	local settingsOpen = source(false)

	local topButtonPos = source(UDim2.new(0.5, 0, 0, 10))
	local topDisplayPos = spring(topButtonPos, 0.1)
	local locked = source(false)

	local windowPos = source(OPENED_POSITION)
	local displayPos = spring(function()
		return if minimized() then CLOSED_POSITION else windowPos()
	end, 0.3)

	local function toggleMinimized()
		local nowMinimized = not minimized()
		if not nowMinimized then
			windowPos(OPENED_POSITION)
		end
		minimized(nowMinimized)
	end

	local mainDrag = makeDraggable(windowPos, scale, nil)
	local topDrag = makeDraggable(topButtonPos, scale, locked)

	local function updateScale()
		local vp = camera.ViewportSize
		local raw = math.min(vp.X / 1920, vp.Y / 1080)
		scale(math.min(raw, 1) * UI_SCALE)
	end

	local conn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	vide.cleanup(conn)
	updateScale()

	local keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		-- A keybind element is waiting for its new key: that press is being typed into the
		-- element, so it must not also fold the window away.
		if Keybind.IsCapturing() then
			return
		end

		if input.KeyCode.Name == toggleKeyName() then
			toggleMinimized()
		end
	end)
	vide.cleanup(keyConn)

	-- Hard on/off for the whole interface, separate from `minimized` (which is the animated
	-- slide-away that leaves the Open pill behind). SetVisibility(false) leaves nothing.
	local enabled = source(true)
	self.enabled = enabled
	self.minimized = minimized
	self.toggleMinimized = toggleMinimized

	-- The rebind pill shown in the settings panel. onFire is a no-op: the window's own global
	-- handler already reacts to the key, so the badge is purely the rebind UI. onChanged fires
	-- once the pill has captured a new key, pushes it into the live toggle, and requests a save
	-- so the choice survives a reload (only actually written when config.Saving is on).
	local toggleKeyBadge
	toggleKeyBadge = Keybind.newBadge({ CurrentKeybind = toggleKeyName() }, function() end, function()
		setToggleKey(toggleKeyBadge.get())
		if self.onChanged then
			self.onChanged()
		end
	end)

	-- Read/write the toggle key from outside (config load). The setter also updates the visible
	-- pill and does NOT request a save, so restoring from disk cannot loop back into a write.
	self.getToggleKey = function()
		return toggleKeyName()
	end
	self.setToggleKey = function(name)
		if not Enum.KeyCode[name] then
			return
		end
		setToggleKey(name) -- live key + reservation
		toggleKeyBadge.set(name) -- pill display (no fire, so no onChanged)
	end

	self.node = create("ScreenGui")({
		Name = "PixlLib",
		IgnoreGuiInset = true,
		Enabled = enabled,

		create("UIScale")({ Scale = scale }),

		create("Frame")({ -- mainframe (footer removed -> shorter)
			Size = UDim2.fromOffset(960, 540),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = displayPos,
			BackgroundColor3 = Colors.surfaceActive,

			create("UICorner")({ CornerRadius = UDim.new(0, 12) }),

			create("UIStroke")({ -- subtle outer border
				Color = Colors.surface,
				Thickness = 4,
				Transparency = 0.7,
			}),

			createTopbar({
				title = config.Title,
				onMinimize = toggleMinimized,
				onSettings = function()
					settingsOpen(not settingsOpen())
				end,
				settingsOpen = settingsOpen,
				onDragBegan = mainDrag.began,
				onDragEnded = mainDrag.ended,

				playerName = playerName,
				userId = userId,
			}),

			createTabList({
				tabs = self.tabs,
				activeTab = self.activeTab,
				onSelect = function(tab)
					self.activeTab(tab)
					settingsOpen(false) -- picking a tab returns from the settings view
				end,
			}),
			createCurrentTab({
				tabs = self.tabs,
				activeTab = self.activeTab,
				settingsOpen = settingsOpen,
			}),
			createSettingsPanel({
				settingsOpen = settingsOpen,
				keyBadge = toggleKeyBadge,
				onUnload = onUnload,
			}),
		}),

		createTopButton({
			minimized = minimized,
			position = topDisplayPos,
			onDragBegan = topDrag.began,
			onDragEnded = topDrag.ended,
			locked = locked,

			onToggle = function()
				if topDrag.wasDragged() then
					return
				end
				toggleMinimized()
			end,
			onToggleLock = function()
				locked(not locked())
			end,
		}),

		createNotificationStack({
			notifications = notifications, -- the source, see below
		}),
	})

	return self
end

-- icon takes a name from Icons.Named ("farming"), a raw asset id, or an rbxassetid:// string
function Window:CreateTab(name: string, icon: (string | number)?)
	local tab = Tab.new(name, Icons.resolve(icon), self.flags, self.onChanged)

	local new = table.clone(self.tabs())
	table.insert(new, tab)
	self.tabs(new)

	if self.activeTab() == nil then
		self.activeTab(tab)
	end

	return tab
end

-- Stops everything the elements started, across every tab. Called once as the UI is torn
-- down, so a toggled-on feature does not keep its loop running after its switch is gone.
function Window:TeardownAll()
	for _, tab in self.tabs() do
		for _, child in tab.children() do
			if child.Teardown then
				child:Teardown()
			end
		end
	end
end

function Window:SelectTab(tab)
	self.activeTab(tab)
end

function Window:GetTabs()
	return table.clone(self.tabs())
end

-- Shows/hides the entire interface, the Open pill included. This is the one to bind to a
-- panic key; :Minimize() is the softer "get out of the way" the topbar button uses.
function Window:SetVisibility(visible: boolean)
	self.enabled(visible and true or false)
end

function Window:IsVisible(): boolean
	return self.enabled()
end

function Window:Minimize(minimized: boolean?)
	if minimized == nil then
		self.toggleMinimized() -- no argument: flip it
	elseif minimized ~= self.minimized() then
		self.toggleMinimized()
	end
end

function Window:IsMinimized(): boolean
	return self.minimized()
end

return Window
end function __DARKLUA_BUNDLE_MODULES.Q():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.Q if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.Q=v end return v.c end end end
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local vide = __DARKLUA_BUNDLE_MODULES.A()
local Window = __DARKLUA_BUNDLE_MODULES.Q()

local source = vide.source

local PixlLib = {}

-- Every element that carries a Flag, keyed by it. This is what the config reads and writes,
-- and what you index to reach an element from anywhere: PixlLib.Flags.AutoFarm:Set(true)
PixlLib.Flags = {}

-- Written to the config file so a future format change can migrate instead of guessing
local CONFIG_VERSION = 1

-- Executors expose these as globals; Studio does not, in which case they read as nil.
-- Everything file-related goes through this table, so exactly one place knows whether saving
-- is possible at all - the rest of the library never has to ask.
local fs = {
	read = readfile,
	write = writefile,
	isFile = isfile,
	isFolder = isfolder,
	makeFolder = makefolder,
}

local function canWrite(): boolean
	return fs.write ~= nil and fs.isFolder ~= nil and fs.makeFolder ~= nil
end

local function canRead(): boolean
	return fs.read ~= nil and fs.isFile ~= nil
end

local function getGuiParent()
	if gethui then
		return gethui()
	end
	-- studio / kein executor -> fallback
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function configPath(config): string
	return `{config.FolderName}/{config.FileName}.json`
end

-------------------------------------------------------------------------------
-- Configuration
-------------------------------------------------------------------------------

function PixlLib:Save()
	local config = self.config
	if not (config and config.Saving) then
		return
	end

	local values = {}
	for flag, element in self.Flags do
		values[flag] = element:Get()
	end

	local payload = {
		version = CONFIG_VERSION,
		values = values,
		-- The window toggle key lives outside the Flags map, so it rides along separately.
		toggleKey = self._window and self._window.getToggleKey and self._window.getToggleKey() or nil,
	}

	if not canWrite() then
		return -- Studio, or an executor without file access: nothing to do, and nothing broken
	end

	local ok, err = pcall(function()
		if not fs.isFolder(config.FolderName) then
			fs.makeFolder(config.FolderName)
		end
		fs.write(configPath(config), HttpService:JSONEncode(payload))
	end)

	if not ok then
		warn(`[PixlLib] could not save config: {err}`)
	end
end

-- Saving on every keystroke of a text box (or every step of a slider drag) would hammer the
-- disk. Collapse the writes: the last change within the window wins.
local SAVE_DEBOUNCE = 0.5
local savePending = false

local function requestSave()
	if savePending then
		return
	end
	savePending = true

	task.delay(SAVE_DEBOUNCE, function()
		savePending = false
		PixlLib:Save()
	end)
end

function PixlLib:Load()
	local config = self.config
	if not (config and config.Loading) then
		return
	end

	if not canRead() then
		return -- Studio: no file API, so there is nothing saved to restore
	end

	local path = configPath(config)

	local ok, decoded = pcall(function()
		if not fs.isFile(path) then
			return nil
		end
		return HttpService:JSONDecode(fs.read(path))
	end)

	if not ok then
		warn(`[PixlLib] config at {path} is unreadable, ignoring it: {decoded}`)
		return
	end

	if not decoded then
		return -- nothing saved yet
	end

	-- v1 wraps the values; anything older was a flat map of flag -> value
	local values = decoded.values or decoded

	-- Restore the window toggle key before the flags: it is independent of them, and doing it
	-- up front keeps the reservation correct while the elements below load.
	if decoded.toggleKey and self._window and self._window.setToggleKey then
		self._window.setToggleKey(decoded.toggleKey)
	end

	-- Whether restoring a value should run the element's callback. On by default, so a saved
	-- toggle actually turns its feature back on - a config that restores the switch but not
	-- the thing behind it is a lie. Set FireCallbacksOnLoad = false when the callbacks do
	-- something you would not want to happen unattended at launch.
	local fire = config.FireCallbacksOnLoad ~= false

	for flag, value in values do
		local element = self.Flags[flag]

		if element then
			if fire then
				element:Set(value)
			else
				element:SetSilent(value)
			end
		end
		-- A flag in the file with no element is not an error: the script may simply have
		-- dropped that feature since. It is kept in `values` and rewritten on the next save.
	end
end

-------------------------------------------------------------------------------
-- Notifications
-------------------------------------------------------------------------------

local notifications = source({})
local nextId = 0

local function removeById(id)
	local new = table.clone(notifications())
	new[id] = nil -- key disappears -> indexes destroys exactly this scope
	notifications(new)
end

function PixlLib:Notify(config)
	nextId += 1
	local id = nextId

	local new = table.clone(notifications())
	new[id] = {
		Title = config.Title,
		Content = config.Content,
		Icon = config.Icon,
	}
	notifications(new) -- triggers the renderer

	local duration = config.Duration or 6
	task.delay(duration, removeById, id)

	return function()
		removeById(id) -- dismiss it early
	end
end

-------------------------------------------------------------------------------
-- Window
-------------------------------------------------------------------------------

function PixlLib:CreateWindow(config)
	-- Running the script twice would otherwise leave the old interface behind, still
	-- listening to input and still holding its feature loops.
	local env = getgenv and getgenv() or {}
	if env.PixlLibUnmount then
		env.PixlLibUnmount()
	end

	self.Flags = {}
	self.config = config.Configuration

	local window
	local destroyScope = vide.mount(function()
		-- onUnload lets the settings panel's "Unload UI" button trigger the same full teardown
		-- (flush pending config, stop features, destroy the tree) as calling PixlLib:Destroy().
		window = Window.new(config, notifications, self.Flags, requestSave, function()
			self:Destroy()
		end)
		return window.node
	end, getGuiParent())

	self._window = window
	self._unmount = function()
		-- Stop the running features FIRST, while the elements and their callbacks still
		-- exist. This is the manual "turn everything off before unloading" that a caller used
		-- to have to write by hand - now it is unavoidable, so a reload can never leave an
		-- orphaned loop firing remotes with no switch left to stop it.
		window:TeardownAll()

		destroyScope()
		if window.node then
			window.node:Destroy()
		end

		self._window = nil
		self.Flags = {}
		env.PixlLibUnmount = nil
	end

	env.PixlLibUnmount = self._unmount

	if self.config and self.config.Loading then
		-- Deferred so the caller can finish building its tabs first: elements that do not
		-- exist yet cannot be restored.
		task.defer(function()
			self:Load()
		end)
	end

	return window
end

-- Tears the interface down for good, after writing any pending config change. Everything
-- vide created goes with the scope, so no connections are left running.
function PixlLib:Destroy()
	if savePending then
		savePending = false
		self:Save()
	end

	if self._unmount then
		self._unmount()
		self._unmount = nil
	end
end

function PixlLib:SetVisibility(visible: boolean)
	if self._window then
		self._window:SetVisibility(visible)
	end
end

function PixlLib:IsVisible(): boolean
	return self._window ~= nil and self._window:IsVisible()
end

return PixlLib
