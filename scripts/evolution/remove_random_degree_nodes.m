function [nodes, edges] = remove_random_degree_nodes(nodes, edges, count, constraint)
    %Get the indices of the matching and non-matching nodes.
    [matching_nodes, ~] = find(constraint);
    [non_matching_nodes, ~] = find(~constraint);

    %The indices to remove.
    random_indices = randperm(length(matching_nodes));

    %Convert it to the subarray from 1 to count.
    random_indices = random_indices(1:count);

    %Remove the selected random indices from the matches.
    matching_nodes(random_indices) = [];

    %Combine the non match list and the (randomly reduced) match list.
    selected_node_indices = [matching_nodes; non_matching_nodes];

    %To be certain, sort the selected edge indices.
    sort(selected_node_indices);

    %Get the list of resulting nodes.
    nodes = nodes(selected_node_indices,:);
    
    %Remove any edges that contain a node that is not in the nodes list.
    %So, if any edge value is not a member of nodes.
    %selected_node_indices should coincide with the values in nodes(:,1).
    edges(any(~ismember(edges, selected_node_indices), 2),:) = [];
end