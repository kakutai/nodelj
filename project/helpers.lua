-----------------------------------------------------------------------------------------------
local ffi = require 'ffi'
local pthread = require 'pthread'

ffi.cdef [[

void free(void *);
]]

-----------------------------------------------------------------------------------------------

local function mutex_init()

    local mutex = ffi.new("pthread_mutex_t[1]")
    pthread.pthread_mutex_init( mutex, nil)
    return mutex 
end

local function mutex_lock( mutex )
    pthread.pthread_mutex_lock(mutex)
end

local function mutex_unlock( mutex )
    pthread.pthread_mutex_unlock(mutex)
end

local mutex = mutex_init()

-----------------------------------------------------------------------------------------------

local function error_callback( error, desc )
    print("Error: ", error, ffi.string(desc))
end

-----------------------------------------------------------------------------------------------

local function print_string_list( strlist )
    local slc = cef.cef_string_list_size(strlist)
    p("String List Size:", tonumber(slc))
    for i=0, tonumber(slc)-1 do 
        local value = ffi.new("cef_string_t[1]")
        cef.cef_string_list_value(strlist, i, value)
        local val = ffi.new("cef_string_utf8_t[1]")
        cef.cef_string_utf16_to_utf8( value[0].str, value[0].length, val)
        if(tonumber(val[0].length)> 0) then 
            p("Index: "..i, "Value: "..ffi.string(val[0].str, tonumber(val[0].str)) ) 
        end
    end
end

-----------------------------------------------------------------------------------------------
-- This is some crazy shit. God.. if this is how Google code.. they are completely shite.
local function insert_command( commandline, command )

    local argv = cef.cef_string_list_alloc()
    commandline.get_argv( commandline, argv )
    local argc = tonumber(cef.cef_string_list_size(argv))
    local out_argv = ffi.new("char *[?]", argc + 1)

    local ct = 0
    -- Iterate current list. Insert command 1 after the main command.
    for idx = 0, argc - 1 do
        
        local value = ffi.new("cef_string_t[1]")
        cef.cef_string_list_value(argv, idx, value)
        local val = ffi.new("cef_string_utf8_t[1]")
        cef.cef_string_utf16_to_utf8( value[0].str, value[0].length, val)
        local commandstring = ffi.string(val[0].str)

        -- out_argv[ct] = ffi.cast("char *", commandstring)
        out_argv[ct] = val[0].str
        ct = ct + 1

        if( idx == 0 ) then
            local cmdstr = ffi.new("char[?]", #command + 1)
            ffi.copy(cmdstr, ffi.string(command, #command), #command)
            out_argv[ct] = cmdstr
            -- commandstring = commandstring..' '..ffi.string( cmdstr )
            ct = ct + 1
        end
    end 

    if( ct > 0 ) then 
        commandline.init_from_argv( commandline, ct, ffi.cast("const char *const *", out_argv ))
    end
    return commandline
end

-----------------------------------------------------------------------------------------------
-- Reference counter needed by cef

local refcounts = {}
local ref_mutex = mutex_init()

local function add_ref(self)

    mutex_lock(mutex)   

    local addr = "ptr_"..tonumber(ffi.cast("unsigned int", self))
    cefstr.add_ref( ffi.string( addr ) )
    mutex_unlock(mutex)   
end

local function rel_ref(self)

    mutex_lock(mutex)   

    local addr = "ptr_"..tonumber(ffi.cast("unsigned int", self))
    local ret =  cefstr.rel_ref( ffi.string( addr ) )
    mutex_unlock(mutex)   
    return ret
end

local function has_one_ref(self)

    mutex_lock(mutex)   

    local addr = "ptr_"..tonumber(ffi.cast("unsigned int", self))
    local ret =  cefstr.has_one_ref( ffi.string( addr ) )
    mutex_unlock(mutex)   
    return ret
end

local function make_ref( inst, base_type )

    mutex_lock(mutex)   
    inst.base.size = ffi.sizeof(base_type)
    -- inst.base.add_ref = add_ref
    -- inst.base.release = rel_ref
    -- inst.base.has_one_ref = has_one_ref
    inst.base.add_ref = cefstr.add_ref
    inst.base.release = cefstr.rel_ref
    inst.base.has_one_ref = cefstr.has_one_ref
    mutex_unlock(mutex)   
end

-----------------------------------------------------------------------------------------------

local function make_task( task_func )

    local task = ffi.new("cef_task_t[1]")
    make_ref(task[0], "cef_task_t")
    task[0].execute = task_func
    return task
end

-----------------------------------------------------------------------------------------------

return {

    mutex_init = mutex_init,
    mutex_lock = mutex_lock,
    mutex_unlock = mutex_unlock,

    make_ref = make_ref,
    print_string_list = print_string_list,
    insert_command = insert_command,

    error_callback = error_callback,

    make_task = make_task,
}

-----------------------------------------------------------------------------------------------
