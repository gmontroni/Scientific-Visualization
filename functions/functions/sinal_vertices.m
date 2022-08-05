function [r] = sinal_vertices(F)
% Função que avalia todos as arestas dos triângulos da malha a partir da
% mudança de sinal dos vértices e cálcula a interpolação linear na aresta
% onde existe a troca de sinal
    % INPUT: F, malha interpolada por RBF
    % OUTPUT: r, ponto aproximado da arestas que cortam a superfície em
    % F(r) = 0.

k=1;
% for para triangularização da malha
for i=1:size(F,1)-1
    for j=1:size(F,2)-1
        % Primeiro triângulo
        % if é a condiçao de mudança de sinal em cada vertice do triangulo
        if F(i,j)*F(i+1,j+1)<=0
            % Marching Triangles
            t = F(i,j)/(F(i,j)-F(i+1,j+1));
            r(k,:) = (1-t)*[i,j] + t*[i+1,j+1];
            k=k+1;
        end
        if F(i+1,j+1)*F(i,j+1)<=0
            t = F(i+1,j+1)/(F(i+1,j+1)-F(i,j+1));
            r(k,:) = (1-t)*[i+1,j+1] + t*[i,j+1];
            k=k+1;
        end
        if F(i,j+1)*F(i,j)<=0
            t = F(i,j+1)/(F(i,j+1)-F(i,j));
            r(k,:) = (1-t)*[i,j+1] + t*[i,j];
            k=k+1;
        end

        % Segundo triângulo
        if F(i,j)*F(i+1,j)<=0
            t = F(i,j)/(F(i,j)-F(i+1,j));
            r(k,:) = (1-t)*[i,j] + t*[i+1,j];
            k=k+1;
        end
        if F(i+1,j)*F(i+1,j+1)<=0
            t = F(i+1,j)/(F(i+1,j)-F(i+1,j+1));
            r(k,:) = (1-t)*[i+1,j] + t*[i+1,j+1];
            k=k+1;
        end
        if F(i+1,j+1)*F(i,j)<=0
            t = F(i+1,j+1)/(F(i+1,j+1)-F(i,j));
            r(k,:) = (1-t)*[i+1,j+1] + t*[i,j];
            k=k+1;
        end
    end
end
end