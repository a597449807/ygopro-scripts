--マドルチェ・バトラスク
---@param c Card
function c48252330.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(48252330,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c48252330.retcon)
	e1:SetTarget(c48252330.rettg)
	e1:SetOperation(c48252330.retop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48252330,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c48252330.shcon)
	e2:SetTarget(c48252330.shtg)
	e2:SetOperation(c48252330.shop)
	c:RegisterEffect(e2)
end
function c48252330.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():IsPreviousControler(tp)
end
function c48252330.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c48252330.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c48252330.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x71)
end
function c48252330.shcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c48252330.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c48252330.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c48252330.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48252330.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c48252330.shop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c48252330.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c48252330.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
