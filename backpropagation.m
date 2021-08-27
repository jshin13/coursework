%% Load the images and their labels

X = load('X.mat').X; %loading training data
y = load('y.mat').y; %loading label
load('weight.mat'); %loading weight matrices

%% Setting paramenters
num_train = 5000; % number of training examples
num_input = 400; % number of input neurons
num_hidden = 25; % number of hidden layer neurons
num_output = 10; % number of output neurons

%% 1. Display some sample images; use function like 'imshow'

%figure('Position', [0 0 600 400]);
for i = 1:1:3
    idx = randperm(5000,1);
    subplot(1,3,i);
    imshow(reshape(X(idx,:),20,20));
    title(['y=',num2str(y(idx))])
end

%% 2. Finish 'sigmoid' and 'sigmoidDeriv' functions
% Completed
%% 3. Finish 'forwardPropagationFunc
% Completed
%% 4. What is the accuracy of classifier using the initial weights given?
[z2, a2, z3, y_hat] = forwardPropagationFunc(X,weight1,weight2,5000);
acc = compute_accuracy(y_hat, y);
disp(acc); %accuracy is 0.0666
%% 5. Finish 'costFunc'
% Completed
%% 6. Finish 'backpropagationFunc' 
% Completed
%% Optimizing the weights
weight = [weight1(:); weight2(:)]; % "unrolling" weights to be used as the starting points
% Run this after completing 'backpropagationFunc'
options = optimset('MaxIter', 150);
fun = @(x) backpropagationFunc(x, X, y, num_input, num_hidden, num_output); 
[trained_weight, cost] = fmincg(fun, weight, options); 

%% 7. Visualize the weights

% Reshaping 'trained_weight' the output from minimization function
weight1 = reshape(trained_weight(1:(num_input+1)*num_hidden), num_hidden, num_input+1);
weight2 = reshape(trained_weight((num_input+1)*num_hidden+1:end), num_output, num_hidden+1);

idx = randperm(25,10);

for i = 1:1:10
    subplot(2,5,i);
    imshow(reshape(weight1(idx(i),2:end)',20,20), 'Colormap', flag);
    title(['neuron #' , num2str(idx(i))]);
end

% they do not look as obvious as the examples seen in the lecture because humans cannot easily recognize what the network is learning. 
%% 8. What is the accuracy of the trained classifier?

[z2, a2, z3, y_hat_trained] = forwardPropagationFunc(X,weight1,weight2,5000);
acc = compute_accuracy(y_hat_trained, y);
disp(acc); %accuracy is 0.9316

