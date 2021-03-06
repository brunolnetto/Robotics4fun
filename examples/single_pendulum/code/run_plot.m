plot_info.titles = {'$\theta$', '$\dot \theta$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\theta$ $[rad]$', '$\dot \theta$ $[rad/s]$'};
plot_info.grid_size = [2, 1];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);
hfig_energies = plot_energies(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i)], 'epsc'); 
end
