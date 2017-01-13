%The transition files end with the extension '.txt', so add this.
transition_file = 'polblogs.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = [1:max(base_edges(:))].';
base_degrees_1 = get_degree(base_edges, length(base_nodes));


transition_file = 'p2p-Gnutella08.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = [1:max(base_edges(:))].';
base_degrees_2 = get_degree(base_edges, length(base_nodes));

transition_file = 'California.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = [1:max(base_edges(:))].';
base_degrees_3 = get_degree(base_edges, length(base_nodes));

ft_1 = tabulate(base_degrees_1);
ft_2 = tabulate(base_degrees_2);
ft_3 = tabulate(base_degrees_3);

plot(ft_1(:,1), ft_1(:,3), ft_2(:,1), ft_2(:,3), ft_3(:,1), ft_3(:,3));
set(gcf,'position',[0,0,960,450]);
xlabel('Degree values');
ylabel('Percentage of all degrees');
title('Plot of the degree frequency percentage in range [0-20]');
legend('polblogs','p2p-Gnutella08','California');
print('output/frequency_comparison','-dpng','-r300')

