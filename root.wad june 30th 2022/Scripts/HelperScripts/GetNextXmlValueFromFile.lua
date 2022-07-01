--This function returns the value between the opening and closing xml tags passed in by the calling
--function.  You pass it a file so that the file position is always maintained.  That way you can
--search the file over and over for the same tag and get the next one each time, thus iterating
--through the file.  This function assumes you have opened the file in read mode before passing the
--file handle.
function GetNextXmlValueFromFile(xmlFile, tagName)
	--If xmlFile is nil, we can't do anything
	if(xmlFile == nil) then
		return nil;
	end
	
	local tagLine;
	local tagSearchStr = "<"..tagName..">";
	local tagDummyVar;
	local tagStart;
	local tagFinish;
	
	--Find the opening tag
	repeat
	do
		tagLine = xmlFile:read();
		tagDummyVar, tagStart = string.find(tagLine, tagSearchStr);
	end
	until (tagDummyVar ~= nil or tagLine == nil)
	
	--If this was the end of the file, then return nil
	if(tagLine == nil) then
		return nil;
	end
	
	tagFinish = string.find(tagLine, "</"..tagName..">");
	return string.sub(tagLine, tagStart+1, tagFinish-1);
end
