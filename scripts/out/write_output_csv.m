%Write the results to a csv file.
function write_output_csv(output_file, data, header)
    output_file_id = fopen(output_file, 'w');
    fprintf(output_file_id, header);
    fclose(output_file_id);

    dlmwrite(output_file, data, '-append', 'delimiter', ';', 'precision', 12, 'roffset', 1);
end