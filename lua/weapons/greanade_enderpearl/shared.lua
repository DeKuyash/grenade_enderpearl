if SERVER then
    AddCSLuaFile('shared.lua');
    resource.AddFile('sound/epearl/teleport.wav')
    resource.AddFile('sound/epearl/throw.wav')


    sound.Add({name = 'teleport', channel = CHAN_AUTO, volume = 1, level = 80, sound = 'epearl/teleport.wav'})
    sound.Add({name = 'throw', channel = CHAN_AUTO, volume = 1, level = 80, sound = 'epearl/throw.wav'})

end

if CLIENT then
    SWEP.PrintName = 'Граната-Эндерперл';
    SWEP.Slot = 2;
    SWEP.SlotPos = 3;
    SWEP.DrawAmmo = false;
    SWEP.DrawCrosshair = false;

end

SWEP.Purpose = 'Граната-Эндерперл'
SWEP.Instructions = 'ЛКМ - Бросить пёрл'
SWEP.Author = 'Kuyash'

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip  = false

SWEP.Category = 'Портфолио'
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.NextStrike  = 0;

SWEP.ViewModel = 'models/items/grenadeammo.mdl'
SWEP.WorldModel = 'models/items/grenadeammo.mdl'


SWEP.Primary.Delay = 0.01
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = 'none'


SWEP.Secondary.Delay = 0.01
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = 'none'




function SWEP:Initialize()
    if CLIENT then
        self:SetWeaponHoldType('grenade') 
    end 

end



function SWEP:PrimaryAttack()
    if CurTime() < self.NextStrike then return end
    self.NextStrike = CurTime() + 1

    if SERVER then
        for _, v in ipairs(ents.FindByModel('models/Gibs/HGIBS.mdl')) do
            v:Remove()
        end


        local ply = self.Owner
        local ePearl = ents.Create('prop_physics')
        if not IsValid(ePearl) then return end
        ePearl:SetModel('models/Gibs/HGIBS.mdl')
        ePearl:SetMaterial('phoenix_storms/metalset_1-2')
        ePearl:Spawn()
        ePearl:EmitSound('throw')
        
        local forward = ply:EyeAngles():Forward() 
        ePearl:SetPos(ply:EyePos() + forward * 50)

        ePearl:GetPhysicsObject():SetVelocity(forward*800)


        ePearl:AddCallback('PhysicsCollide', function(ent, data)
            ePearl:Remove()

            timer.Simple(0, function() -- перенос действия в следующий тик
                self.Owner:SetPos(data.HitPos)

                -- костыль, нет звука fallpain2, не сделать через math.random(1,3)
                if math.random(1, 2) == 1 then
                    self:EmitSound('player/pl_fallpain1.wav', 100, 100, 0.2)
                    self:EmitSound('teleport')
    
                else
                    self:EmitSound('player/pl_fallpain3.wav', 100, 100, 0.2)
                    self:EmitSound('teleport')
                end


                ply:SetHealth(ply:Health() - math.random(5, 15))
                if ply:Health() <= 0 then
                    ply:Kill()
                end
                
            end)
        end)
    end

end