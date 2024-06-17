



if SERVER then
    AddCSLuaFile('shared.lua');
end

if CLIENT then
    SWEP.PrintName = 'Граната-Эндерперл';
    SWEP.Slot = 2;
    SWEP.SlotPos = 3;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;
end

SWEP.Purpose = 'Граната-Эндерперл'
SWEP.Instructions = 'ЛКМ - Кинуть перл\nПКМ - Телепортироваться'
SWEP.Author = 'Kuyash'

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip  = false

SWEP.Category = 'Портфолио'
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.NextStrike  = 0;

SWEP.ViewModel = 'models/items/grenadeammo.mdl'
SWEP.WorldModel = 'models/items/grenadeammo.mdl'


-----Огонь по ЛКМ-----

SWEP.Primary.Delay = 0.01
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = 'none'



-----Огонь по ПКМ-----

SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = 'none'



-----Функции-----

function SWEP:Initialize()

    if CLIENT then
        self:SetWeaponHoldType('grenade') end end

function SWEP:Precache() end

function SWEP:Deploy() end


function SWEP:PrimaryAttack()

    if ( CurTime() < self.NextStrike) then return; end

    self.NextStrike = (CurTime() + 1); --- КД 1 секунда между атакой


    if IsValid(ents.FindByModel('models/Gibs/HGIBS.mdl')[1]) then --- Удаляет все предыдущие перлы, чтобы не было багов
        ents.FindByModel('models/Gibs/HGIBS.mdl')[1]:Remove()
    end


    local ply = self.Owner
    pearl = ents.Create('prop_physics')

    pearl:SetModel('models/Gibs/HGIBS.mdl')
    pearl:PhysicsInit(SOLID_VPHYSICS)
    pearl:SetMoveType(MOVETYPE_VPHYSICS)
    pearl:SetSolid(SOLID_VPHYSICS)
    
    local eyeang = ply:EyeAngles()
    local forward = eyeang:Forward()
    local right = eyeang:Right()
    local up = eyeang:Up()

    local pos = ply:GetShootPos() + forward * 10 + right * 8 + up * -5 --- Настройка положения спавна
    local ang = ply:EyeAngles()

    pearl:SetPos(pos)
    pearl:SetAngles(ang)
    pearl:Spawn()

    local phys = pearl:GetPhysicsObject()
    
    if not IsValid(phys) then pearl:Remove() return end

    phys:SetMass(10)

    local velocity = forward * 10000 --- Настройка силы броска
    phys:ApplyForceCenter(velocity)

end



function SWEP:SecondaryAttack()

    if not IsValid(pearl) then return end

    local pearl_pos = pearl:GetPos()
    local ply = self.Owner

    ply:SetPos(pearl_pos)
    pearl:Remove()

end

function SWEP:Reload()
end