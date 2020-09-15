// Setting the JCHEMHOME environmental variable
if(WScript.Arguments.length==0) {
    WScript.Echo("Too few parameters\nSyntax: cscript "+
    	    WScript.ScriptName + " \"<string>\"");
} else {	
    var value = WScript.Arguments.Item(0);
    if(value.substr(value.length-1, 1)=='\\')
	value = value.substr(0, value.length-1);
    WScript.Echo("The JCHEMHOME environmental variable is set to \""+
	    value + "\"");

    var shell = WScript.CreateObject("WScript.Shell");
    var env = shell.Environment("System");
    env.Item("JCHEMHOME") = value;
}

