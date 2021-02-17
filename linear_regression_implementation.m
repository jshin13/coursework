%% Load the images and their labels

data = load('classify_regress.txt'); %loading training data

%% 1. Visualize data

b0 = ones(length(data),1); %bias term
X1 = data(:,1); 
X2 = data(:,2);
X = [b0 X1 X2]; %new dataset with bias term
C = data(:,3); %label
subplot(1,1,1);
gscatter(X1,X2,C,'rg');

%% Init params
num_iterations = 1; % number of total iterations
num_datapoints = length(X1); % number of data points in the input file
w = zeros(3,1); % initial weights
y_hat = nan(size(C)); % output prediction
eta = 0.9; %learning rate
c = zeros(num_iterations,1); % initialize counter

%% Main Loop
for counter_iteration = 1 : 1 : num_iterations
    
    for counter_data = 1 : 1 : num_datapoints
        
        x_i = data(counter_data,1:3); %training sample in 1x3
        y_i = C(counter_data,1); %training label
        yhat_i = x_i*w; %y_hat prediction in 1x3 * 3x1
        
        % sign funciton
        if yhat_i > 0.5
            y_hat(counter_data) = 1; %pred greater than 0 is 1
        elseif yhat_i <= 0.5
            y_hat(counter_data) = 0;%pred less than 0 is -1
        end
        
        if y_i ~= y_hat(counter_data) %conditional on mismatch
            w = w + eta*(x_i*x_i').^-1*(y_i-x_i*w).*x_i'; % weight update (dim below)
            % (3x1) + (1x3*3x1)*(1x1-1x3*3x1)*1x3
            % (3x1) + (1x1)*(1x1)*3x1 = 3x1
            c(counter_iteration) = c(counter_iteration) + 1; % counter update
        end  
        
    end
    
end

%% print weights
disp(w')

%% calculate line
n = 100; %number of points in line space
x1 = linspace(min(X1),max(X1)*1,n); %line space for x1
x2 = linspace(min(X2)*1,max(X2)*0.5,n); %line space for x2
y = -w(1)-w(2).*x1-w(3).*x2; % calculate y

%% Plot fitted line
clf(figure(1)); %clear plot
subplot(1,1,1); %top plot
gscatter(X1,X2,C,'rg'); hold on; %plot Y
plot(x1,y,'b','DisplayName','y'); %draw line
title('Drawing Y');

% subplot(2,1,2); %bottom plot
% gscatter(X1,X2,y_hat,'rg'); hold on; %plot Y_hat
% plot(x1,y,'b','DisplayName','y'); %draw the same line as above panel
% title('Drawing Y hat');