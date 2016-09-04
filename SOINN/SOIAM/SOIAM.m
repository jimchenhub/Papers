function [node, connection] = SOIAM(data, agemax, lambda, c)

if size(data, 1) < 2
    fprintf('Too less data\n\n');
    return;
end

% additive white Gaussian noise(AWGN) snr
snr=50;
data=awgn(data, snr);

node=[data(1,:); data(2,:)];
M=[1,1];
tem=norm(node(1,:)-node(2,:));
threshold=[tem,tem];
connection=[0,0; 0,0];
age=[0,0; 0,0];

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
        % Increase the age of all edges emanating from s1
        [row,col]=find(connection(index(1),:)~=0);
        age(index(1),col)=age(index(1),col)+1;
        age(col,index(1))=age(col,index(1))+1;

        % Remove edges with an age greater than a predefined threshold age dead
        locate=find(age(index(1),:)>agemax);
        connection(index(1),locate)=0;
        connection(locate,index(1))=0;
        age(index(1),locate)=0;
        age(locate,index(1))=0;
        
        % Add 1 to the local accumulated number of signals Ms1
        M(index(1))=M(index(1))+1;

        % update weights of winner
        node(index(1),:)=node(index(1),:)+(1/M(index(1)))*(data(i,:)-node(index(1),:));
        % and its neighbors
        [row,col]=find(connection(index(1),:)~=0);
        node(col,:)=node(col,:)+(0.01/M(index(1)))*(repmat(data(i,:),size(col,2),1)-node(col,:));
    end
    
    % threshold update
    if nnz(connection(index(1),:))==0
        threshold(index(1))=norm(node(index(1),:)-node(index(2),:));
    else
        % calculate the between-cluster distance db(Ci,Cj) of clusters Ci and Cj as
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
    % Remove nodes with no neighbors if np is more than lambda;
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