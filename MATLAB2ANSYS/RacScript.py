import ScriptEnv
ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")
oDesktop.RestoreWindow()
oProject = oDesktop.SetActiveProject("sahinUsta")
oDesign = oProject.SetActiveDesign("Maxwell2DDesign6")
oModule = oDesign.GetModule("FieldsReporter")

for i in range(0,1438):
	ObjectBaseName = "Seconder_"+str(i+1)
	objectname = ObjectBaseName
	oModule.CopyNamedExprToStack("J_Vector")
	oModule.CopyNamedExprToStack("J_Vector")
	oModule.CalcOp("Dot")
	oModule.EnterScalar(1.67E-8)
	oModule.CalcOp("*")
	oModule.EnterSurf(objectname)
	oModule.CalcOp("Integrate")
	oModule.EnterScalar(9)
	oModule.CalcOp("/")
	oModule.AddNamedExpression("Rsec_"+str(i+1), "Fields")