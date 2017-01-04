%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load('transition.txt', '-ascii');
base_nodes = load('label.txt', '-ascii');

%Calculate the base pagerank.
base_pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
base_rank = get_ranking(base_pagerank);

%Start the experiment.
iterations = 10;
rank_errors = zeros(iterations, 1);
value_errors = zeros(iterations, 1);
experiment_results = {};

for i = 1:iterations 
    %Randomly remove edges.
    experiment_edges = remove_random_edges(base_edges, 1000);
    experiment_nodes = base_nodes;
    
    %Find the pagerank and rankings.
    experiment_pagerank = sparse_power_with_teleport(experiment_edges, length(experiment_nodes));
    experiment_rank = get_ranking(experiment_pagerank);
    
    %Calculate the rank and value errors.
    rank_errors(i) = get_rank_based_error(base_rank, experiment_rank);
    value_errors(i) = get_value_based_error(base_rank, base_pagerank, experiment_pagerank);
    
    %Set the experiment's pagerank and rank for administration purposes.
    experiment_results = [experiment_results experiment_pagerank experiment_rank];
end

rank_error_mean = mean(rank_errors)
rank_error_std = std(rank_errors)
value_error_mean = mean(value_errors)
value_error_std = std(value_errors)

%Write the results to a csv file.
output_file = 'result/pagerank_result.csv';
header = 'Baseline PageRank;Baseline Rank';

%Extend the size of the header, to also contain all results of the
%experiments done above.
for i = 1:iterations 
    header = [header ';Method_' num2str(i) '_PageRank' ';Method_' num2str(i) '_Rank'];
end

write_output_csv(output_file, [base_pagerank base_rank experiment_results], header);

%Output mean and std of error values.
output_file = 'result/evolution_error_summary_result.csv';
header = 'rank_error_mean;rank_error_std;value_error_mean;value_error_std';
write_output_csv(output_file, [rank_error_mean rank_error_std value_error_mean value_error_std], header);

%Output all value and rank errors.
output_file = 'result/evolution_error_result.csv';
header = 'rank_error;value_error';
write_output_csv(output_file, [rank_errors value_errors], header);