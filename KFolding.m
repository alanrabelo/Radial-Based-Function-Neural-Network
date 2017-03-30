clear;
close all;
clc;

indexes = 1:1000;

k =  5;

totalLength = length(indexes);
length = length(indexes)/k;

test = zeros(length, k);
trainning = zeros(totalLength - length, k);

for i = 0:k-1
    testInitialPosition = i*length+1;
    testFinalPosition =  i*length+length;
    trainning(:, i+1) = [1:testInitialPosition-1 testFinalPosition+1 : totalLength];
    test(:, i+1) = indexes(testInitialPosition : testFinalPosition);
end


