--This function will return the value in the first tags that match the tag name within the search
--constraints specified by the calling function.
--
--@param[in]	xmlFileName		Name of the xml file to be searched
--@param[in]	tagName		Name of the tag to be searched for (not including the braces)
--@param[in]	startIndex		Position in the file to begin searching for the tag name.
--						1 represents the beginning of the file.  -1 the end.  Defaults to 1.
--@param[in]	endIndex		Position in the file to stop searching.  Defaults to -1.
--@param[in]	tagSubItem		This is a subitem in the opening tag apart from the tag name
--						itself.  For example, <Class Name="class ReqMagicLevel"> has a tag name of
--						"Class" and a subitem of 'Name="class ReqMagicLevel"'
--
--@return[1]	A string containing all of the text between the opening and closing tags specified
--			by the tag name.  Or nil, if the file refered to by xmlFileName cannot be opened in
--			read mode, or if the starting tag cannot be found.
--@return[2]	The position immediately after the found tags, thus enabling you to call this
--			function repeatedly by passing in the returned index to get the next tag value with
--			each iteration.
--@return[3]	The position immediately before the found tags, in case you want to use this and
--			the ending index to further pair a search down within a specific block of the file.
function GetXmlValueFromFile(xmlFileName, tagName, startIndex, endIndex, tagSubItem)
	--Open the file.
	local xmlFile = io.open(xmlFileName);
	
	--If xmlFile is nil, we can't open the file, so we can't do anything
	if(xmlFile == nil) then
		return nil;
	end
	
	--If the startIndex is not included, then default it to start at the beginning of the file
	if(startIndex == nil) then
		startIndex = 1;
	end
	
	--If the end index is not included, then default it to the end of the file
	if(endIndex == nil) then
		endIndex = -1;
	end
	
	--Get all of the text in the file up to the ending point specified by the calling function
	local xml = string.sub(xmlFile:read("*a"), 1, endIndex);
	
	--Construct the opening tag string
	local openTag = "<"..tagName;
	if(tagSubItem ~= nil) then
		openTag = openTag.." "..tagSubItem;
	end
	
	--Find the beginning tag, but only search from the where the calling function specified
	local tagStart, midTag = string.find(xml, openTag, startIndex, true);
	
	--If there were no tags that matched the requested tag after the start index, then return nil
	if(tagStart == nil) then
		return nil;
	end

	--Find the beginning of the value contained within this tag
	local endTag, valueStart = string.find(xml, ">", midTag, true);
	if(endTag == nil) then
		return nil;
	end
	
	--Find the ending tag
	local valueEnd, tagEnd = string.find(xml, "</"..tagName..">", tagStart, true);
	if(valueEnd == nil) then
		return nil;
	end
	
	--Close the file and return everything that we need to
	xmlFile:close();
	return string.sub(xml, valueStart+1, valueEnd-1), tagEnd+1, tagStart -1;
end
