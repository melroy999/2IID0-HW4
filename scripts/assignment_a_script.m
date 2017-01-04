%Set which files to load.
transition_file = 'transition.txt';
label_file = 'label.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = load(label_file, '-ascii');

%Calculate the base pagerank.
base_pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
base_rank = get_ranking(base_pagerank);

%Write the results to a csv file.
output_file = 'output/pagerank_result.csv';
header = 'Baseline PageRank;Baseline Rank';

%Write the output to a csv file.
write_output_csv(output_file, [base_pagerank base_rank], header);

%Draw some fancy box plots for the pagerank values.
boxplot(base_pagerank);
ylabel('PageRank values');
title('Boxplot of the PageRanks');
saveas(gcf,'output/base_page_rank_boxplot.png');
