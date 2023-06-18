x = load('swiss_roll_data');
tic;
D = L2_distance(x.X_data(:,1:1000), x.X_data(:,1:1000), 1);

options.dims = 1:2;
[Y, R, E] = IsomapII(D,'k', 6, options); 
X=x.X_data(:,1:1000)';


[m,n]=size(X);
D=zeros(m,m);
for i=1:m
    for j=i:m
        D(i,j)=norm(X(i,:)-X(j,:));
        D(j,i)=D(i,j);
    end
end
%计算矩阵中每行前k个值的位置并赋值（先按大小排列）
W1=zeros(m,m);
k=6;
for i=1:m
A=D(i,:);
t=sort(A(:));%对每行进行排序后构成一个从小到大有序的列向量
[row,col]=find(A<=t(k),k);%找出每行前K个最小数的位置
for j=1:k
c=col(1,j);
 W1(i,c)=D(i,c); %W1(i,c)=1;%给k近邻赋值为距离
end
end
for i=1:m
    for j=1:m
        if W1(i,j)==0&i~=j
            W1(i,j)=inf;
        end
    end
end
%计算测地距离，o是每个点到其他点的测地距离矩阵
[dist,mypath,o]=myfloyd(W1,100,1000);
%[dist,mypath]=mydijkstra(W1,100,1000);

save 1.mat mypath

[col,rol]=size(mypath)
X1=[];
for i=1:rol
    ding=mypath(1,i);
    X1=[X1;X(ding,:)];
end
toc;
figure;
plot3(X(:,1),X(:,2),X(:,3),'.')
hold on
plot3(X1(:,1),X1(:,2),X1(:,3),'o-r')
hold on
plot3([X1(1,1) X1(length(mypath),1)],[X1(1,2) X1(length(mypath),2)],[X1(1,3) X1(length(mypath),3)],'o:r','LineWidth',1.2)
load 1.mat;
figure;
plot(Y.coords{2,1}(1,mypath(1:length(mypath))),Y.coords{2,1}(2,mypath(1:length(mypath))),'o-r','LineWidth',1.2)
hold on
plot(Y.coords{2,1}(1,[mypath(1),mypath(length(mypath))]),Y.coords{2,1}(2,[mypath(1),mypath(length(mypath))]),'o-k','LineWidth',1.2)

