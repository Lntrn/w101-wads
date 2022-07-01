--[[

	class.lua
	
	class metatable to allow for the creation of "class" type functionality
	
]]


--[[
--------------------------------------------------------------------
	Temporary Helpers
--------------------------------------------------------------------	
]]

function MakeRectString(sx,sy,ex,ey)
	return ""..sx..","..sy..","..ex..","..ey;
end

function MakePointString(x,y)
	return ""..x..","..y;
end



function class(base,contructor)
	local c = {}     
	if not contructor and type(base) == 'function' then
		contructor = base
		base = nil
	elseif type(base) == 'table' then
		for i,v in pairs(base) do
			c[i] = v
		end
		c._base = base
    end
    
	c.__index = c
	local mt = {}
	mt.__call = function(class_tbl,...)
		local obj = {}
		setmetatable(obj,c)
		if contructor then
		contructor(obj,unpack(arg))
		else 
			if base and base.init then
				base.init(obj,unpack(arg))
			end
		end
		return obj
	end
  
	c.init = contructor
	c.is_a = function(self,klass)
		local m = getmetatable(self)
		while m do 
			if m == klass then 
				return true 
			end
			m = m._base
		end
		return false
	end
	setmetatable(c,mt)
	return c
end


