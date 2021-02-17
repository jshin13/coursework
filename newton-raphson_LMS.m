%% Part 1. Plot g(x) for sigma=+1, c=+1, and x in range -10 to 10
gaus = @(x,sig,c)exp(-(((x-c).^2)/(2*sig.^2))); %define gaussian function

x = linspace(-10,10,100); %x ranging from -10 to 10
sig = 1; %variance
c = 1; %mean
w = 1; %weight

y = gaus(x,sig,c).* w; %calculating y

%plotting bell curve using gaussian function
clf(figure(1));
plot(x, y, 'b-', 'LineWidth', 3)
title(sprintf('PART1: Gaussian function (\\mu=%.1f, \\sigma=%.1f, w=%.1f)',c, sig, w));
hold on
plot(x, y, 'ro');

%% Part 2. Plot g(x).w for w=3, sigma=+1, c=+1, and x in range -10 to 10
x = linspace(-10,10,100); %x ranging from -10 to 10
sig = 1; %variance
c = 1; %mean
w = 3; %weight

y = gaus(x,sig,c) .* w; %calculating y

%plotting bell curve using gaussian function
clf(figure(1));
plot(x, y, 'b-', 'LineWidth', 3)
title(sprintf('PART2: Gaussian function (\\mu=%.1f, \\sigma=%.1f, w=%.1f)',c, sig, w));
hold on
plot(x, y, 'ro');

%% Part 3. Plot above loss function for c in range -10 to 10
x = [1,-1]; %x ranging from -10 to 10
y = [1,1];
sig = 0.7; %variance
c = linspace(-10,10,100); %mean
w = 3; %weight
N = length(x);
J = 0;

for i = 1:N
    y_hat = gaus(x(i),sig,c).*w; %calculating y
    J = J + 1/N*sum((y(i)-y_hat).^2,1);
end

%plotting bell curve using gaussian function
clf(figure(1));
plot(c, J, 'b-', 'LineWidth', 3)
title(sprintf('PART3: Gaussian function (\\sigma=%.1f, w=%.1f)',sig, w));
hold on

%% Part 4. Part4. Plot loss function for c2 in range -10 to 10
x = [1,-1]; %two x points
y = [1,1]; %two y points
sig = 0.7; %variance
c1 = 1; %mean for the first basis function
c2 = linspace(-10,10,100); %mean for the second basis function
w = [1 1]; %weight
N = length(x); %total number of function
J = 0; %initialize loss function

y_hat = gaus(x(1),sig,c1).*w(1); %calculating y_hat
J = J + 1/N*sum((y(1)-y_hat).^2,1); %calculating loss function

y_hat = gaus(x(2),sig,c2).*w(2); %calculating y_hat
J = J + 1/N*sum((y(2)-y_hat).^2,1); %calculating loss function

%plotting bell curve using gaussian function
clf(figure(1));
plot(c, J, 'b-', 'LineWidth', 3)
title(sprintf('PART4: Gaussian function (\\sigma=%.1f, w=%.1f)',sig, w(1)));
hold on

%%
%1. Starting with a squared error loss function, derive a steepest
%descent and an LMS rule to move the centers. Show that a good learning rule is to move the
%centers toward the data points. 
%2. Note that the loss function is not a quadratic function of c.
%How will this affect the convergence of your algorithm?

% b0 = ones(length(data),1); %bias term
% X1 = data(:,1); 
% X2 = data(:,2);
% X = [b0 X1 X2]; %new dataset with bias term
% C = data(:,3); %label
% subplot(1,1,1);
% gscatter(X1,X2,C,'rg');

%% Init params
% num_iterations = 1; % number of total iterations
% num_datapoints = length(x); % number of data points in the input file
% w = zeros(1,1); % initial weights
% y_hat = nan(size(y))'; % output prediction
% eta = 0.9; %learning rate
% ct = zeros(num_iterations,1); % initialize counter
% x = x';
% y = y';

%% Main Loop
% for counter_iteration = 1 : 1 : num_iterations
%     
%     for counter_data = 1 : 1 : num_datapoints
%         
%         x_i = x(counter_data,1); %training sample in 1x3
%         y_i = y(counter_data,1); %training label
%         yhat_i = gaus(x_i,sig,c)*w; %y_hat prediction in 1x3 * 3x1
%               
%         if y_i ~= y_hat(counter_data) %conditional on mismatch
%             w = w + eta*(x_i*x_i').^-1*(y_i-x_i*w).*x_i'; % steepest descent
%             c = c - eta* 
%             % (3x1) + (1x3*3x1)*(1x1-1x3*3x1)*1x3
%             % (3x1) + (1x1)*(1x1)*3x1 = 3x1
%             ct(counter_iteration) = ct(counter_iteration) + 1; % counter update
%         end  
%         
%     end
%     
% end

%% Part 2. Plot g(x).w for w=3, sigma=+1, c=+1, and x in range -10 to 10
% x = linspace(-10,10,100); %x ranging from -10 to 10
% sig = 1; %variance
% c = 3; %mean
% % w = 3; %weight
% 
% y = gaus(x,sig,c) .* w; %calculating y
% 
% %plotting bell curve using gaussian function
% clf(figure(1));
% plot(x, y, 'b-', 'LineWidth', 3)
% title(sprintf('PART1: Gaussian function (\\mu=%.1f, \\sigma=%.1f, w=%.1f)',c, sig, w));
% hold on
% plot(x, y, 'ro');