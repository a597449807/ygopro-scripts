--マシンナーズ・フォートレス
---@param c Card
function c5556499.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c5556499.spcon)
	e1:SetTarget(c5556499.sptg)
	e1:SetOperation(c5556499.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5556499,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c5556499.condition)
	e2:SetTarget(c5556499.target)
	e2:SetOperation(c5556499.operation)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(c5556499.hdop)
	c:RegisterEffect(e4)
end
function c5556499.spfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c5556499.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c5556499.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	return g:CheckWithSumGreater(Card.GetLevel,8)
end
function c5556499.fselect(g)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,8)
end
function c5556499.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c5556499.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:SelectSubGroup(tp,c5556499.fselect,true,1,g:GetCount())
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c5556499.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.SendtoGrave(sg,REASON_SPSUMMON+REASON_DISCARD)
	sg:DeleteGroup()
end
function c5556499.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c5556499.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c5556499.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c5556499.hdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)==0 then return end
	if ep==tp then return end
	if not re:IsActiveType(TYPE_EFFECT) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if hg:GetCount()==0 then return end
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=hg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	end
end
