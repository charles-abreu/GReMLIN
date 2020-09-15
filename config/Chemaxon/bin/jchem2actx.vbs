' Registering JChem's JavaBeans as ActiveX components

Dim shell, env, packagerPath, packagerClass, jchemHome

Set shell = WScript.CreateObject("WScript.Shell")
Set pEnv = shell.Environment("Process")
Set sEnv = shell.Environment("System")

javaHome = sEnv.Item("JAVA_HOME")
if javaHome = Null Or javaHome = "" Then javaHome = "c:\jdk1.3"
packagerPath = javaHome & "\jre\lib\jaws.jar"
packagerClass = "sun.beans.ole.Packager"
jchemHome = sEnv.Item("JCHEMHOME")
if jchemHome = Null Or jchemHome = "" Then jchemHome = "c:\jchem"

title = "Input for registering JChem"

javaHome = InputBox("Java home: ", title, javaHome)
if javaHome = "" Then WScript.Quit
packagerPath = InputBox("Packager path: ", title, packagerPath)
if packagerPath = "" Then WScript.Quit
packagerClass = InputBox("Packager class: ", title, packagerClass)
if packagerClass = "" Then WScript.Quit
jchemHome = InputBox("JChem home: ", title, jchemHome)
if jchemHome = "" Then WScript.Quit

pEnv.Item("JAVA_HOME") = javaHome
pEnv.Item("PACKAGERPATH") = packagerPath
pEnv.Item("PACKAGERClass") = packagerClass
pEnv.Item("JCHEMHOME") = jchemHome

shell.Run "jchem2actx.bat"

