%Calculate the value-based error.
function error = get_value_based_error(baseline_rank, baseline_pagerank, pagerank)
    error = 0;
    for i = 1:length(baseline_rank)
        error = error + abs(pagerank(i)-baseline_pagerank(i))/baseline_rank(i);
    end
end