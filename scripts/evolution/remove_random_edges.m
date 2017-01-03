%Remove a certain amount of uniformly random edges from the edges array.
function edges = remove_random_edges(edges, count)
    %The indices to remove.
    random_indices = randperm(length(edges));
    
    %Convert it to the subarray from 1 to count.
    random_indices = random_indices(1:count);
    
    %Remove the values at the random indices in the edges array.
    edges(random_indices,:) = [];
end