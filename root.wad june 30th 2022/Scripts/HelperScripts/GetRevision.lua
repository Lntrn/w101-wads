function GetRevision()
    RevisionDat = "./revision.dat"
	revisionFile = io.open(RevisionDat);
	if(revisionFile == nil) then
		Log("Failed to open file:  "..RevisionDat);
		return;
	end
	revisionString = revisionFile:read("*a");
	theDot = string.find(revisionString, "%p.")
	revisionNumber = string.sub(revisionString, 1, theDot -1)
	revisionBranch = string.sub(revisionString, theDot +1)
end
