%The percentage of the total size of the transitions that are removed in the experiment.
edge_removal_percentages = [0.05, 0.1, 0.2, 0.5];

%The sub folder to place these results in.
sub_folder = '/uniform_edge_removal/';

%Make a directory for the results of this method.
mkdir([output_folder sub_folder]);

%Iterate over all amount of edges we want to delete.
for percent = edge_removal_percentages
    %Get the actual count.
    count = floor(percent * length(base_edges));
    
    %Make sure that we have the exact same seed for every run.
    rng(1);
    
    %Calculate the base pagerank.
    base_pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
    base_rank = get_ranking(base_pagerank);

    %Start the experiment.
    iterations = 25;
    rank_errors = zeros(iterations, 1);
    value_errors = zeros(iterations, 1);
    experiment_results = {};
    experiment_pageranks = {};
    experiment_ranks = {};
    experiment_degrees = {};

    for i = 1:iterations 
        %Randomly remove edges.
        experiment_edges = remove_random_edges(base_edges, count);
        experiment_nodes = base_nodes;

        %Find the pagerank and rankings.
        experiment_pagerank = sparse_power_with_teleport(experiment_edges, length(experiment_nodes));
        experiment_rank = get_ranking(experiment_pagerank);

        %Calculate the rank and value errors.
        rank_errors(i) = get_rank_based_error(experiment_nodes, base_rank, experiment_rank);
        value_errors(i) = get_value_based_error(experiment_nodes, base_rank, base_pagerank, experiment_pagerank);

        %Set the experiment's pagerank and rank for administration purposes.
        experiment_results = [experiment_results experiment_pagerank experiment_rank];
        experiment_pageranks = [experiment_pageranks experiment_pagerank];
        experiment_ranks = [experiment_ranks experiment_rank];
        experiment_degrees = [experiment_degrees get_degree(experiment_edges, length(base_nodes))];
    end

    rank_error_mean = mean(rank_errors);
    rank_error_std = std(rank_errors);
    rank_error_min = min(rank_errors);
    rank_error_max = max(rank_errors);
    value_error_mean = mean(value_errors);
    value_error_std = std(value_errors);
    value_error_min = min(value_errors);
    value_error_max = max(value_errors);
    
    %The experiment information to be stored in the file name.
    file_code = [num2str(iterations) '_' num2str(count)];
    
    %Write the results to a csv file.
    output_file = [output_folder sub_folder 'pagerank_result_' file_code '.csv'];
    header = 'Baseline PageRank;Baseline Rank';

    %Extend the size of the header, to also contain all results of the
    %experiments done above.
    for i = 1:iterations 
        header = [header ';Method_' num2str(i) '_PageRank' ';Method_' num2str(i) '_Rank'];
    end

    write_output_csv(output_file, [base_pagerank base_rank experiment_results], header);

    %Output mean and std of error values.
    output_file = [output_folder sub_folder 'evolution_error_summary_result_' file_code '.csv'];
    header = 'rank_error_mean;rank_error_std;value_error_mean;value_error_std';
    write_output_csv(output_file, [rank_error_mean rank_error_std value_error_mean value_error_std], header);

    %Output all value and rank errors.
    output_file = [output_folder sub_folder 'evolution_error_result_' file_code '.csv'];
    header = 'rank_error;value_error';
    write_output_csv(output_file, [rank_errors value_errors], header);

    %%%% Draw plots %%%%
    %Draw some fancy box plots for the error distribution.
    figure;
    set(gcf,'visible','off')
    set(gcf, 'renderer', 'zbuffer')
   
    boxplot(rank_errors, {' '}, 'orientation', 'horizontal');
    set(gcf,'units','pixel');
    xlabel(['Mean: ' num2str(rank_error_mean) ', Standard deviation: ' num2str(rank_error_std)  ', Min: '  num2str(rank_error_min)  ', Max: '  num2str(rank_error_max)])
    xlim([0 10000])
    set(gcf,'position',[0,0,960,125]);

    title(['Boxplot of the rank error (' num2str(percent) ' percent)']);
    print([output_folder sub_folder 'rank_error_boxplots_' file_code],'-dpng','-r300')

    %Draw some fancy box plots for the value distribution.
    figure;
    set(gcf,'visible','off')
    set(gcf, 'renderer', 'zbuffer')
    
    boxplot(value_errors, {' '}, 'orientation', 'horizontal');
    set(gcf,'units','pixel');
    xlabel(['Mean: ' num2str(value_error_mean) ', Standard deviation: ' num2str(value_error_std)  ', Min: '  num2str(value_error_min)  ', Max: '  num2str(value_error_max)])
    xlim([0 0.015])
    set(gcf,'position',[0,0,960,125]);
    
    title(['Boxplot of the value error (' num2str(percent) ' percent)']);
    print([output_folder sub_folder 'value_error_boxplot_' file_code],'-dpng','-r300')

    %Draw a box plot with all experiment results side by side.
    figure;
    set(gcf,'visible','off')
    
    boxplot(cell2mat(experiment_pageranks));
    set(gcf,'position',[0,0,960,250]);
    set(gcf, 'renderer', 'zbuffer')

    ylabel('PageRank values');
    xlabel(['Random runs with ' num2str(count) ' (' num2str(percent) ' percent) randomly removed edges']);
    title(['PageRanks in experiment (' num2str(percent) ' percent)']);
    print([output_folder sub_folder 'pagerank_boxplots_' file_code],'-dpng','-r300')

    %Draw a box plot with all experiment results side by side, in logarithmic scale.
    figure;
    set(gcf,'visible','off')
    
    boxplot(cell2mat(experiment_pageranks));
    set(gcf,'units','pixel');
    set(gca,'YScale','log')
    ylim([0 0.1])
    set(gca,'YTick',[0 0.0005 0.001 0.005 0.01 0.05, 0.1])
    set(gcf,'position',[0,0,960,250]);

    ylabel('PageRank values (log scale)');
    xlabel(['Random runs with ' num2str(count) ' (' num2str(percent) ' percent) randomly removed edges']);
    title(['PageRanks in experiment (' num2str(percent) ' percent)']);
    print([output_folder sub_folder 'pagerank_log_boxplots_' file_code],'-dpng','-r300')
    
    %Draw a box plot with all experiment degrees side by side.
    figure;
    set(gcf,'visible','off')

    boxplot(cell2mat(experiment_degrees));
    set(gcf,'units','pixel');
    ylim([0 max(base_degrees)])
    set(gcf,'position',[0,0,960,250]);

    ylabel('Node degree');
    xlabel(['Random runs with ' num2str(count) ' (' num2str(percent) ' percent) randomly removed edges']);
    title(['Node degrees in experiment (' num2str(percent) ' percent)']);
    print([output_folder sub_folder 'degree_boxplots_' file_code],'-dpng','-r300')
end

