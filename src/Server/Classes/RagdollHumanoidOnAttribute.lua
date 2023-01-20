--[=[
	Ragdolls the humanoid on death.
	@server
	@class RagdollHumanoidOnAttribute
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")
local RagdollBindersServer = require("RagdollBindersServer")

local RagdollHumanoidOnAttribute = setmetatable({}, BaseObject)
RagdollHumanoidOnAttribute.ClassName = "RagdollHumanoidOnAttribute"
RagdollHumanoidOnAttribute.__index = RagdollHumanoidOnAttribute

--[=[
	Constructs a new RagdollHumanoidOnAttribute. Should be done via [Binder]. See [RagdollBindersServer].
	@param humanoid Humanoid
	@param serviceBag ServiceBag
	@return RagdollHumanoidOnAttribute
]=]
function RagdollHumanoidOnAttribute.new(humanoid, serviceBag)
	local self = setmetatable(BaseObject.new(humanoid), RagdollHumanoidOnAttribute)

	self._ragdollBinder = serviceBag:GetService(RagdollBindersServer).Ragdoll

	self._maid:GiveTask(self._obj:GetAttributeChangedSignal("Ragdoll"):Connect(function()
		if self._obj:GetAttribute("Ragdoll") then
			self._ragdollBinder:Bind(self._obj)
		else
			self._ragdollBinder:Unbind(self._obj)
		end
	end))

	return self
end

return RagdollHumanoidOnAttribute