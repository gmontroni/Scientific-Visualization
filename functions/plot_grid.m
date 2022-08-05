function plot_grid(X,Y)
% X e Y são grids com posições

[m,n] = size(X);

hold on
for i=1:m   % linhas
    plot(X(i,:),Y(i,:),'k');
end

for j=1:n   % colunas
    plot(X(:,j),Y(:,j),'k');
end
hold off

end