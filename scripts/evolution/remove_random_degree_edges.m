function edges = remove_random_degree_edges(edges, count, constraint)
    %Get the indices of the matching nodes.
    [matching_nodes, ~] = find(constraint);

    %Get the indices of the matching edges.
    [matching_edge_indices, ~] = find(any(ismember(edges, matching_nodes), 2));
    [non_matching_edge_indices, ~] = find(~any(ismember(edges, matching_nodes), 2));

    %The indices to remove.
    random_indices = randperm(length(matching_edge_indices));

    %Convert it to the subarray from 1 to count.
    random_indices = random_indices(1:count);

    %Remove the selected random indices from the matches.
    matching_edge_indices(random_indices) = [];

    %Combine the non match list and the (randomly reduced) match list.
    selected_edge_indices = [matching_edge_indices; non_matching_edge_indices];

    %To be certain, sort the selected edge indices.
    sort(selected_edge_indices);

    %Get the list of resulting edges.
    edges = edges(selected_edge_indices,:);
end