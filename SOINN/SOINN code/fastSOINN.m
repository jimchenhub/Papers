function [node, connection] = fastSOINN(data, agemax, lambda, c)
% SOINN        Self-Organizing Incremental Neural Network is an
%              Neural Network model for incremental or on-line
%              learning. It is proposed by Dr. Furao Shen and Osamu Hasegawa 
%              in 2006: Shen Furao & Osamu Hasegawa, "An Incremental Network 
%              for On-line Unsupervised Classification and Topology 
%              Learning," Neural Networks, vol. 19, pp.90-106, 2006. SOINN
%              has been applied to Active Learning, Transfer Learning, 
%              Associative Memory and some other fields in rencent years.              
%              Some more advanced readings can be found in 
%              http://cs.nju.edu.cn/rinc/. If you have any problems please
%              contact the author: frshen@nju.edu.cn.
% [node, connection] = fastSOINN(data, agemax, lambda, c);     
%             
% Input:
%       data = N x D matrix. The matrix of your training set.
%              N is the number of your data points.
%              D is the demension of your data.
%       For example, you have 3 2-demensional pionts in your training set:
%       [1,2],[3,4],[5,6]. Then data is: [1,2
%                                         3,4
%                                         5,6]
%
%       agemax = The outdate degree of connections between prototypes.
%                If a connection between some two prototypes i and j 
%                (i, j < M) with an age(i,j) > agemax. The connection
%                will be deleted.
%
%       lambda = The cycle of noise processing.
%                Every lambda points of your data are learned by SOINN,
%                SOINN would denoising the learned prototypes.
%
%       c = The control parameter of denoising. In the range of [0,1].
%           The prototype which has only one neighbor and the density of
%           this prototype is less than c*mean_density, SOINN will delete
%           this prototype as a noise point.
%
%
%
% Output: 
%         node = M x N matrix. Edge matrix for neighborhood graph
%                M is the number of the learned prototypes.
%                D is the demension of your data.
%
%         connection = M x M matrix.
%                If there is a connection between some two prototypes 
%                i and j (i, j < M), the connection(i,j) = 1. Else 
%                connection(i,j) = 0.
%



%Initialize two points
node=[data(1,:);data(2,:)];
M=[1,1];
tem=norm(data(1,:)-data(2,:));
threshold=[tem,tem];
connection=[0,0;0,0];
age=[0,0;0,0];


for i=3:size(data,1)
    %find winner node and runner-up node
    dis=sqrt(sum((repmat(data(i,:),size(node,1),1)-node).^2'));
    [value(1) index(1)]=min(dis);
    dis(index(1))=1000000;
    [value(2) index(2)]=min(dis);
    %prototype, connection and age update
    if value(1)>threshold(index(1))||value(2)>threshold(index(2))
        node=[node;data(i,:)];
        threshold=[threshold,1000000];
        M=[M,1];
        s=size(node,1);
        connection(:,s)=0;
        connection(s,:)=0;
        age(:,s)=0;
        age(s,:)=0;
    else
        if connection(index(1),index(2))==0
            connection(index(1),index(2))=1;
            connection(index(2),index(1))=1;
            age(index(1),index(2))=1;
            age(index(2),index(1))=1;
        else
            age(index(1),index(2))=1;
            age(index(2),index(1))=1;
        end
        [row,col]=find(connection(index(1),:)~=0);
        age(index(1),col)=age(index(1),col)+1;
        age(col,index(1))=age(col,index(1))+1;
        locate=find(age(index(1),:)>agemax);
        connection(index(1),locate)=0;
        connection(locate,index(1))=0;
        age(index(1),locate)=0;
        age(locate,index(1))=0;
        M(index(1))=M(index(1))+1;
        node(index(1),:)=node(index(1),:)+(1/M(index(1)))*(data(i,:)-node(index(1),:));
    end
    
    % threshold update
    if nnz(connection(index(1),:))==0
        threshold(index(1))=norm(node(index(1),:)-node(index(2),:));
    else
        v=find(connection(index(1),:)~=0);
        distance=  repmat(node(index(1),:),size(v,2),1)-node(v,:);
        threshold(index(1))=max(sqrt(sum(distance.^2')));
        
    end
    
    if nnz(connection(index(2),:))==0
        threshold(index(2))=norm(node(index(1),:)-node(index(2),:));
    else
        v=find(connection(index(2),:)~=0);
        distance=  repmat(node(index(2),:),size(v,2),1)-node(v,:);
        threshold(index(2))=max(sqrt(sum(distance.^2')));
    end
    
    % denosing
    if mod(i,lambda)==0
        meanM=sum(M)/size(M,2);
        neighbor=sum(connection);       
        setu=union(intersect(find(M<c*meanM),find(neighbor==1)),intersect(find(M<meanM),find(neighbor==0)));        
        node(setu,:)=[];
        threshold(setu)=[];
        M(setu)=[];
        connection(setu,:)=[];
        connection(:,setu)=[];
        age(setu,:)=[];
        age(:,setu)=[];
    end 
end
end

