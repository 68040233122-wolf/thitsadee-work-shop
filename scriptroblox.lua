local ServerStorage = game:GetService("ServerStorage")
local taw = script.Parent -- สมมติว่าเป็นส่วนของเตา

local meal1Name = "meal1" -- ชื่อ Tool ที่ผู้เล่นถือมา
local vegetable1Name = "vegetable1" -- ชื่อ Tool ที่จะได้รับหลังทำเสร็จ

local prompt = Instance.new("ProximityPrompt")
prompt.Parent = taw
prompt.ActionText = "วาง"
prompt.ObjectText = "หม้อ"
prompt.HoldDuration = 2

local nofood = nil -- ตัวแปรเก็บ Object ที่วางบนเตา

prompt.Triggered:Connect(function(player)
	local character = player.Character
	if not character then return end

	-- ช่วงที่ 1: ถ้ามีอาหารสุกอยู่บนเตา (หยิบอาหาร)
	if nofood ~= nil and prompt.ActionText == "หยิบ" then
		local cookedTool = ServerStorage:FindFirstChild(vegetable1Name)
		if cookedTool then
			local toolClone = cookedTool:Clone()
			toolClone.Parent = player.Backpack
			
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then 
				humanoid:EquipTool(toolClone) 
			end
			
			nofood:Destroy()
			nofood = nil
			prompt.ActionText = "วาง"
		end
		return
	end
	
	-- ช่วงที่ 2: ถ้าไม่มีอะไรบนเตา (วางอาหารเพื่อปรุง)
	local toolInHand = character:FindFirstChild(meal1Name)
	if toolInHand then
		local handle = toolInHand:FindFirstChild("Handle")
		
		if handle then
			-- วางของดิบลงบนเตา
			local onstove = handle:Clone()
			onstove.Parent = workspace
			onstove.CFrame = taw.CFrame * CFrame.new(0, 0.5, 0)
			onstove.Anchored = true
			onstove.CanCollide = false
			
			toolInHand:Destroy() -- ลบ Tool ในมือออก
			nofood = onstove
			
			prompt.Enabled = false -- ปิด Prompt ระหว่างรอสุก
			task.wait(5) -- รอ 5 วินาที

			-- ปรับปรุง: เปลี่ยนจากของดิบเป็นของสุก
			if nofood then 
				nofood:Destroy() 
			end
			
			-- แสดง Model ของสุกบนเตา (สมมติว่าใช้ Handle ของของสุกมาโชว์)
			local cookedTemplate = ServerStorage:FindFirstChild(vegetable1Name)
			if cookedTemplate and cookedTemplate:FindFirstChild("Handle") then
				local cookedPart = cookedTemplate.Handle:Clone()
				cookedPart.Parent = workspace
				cookedPart.CFrame = taw.CFrame * CFrame.new(0, 0.5, 0)
				cookedPart.Anchored = true
				cookedPart.CanCollide = false
				
				nofood = cookedPart
			end
			
			prompt.Enabled = true
			prompt.ActionText = "หยิบ"
		end
	end
end)