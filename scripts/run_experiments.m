%Runs all experiments.

%First of all, create the output folder.
mkdir('output');

%Get the list of data files.
dataset_files = {'polblogs', 'p2p-Gnutella08', 'California'};
%dataset_files = {'California'};

%Iterate over all file names.
for dataset_name = dataset_files
    %The transition files end with the extension '.txt', so add this.
    transition_file = char(strcat(dataset_name,'.txt'));
    
    %Load the original matrix, of which the values can be found within the corresponding files.
    base_edges = load(transition_file, '-ascii');
    base_nodes = [1:max(base_edges(:))].';
    base_degrees = get_degree(base_edges, length(base_nodes));
    
    %Define the output folder location.
    output_folder = char(strcat('output/',dataset_name));
    
    %Make a folder in which all results will be stored for this particular
    %dataset.
    mkdir(output_folder);
    
    %We start with plotting the results for assignment a.
    assignment_a_script;
    
    %Run the uniform edge removal experiment.
    %assignment_b_sample_random_edge_script;
    
    %Run the uniform node removal experiment.
    %assignment_b_sample_random_node_script;
    
    %Run the degree edge removal experiment.
    assignment_b_sample_degree_random_edge_script;
    
    %Run the degree node removal experiment.
    %assignment_b_sample_degree_random_node_script;
end