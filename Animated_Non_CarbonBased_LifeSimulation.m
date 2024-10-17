 
function silicon_life_simulation()
    % Create the main figure
    hFig = figure('Name', 'Non-Carbon Based Life Simulation', ...
                  'MenuBar', 'none', ...
                  'NumberTitle', 'off', ...
                  'Position', [100 100 800 600]);

    % Create UI controls for parameters
    uicontrol('Style', 'text', 'String', 'Initial Cells:', 'Position', [20 550 80 20]);
    initial_cells_input = uicontrol('Style', 'edit', 'String', '1', 'Position', [100 550 50 20]);
    
    uicontrol('Style', 'text', 'String', 'Max Capacity:', 'Position', [200 550 80 20]);
    max_capacity_input = uicontrol('Style', 'edit', 'String', '1000', 'Position', [280 550 50 20]);
    
    uicontrol('Style', 'text', 'String', 'Growth Rate:', 'Position', [380 550 80 20]);
    growth_rate_input = uicontrol('Style', 'edit', 'String', '0.05', 'Position', [460 550 50 20]);
    
    uicontrol('Style', 'text', 'String', 'Metabolic Rate:', 'Position', [560 550 80 20]);
    metabolic_rate_input = uicontrol('Style', 'edit', 'String', '0.02', 'Position', [640 550 50 20]);
    
    % Create a start button
    start_button = uicontrol('Style', 'pushbutton', 'String', 'Start Simulation', ...
                             'Position', [20 500 100 30], ...
                             'Callback', @start_simulation);
                         
    % Create axes for plotting
    axes1 = axes('Parent', hFig, 'Position', [0.1 0.3 0.8 0.6]);
    xlabel(axes1, 'Time (arbitrary units)');
    ylabel(axes1, 'Population / Silicon Availability');
    title(axes1, 'Growth of Silicon-based Life and Silicon Availability');
    grid(axes1, 'on');

    hold(axes1, 'on');
    population_line = plot(axes1, NaN, NaN, '-b', 'LineWidth', 2, 'DisplayName', 'Population');
    silicon_line = plot(axes1, NaN, NaN, '-r', 'LineWidth', 2, 'DisplayName', 'Silicon Availability');
    legend(axes1, 'show');
    
    % Plotting animation variables
    time_steps = 100; 
    dt = 0.1; 
    time = zeros(1, time_steps);
    
    % Nested function to run the simulation
    function start_simulation(~, ~)
        % Read the user-defined input
        initial_cells = str2double(get(initial_cells_input, 'String'));
        max_capacity = str2double(get(max_capacity_input, 'String'));
        growth_rate = str2double(get(growth_rate_input, 'String'));
        metabolic_rate = str2double(get(metabolic_rate_input, 'String'));

        % Reset simulation data
        population = zeros(1, time_steps);
        environment_silicon = zeros(1, time_steps);
        population(1) = initial_cells;
        environment_silicon(1) = max_capacity; 
        
        % Animation loop
        for t = 2:time_steps
            % Update time
            time(t) = (t-1) * dt;

            growth_potential = min(growth_rate * population(t-1), environment_silicon(t-1));
            population(t) = population(t-1) + growth_potential; 

            if environment_silicon(t-1) <= 0
                population(t) = population(t-1);
            end
            
            consumed_silicon = min(metabolic_rate * population(t), environment_silicon(t-1));
            environment_silicon(t) = environment_silicon(t-1) - consumed_silicon;  

            if environment_silicon(t) < 0
                environment_silicon(t) = 0; 
            end
            
            % Update plot
            set(population_line, 'XData', time(1:t), 'YData', population(1:t));
            set(silicon_line, 'XData', time(1:t), 'YData', environment_silicon(1:t));
            drawnow;

            pause(0.1);  % Pause for a short time for animation effect
        end

        disp('Final Population:');
        disp(population(end));
        disp('Final Silicon in Environment:');
        disp(environment_silicon(end));
    end
end