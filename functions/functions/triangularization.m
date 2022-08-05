function [tri] = triangularization(F)
% Função que avalia todos as arestas dos triângulos da malha a partir da
% mudança de sinal dos vértices e cálcula a interpolação linear na aresta
% onde existe a troca de sinal
    % INPUT:
    % OUTPUT:

k =1;
for i=1:size(F,1)-1
    for j=1:size(F,2)-1

        tri(k,:) = [F(i,j), F(i+1,j+1), F(i,j+1)];
        tri(k+1,:) = [F(i,j), F(i+1,j), F(i+1,j+1)];
        k=k+2;
    end
end
