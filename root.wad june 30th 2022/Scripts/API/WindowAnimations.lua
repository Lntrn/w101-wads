

---------------------------------------------------------------------------------------------------------
function WaitForAnimationsToFinish( a_targetWindow )
	while( a_targetWindow.GetAnimationCount() > 0 ) do
		Sleep(0.1);
	end
end


---------------------------------------------------------------------------------------------------------
function CreateWinAnimScaleTime( a_scale, a_time )
	local scaleTime = CreateClass("WinAnimScaleTime");
	scaleTime.SetScale(a_scale);
	scaleTime.SetTime(a_time);
	
	return scaleTime;
end

---------------------------------------------------------------------------------------------------------
function CreateWinAnimMoveToLocationTime( a_posX, a_posY, a_timeToPerform )
	local moveTime = CreateClass("WinAnimMoveToLocationTime");
	moveTime.SetTargetLocation(a_posX, a_posY);
	moveTime.SetTime(a_timeToPerform);
	
	return moveTime;
end

---------------------------------------------------------------------------------------------------------
function CreateWinAnimMoveToLocationTimeEase( a_posX, a_posY, a_timeToPerform, a_easeIn, a_easeOut )
	local moveTime = CreateClass("WinAnimMoveToLocationTimeEase");
	moveTime.SetTargetLocation(a_posX, a_posY);
	moveTime.SetTime(a_timeToPerform);
	moveTime.SetEaseInPercent(a_easeIn);
	moveTime.SetEaseOutPercent(a_easeOut);

	return moveTime;
end

---------------------------------------------------------------------------------------------------------
function CreateWinAnimMoveToLocationTimeEaseApprox( a_posX, a_posY, a_timeToPerform, a_easeAmount, a_accelRateMult )
	local moveTime = CreateClass("WinAnimMoveToLocationTimeEaseApprox");
	moveTime.SetTargetLocation(a_posX, a_posY);
	moveTime.SetTime(a_timeToPerform);
	moveTime.SetEaseAmount(a_easeAmount);
	moveTime.SetAccelRateMult(a_accelRateMult);

	return moveTime;
end

---------------------------------------------------------------------------------------------------------
function CreateWinAnimFillGlobeTime( a_amount, a_timeToPerform, a_endTutorialOnFinish )
	local fillGlobeTime = CreateClass("WinAnimFillGlobeTime");	
	fillGlobeTime.SetAmount(a_amount)
	fillGlobeTime.SetTime(a_timeToPerform);
	fillGlobeTime.SetEndTutorialOnFinish(a_endTutorialOnFinish);
	return fillGlobeTime;
end

---------------------------------------------------------------------------------------------------------
function CreateWinAnimAlphaFade( a_cycleTime, a_cycle )
   local fadeAnim = CreateClass("WinAnimAlphaFade");
   fadeAnim.SetCycleTime(a_cycleTime);
   fadeAnim.SetCycle(a_cycle);
   return fadeAnim;
end
