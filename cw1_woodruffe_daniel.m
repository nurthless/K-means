function [] = cw1_woodruffe_daniel(X,K, maxIt)
%Implementation of kmean function
%takes in X(dataset), K(number of clusters) and maxIt(maximum itterations,
%to prevent infinate looping under rare secumstances
%example call : cw1_woodruffe_daniel(data,4,100)

data = normal(X);    %normalise data
means = rand(K,2);   %initialise kmeans
means

partitionMatrix = zeros(K,size(X,1)); %initiallises enpty distance matrix

[data,means,partitionMatrix] = updateMatrix(data,means,partitionMatrix); %first alocation of matrix
tempMeans = []; %creates empty matrix for means to be checked against


iteration=0;
while isequal(tempMeans,means)==0&&iteration<maxIt     %if temp means == means then no change was made on last iteration, break
    tempMeans = means;  %update temp means
    [data,means,partitionMatrix] = updateMeans(data,means,partitionMatrix);         %reassign means
    [data,means,partitionMatrix] = updateMatrix(data,means,partitionMatrix);        %update the partion matrix
    iteration=(iteration+1); %logs iteration
    iteration
end
partitionMatrix
means
[data,means,partitionMatrix] = plotMean(data,means,partitionMatrix,X);        %plot results
end

function [data,means,partitionMatrix] = updateMatrix(data,means,partitionMatrix)
%updates the partition matrix according to the means

partitionMatrix = zeros( size(means,1),size(data,1) ); %clears zpartition matrix

for dataIndex=1:size(data,1) %for each data value
    
    closestMean = [];      %distance to closest centroid
    closestMeanDist = []; %distance to closest centroid
    
    for j=1:size(means,1)   %for each centroid
        i = [data(dataIndex,1:2);means(j,:)];   %these 2 lines work out the distance between the data value and the selected centroid
        v = pdist(i,'euclidean');
        
        if j == 1   %if its the first centroid checked it must be the closest so far
            closestMean = 1;
            closestMeanDist = v;    %distance of closest centroid
        else
            if v<closestMeanDist        %if centroid is closer than previous closest
                closestMean = j;        %set as new closest centroid
                closestMeanDist = v;    %log distance for next check
            end
        end
    end
    partitionMatrix(closestMean,dataIndex) = 1; %update datavalue entry with closest centroid
end
end

function [data,means,partitionMatrix] = updateMeans(data,means,partitionMatrix)
%updates means according to locations of asigned points

for n=1:size(means,1)   %for the number of centroids
    %loop finds all points assigned to n centroid and plots a '1' in the
    %matrix
    
    myX = [];
    myY = [];
    
    for j=1:length(partitionMatrix)     %for every data value
        if partitionMatrix(n,j)==1      %if selected datavalue is assigned to selected centroid
            myX(end+1)=data(j,1);       %log the location
            myY(end+1)=data(j,2);
        end
    end
    
    means(n,1) = mean(myX);     %find the average location of all the assigned points
    means(n,2) = mean(myY);     %set the centroid to this average location
end
    
end

function [data,means,partitionMatrix] = plotMean(data,means,partitionMatrix,X)
%plots data

for n=1:size(means,1)
    for j=1:length(partitionMatrix)
        if partitionMatrix(n,j)==1
            switch n
                case 1
                    scatter(data(j,1),data(j,2),80,'green');
                    hold on;
                case 2
                    scatter(data(j,1),data(j,2),80,'yellow');
                    hold on;
                case 3
                    scatter(data(j,1),data(j,2),80,'blue');
                    hold on;
                case 4
                    scatter(data(j,1),data(j,2),80,'black');
                    hold on;
                case 5
                    scatter(data(j,1),data(j,2),80,'cyan');
                    hold on;
                otherwise
                    warning('too many centroids, cant handle the colours')
            end
        end
    end
end

scatter(means(:,1),means(:,2),80,'red','filled');   %adds centroids


title('k-means visualisation');
%xlabel('X Axis');
%ylabel('Y Axis');
xlabel('Temperature');
ylabel('Wind Speed');
%axis([min(X(:,1)) max(X(:,1)) min(X(:,2)) max(X(:,2))]);
end

            
            
