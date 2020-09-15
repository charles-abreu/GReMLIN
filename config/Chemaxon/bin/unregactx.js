// Unregistering JChem's JavaBeans over ActiveX

function deleteOfOne(name) {
    shell.RegDelete(name);
}

function regDelete(name) {
    var keyPrefix = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\";
    deleteOfOne(keyPrefix+name+"\\CLSID\\");
    deleteOfOne(keyPrefix+name+"\\CurVer\\");
    deleteOfOne(keyPrefix+name+"\\");
    deleteOfOne(keyPrefix+name+".1\\CLSID\\");
    deleteOfOne(keyPrefix+name+".1\\Insertable\\");
    deleteOfOne(keyPrefix+name+".1\\");
}

var shell = WScript.CreateObject("WScript.Shell");

/*
env = shell.Environment("System");
if(env.Item("JCHEMHOME"!=null)) {
    env.Remove("JCHEMHOME");
}
*/

regDelete("ChemAxon_MSketchPane.Bean");
regDelete("ChemAxon_MViewPane.Bean");
regDelete("ChemAxon_ConnectionHandler.Bean");
regDelete("ChemAxon_JChemSearch.Bean");
regDelete("ChemAxon_MolHandler.Bean");
regDelete("ChemAxon_UpdateHandler.Bean");

