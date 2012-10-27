clear all; close all; clear classes; clc;

%% Solve the system.
inspect_only = false;
[E, H, obj_array] = maxwell_run(1e-9, 100, ...
	{'vacuum', 'none', 1.0}, [-50, 50; -60, 60; 0, 1], 1, [BC.p BC.Et0 BC.p], [0 10 0], ...
	PlaneSrc(Axis.y, 0, Axis.z), inspect_only);  % PlaneSrc(plane_normal_axis, intercept, polarization_axis)

%% Visualize the solution.
figure
vis2d(E{Axis.z}, Axis.z, 0, obj_array)

%% Calculate the power emanating from the source.
power = powerflux_patch(E, H, Axis.y, 10);
fprintf('power = %e\n', power);
