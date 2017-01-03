%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load('transition.txt', '-ascii');
base_nodes = load('label.txt', '-ascii');

%Get the political leaning values.
base_political_leaning = base_nodes(:,2);

pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
rank = get_ranking(pagerank);

%Write the results to a csv file.
dlmwrite('pagerank_result.csv', [pagerank, rank], 'delimiter', ';', 'precision', 12);

nodes = [1 2 3 4 5 6];
edges = [1 2; 1 3; 1 4; 1 5; 1 6; 2 1; 2 3; 2 4; 2 5; 2 6; 3 1; 3 2; 3 4; 3 5; 3 6];

[nodes, edges] = remove_random_nodes(nodes, edges, 1);