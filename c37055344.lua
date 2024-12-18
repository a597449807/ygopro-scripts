--ゴーストリック・ロールシフト
---@param c Card
function c37055344.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37055344,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c37055344.condition)
	e2:SetTarget(c37055344.target)
	e2:SetOperation(c37055344.operation)
	c:RegisterEffect(e2)
end
function c37055344.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c37055344.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x8d) and c:IsCanTurnSet()
end
function c37055344.filter2(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c37055344.filter3(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c37055344.filter4(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c37055344.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c37055344.filter1(chkc)
		else return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c37055344.filter3(chkc) end
	end
	local b1=Duel.IsExistingTarget(c37055344.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c37055344.filter2,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c37055344.filter3,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(37055344,1),aux.Stringid(37055344,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(37055344,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(37055344,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c37055344.filter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
		local g=Duel.SelectTarget(tp,c37055344.filter3,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	end
end
function c37055344.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
		local g=Duel.SelectMatchingCard(tp,c37055344.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		end
	else
		if not tc:IsRelateToEffect(e) or tc:IsPosition(POS_FACEUP_ATTACK) then return end
		if Duel.ChangePosition(tc,POS_FACEUP_ATTACK)==0 or not tc:IsSetCard(0x8d) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c37055344.filter4,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
