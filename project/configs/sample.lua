
-----------------------------------------------------------------------------------------------

local wv = nil
local wvobj = nil

function init( _wv, _wvobj )
    wv = _wv
    wvobj = _wvobj
end

-----------------------------------------------------------------------------------------------
local function lj_sampleFunc( seq, req, arg )

    print( "Luajit Called from JS: ", ffi.string(seq), ffi.string(req), arg)
end

-----------------------------------------------------------------------------------------------

return {
    lj_func = lj_sampleFunc,
    lj_init = init,
}

-----------------------------------------------------------------------------------------------
