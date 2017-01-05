%Set which files to load.
transition_file = 'transition.txt';
label_file = 'label.txt';

%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = load(label_file, '-ascii');
base_degrees = get_degree(base_edges, length(base_nodes));

%The amount of edges/nodes to remove.
count = 50;

%Define the constraint we have on the degree of the node.
constraint = base_degrees > 100;

%edges = remove_random_degree_edges(base_edges, count, constraint);
[nodes, edges] = remove_random_degree_nodes(base_nodes, base_edges, count, constraint);


