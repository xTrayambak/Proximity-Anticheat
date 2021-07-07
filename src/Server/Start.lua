local module = require(script.Parent)
local rs = game:GetService('RunService')

rs.Heartbeat:Connect(module.FrameUpdate)