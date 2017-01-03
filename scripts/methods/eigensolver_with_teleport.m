%Call the eigenvalue solver with teleportation.
function x = eigensolver_with_teleport(A, num)
    i = A(:,1);
    j = A(:,2);

    G = sparse(i,j,1,num,num);
    c = full(sum(G));
    k = find(c~=0);
    D = sparse(k,k,1./c(k),num,num);
    e = ones(num,1);

    % adding the teleport
    p = 0.85;
    z = ((1-p)*(c~=0)+(c==0))/num;
    A = p*G*D+e*z;

    % call eigensolver
    [V, D] = eigs(A);
    x = V(:,1);
    x = x/sum(x);
end