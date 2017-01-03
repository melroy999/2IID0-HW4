%Add a certain amount of uniformly random edges from the edges array.
function edges = add_random_edges(edges, num, count)
    appendix = zeros(count, 2);
    for i = 1:count
        pair = randi([1 num], 1, 2);
        
        %Add the pair to the additions.
        appendix(i,1) = pair(1);
        appendix(i,2) = pair(2);
    end
   
    %Add the edges to the end of the array.
    edges = [edges; appendix];
end