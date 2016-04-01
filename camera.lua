cam:setPosition(0,0)

function cam:update()
	self:shakeProcess()
	--self:edgeMove()
	self :holdMove()
	mouseX,mouseY = cam.x+ (love.mouse.getX()-w()/2)/cam.scale,cam.y+(love.mouse.getY()-h()/2)/cam.scale
end

function cam:shakeProcess()
	if self.shakeState==true then 
        local maxShake = 5
        local atenuationSpeed = 4
        self.shakeIntensity = math.max(0 , self.shakeIntensity - atenuationSpeed * 0.02)        
        if self.shakeIntensity > 0 then
            local x,y = self:getPosition()
            local dx,dy=(100 - 200*love.math.random()) * 0.02*self.shakeIntensity,
            (100 - 200*love.math.random()) * 0.02*self.shakeIntensity
            x = x + dx
            y = y + dy       
            self:setPosition(x,y)
        else
            self.shakeState=false
        end
    end

end


function cam:shake(int)
	self.shakeState=true
    self.shakeIntensity=int or 5
end

function cam:edgeMove()
	local x, y = love.mouse.getPosition()
	if x<=0 then self:move(-self.camMoveSpeed,0); self.camMoveSpeed=self.camMoveSpeed+0.5
	elseif x>=w()-1 then self:move(self.camMoveSpeed,0); self.camMoveSpeed=self.camMoveSpeed+0.5
	elseif y<=0 then self:move(0,-self.camMoveSpeed); self.camMoveSpeed=self.camMoveSpeed+0.5
	elseif y>=h()-1 then self:move(0,self.camMoveSpeed) ; self.camMoveSpeed=self.camMoveSpeed+0.5
	else self.camMoveSpeed=3
	end
end

function cam:holdMove()
	if love.mouse.isDown(1) and love.keyboard.isDown("space") then
		if self.holdOX then
			self:move((self.holdOX-love.mouse.getX())/self.scale,(self.holdOY-love.mouse.getY())/self.scale)
			self.holdOX,self.holdOY= love.mouse.getPosition()
		else
			self.holdOX,self.holdOY= love.mouse.getPosition()
		end
	else
		self.holdOX=nil
	end
end

function cam:scrollScale(y)
	
	if y>0 then
		self:setScale(self:getScale()*1.05)
	else
		self:setScale(self:getScale()*0.95)
	end
end

return cam