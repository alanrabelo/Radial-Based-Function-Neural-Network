clear;
close all;
clc;

numeroDeAmostras = 1000;
numeroDeAmostrasParaTeste = 100;
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



randomIndexes = randperm(numeroDeAmostras);

X_treino = X(randomIndexes(1:numeroDeAmostrasParaTreino));
X_teste = X(randomIndexes(numeroDeAmostrasParaTreino+1:numeroDeAmostras));

Y_treino = Y(randomIndexes(1:numeroDeAmostrasParaTreino));
Y_teste = Y(randomIndexes(numeroDeAmostrasParaTreino+1:numeroDeAmostras));

centros = X(randomIndexes(1:numeroDeBases));

repX_treino  = repmat(X_treino, 1, numeroDeBases);
repCentros = repmat(centros, 1, numeroDeAmostrasParaTreino).';

% % funcao gaussiana

H = exp(-1/2*(repX_treino - repCentros).^2/valorDeSigma.^2);
H = [repmat(-1, numeroDeAmostrasParaTreino, 1) H];

% W = (inv((H'*H))*H')*Y2

inverseOfInputs = inv(H' * H);
weights =  ((H'*H)\H')*Y_treino;

% Fase de Testes
repCentros = repmat(centros, 1, numeroDeAmostrasParaTeste).';
repX_teste  = repmat(X_teste, 1, numeroDeBases);
H_teste = [repmat(-1, numeroDeAmostrasParaTeste, 1) exp(-1/2*(repX_teste - repCentros).^2/valorDeSigma.^2)];

% Y_final = H_teste.' * weights.';
Y_final = H_teste * weights;

erro = sqrt(sum((Y_final - Y_teste).^2));

plot(X_teste, Y_final, 'rx'); hold on;
plot(X_teste, Y_teste, 'b.');

function y = gaussiana(x, centro, abertura)
    y = exp( 0.5 * -(x(:,1) - centro(:,1)).^2 / abertura);
end





