clear all; 
%close all;
clear classes;
%clc;

%% Set flags.
inspect_only = false;

flux_loc = 20;
wvlen = 15;

%% Solve the system.
% % (incidence in x-direction)
% polarization = Axis.z;
% prop = Axis.x;
% angle = 0;
% [E, H, obj_array, src_array, J] = maxwell_run(...
% 	'OSC', 1e-9, wvlen, ...
% 	'DOM', {'vacuum', 'none', 1.0}, [-60, 60; -50, 50; 0, 1], 1, BC.p, [10 0 0], ...
% 	'OBJ', {'vacuum', 'none', 1.0}, Plane(Axis.y, flux_loc), ...
% 	'SRCJ', PlaneSrc(prop, 0, polarization), ...  % PlaneSrc(plane_normal_axis, intercept, polarization_axis)
% 	inspect_only);

if 1
    polarization = Axis.z;
    prop = Axis.y; % (incidence in y-direction)
    [E, H, obj_array, src_array, J] = maxwell_run(...
    	'OSC', 1e-9, wvlen, ...
        'DOM', {'vacuum', 'none', 1.0}, [-50, 50; -60, 60; 0, 1], 1, BC.p, [0 10 0], ...
        'OBJ', {'vacuum', 'none', 2+2j}, Box([-50, 0; -60,0; 0, 10]), ...
               {'vacuum', 'none', 1+1j}, Box([  0, 50; -60, 0; 0, 10]),...
    	'SRCJ', PlaneSrc(prop, 10, polarization), ...  % PlaneSrc(plane_normal_axis, intercept, polarization_axis)
        inspect_only);  
end

if 0
    polarization = Axis.z;
    prop = Axis.y; % (incidence in y-direction)
    [E, H, obj_array, src_array, J] = maxwell_run(...
    	'OSC', 1e-9, wvlen, ...
        'DOM', {'vacuum', 'none', 1.0}, [-50, 50; -60, 60; 0, 1], 1, BC.p, [0 10 0], ...
        'OBJ', {'vacuum', 'none', 1.0 - .1j}, Box([-50, 0; -60,0; 0, 10]), ...
               {'vacuum', 'none', 1.0 - .1j}, Box([  0, 50; -60, 0; 0, 10]),...
    	'SRCJ', PlaneSrc(prop, 10, polarization), ...  % PlaneSrc(plane_normal_axis, intercept, polarization_axis)
        inspect_only);  
end

if 0
    % (oblique incidence)
    polarization = Axis.z;
    prop = Axis.y;
    angle = pi/3;
    [E, H, obj_array, src_array, J] = maxwell_run(...
        'OSC', 1e-9, wvlen, ...
        'DOM', {'vacuum', 'none', 1.0}, [-50, 50; -60, 60; 0, 1], 1, BC.p, [0 10 0], ...
        'OBJ', {'vacuum', 'none', 1.0}, Plane(Axis.y, flux_loc), ...
        'SRCJ', PlaneSrc(prop, 0, polarization, 1, angle, wvlen), ...  % PlaneSrc(normal_axis, intercept, polarization, K, theta, wvlen)
        inspect_only);  
end
    
%% Visualize the solution.
figure(1);
clear opts;
opts.withobjsrc = true;
opts.withinterp = false;
opts.withpml = true;
vis2d(E{polarization}, Axis.z, 0, obj_array, src_array, opts)

if 0
    %% Calculate the power emanating from the source and test the performance of PML.
    power_measured = powerflux_patch(E, H, prop, flux_loc);
    power_expected = (1/2) * (0.5 * 0.5 * (100 * 1)) / cos(angle);  % (1/2) E x H x area / cos(angle)
    fprintf('power:\n');
    fprintf('measured = %s\n', num2str(power_measured));
    fprintf('expected = %s\n', num2str(power_expected));
    fprintf('error = %s%%\n',num2str((power_measured-power_expected)/power_expected*100));
end