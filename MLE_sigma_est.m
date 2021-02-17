%First generate a large data set of 2500 points. 
%Generate the x values for these data points from a uniform distribution on the interval [0,10]. 
%Generate the noise term for each data point using a normal random variable 
%with the mean and variance specified in the problem statement.

N = 2500; %sample size
mu = 0; %mean
sigma = 1; %variance
x = unifrnd(0, 10, [1,N]); %uniform distribution x variable
e = normrnd(mu,sigma,[1,N]); %normal distribution noise

% Next, for each batch of data (n = 5, to whatever seems reasonable to you), 
%sample random points from the 2500 data point initial data set. 
%Do this a number of times for each batch size to compute the average value 
%as requested in the problem statement. 

batches = 500; %samples in each batch
bsize = 1000; %batch size

sigma_est = zeros([1,bsize/5]); %initialize sigma estimation
w = [0.2; 0.5; 0.1]; %weight vector 3x1

for trial = 5:5:bsize
    idx = randi(N, 1, batches); %random indices
    mu = sum(x(idx)) / batches; %batch mean
    x_b = x(idx); %batch x
    X = [ones([1,batches]); x_b; x_b.^2]; %3x2500    
    y = w'*X+e(idx); %1*3 x 3x2500 = 1x2500 + 1x2500 
    sigma_est(trial/5) = 1/batches*sum((y-mu).^2); %maximum likelihood estimate
end

% Your results should include a plot demonstrating the relationship between 
%the sigma^2 estimate and the batch size. In addition, be sure to offer 
%a qualitative discussion of whether the ML estimate is unbiased or not, 
%as requested in the problem statement.

clf(figure(1));
plot(5:5:bsize, sigma_est, 'b-', 'LineWidth', 3) %plotting x 
title(sprintf('\\sigma^2 vs batch size (N=%.1f)',N));

disp(mean(sigma_est)); % average estimated variance