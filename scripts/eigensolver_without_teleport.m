A = load('transition.txt', '-ascii');
i = A(:,1);
j = A(:,2);
num = 1490;

G = sparse(i,j,1,num,num);
c = full(sum(G));
k = find(c~=0);
D = sparse(k,k,1./c(k),num,num);
A = G*D;

% call eigensolver
[V, D] = eigs(A);
x = V(:,1);
x = x/sum(x);