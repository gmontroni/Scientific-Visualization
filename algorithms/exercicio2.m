%% Exercício 2
clc;clear;
load('dados_discretos.mat');                % malha

Pi = [D.verts];                             % pontos da malha  
%p = [-1.7,1.6];                            % exemplo 
p = input('Escolha o ponto p = [x,y]: ');

%% Busca dos k vértices mais próximos
k = 20;                                     % k  vértices vizinhos
[idx,~] = knnsearch(Pi,p,'k',k);            % método knn

%% Respectivos triângulos que compõem cada índice k

triangles = zeros(1,3);
for j=1:3
    for i=1:k
        % encontra todos os triângulos de cada vértice
        triangle = D.trigs(idx(i) == D.trigs(:,j),:);
        triangles = [triangles; triangle];  % Concatena os triângulos
    end
end
triangles = triangles(2:end,:);

%% Teste para identificar qual triângulo o ponto pertence

%Sistema Linear para o cálculo de lambda
trig = zeros(3,3);       
P = [1; p(1,:)'];                           % vetor independente

% teste para saber se o ponto já está dentro de algum triângulo da malha
for i=1:k
   
    A = [[1,1,1];Pi(triangles(i,:),:)'];    % Matriz A
    lambda = A\P;                           % lambda (resolução do sistema)

    % caso algum lambda seja negativo
    if min(lambda) < 0
        % se o for chegar ao número máximo de iterações e não encontrar o
        % triângulo correto
        if i == k
            disp('ERROR !!!')
            disp('Verifique se o ponto pertence ao intervalo da malha.');
            disp('Caso sim, escolha um k maior.');
            trisurf(D.trigs,D.verts(:,1),D.verts(:,2),D.fi,'FaceColor','Interp')
            return
        else
            continue
        end
    else % caso em que  todos são positivos
        idxtrig = triangles(i,:);           % indice dos vértices do triângulo
        fi = D.fi(idxtrig);                 % respectiva fi dos vértices
        trig(:,:) = A(:,:);                 % coordenada dos triângulos
        break
    end
end
P1 = trig(:,3);
P2 = trig(:,1);
P3 = trig(:,2);

%% Célula de Referência

% regra de cramer
E = det([P,P1,P2])/det([P1,P2,P3]);
n = det([P,P2,P3])/det([P1,P2,P3]);

%% função de base local (p/ interpolação bilinear) do triângulo
phi1 = 1-E-n;
phi2 = E;
phi3 = n;

phi = [phi1;phi2;phi3];
%% Cálculo da F
soma = 0;
for i=1:3
    soma = fi(i)*phi(i) + soma;
end

F = soma;
fprintf('F([%4.2f,%4.2f ]) = %4.4f \n', p(1), p(2), F)

%% ---------------------- plot ---------------------------
hold on
trisurf(D.trigs,D.verts(:,1),D.verts(:,2),D.fi,'FaceColor','Interp')
cb = colorbar();
title(cb, 'F(p)')
plot3(p(1),p(2),F,'*r')
hold off