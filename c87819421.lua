--マスク・チャージ
---@param c Card
function c87819421.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c87819421.target)
	e1:SetOperation(c87819421.activate)
	c:RegisterEffect(e1)
end
function c87819421.filter1(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c87819421.filter2(c)
	return c:IsSetCard(0xa5) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c87819421.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c87819421.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c87819421.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c87819421.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c87819421.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c87819421.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
