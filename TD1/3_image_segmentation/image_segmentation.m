function [] = image_segmentation(input_img, input_ext)
%  [] = image_segmentation(input_img, input_ext)
%      a skeleton function to perform image segmentation, needs to be completed
%  Input
%  input_img:
%      (string) name of the image file, without extension (e.g. 'four_elements')
%  input_ext:
%      (string) extension of the image file (e.g. 'bmp')

X = double(imread(input_img,input_ext));
X = reshape(X,[],3);

im_side = sqrt(size(X,1));





graph_param.graph_type = 'knn'; %'knn' or 'eps'
graph_param.graph_thresh = 400; %size(X,1)/5; % the number of neighbours for the graph or the epsilon threshold 0.82
graph_param.sigma2 = 1; % exponential_euclidean's sigma^2

W =  build_similarity_graph(X, graph_param);

laplacian_normalization = 'rw'; %either 'unn'normalized, 'sym'metric normalization or 'rw' random-walk normalization

% build the laplacian
L =  build_laplacian(X, graph_param, laplacian_normalization);



%plot_graph_matrix(X,W);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y_rec should contain an index from 1 to c where c is the      %
% number of segments you want to split the image into           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y_rec = spectral_clustering_adaptive(L, 6);
%Y_rec = spectral_clustering(L, [2:7], 7);

%size(Y_rec)
%length(unique(Y_rec))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()

subplot(1,2,1);
imagesc(imread(input_img,input_ext));
axis square;

subplot(1,2,2);
imagesc(reshape(Y_rec,im_side,im_side));
axis square;


