%% Exercicio 1
clc;clear;

%% Função Principal
filename = 'bunny.obj';                     % arquivo obj
[V,F] = read_obj(filename);                 % read obj
estrelas = estrela_vertice(V, F);           % estrelas do vértice
[na] = normalGS(V, estrelas);               % normal por vértice (Gouraud shading)

%% ---------------------- plot ---------------------------
hold on
trisurf(F, V(:,1),V(:,2),V(:,3))
quiver3(V(:,1),V(:,2),V(:,3),na(:,1),na(:,2),na(:,3),'r')
hold off


%% estrelas do vertice
function estrelas = estrela_vertice(vertices, faces)
% função que determina todos os triângulos incidentes em cada vértice da
% malha
    % INPUT: vértices e faces.
    % OUTPUT: estrelas, estrutura dos triângulos incidentes

  indices = [1:size(faces,1)];                  % índices das faces
  faces = [faces indices'];                     % concatena as faces com seu índice
  nvertices = size(vertices,1);                 % número de vertices
    
  % for que percorre todos os vértices
  for vertex = 1:nvertices
    f1 = faces(faces(:,1)==vertex,:);           % faces cujo primeiro componente é o vertex escolhido
    f2 = faces(faces(:,2)==vertex,[2 3 1 4]);   % faces cujo segundo componente é o vertex escolhido 
    f3 = faces(faces(:,3)==vertex,[3 1 2 4]);   % faces cujo terceiro componente é o vertex escolhido
    f = [f1;f2;f3];                             % concatena todos os triângulos que são incidentes do mesmo vértice
    
    estrela = f(1,:);
    % sentido das células (anti-horário)
    for i = 1:size(f,1)-1
      celulas = f(f(:,2)==estrela(i,3),:);
      if size(celulas,1) ~= 1 
        return
      end
      estrela = [ estrela; celulas];            % a primeira linha é a estrela
    end
    estrelas(vertex).estrela = estrela;         % salva a estrutura
  end

end

%% normal Gouraud Shading
function [na] = normalGS(V, estrelas)
% funçao que calcula a normal por vértice do triangulo (Gouraud shading)
    % INPUT: V, vertices da malha.  
           % estrelas, estrutura de dados com os triângulos incidentes de
    %cada vértice
    % OUTPUT: na, a normal por vértice (Gouraud shading)

nt = zeros(size(estrelas,2),3);
na = nt;
% Normal por face
for vertex = 1:size(estrelas,2)
    
    soma = 0;
    % cálculo da área de cada triângulo incidente de cada vértice
    for i = 1:size(estrelas(vertex).estrela,1)
        a = V(estrelas(vertex).estrela(i,1),:);
        b = V(estrelas(vertex).estrela(i,2),:);
        c = V(estrelas(vertex).estrela(i,3),:);
        
        % cálculo da normal por face
        nt = cross((b-a),(c-a))./norm(cross((b-a),(c-a)));              % produto vetorial
        
        arestas = sum(sqrt([b-a;c-a;c-b].^2),2);                        % arestas do triângulo
        s = (arestas(1) + arestas(2) + arestas(3))/2;                   % semiperímetro do triângulo

        % Fórmula de Heron
        area = sqrt(abs(s*(s-arestas(1))*(s-arestas(2))*(s-arestas(3))));    % área do triângulo
        soma = nt*area + soma;
        
    end 
        
        na(vertex,:) = soma/norm(soma);                                 % normal por vértice (Gouraud shading)
end
end