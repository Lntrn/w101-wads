--The directory passed to this function needs to end in a "\".  This function will return a table of all xml Files found in the specified directory.
function GetXmlFileList(dir)
	--Have the game query the OS for a directory listing of the passed-in directory and return to us a string with the results.OS output a directory listing to a dummy file
	local dirTxt;
	if(GetOS() == "Win32") then
		--We're running on windows
		
		--Make the file paths use the correct slash direction ('\' rather than '/')
		dir = string.gsub(dir, "/", "\\");
		
		--Get the Game to return a string of the directory listing
		dirTxt = ExecuteSysCmd("dir /B \""..dir.."\"");
	else
		--We're running on Linux, so we don't have to reformat any of the slashes.
		--Just get the Game to return a string of the directory listing
		dirTxt = ExecuteSysCmd("ls \""..dir.."\"");
	end
	
	--Search the directory listing for xml Files and store them in a table
	local fileList = {};
	local fileName = "";
	local filePos = 1;
	while(filePos < string.len(dirTxt)) do
		--Find the next string that is of the form "*.xml", where '*' is a wildcard standing
		--for any character.  The tricky part is that there could be spaces in the file name, so we
		--have to queue up the words until we hit a .xml extension and we will assume that any
		--words separated by only one space belong to the file name.  If a word is separated from
		--the previous word by more than one space, or by another whitespace character, we will
		--assume we have started a new file name.
		
		--Get the first word and the separator after it.  We will read all white space into the
		--separator, so we can check if it matches our specs for separating file names, or if it's
		--just separating two words in a file name.
		local skip, word, sep;
		skip, filePos, word, sep = string.find(dirTxt, "(%S+)(%s*)", filePos);
		
		--If this word ends in a .xml extension...
		if(string.find(word, ".xml", 1, true) ~= nil) then
			--This word ends in an .xml extension, so we can just add the file to the file list and
			--go to the next word
			fileName = fileName..word;
			table.insert(fileList, dir..fileName);
			
			--Need to clear the file name, since we just recorded this one in the list.
			fileName = "";
		else
			--This word does not end in an .xml extension, so we need to check the separator to see
			--if we need to start a new file name
			if(string.len(sep) ~= 1 or sep ~= " ") then
				--The separator is not just a single space, so we are assuming it is separating two
				--words, which means we did not find an xml extension for this file.  So, we can
				--just reset the file name, which effectively skips this file or folder.
				fileName = "";
			else
				--The separator is just a single space, so we are assuming it is separating two
				--words, so join this word to the file name and add a space at the end
				fileName = fileName..word.." ";
			end
		end
	end

	--We're done reading the file, so we can close the file and return the file list
	return fileList;
end
