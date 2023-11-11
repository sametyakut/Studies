function PlotCosts(pop)

    Costs = [pop.Cost];
    
    plot(Costs(1, :), Costs(2, :).^-1, '*', 'MarkerSize', 15);
    xlabel('Initial Cost (USD)');
    ylabel('Efficiency (\%)');
    title('Non-dominated Solutions (F$_{1}$)');
    grid on;
    ax = gca; % current axes
    ax.FontSize = 24;
end