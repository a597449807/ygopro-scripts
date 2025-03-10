--結束 UNITY
function c14731897.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c14731897.target)
	e1:SetOperation(c14731897.activate)
	c:RegisterEffect(e1)
end
function c14731897.sumfilter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c14731897.filter(c,def)
	return c:IsFaceup() and c:IsDefenseAbove(0) and not c:IsDefense(def)
end
function c14731897.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c14731897.sumfilter,tp,LOCATION_MZONE,0,nil)
	local sum=g:GetSum(Card.GetBaseDefense)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14731897.filter(chkc,sum) end
	if chk==0 then return Duel.IsExistingTarget(c14731897.filter,tp,LOCATION_MZONE,0,1,nil,sum) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c14731897.filter,tp,LOCATION_MZONE,0,1,1,nil,sum)
end
function c14731897.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local def=0
		local sc=g:GetFirst()
		while sc do
			local cdef=sc:GetBaseDefense()
			if cdef<0 then cdef=0 end
			def=def+cdef
			sc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
