%Load the original matrix, of which the values can be found within the corresponding files.
base_edges = load(transition_file, '-ascii');
base_nodes = [1:max(base_edges(:))].';
num = length(base_nodes);
base_degrees = get_degree(base_edges, num);

%Make a directory for the results of this assignment.
mkdir([output_folder '/assignment_1']);

%%%Calculate the pageranks for each method.
ewt_pagerank = eigensolver_with_teleport(base_edges, length(base_nodes));
ewt_rank = get_ranking(ewt_pagerank);

enwt_pagerank = eigensolver_without_teleport(base_edges, length(base_nodes));
enwt_rank = get_ranking(enwt_pagerank);

pwt_pagerank = power_with_teleport(base_edges, length(base_nodes));
pwt_rank = get_ranking(pwt_pagerank);

pnwt_pagerank = power_without_teleport(base_edges, length(base_nodes));
pnwt_rank = get_ranking(pnwt_pagerank);

spwt_pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
spwt_rank = get_ranking(spwt_pagerank);


%%%Write results to CSV files.
output_file = [output_folder '/assignment_1/method_pagerank_results.csv'];

%Define the pagerank and rank headers in the table.
pagerank_headers = {'eigensolver_with_teleport_pagerank;' 'eigensolver_without_teleport_pagerank;' 'power_with_teleport_pagerank;' 'power_without_teleport_pagerank;' 'sparse_power_with_teleport_pagerank;'};
rank_headers = {'eigensolver_with_teleport_rank;' 'eigensolver_without_teleport_rank;' 'power_with_teleport_rank;' 'power_without_teleport_rank;' 'sparse_power_with_teleport_rank'};
method_names = {'eigensolver_with_teleport' 'eigensolver_without_teleport' 'power_with_teleport' 'power_without_teleport' 'sparse_power_with_teleport'};

%Define the arrays of values.
pageranks = [ewt_pagerank enwt_pagerank pwt_pagerank pnwt_pagerank spwt_pagerank];
ranks = [ewt_rank enwt_rank pwt_rank pnwt_rank spwt_rank];

%Write the output to a csv file.
write_output_csv(output_file, [base_degrees pageranks ranks], strjoin(['degree;' pagerank_headers rank_headers], ''));


%%%Create the figures.
%Write all the results to a single boxplot. This may error.
try
    boxplot(pageranks, method_names, 'orientation', 'horizontal');
    set(gcf,'units','pixel');
    set(gcf,'position',[0,0,960,450]);
    set(gca,'XScale','log')

    xlabel('PageRank values');
    title('The PageRank values for each method');
    print([output_folder '/assignment_1/method_boxplots_all'],'-dpng','-r300')
catch
    disp('An error occurred while drawing the 5 method boxplot.');
    disp('Execution will continue.');
end


%Write all results to a single boxplot, with the exception of
%eigensolver_without_teleport:
boxplot(pageranks(:,[1, 3, 4, 5]), method_names([1, 3, 4, 5]), 'orientation', 'horizontal');
set(gcf,'units','pixel');
set(gcf,'position',[0,0,960,450]);
set(gca,'XScale','log')

xlabel('PageRank values');
title('The PageRank values for each method (minus eigensolver without teleport)');
print([output_folder '/assignment_1/method_boxplots_minus_enwt'],'-dpng','-r300')

%Draw the enwt boxplot individually.
try
    boxplot(enwt_pagerank, method_names(2), 'orientation', 'horizontal');
    set(gcf,'units','pixel');
    set(gcf,'position',[0,0,960,150]);
    set(gca,'XScale','log')

    xlabel('PageRank values');
    title('The PageRank values for eigensolver without teleport');
    print([output_folder '/assignment_1/method_boxplot_enwt'],'-dpng','-r300')
catch
    disp('An error occurred while drawing the enwt boxplot.');
    disp('Execution will continue.');
end

%Plot the degrees as a bar diagram.
histogram(base_degrees, 150)
set(gcf,'units','pixel');
set(gcf,'position',[0,0,960,450]);

xlabel('Node degree');
title('The node degrees in the initial graph');
print([output_folder '/assignment_1/degrees_histogram'],'-dpng','-r300')