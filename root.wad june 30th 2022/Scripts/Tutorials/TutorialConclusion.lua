-- TutorialConclusion.lua

Include("Tutorials/API/TutorialCommon.lua");

---------------------------------------------------------------------------------------------------------
function TutorialConclusion()
   -- Reconfigure the tutorial dialog        
   gTutorialDialog:SetTitle("Tutorial_Title1"); -- "Headmaster Ambrose"
	gTutorialDialog:SetProfessorImage("GUI/NpcPortraits/Art_Portrait_Ambrose.dds"); 		   
	gTutorialDialog:MoveToBottom();
   gTutorialDialog:Display("Tutorial_Tutorial_Conclusion1", true); -- 'That's it!...'
   gTutorialDialog:Display("Tutorial_Tutorial_Conclusion2", true); -- 'I see great potential...'
end


