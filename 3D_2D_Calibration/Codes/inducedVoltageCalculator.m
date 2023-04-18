% This function is created for calculating the induced voltage from the fft
% performed flux values of 3D model. It takes the selected harmonics with
% their winding factors, time vector, magnitude and angle lists of the two
% different phases as input. Also, user need to specify if she wants to
% plot phase voltage or line to line voltage. It gives the two of the phase voltages
% and their fundamental components as output
function [Va, Vb, Va_fund, Vb_fund] = inducedVoltageCalculator(k, time, kw, mag_short_listed_A, angle_short_listed_A, mag_short_listed_B, angle_short_listed_B, value)
    Va=0;
    Vb=0;
    Va_fund=0;
    Vb_fund=0;
    for i=1:length(k)
        
        Va=Va+100*kw(i)*2*pi*50*k(i)*mag_short_listed_A(i)*sin(k(i).*time-angle_short_listed_A(i));
        Vb=Vb+100*kw(i)*2*pi*50*k(i)*mag_short_listed_B(i)*sin(k(i).*time-angle_short_listed_B(i));
        Va_fund=100*kw(1)*2*pi*50*k(1)*mag_short_listed_A(1)*sin(k(1).*time-angle_short_listed_A(1)); % only fundamental components
        Vb_fund=100*kw(1)*2*pi*50*k(1)*mag_short_listed_B(1)*sin(k(1).*time-angle_short_listed_B(1)); % only fundamental components
    end
    if isequal(value, 'Phase')
        figure1=figure('Position',[0 0 800 600]);
        plot(time*180/pi,Va/1e3,'Color',[1 0 0],'LineWidth',1)
        hold on;
        plot(time*180/pi,Va_fund/1e3,'Color',[0 0 1],'LineWidth',1)
        xlim([0 360])
        %ylim([min(Va)/1e3-1 max(Va)/1e3+1])
        xlabel('Angle','FontName','Times New Roman');
        ylabel('Phase Voltage (kV)','FontName','Times New Roman');
        set(gca,'FontName','Times New Roman','FontSize',15);
        legend('With harmonics','Fundamental')
        grid on;
        grid minor;
    end
    if isequal(value, 'Line2Line')
        figure1=figure('Position',[0 0 800 600]);
        hold on;
        plot(time*180/pi,(Va-Vb)/1e3,'Color',[1 0 0],'LineWidth',1)
        hold on;
        plot(time*180/pi,(Va_fund-Vb_fund)/1e3,'Color',[0 0 1],'LineWidth',1)
        xlim([0 360])
        %ylim([min(2*(Va-Vb))/1e3-1 max(2*(Va-Vb))/1e3+1])
        xlabel('Angle','FontName','Times New Roman');
        ylabel('Line-to-line Voltage (kV)','FontName','Times New Roman');
        set(gca,'FontName','Times New Roman','FontSize',15);
        legend('With harmonics','Fundamental')
        grid on;
        grid minor;
    end
end