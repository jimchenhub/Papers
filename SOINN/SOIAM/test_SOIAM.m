load('train.mat');
tic;
[node, connection] = SOIAM(train, 50, 100, 0.5);
time=toc;
fprintf('%5.8f seconds SOIAM execute time.\n\n',time);

figure(1)
for i=1:size(node,1)
    plot(node(i,1),node(i,2),'ro', 'MarkerSize',4); 
    hold on;
end

for i=1:size(node,1)
  for j=1:size(node,1)
      if connection(i,j)~=0
         line([node(i,1),node(j,1)],[node(i,2),node(j,2)]);
         hold on;
      end
  end
end 

tic;
[node, connection] = SOIAM(train, 50, 100, 1);
time=toc;
fprintf('%5.8f seconds SOIAM execute time.\n\n',time);

figure(2)
for i=1:size(node,1)
    plot(node(i,1),node(i,2),'ro', 'MarkerSize',4); 
    hold on;
end

for i=1:size(node,1)
  for j=1:size(node,1)
      if connection(i,j)~=0
         line([node(i,1),node(j,1)],[node(i,2),node(j,2)]);
         hold on;
      end
  end
end 