%Calculate the value-based error.
function error = get_value_based_error(experiment_nodes, baseline_rank, baseline_pagerank, experiment_pagerank)
    error = 0;
    
    %Iterate over all the indices of the nodes.
    for i = 1:length(experiment_nodes)
        %We are trying to compare two different lists.
        %In the baseline, we want to extract the node with id node.
        node = experiment_nodes(i);
        
        %In the experiment, we want to extract the index "i", as experiment_nodes and
        %experiment_rank are using the same indices.
        error = error + abs(experiment_pagerank(i) - baseline_pagerank(node)) / baseline_rank(node);
    end
end