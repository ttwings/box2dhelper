local helper
local script = {}
local ref = {}

function script.load()
	ref = {}
	for i,body in ipairs(helper.world:getBodyList()) do
		script.set(body)
		local scription = helper.getProperty(body,"scription")
		if scription then
			if scription.load then scription.load() end
		end
	end
end
--[[
function script.update()
	for i,body in ipairs(helper.world:getBodyList()) do
		local scription = helper.getProperty(body,"scription")
		if scription then
			if scription.update then scription.update(love.timer.getDelta()) end
		end
	end
end]]

function script.update()
	for handle,body in pairs(ref) do
		local scription = helper.getProperty(body,"scription")
		if body:isDestroyed() then
			if scription.destroy then scription.destroy() end
		else
			if scription.update then scription.update(love.timer.getDelta()) end
		end
		
		
		
	end
end

function script.draw()
	for i,body in ipairs(helper.world:getBodyList()) do
		local scription = helper.getProperty(body,"scription")
		if scription then
			if scription.draw then scription.draw() end
		end
	end
end

function script.set(body)
	local file = helper.getProperty(body,"script_file")
	
	if not file then return end
	local func = loadstring(file)
	if not func then return end
	ref[body] = body
	local env = {}
	env.helper = helper
	env.editor = helper.editor
	env.world = helper.world
	env.body = body
	env.set = helper.setProperty
	env.get = helper.getProperty
	env.fixtures = body:getFixtureList()
	env.print = helper.editor.log.print
	setmetatable(env, {__index = _G}) 

	env.getBody = function(name)
		for i,body in ipairs(env.world:getBodyList()) do
			if helper.getProperty(body,"name") == name then return body end
		end
	end
	env.getFixture = function(body,name)
		for i,fixture in ipairs(body:getFixtureList()) do
			if helper.getProperty(fixture,"name") == name then return fixture end
		end
	end
	
	env.copyBody = function(body,x,y)
		local angle = body:getAngle()
		local copied= helper.getWorldData({body},body:getX(),body:getY())
		local group = helper.createWorld(helper.world, copied,x,y)
		return group[1].body
	end
	
	env.todo = function(func,...)
		table.insert(helper.system.todo,{func,...})
	end

	env.delay = function(func,time,...)
		helper.system.addDelay(func,time,...)
	end
	--draw/update/load/startcoll/endcoll/presolve/postsolve

	
	setfenv(func, env)
	func()
	helper.setProperty(body,"scription",env)
	helper.collMode.setCallbacks()
end

return function(parent) helper=parent;helper.script=script end