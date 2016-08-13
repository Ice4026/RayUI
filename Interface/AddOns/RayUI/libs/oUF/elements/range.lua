--[[ Element: Range Fader

 Widget

 Range - A table containing opacity values.

 Options

 .outsideAlpha - Opacity when the unit is out of range. Values 0 (fully
                 transparent) - 1 (fully opaque).
 .insideAlpha  - Opacity when the unit is within range. Values 0 (fully
                 transparent) - 1 (fully opaque).

 Examples

<<<<<<< HEAD
local _,class = UnitClass("player")
do
	if class == "PRIEST" then
		AddSpell(enemySpells, 585) -- Smite (40 yards)
		AddSpell(enemySpells, 589) -- Shadow Word: Pain (40 yards)
		AddSpell(friendlySpells, 2061) -- Flash Heal (40 yards)
		AddSpell(friendlySpells, 17) -- Power Word: Shield (40 yards)
		AddSpell(resSpells, 2006) -- Resurrection (40 yards)
	elseif class == "DRUID" then
		AddSpell(enemySpells, 339) -- Entangling Roots (35 yards)
		AddSpell(longEnemySpells, 8921) -- Moonfire (40 yards)
		AddSpell(friendlySpells, 2782) -- Remove Corruption (Balance/Feral/Guardian) (40 yards)
		AddSpell(friendlySpells, 88423) -- Nature's Cure (Resto) (40 yards)
		AddSpell(resSpells, 50769) -- Revive (40 yards)
		AddSpell(resSpells, 20484) -- Rebirth (40 yards)
	elseif class == "PALADIN" then
		AddSpell(enemySpells, 20271) -- Judgement (30 yards)
		AddSpell(longEnemySpells, 20473) -- Holy Shock (40 yards)
		AddSpell(friendlySpells, 19750) -- Flash of Light (40 yards)
		AddSpell(resSpells, 7328) -- Redemption (40 yards)
	elseif class == "SHAMAN" then
		AddSpell(enemySpells, 188196) -- Lightning Bolt (Elemental) (40 yards)
		AddSpell(enemySpells, 187837) -- Lightning Bolt (Enhancement) (40 yards)
		AddSpell(enemySpells, 403) -- Lightning Bolt (Resto) (40 yards)
		AddSpell(friendlySpells, 8004) -- Healing Surge (Resto/Elemental) (40 yards)
		AddSpell(friendlySpells, 188070) -- Healing Surge (Enhancement) (40 yards)
		AddSpell(resSpells, 2008) -- Ancestral Spirit (40 yards) 
	elseif class == "WARLOCK" then
		AddSpell(enemySpells, 5782) -- Fear (30 yards)
		AddSpell(longEnemySpells, 689) -- Drain Life (40 yards)
		AddSpell(petSpells, 755) -- Health Funnel (45 yards)
		AddSpell(friendlySpells, 20707) -- Soulstone (40 yards)
	elseif class == "MAGE" then
		AddSpell(enemySpells, 118) -- Polymorph (30 yards)
		AddSpell(longEnemySpells, 116) -- Frostbolt (Frost) (40 yards)
		AddSpell(longEnemySpells, 44425) -- Arcane Barrage (Arcane) (40 yards)
		AddSpell(longEnemySpells, 133) -- Fireball (Fire) (40 yards)
		AddSpell(friendlySpells, 130) -- Slow Fall (40 yards)
	elseif class == "HUNTER" then
		AddSpell(petSpells, 982) -- Mend Pet (45 yards)
		AddSpell(enemySpells, 75) -- Auto Shot (40 yards)
	elseif class == "DEATHKNIGHT" then
		AddSpell(enemySpells, 49576) -- Death Grip
		AddSpell(longEnemySpells, 47541) -- Death Coil (Unholy) (40 yards)
		AddSpell(resSpells, 61999) -- Raise Ally (40 yards)
	elseif class == "ROGUE" then
		AddSpell(enemySpells, 185565) -- Poisoned Knife (Assassination) (30 yards)
		AddSpell(enemySpells, 185763) -- Pistol Shot (Outlaw) (20 yards)
		AddSpell(enemySpells, 114014) -- Shuriken Toss (Sublety) (30 yards)
		AddSpell(enemySpells, 1725) -- Distract (30 yards)
		AddSpell(friendlySpells, 57934) -- Tricks of the Trade (100 yards)
	elseif class == "WARRIOR" then
		AddSpell(enemySpells, 5246) -- Intimidating Shout (Arms/Fury) (8 yards)
		AddSpell(enemySpells, 100) -- Charge (Arms/Fury) (8-25 yards)
		AddSpell(longEnemySpells, 355) -- Taunt (30 yards)
	elseif class == "MONK" then
		AddSpell(enemySpells, 115546) -- Provoke (30 yards)
		AddSpell(longEnemySpells, 117952) -- Crackling Jade Lightning (40 yards)
		AddSpell(friendlySpells, 116694) -- Effuse (40 yards)
		AddSpell(resSpells, 115178) -- Resuscitate (40 yards)
	elseif class == "DEMONHUNTER" then
		AddSpell(enemySpells, 183752) -- Consume Magic (20 yards)
		AddSpell(longEnemySpells, 185123) -- Throw Glaive (Havoc) (30 yards)
		AddSpell(longEnemySpells, 204021) -- Fiery Brand (Vengeance) (30 yards)
	end
end
=======
   -- Register with oUF
   self.Range = {
      insideAlpha = 1,
      outsideAlpha = 1/2,
   }
>>>>>>> myrayui

 Hooks

]]

local parent, ns = ...
local oUF = ns.oUF

local _FRAMES = {}
local OnRangeFrame

local UnitInRange, UnitIsConnected = UnitInRange, UnitIsConnected

-- updating of range.
local timer = 0
local OnRangeUpdate = function(self, elapsed)
	timer = timer + elapsed

	if(timer >= .20) then
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				local range = object.Range
				if(UnitIsConnected(object.unit)) then
					local inRange, checkedRange = UnitInRange(object.unit)
					if(checkedRange and not inRange) then
						if(range.Override) then
							--[[ .Override(self, status)

							 A function used to override the calls to :SetAlpha().

							 Arguments

							 self   - The unit object.
							 status - The range status of the unit. Either `inside` or
							          `outside`.
							]]
							range.Override(object, 'outside')
						else
							object:SetAlpha(range.outsideAlpha)
						end
					else
						if(range.Override) then
							range.Override(object, 'inside')
						elseif(object:GetAlpha() ~= range.insideAlpha) then
							object:SetAlpha(range.insideAlpha)
						end
					end
				else
					if(range.Override) then
						range.Override(object, 'offline')
					elseif(object:GetAlpha() ~= range.insideAlpha) then
						object:SetAlpha(range.insideAlpha)
					end
				end
			end
		end

		timer = 0
	end
end

local Enable = function(self)
	local range = self.Range
	if(range and range.insideAlpha and range.outsideAlpha) then
		table.insert(_FRAMES, self)

		if(not OnRangeFrame) then
			OnRangeFrame = CreateFrame"Frame"
			OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)
		end

		OnRangeFrame:Show()

		return true
	end
end

local Disable = function(self)
	local range = self.Range
	if(range) then
		for k, frame in next, _FRAMES do
			if(frame == self) then
				table.remove(_FRAMES, k)
				break
			end
		end
		self:SetAlpha(1)

		if(#_FRAMES == 0) then
			OnRangeFrame:Hide()
		end
	end
end

oUF:AddElement('Range', nil, Enable, Disable)
