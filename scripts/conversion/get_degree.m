function degree = get_degree(A, num)
    %Convert the given data to a form we can work with.
    i = A(:,1);
    j = A(:,2);
    G = sparse(i,j,1,num,num);

    %Compute the in and out degrees. Here out is the row, and in is the column.     
    %Note that we want both arrays to be the same size, we choose two column arrays, so invert the in degrees.
    out_degree = full(sum(G,2));                                            
    in_degree = full(sum(G)).';
    
    %The degree is the sum of the in and out degrees. 
    degree = out_degree + in_degree;
end