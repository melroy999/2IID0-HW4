%Calculate the rank-based error.
function error = get_rank_based_error(experiment_nodes, baseline_pagerank, experiment_pagerank)
    error = 0;
    
    %Extract the nodes we are interested in from the pageranks.
    baseline_selected_pagerank = baseline_pagerank(experiment_nodes);
    experiment_selected_pagerank = experiment_pagerank(experiment_nodes);
    
    %Calculate the ranks for these pageranks.
    baseline_selected_rank = get_ranking(baseline_selected_pagerank);
    experiment_selected_rank = get_ranking(experiment_selected_pagerank);
    
    %Iterate over all the indices of the nodes.
    for i = 1:length(experiment_nodes)
        %Calculate the error.
        error = error + abs(experiment_selected_rank(i) - baseline_selected_rank(i)) / baseline_selected_rank(i);
    end
end