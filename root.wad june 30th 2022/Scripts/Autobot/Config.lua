---------------------------------------
-- Configure the autobots
---------------------------------------
function main()
   -- Show the current path the Autobot is following
   -- Default value = 0
   ConfigureAutobot( "m_displayPath", "1" );

   -- Seek out and Accept side quests
   -- Default value = 1
   ConfigureAutobot( "m_findSideQuests", "1" );

   -- Do not popup a MessageBox on ERROR level logs (only has an effect when attached to a debugger)
   -- Default value = 0
   ConfigureAutobot( "m_silent", "0" );

   -- Do not switch to another quest unless completing said quest is a goal of the active quest
   -- Default value = 0
   ConfigureAutobot( "m_stayOnActiveQuest", "0" );

   -- Stop when the active quest is complete
   -- Default value = 0
   ConfigureAutobot( "m_stopOnQuestComplete", "0" );
end

