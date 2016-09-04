% initialization and trainning
load('train.mat');
tic;
[node, connection] = SOIAM(train, 50, 100, 0.5);
time=toc;
fprintf('%5.8f seconds SOIAM execute time.\n\n',time);

tic;
[node, connection] = SOIAM(train, 50, 100, 1);
time=toc;
fprintf('%5.8f seconds SOIAM execute time.\n\n',time);

% input variables
pattern_size=[1,1];
input_key=[0.15];
key_type=1; % 1 stands for pattern F and 2 for pattern R

% recall associative pattern
delta_r=0.01;
dist=sqrt((repmat(input_key, size(node,1), 1)-node(:,1:pattern_size(key_type))).^2')/sqrt(pattern_size(key_type));
[value, index]=find(dist<delta_r);
if size(value) ~= 0
    fprintf('Satisfied pattern as follow:\n');
    if key_type==1
        node(index, 1:pattern_size(1))
    else
        node(index, pattern_size(1)+1:sum(pattern_size))
    end
else
    fprintf('unknown pattern\n');
end

% figures
figure(1)
for i=1:size(node,1)
    plot(node(i,1),node(i,2),'bo', 'MarkerSize',2); 
    hold on;
end

plot([input_key, input_key], ylim, 'm--');

plot(node(index,1),node(index,2),'ro', 'MarkerSize',5);
