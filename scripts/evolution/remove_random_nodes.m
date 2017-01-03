%Remove a certain amount of uniformly random edges from the nodes array, together with corresponding edges in the edges array.
function [nodes, edges] = remove_random_nodes(nodes, edges, count)
    %The nodes to remove.
    random_nodes = randperm(length(nodes));
    
    %Convert it to the subarray from 1 to count.
    random_nodes = random_nodes(1:count);
    
    %Remove the values at the random indices in the edges array.
    nodes(random_nodes) = [];
    
    %Make sure that all occurrences are also removed from the edge array.
    %Second argument in any is 2, as we want to search horizontally.
    edges(any(ismember(edges, random_nodes), 2),:) = [];
end