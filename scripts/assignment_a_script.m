%Set which files to load.
transition_file = 'transition.txt';
label_file = 'label.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = load(label_file, '-ascii');

%List of pageranks of all 5 methods.
pageranks = {};
ranks = {};

%Calculate the pageranks for each method.
pagerank = eigensolver_with_teleport(base_edges, length(base_nodes));
pageranks = [pageranks pagerank];
rank = get_ranking(pagerank);
ranks = [ranks rank];

pagerank = eigensolver_without_teleport(base_edges, length(base_nodes));
pageranks = [pageranks pagerank];
rank = get_ranking(pagerank);
ranks = [ranks rank];

pagerank = power_with_teleport(base_edges, length(base_nodes));
pageranks = [pageranks pagerank];
rank = get_ranking(pagerank);
ranks = [ranks rank];

pagerank = power_without_teleport(base_edges, length(base_nodes));
pageranks = [pageranks pagerank];
rank = get_ranking(pagerank);
ranks = [ranks rank];

pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
pageranks = [pageranks pagerank];
rank = get_ranking(pagerank);
ranks = [ranks rank];

%Write the results to a csv file.
output_file = 'output/pagerank_results.csv';
header = 'eigensolver_with_teleport_pagerank';
header = [header 'eigensolver_without_teleport_pagerank' 'power_with_teleport_pagerank' 'power_without_teleport_pagerank' 'sparse_power_with_teleport_pagerank' 'eigensolver_with_teleport_rank' 'eigensolver_without_teleport_rank' 'power_with_teleport_rank' 'power_without_teleport_rank' 'sparse_power_with_teleport_rank'];

%Write the output to a csv file.
write_output_csv(output_file, [pageranks ranks], header);

%Draw a box plot with all methods side by side.
boxplot(cell2mat(pageranks));
ylabel('PageRank values');
title('Boxplots.');
saveas(gcf,'output/uniform_random_edge_deletion_boxplots.png');
