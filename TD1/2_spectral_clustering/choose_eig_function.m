function [eig_ind] = choose_eig_function(eigenvalues)
%  [eig_ind] = choose_eig_function(eigenvalues)
%     chooses indices of eigenvalues to use in clustering
%
% Input
% eigenvalues:
%     eigenvalues sorted in ascending order
%
% Output
% eig_ind:
%     the indices of the eigenvectors chosen for the clustering
%     e.g. [1,2,3,5] selects 1st, 2nd, 3rd, and 5th smallest eigenvalues

i=2;
while eigenvalues(i+1)/eigenvalues(i)<5
  i=i+1;
  if i == length(eigenvalues)
    break;
  end
end

if length(eigenvalues(eigenvalues<10^-10))==1
  eig_ind = [2:i];
else
  eig_ind = [1:i];
end
