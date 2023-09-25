function PlotCosts(pop)

    Costs = [pop.Cost];
    
    plot(Costs(1, :), Costs(2, :).^-1, '*', 'MarkerSize', 12);
    xlabel('Initial Cost (USD)');
    ylabel('Efficiency (\%)');
    title('Non-dominated Solutions (F$_{1}$)');
    grid on;

end