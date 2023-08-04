# MATLAB2ANSYS User Manual
_**matlab2ansys.m**_ script is created for controlling an ANSYS Electronics Desktop project via MATLAB. To make this connection, one needs to follow the steps below.

## 1. Recording Script via ANSYS
ANSYS EM software supports scripting with _**.vbs**_ and _**.py**_ scripting. In python environment, [ANSYS library](https://docs.pyansys.com/version/stable/) can be used to generate projects via scripting. For those who are familiar with MATLAB,
ANSYS EM offers _**vbs**_ recording. By using the recorded script _**(rmxprtExporting.vbs for my case)**_, a new script can be generated via MATLAB.
- Navigate the _**Tools->Record Script to File**_ menu in ANSYS project
- Select _**.vbs**_ as extension, name the file, and save the path you want
- Create ANSYS model or change the parameters that you are interested in
- If you done with the above steps, navigate the _**Tools->Stop Script Recording**_
- This will be your original script

## 2. Changes in VBS File
Once you have recorded the script, items can be parametrized in VBS file. To parametrize the design:
- Define the parameters in the VBS script as _**Parameter = Value**_. Before defining parameters, add _**'matlab**_ for reaching the parameters section from MATLAB
- Adjust the _**oDesign.ChangeProperty**_ function to make it parametric, i.e., replace the _**Value**_ attribute with the previously defined parameter
- If necessary, add _**oProject.Save**_ and _**oDesign.Analyze**_ functions to save and analyze the project

## 3. MATLAB Scripting
After completing previous steps, the MATLAB script can be written to change the VBS file via MATLAB and save it as another VBS file. Then, by using the _**system(filename)**_ function in MATLAB, VBS file can be run, and ANSYS simulation is started.
- Open original script in the _**read mode**_
- Create new script in the _**write mode**_: This will be your modified script to change the parameters
- Define necessary parameters in MATLAB script
- Read the original script line-by-line and copy lines into the modified script, except the parameter definitions
- Write new parameters into the modified script
- Run the modified script

After following this steps, you can convert the whole code to a MATLAB function to embed it into optimization algorithm easily.
