%Set which files to load.
transition_file = 'transition.txt';
label_file = 'label.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = load(label_file, '-ascii');
base_degrees = get_degree(base_edges, length(base_nodes));

%Set the amount of edges we want to delete.
count = 1000;

%Calculate the base pagerank.
base_pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
base_rank = get_ranking(base_pagerank);

%Start the experiment.
iterations = 25;
rank_errors = zeros(iterations, 1);
value_errors = zeros(iterations, 1);
experiment_results = {};
experiment_pageranks = {};
experiment_ranks = {};

for i = 1:iterations 
    %Randomly remove edges.
    experiment_edges = remove_random_edges(base_edges, count);
    experiment_nodes = base_nodes;
    
    %Find the pagerank and rankings.
    experiment_pagerank = sparse_power_with_teleport(experiment_edges, length(experiment_nodes));
    experiment_rank = get_ranking(experiment_pagerank);
    
    %Calculate the rank and value errors.
    rank_errors(i) = get_rank_based_error(experiment_nodes, base_rank, experiment_rank);
    value_errors(i) = get_value_based_error(experiment_nodes, base_rank, base_pagerank, experiment_pagerank);
    
    %Set the experiment's pagerank and rank for administration purposes.
    experiment_results = [experiment_results experiment_pagerank experiment_rank];
    experiment_pageranks = [experiment_pageranks experiment_pagerank];
    experiment_ranks = [experiment_ranks experiment_rank];
end

rank_error_mean = mean(rank_errors);
rank_error_std = std(rank_errors);
value_error_mean = mean(value_errors);
value_error_std = std(value_errors);

%Write the results to a csv file.
output_file = ['output/uniform_edges_' num2str(iterations) '_' num2str(count) '_pagerank_result.csv'];
header = 'Baseline PageRank;Baseline Rank';

%Extend the size of the header, to also contain all results of the
%experiments done above.
for i = 1:iterations 
    header = [header ';Method_' num2str(i) '_PageRank' ';Method_' num2str(i) '_Rank'];
end

write_output_csv(output_file, [base_pagerank base_rank experiment_results], header);

%Output mean and std of error values.
output_file = ['output/uniform_edges_' num2str(iterations) '_' num2str(count) '_evolution_error_summary_result.csv'];
header = 'rank_error_mean;rank_error_std;value_error_mean;value_error_std';
write_output_csv(output_file, [rank_error_mean rank_error_std value_error_mean value_error_std], header);

%Output all value and rank errors.
output_file = ['output/uniform_edges_' num2str(iterations) '_' num2str(count) '_evolution_error_result.csv'];
header = 'rank_error;value_error';
write_output_csv(output_file, [rank_errors value_errors], header);

%%%% Draw plots %%%%
%Draw some fancy box plots for the error distribution.
boxplot(rank_errors, {' '});
set(gcf,'units','pixel');
set(gcf,'position',[0,0,320,450]);

ylabel('Rank error');
title('Boxplot of the rank error collection');
print(['output/uniform_edges_' num2str(iterations) '_' num2str(count) '_rank_error_boxplot'],'-dpng','-r300')

%Draw some fancy box plots for the value distribution.
boxplot(value_errors, {' '});
set(gcf,'units','pixel');
set(gcf,'position',[0,0,320,450]);

ylabel('Value error');
title('Boxplot of the value error collection');
print(['output/uniform_edges_' num2str(iterations) '_' num2str(count) '_value_error_boxplot'],'-dpng','-r300')

%Draw a box plot with all experiment results side by side.
boxplot(cell2mat(experiment_pageranks));
set(gcf,'units','pixel');
set(gcf,'position',[0,0,960,450]);

ylabel('PageRank values');
xlabel(['Random runs with ' num2str(count) ' randomly removed edges']);
title('Boxplots of each PageRank in the uniform random edge deletion experiment');
print(['output/uniform_edges_' num2str(iterations) '_' num2str(count) '_boxplots'],'-dpng','-r300')

