function [W,similarities] = build_similarity_graph(X, graph_param)
%  [W, similarities] = build_similarity_graph(graph_type, graph_thresh, X, sigma)
%      Computes the similarity matrix for a given dataset of samples.
%
%  Input
%  X:
%      (n x m) matrix of m-dimensional samples
%  graph_param:
%      structure containing the graph construction parameters as fields
%  graph_param.graph_type:
%      knn or eps graph, as a string, controls the graph that
%      the function will produce
%  graph_param.graph_thresh:
%      controls the main parameter of the graph, the number
%      of neighbours k for k-nn, and the threshold eps for epsilon graphs
%  graph_param.sigma2:
%      the sigma value for the exponential function, already squared
%
%
%  Output
%  W:
%      (n x n) dimensional matrix representing the adjacency matrix of the graph
%  similarities:
%      (n x n) dimensional matrix containing
%      all the similarities between all points (optional output)


if nargin < 2
    error('build_similarity_graph: not enough arguments')
elseif nargin > 2
    error('build_similarity_graph: too many arguments')
end

% unpack the type of the graph to build and the respective      %
% threshold and similarity function options                     %

graph_type = graph_param.graph_type;
graph_thresh = graph_param.graph_thresh; % the number of neighbours for the graph
sigma2 = graph_param.sigma2; % exponential_euclidean's sigma^2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  use similarity function to build full graph (similarities)   %
%  similarities: (n x n) matrix with similarities between       %
%              all possible couples of points                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

similarities = exponential_euclidean(X,sigma2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = size(X,1);
similarities = similarities-eye(n);

W = zeros(n,n);

if strcmp(graph_type,'knn') == 1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  compute a k-nn graph from the similarities                   %
    %  for each node x_i, a k-nn graph has weights                  %
    %  w_ij = d(x_i,x_j) for the k closest nodes to x_i, and 0      %
    %  for all the k-n remaining nodes                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [sorted,entries] = sort(similarities,1,'descend');
    for i=1:n
      W(entries(1:graph_thresh,i),i) = similarities(entries(1:graph_thresh,i),i);
    end
    
    for i=1:n
      for j=i:n
        if W(i,j)~=W(j,i)
          W(i,j)=max(W(i,j),W(j,i));
          W(j,i)=max(W(i,j),W(j,i));
        end
      end
    end
    %issymmetric(W)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif strcmp(graph_type,'eps') == 1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  compute an epsilon graph from the similarities               %
    %  for each node x_i, an epsilon graph has weights              %
    %  w_ij = d(x_i,x_j) when w_ij > eps, and 0 otherwise           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    W = similarities;
    W(similarities<graph_thresh)=0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

else

    error('build_similarity_graph: not a valid graph type')

end
