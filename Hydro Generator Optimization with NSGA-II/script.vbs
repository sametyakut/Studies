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
 
projectName = "trialModel_v2" 
designName = "RMxprtDesign1" 
outDia = 6858.000000 
Dr = 6143.400000 
airgap = 14.400000 
Ls = 888.700000 
b2 = 23.578009 
h2 = 139.007517 
Q = 306.000000 
lambda = 9.000000 
wireWidth = 8.389004 
wireHeight = 2.156150 
dir = "C:/Users/samet/Documents/GitHub/Studies/Hydro Generator Optimization with NSGA-II/" 
 
Set oProject = oDesktop.SetActiveProject(projectName) 
Set oDesign = oProject.SetActiveDesign(designName) 
 
Q = CInt(Q) 
lambda = CInt(lambda) 
 
Set oEditor = oDesign.SetActiveEditor("Machine") 
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Stator", Array("NAME:PropServers",  _ 
  "Stator"), Array("NAME:ChangedProps", Array("NAME:Outer Diameter", "Value:=", "Do"), Array("NAME:Inner Diameter", "Value:=",  _ 
  "Di"), Array("NAME:Length", "Value:=", "Ls"), Array("NAME:Steel Type", "Material:=",  _ 
  "Cogent Power - M270-50A, B-H at 50Hz"), Array("NAME:Number of Slots", "Value:=",  _ 
  cstr(Q)), Array("NAME:Slot Type", "SlotType:=", "6")))) 
 
oEditor.ChangeProperty Array("NAME:AllTabs", Array("NAME:Winding", Array("NAME:PropServers",  _ 
  "Stator:Winding"), Array("NAME:ChangedProps", Array("NAME:Parallel Branches", "Value:=",  _ 
  "1"), Array("NAME:Conductors per Slot", "Value:=", "2"), Array("NAME:Coil Pitch", "Value:=",  _ 
  cstr(lambda)), Array("NAME:Number of Strands", "Value:=", "strands"), Array("NAME:Wire Size", "WireSizeWireDiameter:=",  _ 
  "0mm", "WireSizeGauge:=", "STANDARDRECT", "WireSizeWireWidth:=", "wireWidth", "WireSizeWireThickness:=",  _ 
  "wireHeight", "WireSizeMixedWireRectType:=", false, Array("NAME:WireSizeMixedDiameter"), Array("NAME:WireSizeMixedWidth"), Array("NAME:WireSizeMixedThickness"), Array("NAME:WireSizeMixedThicknessMixedFillet"), Array("NAME:WireSizeMixedThicknessMixedNumber")), Array("NAME:Wire Size", "WireSizeWireDiameter:=",  _ 
  "0mm", "WireSizeGauge:=", "STANDARDRECT", "WireSizeWireWidth:=", "wireWidth", "WireSizeWireThickness:=",  _ 
  "wireHeight", "WireSizeMixedWireRectType:=", false, Array("NAME:WireSizeMixedDiameter"), Array("NAME:WireSizeMixedWidth"), Array("NAME:WireSizeMixedThickness"), Array("NAME:WireSizeMixedThicknessMixedFillet"), Array("NAME:WireSizeMixedThicknessMixedNumber"))))) 
 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Do", "Value:=", cstr(outDia) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Dr", "Value:=", cstr(Dr) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:airgap", "Value:=", cstr(airgap) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:Ls", "Value:=", cstr(Ls) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:b2", "Value:=", cstr(b2) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:h2", "Value:=", cstr(h2) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:wireWidth", "Value:=", cstr(wireWidth) + "mm")))) 
oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _ 
  "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:wireHeight", "Value:=", cstr(wireHeight) + "mm")))) 
 
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
