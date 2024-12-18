--超戦士の萌芽
---@param c Card
function c45948430.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45948430+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c45948430.target)
	e1:SetOperation(c45948430.activate)
	c:RegisterEffect(e1)
end
function c45948430.filter(c,e,tp)
	if not c:IsSetCard(0x10cf) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	return Duel.IsExistingMatchingCard(c45948430.matfilter1,tp,LOCATION_HAND,0,1,c,tp,c)
end
function c45948430.matfilter1(c,tp,rc)
	return c:IsLevelBelow(7) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGrave() and c:IsCanBeRitualMaterial(rc)
		and Duel.IsExistingMatchingCard(c45948430.matfilter2,tp,LOCATION_DECK,0,1,c,c:GetLevel(),c:GetAttribute(),rc)
end
function c45948430.matfilter2(c,lv,att,rc)
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and att==ATTRIBUTE_DARK) or (c:IsAttribute(ATTRIBUTE_DARK) and att==ATTRIBUTE_LIGHT))
		and c:IsLevel(8-lv) and c:IsAbleToGrave() and c:IsCanBeRitualMaterial(rc)
end
function c45948430.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c45948430.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c45948430.check(g)
	return aux.dabcheck(g) and g:GetClassCount(Card.GetLocation)==#g and g:GetSum(Card.GetLevel)==8
end
function c45948430.mfilter(c,rc)
	return c:IsLevelBelow(7) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGrave() and c:IsCanBeRitualMaterial(rc)
end
function c45948430.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	::cancel::
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45948430.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local rc=rg:GetFirst()
	if rc then
		local mg=Duel.GetMatchingGroup(c45948430.mfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,rc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectSubGroup(tp,c45948430.check,true,2,2)
		if not mat then goto cancel end
		rc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		rc:CompleteProcedure()
	end
end
