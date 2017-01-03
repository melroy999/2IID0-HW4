%Call the power method using A as a sparse matrix with teleportation.
function x = sparse_power_with_teleport(A, num)
    A = sparse(A);%Make the initial version of A sparse.
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

    x = e/num;
    oldx = zeros(num,1);
    while norm(x - oldx) > .00001
        oldx = x;
        x = A*x;
    end
    x = x/sum(x);
end
