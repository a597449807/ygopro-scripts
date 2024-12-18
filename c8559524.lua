--コマンド・リゾネーター
---@param c Card
function c8559524.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,8559524+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8559524.cost)
	e1:SetTarget(c8559524.target)
	e1:SetOperation(c8559524.activate)
	c:RegisterEffect(e1)
end
function c8559524.costfilter(c)
	return c:IsSetCard(0x57) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c8559524.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8559524.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c8559524.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c8559524.filter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function c8559524.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8559524.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8559524.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8559524.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
