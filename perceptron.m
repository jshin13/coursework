%% HW1
% Perceptron

%% Student Info
% Name: Jong Shin
% JHED-ID: jshin69

%% Load input, output data
input_  = load('input.dat');
output_ = load('output.dat');

%% shuffle sample (randomization improves performance)
%idx = randperm(200,200);
%input_ = input_(idx,:);
%output_ = output_(idx);

%% Init params
num_iterations = 1000; % number of total iterations
num_datapoints = size(input_, 1); % number of data points in the input file
w = zeros(10,1); % initial weights
y_hat = nan(size(output_)); % output prediction
c = zeros(num_iterations,1); % initialize counter

%% Main Loop
for counter_iteration = 1 : 1 : num_iterations
    
    for counter_data = 1 : 1 : num_datapoints
        
        x_i = input_(counter_data,1:10); %training sample in 1x10
        y_i = output_(counter_data,1); %training label
        yhat_i = x_i*w; %y_hat prediction in 1x10 * 10x1
        
        % sign funciton
        if yhat_i > 0
            y_hat(counter_data) = 1; %pred greater than 0 is 1
        elseif yhat_i < 0
            y_hat(counter_data) = -1;%pred less than 0 is -1
        else
            y_hat(counter_data) = 0; %error is 0
        end
        
        if y_i ~= y_hat(counter_data) %conditional on mismatch
            w = w + ((y_i - y_hat(counter_data))*x_i)'; % weight update (1x1 * 1x10)
            c(counter_iteration) = c(counter_iteration) + 1; % counter update
        end  
        
    end
    
end

%% Plot results
clf(figure(1))

plot([1:num_iterations],[c]) %plotting counter
ylabel('Number of wrong predictions (#)')
xlabel('Iteration number (#)')
title('Perceptron Performance')

%% Extra credit part

%% load data
t0 = ones(28); %inital matrix   
fid=fopen('data0','r'); %-- open the file corresponding to digit 0
for i = 1:1:1000 % iterate over all 1000 samples
    [temp,N]= fread(fid,[28 28],'uchar'); %-- read in the first training example and store it in a 28x28 size matrix t1
    t0 = cat(3, t0, temp); % concatenate new matrix
end
t0 = t0(:,:,2:end); %remove the initial matrix

t1 = ones(28); %inital matrix
fid=fopen('data1','r'); %-- open the file corresponding to digit 0
for i = 1:1:1000 % iterate over all 1000 samples
    [temp,N]= fread(fid,[28 28],'uchar'); %-- read in the first training example and store it in a 28x28 size matrix t1
    t1 = cat(3, t1, temp); % concatenate new matrix
end
t1 = t1(:,:,2:end); %remove the initial matrix

%plotting digit images
for i = 1:1:10
    subplot(2,5,i);
    if i < 6
        imshow(t0(:,:,i)); % plotting digit = 0
    else
        imshow(t1(:,:,end-i)); % plotting digit = 1
    end
end

%% make a y label
t_y = [ones(1000,1)*-1; ones(1000,1)]; %making labels (-1 for digit 0, 1 for digit 1)

%% Create new features

% 1) the pixel at the center of the image 
% 2) the total average pixels over the entire location
% 3) the average pixels in a shape of cross.

%initalize feature values
val0_0 = 0;
val0_1 = 0;
val0_2 = 0;

val1_0 = 0;
val1_1 = 0;
val1_2 = 0;

%feature creation
for i = 1:1:1000
    temp = t0(:,:,i);
    val0_0 = [val0_0, temp(14,14)]; %getting the center pixel value for digit 0 
    val0_1 = [val0_1, sum(sum(temp))/784]; %average overall pixel value for digit 0
    val0_2 = [val0_2, (sum(temp(:,14)) + sum(temp(14,:)))/56]; %average pixel value in a cross shape for digit 0  
    
    temp = t1(:,:,i);
    val1_0 = [val1_0, temp(14,14)]; %getting the center pixel value for digit 1 
    val1_1 = [val1_1, sum(sum(temp))/784]; %average overall pixel value for digit 1
    val1_2 = [val1_2, (sum(temp(:,14)) + sum(temp(14,:)))/56]; %average pixel value in a cross shape for digit 1  
end

% concatenating 2000 x 3 feature input matrix
feature = [val0_0(2:end), val1_0(2:end); val0_1(2:end), val1_1(2:end); val0_2(2:end), val1_2(2:end)]';

idx = 1:1000; %x-axis indices

% visualize features
clf(figure(1))

for i = 1:1:3 %plotting features
    subplot(2,3,i)       
    scatter(idx, feature(1:1000,i)) %plotting digit = 0 
    title('digit=0');
    
    subplot(2,3,i+3)
    scatter(idx, feature(1001:end,i)) %plotting digit = 1 
    title('digit=1');    
end

%% Main Loop

num_iter = 500; % number of iteration
num_image = 200; % number of random images per iteration

w = zeros(3,1); % initial weights (3 x 1)
y_hat = nan(2000:1); % output prediction
c = zeros(num_iter,1); % initalize counter

for counter_iteration = 1 : 1 : num_iter
    
    rndidx = randperm(2000,num_image); %index for 200 random images
    
    for counter_data = 1 : 1 : num_image
        
        idx = rndidx(counter_data); %reindexing from random sampling
        x_i = feature(idx,:); % get a training sample
        y_i = t_y(idx); % get a corresponding label
        yhat_i = x_i*w; %%y_hat prediction in 1x3 * 3x1
        
        % sign funciton
        if yhat_i > 0
            y_hat(idx) = 1; %if pred greater than 1, y_hat is 1 (digit = 1)
        elseif yhat_i < 0
            y_hat(idx) = -1;%if pred less than 1, y_hat is -1 (digit = 0)
        else
            y_hat(idx) = 0; %error is 0
        end
        
        if y_i ~= y_hat(idx) %conditional on mismatch
            w = w + ((y_i - y_hat(idx))*x_i)'; % weight update (1x1 * 1x3)
            c(counter_iteration) = c(counter_iteration) + 1; % counter update        
        end
    end    
end

% plotting prediction result
clf(figure(1))

plot([1:num_iter],[c]) %plotting counter
ylabel('Number of wrong predictions (#)')
xlabel('Iteration number (#)')
title('Perceptron Performance')
