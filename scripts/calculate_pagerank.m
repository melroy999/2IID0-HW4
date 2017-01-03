pagerank = sparse_power_with_teleport('transition.txt');
rank = get_ranking(pagerank);

%Write to csv file.
dlmwrite('pagerank_result.csv', [pagerank, rank], 'delimiter', ';', 'precision', 12);
