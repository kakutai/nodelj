-----------------------------------------------------------------------------------------------

function execute( cmd )

   local fh = io.popen( cmd, "r" )
   return fh 
end


-----------------------------------------------------------------------------------------------
function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
       last_end = e+1
       s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
       cap = str:sub(last_end)
       table.insert(t, cap)
    end
    return t
  end

-----------------------------------------------------------------------------------------------

local function BGRtoRGB( totalsize, pxls )

   totalsize = totalsize / 4
   local intptr = ffi.cast("uint32_t *", pxls)
   for idx = 1, totalsize do
      local r = bit.lshift(bit.band(0x0000ff, intptr[idx]), 16)
      local b = bit.rshift( intptr[idx], 16 )
      local g = bit.rshift(bit.band(0x00ff00, intptr[idx]), 8)
      intptr[idx] = bit.bor(r, bit.bor(g, b))
   end
   return ffi.cast("const char *", intptr)
end

---------------------------------------------------------------------------------------   

local function BGR2YUV( src, width, height )

   local yIndex = 0
   local uvIndex = 0

   local a, R, G, B, Y, U, V;
   local index = 0
   for j = 0, height-1 do
      for i = 0, width-1 do

         a = bit.rshift(bit.band(src[index], 0xff000000), 24)
         B = bit.rshift(bit.band(src[index], 0xff), 0)
         G = bit.rshift(bit.band(src[index], 0xff00), 8)
         R = bit.rshift(bit.band(src[index], 0xff0000), 16)

         -- well known RGB to YUV algorithm
         Y =  bit.rshift(  66 * R + 129 * G +  25 * B + 128, 8) +  16
         U =  bit.rshift( -38 * R -  74 * G + 112 * B + 128, 8) + 128
         V =  bit.rshift( 112 * R -  94 * G -  18 * B + 128, 8) + 128

      --   // NV21 has a plane of Y and interleaved planes of VU each sampled by a factor of 2
      --   //    meaning for every 4 Y pixels there are 1 V and 1 U.  Note the sampling is every other
      --   //    pixel AND every other scanline.
         yplane[yIndex] = bit.band(Y, 0xff)
         yIndex = yIndex + 1

         if (j % 2 == 0) and (i % 2 == 0) then  
            uplane[uvIndex] = bit.band(U, 0xff)
            vplane[uvIndex] = bit.band(V, 0xff)
            uvIndex = uvIndex + 1
         end

         index = index + 1
      end
   end
end

---------------------------------------------------------------------------------------
