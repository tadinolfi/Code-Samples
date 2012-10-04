var text;
function checkLength(val)
{
	if (text == null) text = val.innerHTML;
	var value = ValidatorTrim(ValidatorGetValue(val.controltovalidate));
	if (value.length > val.maxLength)
	{
		val.innerHTML = text;
		if (val.displayEntered.toLowerCase() == "true")
			val.innerHTML += " (" + value.length + " characters entered)";
		return false;
	}
	else return true;
}
