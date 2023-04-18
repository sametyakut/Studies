% This function is created for calculating fft and listing the magnitude,
% and angles of the selected harmonics. Function takes the selected
% harmonics, flux values from 3D model, index for determining the phase (A,
% B, or C), and length of the pole. It gives the magnitude and phases of
% the selected harmonics as output.
function [n_short_listed,mag_short_listed,angle_short_listed] = fftCalculator(k,flux,i,poleLength)
    flux_per_pole2 = [flux;flux]; % just for circular flux pattern
    pp_step = poleLength; % to determine the window of the fft
    theta=pi/pp_step; % to determine the sampling frequency
    % fft script from MATLAB
    Flux_fft=flux_per_pole2(i:i+length(flux));
    Y = fft(Flux_fft);
    L=length(Flux_fft);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    P4 = angle(Y/L);
    P5 = P4(1:L/2+1);
    Fs=1/theta;
    f = Fs*(0:(L/2))/L;
    n=2*pi*f;
    n_short_listed=[];
    mag_short_listed=[];
    angle_short_listed=[];
    % listing the phases and magnitudes of the selected harmonics
    for j = k
       i=j*4+1;
       n_short_listed=[n_short_listed n(i)];
       mag_short_listed=[mag_short_listed P1(i) ];
       angle_short_listed=[angle_short_listed P5(i) ];
    end
end
