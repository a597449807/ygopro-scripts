--連鎖誘爆
---@param c Card
function c85893201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85893201,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c85893201.descon)
	e2:SetTarget(c85893201.destg)
	e2:SetOperation(c85893201.desop)
	c:RegisterEffect(e2)
end
function c85893201.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)
end
function c85893201.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c85893201.cfilter,1,nil,1-tp)
end
function c85893201.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local exg=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then exg=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c85893201.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
