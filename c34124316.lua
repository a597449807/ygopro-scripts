--サイバーポッド
---@param c Card
function c34124316.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(c34124316.target)
	e1:SetOperation(c34124316.operation)
	c:RegisterEffect(e1)
end
function c34124316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c34124316.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local g1=Duel.GetDecktopGroup(tp,5)
	local g2=Duel.GetDecktopGroup(1-tp,5)
	local hg=Group.CreateGroup()
	local gg=Group.CreateGroup()
	Duel.ConfirmDecktop(tp,5)
	local tc=g1:GetFirst()
	while tc do
		if tc:IsLevelBelow(4) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE) then
			Duel.DisableShuffleCheck()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		elseif tc:IsAbleToHand() then
			hg:AddCard(tc)
		else gg:AddCard(tc) end
		tc=g1:GetNext()
	end
	Duel.ConfirmDecktop(1-tp,5)
	tc=g2:GetFirst()
	while tc do
		if tc:IsLevelBelow(4) and tc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE) then
			Duel.DisableShuffleCheck()
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		elseif tc:IsAbleToHand() then
			hg:AddCard(tc)
		else gg:AddCard(tc) end
		tc=g2:GetNext()
	end
	if hg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
	if gg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
	Duel.SpecialSummonComplete()
end
