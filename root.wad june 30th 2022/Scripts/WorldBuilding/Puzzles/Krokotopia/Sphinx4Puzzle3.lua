----------------------------------------------------------------------------------
--                            Sphinx4Puzzle3.lua                                --
-- This file contains elements to execute the Brazier Puzzle in Sphinx Level 4  --
----------------------------------------------------------------------------------

function SphinxPuz3( args )

----NOTE: THIS CODE WAS A TEST AND MORE THAN LIKELY WON'T WORK HOW YOU WANT OR THINK IT WILL WORK OR WHATEVER

    Log("Calling SphinxPuz3 ");

    local zoneID = args.ZoneID;

    local currentBrazierState = IsIntState(zoneID, "FireBrazier", "Fire");

    if currentBrazierState == "Fire"

    then ModifyTriggerObj(zoneID, "FireBrazier", "Ice");

end
