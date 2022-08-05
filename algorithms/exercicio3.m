%% Exercício 3
clc;clear;

load('D.mat');                       % dados do problema

%% Nuvem de pontos
Pi = [D(:,1),D(:,2)];                % pontos da amostra
fi = D(:,3);                         % f da amostra

%% GRID
a = -2; b = 2; n = 32;
t = linspace(a,b,n);                 % intervalo de [a,b] com n pontos igualmente espaçados
[X,Y] = meshgrid(t);                 % malha
P = [X(:), Y(:)];                    % pontos do grid

%% Matriz dos phi
phi = pdist2(Pi,Pi,'euclidean');     % matriz das distâncias entre os pontos da amostra (função poli-harmônica)
lambda = phi\fi;                     % sistema linear para o cálculo de lambda    

%% Interpolaçao RBF (Exercício 3A)
phi1 = pdist2(Pi,P,'euclidean');     % matriz das distâncias dos pontos da amostra p/ os pontos da malha
F = zeros(n^2,1);
for i=1:n^2
    F(i) = sum(lambda.*phi1(:,i));   % F(p) = somatório(lambda * phi(p))     
end
F = reshape(F,[n,n]);

%% Marching Triangles (Exercício 3B)

[r] = marching_triangles(F,P);

%% ---------------------- plot ---------------------------
figure(1), scatter(D(:,1),D(:,2),70,D(:,3),'filled'); title('Nuvem de pontos')
figure(2), pcolor(X,Y,F); title('Interpolação RBF') 
% cb = colorbar(); title(cb, 'F(p)')
hold on
plot(r(:,1),r(:,2),'*r'); 
hold off
% figure(3), plot_grid(X,Y); title('GRID')

%% Algortimo de Marching Triangles
function [r] = marching_triangles(F,P)
% Função que avalia todos as arestas dos triângulos da malha a partir da
% mudança de sinal dos vértices e cálcula a interpolação linear na aresta
% onde existe a troca de sinal
    % INPUT: F, malha interpolada por RBF
    % OUTPUT: r, ponto aproximado da arestas que cortam a superfície em
    % F(r) = 0.

P1 = reshape(P(:,1), [32,32]);
P2 = reshape(P(:,2), [32,32]);
k=1;
% for para triangularização da malha
for i=1:size(F,1)-1
    for j=1:size(F,2)-1
        % Primeiro triângulo
        % if é a condiçao de mudança de sinal em cada vertice do triangulo
        if F(i,j)*F(i+1,j+1)<=0
            % Marching Triangles
            t = F(i,j)/(F(i,j)-F(i+1,j+1));
            r(k,:) = (1-t)*[P1(i,j),P2(i,j)] + t*[P1(i+1,j+1),P2(i+1,j+1)];
            k=k+1;
        end
        if F(i+1,j+1)*F(i,j+1)<=0
            t = F(i+1,j+1)/(F(i+1,j+1)-F(i,j+1));
            r(k,:) = (1-t)*[P1(i+1,j+1),P2(i+1,j+1)]  + t*[P1(i,j+1),P2(i,j+1)];
            k=k+1;
        end
        if F(i,j+1)*F(i,j)<=0
            t = F(i,j+1)/(F(i,j+1)-F(i,j));
            r(k,:) = (1-t)*[P1(i,j+1),P2(i,j+1)] + t*[P1(i,j),P2(i,j)];
            k=k+1;
        end

        % Segundo triângulo
        if F(i,j)*F(i+1,j)<=0
            t = F(i,j)/(F(i,j)-F(i+1,j));
            r(k,:) = (1-t)*[P1(i,j),P2(i,j)] + t*[P1(i+1,j),P2(i+1,j)];
            k=k+1;
        end
        if F(i+1,j)*F(i+1,j+1)<=0
            t = F(i+1,j)/(F(i+1,j)-F(i+1,j+1));
            r(k,:) = (1-t)*[P1(i+1,j),P2(i+1,j)] + t*[P1(i+1,j+1),P2(i+1,j+1)];
            k=k+1;
        end
        if F(i+1,j+1)*F(i,j)<=0
            t = F(i+1,j+1)/(F(i+1,j+1)-F(i,j));
            r(k,:) = (1-t)*[P1(i+1,j+1),P2(i+1,j+1)] + t*[P1(i,j),P2(i,j)];
            k=k+1;
        end
    end
end
end

function plot_grid(X,Y)
% Função que faz o plot de um grid
    % INPUT: X, Y são grids com posições
    % OUTPUT: plot grid
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