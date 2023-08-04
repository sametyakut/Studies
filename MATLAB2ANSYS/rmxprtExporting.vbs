' ----------------------------------------------
' Script Recorded by Ansys  Version 2022.2.0
' 14:53:45  Aug 01, 2023
' ----------------------------------------------
Dim oAnsoftApp
Dim oDesktop
Dim oProject
Dim oDesign
Dim oEditor
Dim oModule

Set oAnsoftApp = CreateObject("Ansoft.ElectronicsDesktop")
Set oDesktop = oAnsoftApp.GetAppDesktop()
oDesktop.RestoreWindow

'matlab
'projectName = ""
'designName = ""
'Do = 6858
'Dr = 6161.6
'airgap = 18
'Ls = 925
'iter = 0

'dir = "D:/EUAS_Elektromanyetik_Draft/MATLAB2ANSYS/"
'fname = "designSheet_iter0"

Set oProject = oDesktop.SetActiveProject(projectName)
Set oDesign = oProject.SetActiveDesign(designName)
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Do", "Value:=", cstr(Do) + "mm"))))
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Dr", "Value:=", cstr(Dr) + "mm"))))
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:airgap", "Value:=", cstr(airgap) + "mm"))))
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Ls", "Value:=", cstr(Ls) + "mm"))))
oProject.Save
oDesign.Analyze "Setup1"
Set oModule = oDesign.GetModule("AnalysisSetup")
oModule.CustomizedDesignSheet Array("NAME:Export Data", "SolutionKey:=", Array("SimSetup:=",  _
  10, "Instance:=",  _
  "airgap=" & Chr(39) & "19mm" & Chr(39) & " apparentPower=" & Chr(39) & "44458.2" & _ 
  "80128677943" & Chr(39) & " b1=" & Chr(39) & "26mm" & Chr(39) & " b2=" & Chr(39) & "" & _ 
  "22mm" & Chr(39) & " Di=" & Chr(39) & "6200mm" & Chr(39) & " Do=" & Chr(39) & "" & _ 
  "6857mm" & Chr(39) & " Dr=" & Chr(39) & "6162mm" & Chr(39) & " Ds=" & Chr(39) & "" & _ 
  "4000mm" & Chr(39) & " fieldWireHeight=" & Chr(39) & "5mm" & Chr(39) & " fieldW" & _ 
  "ireWidth=" & Chr(39) & "50mm" & Chr(39) & " h0=" & Chr(39) & "1mm" & Chr(39) & "" & _ 
  " h1=" & Chr(39) & "3mm" & Chr(39) & " h2=" & Chr(39) & "148mm" & Chr(39) & " L" & _ 
  "r=" & Chr(39) & "925mm" & Chr(39) & " Ls=" & Chr(39) & "900mm" & Chr(39) & " N" & _ 
  "f=" & Chr(39) & "41" & Chr(39) & " opTemperature=" & Chr(39) & "75cel" & Chr(39) & "" & _ 
  " poleBodyHeight=" & Chr(39) & "252mm" & Chr(39) & " poleBodyWidth=" & Chr(39) & "" & _ 
  "343mm" & Chr(39) & " poleShoeHeight=" & Chr(39) & "45mm" & Chr(39) & " poleSho" & _ 
  "eWidth=" & Chr(39) & "406mm" & Chr(39) & " ratedSpeed=" & Chr(39) & "187.50000" & _ 
  "000000003rpm" & Chr(39) & " ratedVoltage=" & Chr(39) & "13800V" & Chr(39) & " " & _ 
  "strands=" & Chr(39) & "48" & Chr(39) & " wireHeight=" & Chr(39) & "2mm" & Chr(39) & "" & _ 
  " wireWidth=" & Chr(39) & "7mm" & Chr(39) & "", "Solution:=", 11, "VersionID:=",  _
  55), "File Name:=",  _
  dir + fname + ".xls")
