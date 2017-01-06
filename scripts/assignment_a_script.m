%Set which files to load.
transition_file = 'transition.txt';
label_file = 'label.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = load(label_file, '-ascii');
base_degrees = get_degree(base_edges, length(base_nodes));

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
pagerank_ewt = pagerank;
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
header = 'degree;';
header = [header 'eigensolver_with_teleport_pagerank;' 'eigensolver_without_teleport_pagerank;' 'power_with_teleport_pagerank;' 'power_without_teleport_pagerank;' 'sparse_power_with_teleport_pagerank;' 'eigensolver_with_teleport_rank;' 'eigensolver_without_teleport_rank;' 'power_with_teleport_rank;' 'power_without_teleport_rank;' 'sparse_power_with_teleport_rank'];

%Write the output to a csv file.
write_output_csv(output_file, [base_degrees pageranks ranks], header);

%Draw a box plot with all methods side by side.
%Does not always plot the correct thing. Sometimes you have to run twice.
boxplot(cell2mat(pageranks), {'eigensolver_with_teleport' 'eigensolver_without_teleport' 'power_with_teleport' 'power_without_teleport' 'sparse_power_with_teleport'}, 'orientation', 'horizontal');
set(gcf,'units','pixel');
set(gcf,'position',[0,0,960,450]);

xlabel('PageRank values');
title('The PageRank values for each method');
print('output/method_boxplots','-dpng','-r300')

min(pagerank_ewt)
max(pagerank_ewt)
pagerank_ewt = log(pagerank_ewt);

boxplot(pagerank_ewt, {'eigensolver_without_teleport'}, 'orientation', 'horizontal');
set(gcf,'units','pixel');
set(gcf,'position',[0,0,960,100]);

xlabel('PageRank values');
title('The PageRank values for each method');
print('output/method_ewt_boxplot','-dpng','-r300')

