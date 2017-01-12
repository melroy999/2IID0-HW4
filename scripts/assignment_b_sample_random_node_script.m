%The ratioage of the total size of the transitions that are removed in the experiment.
edge_removal_ratios = [0.05, 0.1, 0.2, 0.5];

%The sub folder to place these results in.
sub_folder = '/uniform_node_removal/';

%Make a directory for the results of this method.
mkdir([output_folder sub_folder]);

%Iterate over all amount of edges we want to delete.
for ratio = edge_removal_ratios
    %Get the actual count.
    count = floor(ratio * length(base_nodes));
    
    %Make sure that we have the exact same seed for every run.
    rng(1);
    
    %Calculate the base pagerank.
    base_pagerank = sparse_power_with_teleport(base_edges, length(base_nodes));
    base_rank = get_ranking(base_pagerank);

    %Start the experiment.
    iterations = 20;
    rank_errors = zeros(iterations, 1);
    value_errors = zeros(iterations, 1);
    experiment_results = {};
    experiment_pageranks = {};
    experiment_ranks = {};
    experiment_degrees = {};

    for i = 1:iterations 
        %Randomly remove edges.
        [experiment_nodes, experiment_edges] = remove_random_nodes(base_nodes, base_edges, count);

        %Find the pagerank and rankings. Note here that we take the base nodes
        %length, as sparse matrix intialization will throw an error otherwise.
        experiment_pagerank = sparse_power_with_teleport(experiment_edges, length(base_nodes));
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
    
    %The experiment information to be stored in the file name.
    file_code = [num2str(iterations) '_' num2str(count)];

    %Get information about the rank errors.
    rank_error_mean = mean(rank_errors);
    rank_error_std = std(rank_errors);
    rank_error_min = min(rank_errors);
    rank_error_max = max(rank_errors);
    value_error_mean = mean(value_errors);
    value_error_std = std(value_errors);
    value_error_min = min(value_errors);
    value_error_max = max(value_errors);
    
    %Get information about the rank sum.
    rank_sum_array = sum(cell2mat(experiment_ranks)).';
    rank_sum_mean = mean(rank_sum_array);
    
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
    header = 'rank_error_mean;rank_error_std;value_error_mean;value_error_std;rank_sum_mean';
    write_output_csv(output_file, [rank_error_mean rank_error_std value_error_mean value_error_std rank_sum_mean], header);

    %Output the rank sum values.
    output_file = [output_folder sub_folder 'rank_sum_' file_code '.csv'];
    header = 'Rank_sums';
    write_output_csv(output_file, [rank_sum_array], header);
    
    %Output all value and rank errors, with sum information.
    output_file = [output_folder sub_folder 'evolution_error_result_' file_code '.csv'];
    header = 'rank_error;value_error;rank_sum';
    write_output_csv(output_file, [rank_errors value_errors rank_sum_array], header);

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

    title(['Boxplot of the rank error (' num2str(ratio) ' ratio)']);
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
    
    title(['Boxplot of the value error (' num2str(ratio) ' ratio)']);
    print([output_folder sub_folder 'value_error_boxplot_' file_code],'-dpng','-r300')

    %Draw a box plot with all experiment results side by side.
    figure;
    set(gcf,'visible','off')
    
    boxplot(cell2mat(experiment_pageranks));
    set(gcf,'position',[0,0,960,250]);
    set(gcf, 'renderer', 'zbuffer')

    ylabel('PageRank values');
    xlabel(['Random runs with ' num2str(count) ' (' num2str(ratio) ' ratio) randomly removed nodes']);
    title(['PageRanks in experiment (' num2str(ratio) ' ratio)']);
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
    xlabel(['Random runs with ' num2str(count) ' (' num2str(ratio) ' ratio) randomly removed nodes']);
    title(['PageRanks in experiment (' num2str(ratio) ' ratio)']);
    print([output_folder sub_folder 'pagerank_log_boxplots_' file_code],'-dpng','-r300')
    
    %Draw a box plot with all experiment degrees side by side.
    figure;
    set(gcf,'visible','off')

    boxplot(cell2mat(experiment_degrees));
    set(gcf,'units','pixel');
    ylim([0 max(base_degrees)])
    set(gcf,'position',[0,0,960,250]);

    ylabel('Node degree');
    xlabel(['Random runs with ' num2str(count) ' (' num2str(ratio) ' ratio) randomly removed nodes']);
    title(['Node degrees in experiment (' num2str(ratio) ' ratio)']);
    print([output_folder sub_folder 'degree_boxplots_' file_code],'-dpng','-r300')
    
    
    %%%Draw a collection of all results in one figure.
    figure;
    set(gcf,'visible','off')
    set(gcf,'position',[0,0,1080,660]);
    
    subplot(4,4,[1 2 5 6])
    boxplot(cell2mat(experiment_pageranks));
    set(gcf,'units','pixel');
    set(gca,'YScale','log')
    set(gca,'YTick',[0 0.0005 0.001 0.005 0.01 0.05, 0.1])
    
    ylabel('PageRank values (log scale)');
    title(['PageRank values of the random runs']);
    
    
    subplot(4,4,[3 4 7 8])
    boxplot(cell2mat(experiment_degrees));
    set(gcf,'units','pixel');

    ylabel('Node degree');
    title(['Node degrees within the random runs']);
    
    
    subplot(4,4,[9 10 11 12])
    set(gcf, 'renderer', 'zbuffer')
   
    boxplot(rank_errors, {' '}, 'orientation', 'horizontal');
    set(gcf,'units','pixel');
    xlabel(['Mean: ' num2str(rank_error_mean) ', Standard deviation: ' num2str(rank_error_std)  ', Min: '  num2str(rank_error_min)  ', Max: '  num2str(rank_error_max) ', Mean rank sum: ' num2str(rank_sum_mean)])

    title(['Boxplot of the rank error']);
    
    
    subplot(4,4,[13 14 15 16])
    set(gcf, 'renderer', 'zbuffer')
    
    boxplot(value_errors, {' '}, 'orientation', 'horizontal');
    set(gcf,'units','pixel');
    xlabel(['Mean: ' num2str(value_error_mean) ', Standard deviation: ' num2str(value_error_std)  ', Min: '  num2str(value_error_min)  ', Max: '  num2str(value_error_max)])
    
    title(['Boxplot of the value error']);
    
    suptitle(['Figures for uniform random node removal (ratio ' num2str(ratio) ', count ' num2str(count) ')']);
    
    
    print([output_folder sub_folder 'collective_' file_code],'-dpng','-r300')
end
