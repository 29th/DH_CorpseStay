/*
CORPSE STAY MUT
Method copied from [-will-] (will@spambox.co.uk)
Trimmed down and ported to Darkest Hour by Wilson [29th ID] (29th.org)

USAGE
Just enable it on the server and it will make all corpses stay for the duration of the round
*/

class CorpseStayMut extends Mutator;

Simulated Function AdjustBodys(Float Scale)
{
	Local DH_Pawn P;
	local KarmaParamsSkel skelParams;

	ForEach DynamicActors(Class'DH_Pawn', P)
		{
		If (P != None)
			{
			P.SetTimer(0, False);
			If (P.IsInState('Dying'))
				{
				If (P.bDeRes)
					{
					P.SetCollision(False, False, False);
					P.bCollideWorld = False;
					}
				Else
					{
					P.SetCollision(True, False, False);
					P.bCollideWorld = True;
					}

				If ((P.AirControl < P.Default.AirControl + 0.001) && (P.LifeSpan <= 10))
					{
					P.AirControl += 0.001;
					P.bInvulnerableBody = true;
					P.MaxFallSpeed = 0;
					P.LifeSpan = P.Default.RagDollLifeSpan * Scale;
					P.RagDollLifeSpan = P.Default.RagDollLifeSpan * Scale;
					P.MaxFallSpeed = P.LifeSpan;
					}

				If (P.LifeSpan < P.MaxFallSpeed - 2) // Unless you got real crappy framerates this should work...
					P.LifeSpan = P.MaxFallSpeed; //use maxfallspeed cos its not used for this pawn anymore -- it's DEAD
				Else
					P.MaxFallSpeed = P.LifeSpan;

				If ((P.LifeSpan <= 1) && (P.AirControl == P.Default.AirControl + 0.001)) //Check the lifespan is under 1, and it's been increased already
					{
					P.AirControl += 0.001;
					skelParams = KarmaParamsSkel(P.KParams);
					skelParams.bKImportantRagdoll = False;
					P.LifeSpan = 0.001;

					//P.DeResLiftVel.Points[2].InVal = 100 * DeResScale;

					P.StartDeRes();
					}
				If ((P.LifeSpan <= 0.5) && (P.AirControl == P.Default.AirControl + 0.001) )//&& (!DeRes) && (DeathEffects))
					{
					P.AirControl += 0.001;
					P.LifeSpan = 0.3;
					P.FellOutOfWorld(KILLZ_Lava);
					}
				}
			}
		}
}

Simulated Function Tick(Float TimeDelta)
{
	AdjustBodys(0.001);
}

defaultproperties
{
	GroupName="CorpseStay"
	FriendlyName="Corpse Stay"
	Description="Prevents corpses from disappearing"
}