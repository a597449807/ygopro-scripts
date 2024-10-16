--U.A.ペナルティ
---@param c Card
function c70043345.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c70043345.target)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,70043345)
	e2:SetCondition(c70043345.rmcon)
	e2:SetTarget(c70043345.rmtg)
	e2:SetOperation(c70043345.rmop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c70043345.thtg)
	e3:SetOperation(c70043345.thop)
	c:RegisterEffect(e3)
end
function c70043345.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetCurrentPhase()~=PHASE_DAMAGE
	local b2=Duel.CheckEvent(EVENT_BATTLE_START) and c70043345.rmcon(e,tp,eg,ep,ev,re,r,rp) and c70043345.rmtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	if b2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetOperation(c70043345.rmop)
		c70043345.rmtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c70043345.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:IsSetCard(0xb2) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c70043345.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc:IsAbleToRemove() and Duel.GetFlagEffect(tp,70043345)==0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
	Duel.RegisterFlagEffect(tp,70043345,RESET_PHASE+PHASE_END,0,1)
end
function c70043345.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) and Duel.Remove(bc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		bc:SetTurnCounter(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(70043345,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		e1:SetLabelObject(bc)
		e1:SetCountLimit(1)
		e1:SetCondition(c70043345.retcon)
		e1:SetOperation(c70043345.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c70043345.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c70043345.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct==2 then
		Duel.ReturnToField(tc)
	end
end
function c70043345.thfilter(c)
	return c:IsSetCard(0xb2) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c70043345.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70043345.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c70043345.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c70043345.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
