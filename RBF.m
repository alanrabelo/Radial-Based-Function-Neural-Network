clear;close all;clc;

%Gerando pontos aleat�rios
X = 0:0.01:10;
X = X';
Y1 = sin(2*X);
Y1 = Y1';
nValue = 0.1;
noise = nValue*randn(1, length(Y1)) - nValue/2;
Y2 = Y1 + noise;
Y2 = Y2';

centers = 30;
sigma = 0.3;
inds =randperm(length(X));
c_inds = inds(1:centers);
c = X(c_inds, 1);

H = [];
for i = 1 : length(X)
    h = exp(-1/2*(repmat(X(i,:), length(c), 1) - c).^2/sigma.^2);
    H = [H; h'];
end

%Calculando W
bias = repmat(-1,length(H),1);
H = [bias H];
W = (inv((H'*H))*H')*Y2;



% plot(X,Y1,'r*');
% hold on;
% plot(X,Y2, 'b*');
% hold on;
% plot(X(c_inds,1), Y2(c_inds,1),'g*');
% hold off;