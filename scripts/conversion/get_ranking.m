function rank = get_ranking(pagerank)
    pagerank_sorted = sort(pagerank, 'descend');
    [~, rank] = ismember(pagerank, pagerank_sorted);
end