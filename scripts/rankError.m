function error = rankError(baseline_rank, rank)
    error = 0;
    for i = 1:length(baseline_rank)
        error = error + abs(baseline_rank(i)-rank(i))/baseline(i);
    end
end