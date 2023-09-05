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


Set oProject = oDesktop.SetActiveProject(projectName)
Set oDesign = oProject.SetActiveDesign(designName)
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Do", "Value:=", cstr(outDia) + "mm"))))
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Dr", "Value:=", cstr(Dr) + "mm"))))
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:airgap", "Value:=", cstr(airgap) + "mm"))))
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Ls", "Value:=", cstr(Ls) + "mm"))))
oProject.Save
oDesign.Analyze "Setup1"
Set oModule = oDesign.GetModule("ReportSetup")
oModule.UpdateAllReports
oModule.ExportToFile "Efficiency",  _
  dir + "Efficiency.csv", false
oModule.ExportToFile "Losses",  _
  dir + "Losses.csv", false
oModule.ExportToFile "Mass",  _
  dir + "Mass.csv", false
oModule.ExportToFile "SCR", dir + "SCR.csv",  _
  false
