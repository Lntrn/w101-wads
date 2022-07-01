function StripTrailingWhiteSpace(str)
	while(string.find(str, "%s",-1) ~= nil) do
		str = string.sub(str,1,-2);
	end
	return str;
end
