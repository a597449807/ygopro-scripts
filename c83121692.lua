--E・HERO テンペスター
function c83121692.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,21844576,20721928,79979666,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--set target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83121692,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c83121692.cost)
	e1:SetTarget(c83121692.target)
	e1:SetOperation(c83121692.operation)
	c:RegisterEffect(e1)
end
c83121692.material_setcode=0x8
function c83121692.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c83121692.tgfilter(c,ec)
	return c:GetFlagEffect(83121692)==0 and not ec:IsHasCardTarget(c)
end
function c83121692.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c83121692.tgfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c83121692.tgfilter,tp,LOCATION_MZONE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c83121692.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
end
function c83121692.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if c==tc then
		tc:RegisterFlagEffect(83121692,RESET_EVENT+RESETS_STANDARD,0,0)
	else
		c:SetCardTarget(tc)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c83121692.indcon)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function c83121692.indcon(e)
	local c=e:GetHandler()
	local rc=e:GetOwner()
	if c==rc then
		return c:GetFlagEffect(83121692)~=0
	else
		return rc:IsHasCardTarget(c)
	end
end
