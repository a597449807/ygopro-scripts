--No.95 ギャラクシーアイズ・ダークマター・ドラゴン
---@param c Card
function c58820923.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,c58820923.ovfilter,aux.Stringid(58820923,0))
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58820923,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c58820923.rmcon)
	e2:SetCost(c58820923.rmcost)
	e2:SetTarget(c58820923.rmtg)
	e2:SetOperation(c58820923.rmop)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58820923,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c58820923.atkcon)
	e3:SetCost(c58820923.atkcost)
	e3:SetTarget(c58820923.atktg)
	e3:SetOperation(c58820923.atkop)
	c:RegisterEffect(e3)
end
aux.xyz_number[58820923]=95
function c58820923.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ)
end
function c58820923.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c58820923.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function c58820923.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c58820923.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c58820923.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2
		and Duel.IsPlayerCanRemove(1-tp) end
end
function c58820923.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c58820923.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(c58820923.rmfilter,1-tp,LOCATION_DECK,0,nil)
	if g:GetCount()>2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,3,3,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c58820923.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c58820923.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c58820923.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0
		and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK_MONSTER)==0 end
end
function c58820923.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
