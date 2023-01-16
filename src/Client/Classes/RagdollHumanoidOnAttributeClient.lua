--[=[
	Ragdolls the humanoid on death. Should be bound via [RagdollBindersClient].

	@client
	@class RagdollHumanoidOnAttributeClient
]=]

local require = require(script.Parent.loader).load(script)

local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local BaseObject = require("BaseObject")
local RagdollBindersClient = require("RagdollBindersClient")
local CharacterUtils = require("CharacterUtils")

local RagdollHumanoidOnAttributeClient = setmetatable({}, BaseObject)
RagdollHumanoidOnAttributeClient.ClassName = "RagdollHumanoidOnAttributeClient"
RagdollHumanoidOnAttributeClient.__index = RagdollHumanoidOnAttributeClient

--[=[
	Constructs a new RagdollHumanoidOnAttributeClient. Should be done via [Binder]. See [RagdollBindersClient].
	@param humanoid Humanoid
	@param serviceBag ServiceBag
	@return RagdollHumanoidOnAttributeClient
]=]
function RagdollHumanoidOnAttributeClient.new(humanoid, serviceBag)
	local self = setmetatable(BaseObject.new(humanoid), RagdollHumanoidOnAttributeClient)

	self._ragdollBinder = serviceBag:GetService(RagdollBindersClient).Ragdoll

	if self._obj:GetAttribute("Ragdoll") then
		self:_handleRagdoll()
	else
		self._maid._ragdollEvent = self._obj:GetAttributeChangedSignal("Ragdoll"):Connect(function()
			self:_handleRagdoll()
		end)
		self._maid._diedEvent = self._obj.Died:Connect(function()
			self:_handleDeath()
		end)
	end

	return self
end

function RagdollHumanoidOnAttributeClient:_getPlayer()
	return CharacterUtils.getPlayerFromCharacter(self._obj)
end

function RagdollHumanoidOnAttributeClient:_handleDeath()
	-- Disconnect!
	self._maid._ragdollEvent = nil
	self._maid._diedEvent = nil
end

function RagdollHumanoidOnAttributeClient:_handleRagdoll()
	if self:_getPlayer() == Players.LocalPlayer then
		if self._obj:GetAttribute("Ragdoll") then
			self._ragdollBinder:BindClient(self._obj)
		else
			self._ragdollBinder:UnbindClient(self._obj)
		end
	end
end

return RagdollHumanoidOnAttributeClient