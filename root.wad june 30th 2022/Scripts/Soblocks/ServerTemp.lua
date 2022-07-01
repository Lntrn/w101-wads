function GIVEBUCKS_MSG(event)
   local playerbucks = CharRegistryGet(event.CharacterId, "SociaBucks");
   playerbucks = playerbucks + event.Bucks;
   CharRegistrySet(event.CharacterId, "SociaBucks", playerbucks);
end

LF_HighScoreTable = {	{score=10000,name="Mike"},	--1
								{score=9000,name="Fred"},   	--2
								{score=8000,name="Bob"},		--3
								{score=7000,name="Pete"},		--4
								{score=6000,name="Rick"},		--5
								{score=5000,name="Mary"},		--6
								{score=4000,name="Jim"},		--7
								{score=3000,name="Sue"},		--8
								{score=2000,name="Jen"},		--9
								{score=1000,name="Rick"} };	--10

LF_HighScoreFileName = "SoblocksHighScores.txt";
--[[ HELPER: Load the HighScores table. Places table in LF_HighScoreTable. If no table exists a default one is saved ]]
function LF_LoadHighScoreList()

	--For now we will use lua file IO to persist the table. In future this will be integrated with the persistent database
	local hs 			= 1;
	local scoreLine 	= true;
	local newHSTable 	= {}
	local hsFile 		= io.open(LF_HighScoreFileName, "r");
	if( hsFile ) then
		for line in hsFile:lines() do
			--Log("Read HS:"..line);
			if( scoreLine ) then
				newHSTable[hs] = {}			
				newHSTable[hs].score = tonumber(line);
				scoreLine = false;
			else
				newHSTable[hs].name = line;
				scoreLine = true;
				hs = hs + 1;
			end
		end
		hsFile:close()
	end	
	
	if( hs < 10 ) then
		LF_SaveHighScoreList();
	else
		LF_HighScoreTable = newHSTable;		
	end
end

--[[ HELPER: Save the HighScores table. Pulls from table in LF_HighScoreTable ]]
function LF_SaveHighScoreList()
	--For now we will use lua file IO to persist the table. In future this will be integrated with the persistent database
	local hsFile = io.open(LF_HighScoreFileName, "w+");
	
	for k,v in pairs(LF_HighScoreTable) do
		hsFile:write(v.score.."\n");
		hsFile:write(v.name.."\n");
	end
	hsFile:flush();
	hsFile:close();	
end

--[[ Client requests High Score list ]]
function LF_GetHighScoreList( event )
   getHighScores(event.CharacterId);
end

function getHighScores(characterGID)
	local hsString = "";
	local namestring = "";
   hsString = "<color;FFFFFFFF>";
	
	--Get latest high scores
	LF_LoadHighScoreList();
		
	for i=1,10 do
	   local paddedScore = string.format("%08d", LF_HighScoreTable[i].score);
	   hsString = hsString..paddedScore.."\n";
		namestring = namestring..LF_HighScoreTable[i].name.."\n";
	end
	getScores = {};
   getScores.Scores = hsString;
   getScores.Names = namestring;
   
	hsString = hsString.."</color>";
	ClientManager:SendMessage(characterGID, Messages.GetScores, getScores);
end

--[[ Client sends us a new High Score ]]
function LF_AddHighScore( event )
	--Log("LF_AddHighScore called B="..event.Score);

	local beatAScore 	= false;
	local newScoreBoard	= {};
	local newScore 		= event.Score;	
		
	--Get latest high scores
	LF_LoadHighScoreList();
		
	for i=1,10 do
	
	    if( newScore > LF_HighScoreTable[i].score) then
	    
	        --its better than something we have.. shift remaing scores down and send player an updated high score sheet
	        local charID;
	        local newName = GetLocalCharacterName(event.CharacterId);
	        for k = 9, i, -1 do
	            LF_HighScoreTable[k+1].score 	= LF_HighScoreTable[k].score;
	            LF_HighScoreTable[k+1].name     = LF_HighScoreTable[k].name;
	        end
	        
	        LF_HighScoreTable[i].score	= newScore;
	        LF_HighScoreTable[i].name   = newName;
	        
	        break;
	    end
	end
	
	--Save new high scores
	LF_SaveHighScoreList();
end
