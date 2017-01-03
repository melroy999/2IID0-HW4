%Call the eigenvalue solver without teleportation.
function x = eigensolver_without_teleport(A, num)
    i = A(:,1);
    j = A(:,2);

    G = sparse(i,j,1,num,num);
    c = full(sum(G));
    k = find(c~=0);
    D = sparse(k,k,1./c(k),num,num);
    A = G*D;

    % call eigensolver
    [V, D] = eigs(A);
    x = V(:,1);
    x = x/sum(x);
end