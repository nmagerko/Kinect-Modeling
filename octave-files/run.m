% load point cloud into variable
load ../output/RANSAC.mat cloud;

% find the threshold by finding the maximum distance between any two points,
% and taking five percent of this value
t = max(pdist(cloud)) * 0.005;

% get the first set of inliers using the transpose of the pointcloud and
% the above threshold
[~, ~, inliers] = ransacfitplane(transpose(cloud), t);

% get the outliers
v = false(size(cloud, 1), 1);
v(inliers) = 1;
outliers = find(~v);

% get all of the inliers as points from the point cloud and do the same for
% the outlier points
inlier_points = cloud(inliers, :);
outlier_points = cloud(outliers, :);

[u, s, v] = svd(inlier_points);
M = v(:, 3);

[x, y] = meshgrid([min(cloud(inliers, 1)), max(cloud(inliers, 1))],[min(cloud(inliers, 2)), max(cloud(inliers, 2))])

z = -(x*M(1) + y*M(2))/M(3)

mesh(x, y, z)
hold on;
plot3(cloud(inliers, 1), cloud(inliers, 2), cloud(inliers, 3), 'xr');
hold off;
