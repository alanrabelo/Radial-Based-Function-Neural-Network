clear;
close all;
clc;

numeroDeAmostras = 1000;
k =  5;
numeroDeAmostrasParaTeste = numeroDeAmostras/k;
numeroDeAmostrasParaTreino = numeroDeAmostras - numeroDeAmostrasParaTeste;
taxaDeAprendizado = 0.01;
numeroDeBases = 30;
valorDeSigma = 0.3;

nValue = 0.1;

X = 0:0.01:10;
X = X';
Y = sin(X);
Y = Y';
noise = nValue*randn(1, length(Y)) - nValue/2;
Y = Y + noise;
Y = Y';

erroGeral = zeros(32,10);
desvioPadrao = zeros(32,10);

erroMinimo = 1000;
indexesOfMinimo = [0 0];

quantidadeDeTestes = 100;

for testCount = 1:quantidadeDeTestes
    
    for numeroDeBases = 5:5:160
        
        for valorDeSigma = 0.05 : 0.05: 0.5
            
            randomIndexes = randperm(numeroDeAmostras);
            
            
            totalLength = size(randomIndexes, 2);
            length = size(randomIndexes, 2)/k;
            
            test = zeros(length, k);
            trainning = zeros(totalLength - length, k);
            
            for i = 0:k-1
                
                testInitialPosition = i*length+1;
                testFinalPosition =  i*length+length;
                
                X_treino = X([randomIndexes(1:testInitialPosition-1)  randomIndexes(testFinalPosition+1 : totalLength)]);
                X_teste = X(randomIndexes(testInitialPosition : testFinalPosition));
                
                Y_treino = Y([randomIndexes(1:testInitialPosition-1)  randomIndexes(testFinalPosition+1 : totalLength)]);
                Y_teste = Y(randomIndexes(testInitialPosition : testFinalPosition));
%                 centros = X(randomIndexes(1:numeroDeBases));
                centros = X_treino(1:numeroDeBases);
                
                
                repX_treino  = repmat(X_treino, 1, numeroDeBases);
                repCentros = repmat(centros, 1, numeroDeAmostrasParaTreino).';
                
                % % funcao gaussiana
                
                H = exp(-1/2*(repX_treino - repCentros).^2/valorDeSigma.^2);
                H = [repmat(-1, numeroDeAmostrasParaTreino, 1) H];
                
                % W = (inv((H'*H))*H')*Y2
                
                weights =  ((H'*H)\H')*Y_treino;
                
                % Fase de Testes
                repCentros = repmat(centros, 1, numeroDeAmostrasParaTeste).';
                repX_teste  = repmat(X_teste, 1, numeroDeBases);
                H_teste = [repmat(-1, numeroDeAmostrasParaTeste, 1) exp(-1/2*(repX_teste - repCentros).^2/valorDeSigma.^2)];
                
                % Y_final = H_teste * weights;
                Y_final = H_teste * weights;
                
                erro = sqrt(sum((Y_final - Y_teste).^2));                
                
                erroGeral(numeroDeBases / 5, floor(valorDeSigma * 20)) = erroGeral(numeroDeBases / 5, floor(valorDeSigma * 20)) + erro;

            end
            
            if erroGeral(numeroDeBases / 5, floor(valorDeSigma * 20)) ./k < erroMinimo
                    erroMinimo = erroGeral(numeroDeBases / 5, floor(valorDeSigma * 20)) ./ k;
                    indexesOfMinimo = [numeroDeBases valorDeSigma];
                    
             end
        end
    end
    disp(testCount)
end

erroGeral = erroGeral ./ (k * quantidadeDeTestes);
erroMin = min(min(erroGeral));
[row,col] = find(erroGeral==erroMin);
disp(row*5)
disp(col * 0.05)



figure
bar3(erroGeral)

H=bar3(erroGeral);
hx=get(H(1),'parent'); % all bars have the same axes parent.

Hty=get(hx,'ylabel');

set(Hty,'string','Sigma');
set(hx,'yticklabel',num2str([5:5:160]')) % assume you have

hy=get(H(2),'parent'); % all bars have the same axes parent.
Htx=get(hy,'xlabel');
set(Htx,'string','Centros');
set(hy,'xticklabel',num2str([0.05:0.05:0.5]')) % assume you have

function y = gaussiana(x, centro, abertura)
y = exp( 0.5 * -(x(:,1) - centro(:,1)).^2 / abertura);
end





