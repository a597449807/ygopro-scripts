--夜霧のスナイパー
---@param c Card
function c8323633.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c8323633.operation)
	c:RegisterEffect(e1)
end
function c8323633.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER,OPCODE_ISTYPE)
	c:SetHint(CHINT_CARD,ac)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8323633,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c8323633.rmcon)
	e1:SetTarget(c8323633.rmtg)
	e1:SetOperation(c8323633.rmop)
	e1:SetLabel(ac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
end
function c8323633.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c8323633.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c8323633.filter,1,nil,e:GetLabel()) and rp==1-tp
end
function c8323633.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c8323633.filter,nil,e:GetLabel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c8323633.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c8323633.filter,nil,e:GetLabel()):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
