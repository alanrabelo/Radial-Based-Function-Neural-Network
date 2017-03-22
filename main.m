clear;
close all;
clc;

numeroDeAmostras = 1000;
numeroDeAmostrasParaTeste = 100;
numeroDeAmostrasParaTreino = numeroDeAmostras - numeroDeAmostrasParaTeste;
taxaDeAprendizado = 0.01;

x = linspace(-1,1,numeroDeAmostras);
y_orig = sin(x);
y = y_orig + rand(1, numeroDeAmostras)/5;
y_final = zeros(1,numeroDeAmostrasParaTreino);


indicesDeTreino = randperm(numeroDeAmostras);

x_treino = x(indicesDeTreino(1, 1:numeroDeAmostrasParaTreino));

x_teste = x(indicesDeTreino(1, numeroDeAmostrasParaTreino+1:numeroDeAmostras));

y_treino = y(indicesDeTreino(1, 1:numeroDeAmostrasParaTreino));
y_teste =  y(indicesDeTreino(1, numeroDeAmostrasParaTreino+1:numeroDeAmostras));






numeroDeBases = 30;
normalize = true;

sigma = 0.5;
beta = 1 ./ (2 .* sigma.^2);




indicesDasBases = randperm(numeroDeAmostrasParaTreino);
indicesDasBases = indicesDasBases(1:numeroDeBases);
menorErro = 1000;
pesosDoNeuronioDeSaida = zeros(numeroDeBases + 1, 1);
numeroDeEpocas = 1000;

for epoca = 1:numeroDeEpocas
    
    
    somatoriaDoErroPorEpoca = 0;
    for i=1:numeroDeAmostrasParaTreino
        
        entradasDoNeuronioDeSaida = zeros(numeroDeBases, 1);
        entradaAtual = x_treino(1, i);
        for j = 1:numeroDeBases
            baseAtual = x_treino(1, indicesDasBases(1,j));
            entradasDoNeuronioDeSaida(j, 1) = gaussiana(entradaAtual, baseAtual);
        end
        
        uDoNeuronioDeSaida = pesosDoNeuronioDeSaida.' * [-1; entradasDoNeuronioDeSaida];
        
        erroNaSaida = y_treino(1, i) - uDoNeuronioDeSaida;
        pesosDoNeuronioDeSaida = pesosDoNeuronioDeSaida + taxaDeAprendizado * erroNaSaida * [-1; entradasDoNeuronioDeSaida];
        somatoriaDoErroPorEpoca = somatoriaDoErroPorEpoca + erroNaSaida;
        
        if epoca == numeroDeEpocas || somatoriaDoErroPorEpoca < 0.5
            if somatoriaDoErroPorEpoca < menorErro
                menorError = somatoriaDoErroPorEpoca;
            end
            y_final(1, i) = uDoNeuronioDeSaida;
        end
        
    end
    
    if rem(epoca, 100) && epoca > 100
        disp(epoca/numeroDeEpocas);

        
    end
    
end

yDoTeste = zeros(1, numeroDeAmostrasParaTeste);

for entradaDoTeste = 1:numeroDeAmostrasParaTeste
    
    entradaAtual = x_teste(1, entradaDoTeste);

    entradasDoNeuronioDeSaidaDoTeste = zeros(numeroDeBases, 1);
    
    for j = 1:numeroDeBases
        baseAtual = x_treino(1, indicesDasBases(1,j));
        entradasDoNeuronioDeSaidaDoTeste(j, 1) = gaussiana(entradaAtual, baseAtual);
    end
    
    uDoNeuronioDeSaida = pesosDoNeuronioDeSaida.' * [-1; entradasDoNeuronioDeSaidaDoTeste];
    yDoTeste(1, entradaDoTeste) = uDoNeuronioDeSaida;
    erroNaSaida = y_teste(1, entradaDoTeste) - uDoNeuronioDeSaida;
    
end
% plot(t,x,'color','r'); hold on;
% plot(t,y,'color','b');

% plot(x_treino, y_treino,'.', 'color','r' ); hold on;
% plot(x_treino, y_final,'x', 'color','b');
plot(x_teste, y_teste,'.', 'color','r'); hold on;
plot(x_teste, yDoTeste,'x', 'color','b');
disp(menorErro);







function y = gaussiana(x, centro)
height = size(x,2);
sum = 0;

for i = 1:height
    sum = sum + (x(:,i) - centro(:,i)).^2;
end

y = exp( -sum);



end

function y = gaussianaAjalmar(x, centro, abertura)
height = size(x,2);
sum = 0;

for i = 1:height
    sum = sum + (x(:,i) - centro(:,i)).^2;
end

y = exp( 0.5 * -sum / abertura);



end

function y = ativacao(x)
y = x;
end




