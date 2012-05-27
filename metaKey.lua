debug_print = true

Key = {}

function Key:new(keyType, keyCode)
        obj = {}
        setmetatable(obj, self)
        self.__index = self
        obj.keyType = keyType
        obj.pressEvent = keyType .. "_PRESSED"
        obj.releaseEvent = keyType .. "_RELEASED"
        obj.keyCode = keyCode
        obj.isPressed = false
        return obj
end

function Key:handleEvent(event, arg)
        if arg == self.keyCode then
                if event == self.pressEvent then
                        d("handling press for %s%s\n", self.keyType, self.keyCode)
                        self.isPressed = true
                        self:onPress()
                end
                if event == self.releaseEvent then
                        self.isPressed = false
                        self:onRelease()
                end
        end
end

function d(...)
        if debug_print then
                OutputLogMessage(...)
        end
end

meta2 = Key:new("G", 22)
function meta2:onPress()
        if GetMKeyState("lhc") == 1 then
                SetMKeyState(2, "lhc")
        end
end
function meta2:onRelease()
        if GetMKeyState("lhc") == 2 then
                SetMKeyState(1, "lhc")
        end
end

keys = {meta2}

function OnEvent(event, arg)
        d("event = %s, arg = %s\n", event, arg)
        for i, v in ipairs(keys) do
                v:handleEvent(event, arg)
        end
end
