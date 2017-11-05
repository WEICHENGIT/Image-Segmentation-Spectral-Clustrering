function [] = parameter_sensitivity()
%  [] = parameter_sensitivity()
% parameter_sensitivity
%       a skeleton function to test spectral clustering
%       sensitivity to parameter choice

% the number of samples to generate
num_samples = 500;

% the sample distribution function with the options necessary for
% the distribution
%sample_dist = @two_moons;
%dist_options = [1, 0.02];  % two moons: radius of the moons, variance of the moons
sample_dist = @blobs;
dist_options = [4, 0.03, 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% choose the experiment parameter                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

graph_param.graph_type = 'knn'; %'knn' or 'eps'
graph_param.sigma2 = 1; % exponential_euclidean's sigma^2

laplacian_normalization = 'unn'; %either 'unn'normalized, 'sym'metric normalization or 'rw' random-walk normalization
chosen_eig_indices = [1,4]; % indices of the ordered eigenvalues to pick

%parameter_candidate = [2:30];  % the number of neighbours for the graph or the epsilon threshold
parameter_candidate = [2:10:num_samples];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for repeat = 1:20

for i = 1:length(parameter_candidate)

    graph_param.graph_thresh = parameter_candidate(i)

    [X, Y] = get_samples(sample_dist, num_samples, dist_options);

    % automatically infer number of labels from samples
    num_classes = length(unique(Y));

    L =  build_laplacian(X, graph_param, laplacian_normalization);

    Y_rec = spectral_clustering(L, chosen_eig_indices, num_classes);

    parameter_performance(repeat,i) = ari(Y,Y_rec);
end

end

errorbar(parameter_candidate, mean(parameter_performance,1), std(parameter_performance,1));
title('parameter sensitivity')


