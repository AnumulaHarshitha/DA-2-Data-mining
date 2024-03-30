% Import data from CSV file
data = readtable('Credit_Card_Customer_Data.csv');

% Extract the 'Avg_Credit_Limit' column for clustering
X = data.Avg_Credit_Limit;

% Standardize the data (optional but recommended for k-means)
X_standardized = zscore(X);

% Initialize the number of clusters
k = 3;

% Initialize centroids using k-means++
C = kmeans_init(X_standardized, k);

% Initialize the previous cluster centroids
C_prev = zeros(size(C,1),size(C,2));

% Set the maximum number of iterations
max_iter = 100;

% Set the iteration counter
iter = 0;

% Initialize the flag that indicates convergence
converged = false;

% Initialize the total sum of distances
total_sum_dist = Inf;

% Start the k-means clustering algorithm
while ~converged && (iter < max_iter)
    % Assign each data point to the closest centroid
    [~,idx] = pdist2(C,X_standardized,'euclidean','Smallest',1);

    % Calculate the new cluster centroids
    C_new = zeros(k,1);
    for i = 1:k
        C_new(i) = mean(X_standardized(idx == i));
    end

    % Check if the centroids have converged
    convergence_tol = 1e-4;
    if norm(C_new - C, 'fro') < convergence_tol
        converged = true;
    else
        % Update the previous cluster centroids
        C_prev = C;
        % Update the cluster centroids
        C = C_new;
        % Update the iteration counter
        iter = iter + 1;
    end
end

% Display the final cluster centroids
disp('Cluster centroids:');
disp(C);

% Display the total sum of distances
disp(['Total sum of distances: ', num2str(sum(sum(pdist2(C,X_standardized,'euclidean'))))]);

% Generate random colors for each cluster
cluster_colors = rand(k, 3);

% Create a scatter plot of the data points with different colors for each cluster
figure;
for i = 1:k
    scatter(1:numel(X_standardized(idx == i)), X_standardized(idx == i), 50, cluster_colors(i,:), 'filled');
    hold on;
end
title('Credit Card Customer Data Clustering (Avg_Credit_Limit)');
xlabel('Data Index');
ylabel('Standardized Avg_Credit_Limit');
legend('Cluster 1', 'Cluster 2', 'Cluster 3'); % Add legend for clarity
hold off;

function centroids = kmeans_init(X, k)
    centroids = zeros(k, 1);
    centroids(1) = X(randi(numel(X), 1));
    for i = 2:k
        distances = pdist2(X, centroids(1:i-1), 'euclidean', 'Smallest', 1);
        probabilities = distances.^2 / sum(distances.^2);
        cum_probs = cumsum(probabilities);
        rand_val = rand();
        selected_idx = find(cum_probs >= rand_val, 1);
        if ~isempty(selected_idx)
            centroids(i) = X(selected_idx);
        else
            % Handle case when selected index is empty
            % For example, assign a random data point as the centroid
            centroids(i) = X(randi(numel(X), 1));
        end
    end
end