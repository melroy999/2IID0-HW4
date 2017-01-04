%Calculate the rank-based error.
function error = get_rank_based_error(experiment_nodes, baseline_rank, experiment_rank)
    error = 0;
    
    %Iterate over all the indices of the nodes.
    for i = 1:length(experiment_nodes)
        %We are trying to compare two different lists.
        %In the baseline, we want to extract the node with id node.
        node = experiment_nodes(i);
        
        %In the experiment, we want to extract the index "i", as experiment_nodes and
        %experiment_rank are using the same indices.
        error = error + abs(experiment_rank(i) - baseline_rank(node)) / baseline_rank(node);
    end
end