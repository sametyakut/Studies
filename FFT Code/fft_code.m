% clear all
% clc 
% close all

opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Time", "data"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("cogging_torque.csv", opts);
Time = tbl.Time;
data = tbl.data;
clear opts tbl
fs=1/(Time(2)-Time(1))*1e3;

y = fft(data);
L=length(data);
P1= abs(y/L);
P2=2*P1(1:L/2+1);
% P1_phase(2:end-1)=P1_phase(2:end-1);
f= fs*(0:(L/2))/L;

figure()
stem(f,P2)
xlabel('Harmonik Frekans (Hz)')
ylabel('Tork (kN.m)')

%%

opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Time", "data"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("cogging_torque_saturated.csv", opts);
Time = tbl.Time;
data = tbl.data;
clear opts tbl
fs=1/(Time(2)-Time(1))*1e3;

y = fft(data);
L=length(data);
P1= abs(y/L);
P2=2*P1(1:L/2+1);
% P1_phase(2:end-1)=P1_phase(2:end-1);
f= fs*(0:(L/2))/L;

figure()
stem(f,P2)
xlabel('Harmonik Frekans (Hz)')
ylabel('Tork (MN.m)')
xlim([0 2000])