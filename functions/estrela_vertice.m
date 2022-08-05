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
      estrela = [ estrela; celulas];                % a primeira linha é a estrela
    end
    estrelas(vertex).estrela = estrela;               % salva a estrutura
  end

end