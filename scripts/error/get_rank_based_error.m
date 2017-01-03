%Calculate the rank-based error.
function error = get_rank_based_error(baseline_rank, rank)
    error = 0;
    for i = 1:length(baseline_rank)
        error = error + abs(baseline_rank(i)-rank(i))/baseline_rank(i);
    end
end