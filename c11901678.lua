--ブラック・デーモンズ・ドラゴン
---@param c Card
function c11901678.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,70781052,74677422,true,true)
end
c11901678.material_setcode=0x3b
