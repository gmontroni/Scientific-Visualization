function na = normalGS(V, estrelas)
% funçao que calcula a normal por vértice do triangulo (Gouraud shading)
    % INPUT: V, vertices da malha.  
           % estrelas, estrutura de dados com os triângulos incidentes de
    %cada vértice
    % OUTPUT: na, a normal por vértice (Gouraud shading)

nt = zeros(size(estrelas,2),3);
na = nt;

% Normal por face
for vertex = 1:size(estrelas,2)
    
    a = V(estrelas(vertex).estrela(1,1),:);
    b = V(estrelas(vertex).estrela(1,2),:);
    c = V(estrelas(vertex).estrela(1,3),:);
    % cálculo da normal por face
    nt(vertex,:) = cross((b-a),(c-a))./norm(cross((b-a),(c-a)));    % produto vetorial
    
    soma = 0;
    % cálculo da área de cada triângulo incidente de cada vértice
    for i = 1:size(estrelas(vertex).estrela,1)
        a = V(estrelas(vertex).estrela(i,1),:);
        b = V(estrelas(vertex).estrela(i,2),:);
        c = V(estrelas(vertex).estrela(i,2),:);
        
        arestas = sum(sqrt([b-a;c-a;c-b].^2),2);                        % arestas do triângulo
        s = (arestas(1) + arestas(2) + arestas(3))/2;                   % semiperímetro do triângulo

        % Fórmula de Heron
        area = sqrt(s*(s-arestas(1)*(s-arestas(2)*(s-arestas(3)))));    % área do triângulo
        soma = nt(vertex,:)*area + soma;
    end
        na(vertex,:) = soma/norm(soma);                                 % normal por vértice (Gouraud shading)
end

end