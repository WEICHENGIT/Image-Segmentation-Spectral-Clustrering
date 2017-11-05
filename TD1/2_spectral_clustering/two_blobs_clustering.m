function [] = two_blobs_clustering()
%  [] = two_blobs_clustering()
%       a skeleton function for questions 2.1,2.2

% load the data

in_data = load('data_2blobs.mat', '-mat');
X = in_data.X;
Y = in_data.Y;

% automatically infer number of labels from samples
num_classes = length(unique(Y));
%size(X,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% choose the experiment parameter                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

graph_param.graph_type = 'knn'; %'knn' or 'eps'
graph_param.graph_thresh = 5; %size(X,1)/2; % the number of neighbours for the graph or the epsilon threshold
graph_param.sigma2 = 1; % exponential_euclidean's sigma^2

laplacian_normalization = 'unn'; %either 'unn'normalized, 'sym'metric normalization or 'rw' random-walk normalization
chosen_eig_indices = [1,2]; % indices of the ordered eigenvalues to pick

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% build laplacian
L =  build_laplacian(X, graph_param, laplacian_normalization);

Y_rec = spectral_clustering(L, chosen_eig_indices, num_classes);

plot_clustering_result(X, Y, L, Y_rec, kmeans(X, num_classes));
