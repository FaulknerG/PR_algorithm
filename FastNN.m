% ==========================快速近邻算法===============================
% ================聚类过程所使用的主要变量==============================
% X：  随机产生的样本集 
% l:   划分的子集数目
% L:   水平数目
% Xp:  节点p对应的样本子集
% Mp:   各类的均值
% Rp:   从Mp到Xi的最远距离
% =============树搜索过程所使用的重要变量=================================
% CurL:  当前水平
% p:     当前结点
% CurTable:  当前目录表中的子样本集
% CurPinT:   在当前目录表中的子样本结点
% RpCur:     当前目录表中结点p对应的Rp
% x:        待判样本
% =====================================================================
% 实验结果表明，该算法在聚类完成之后，进行树搜索，速度的确比一般的近邻方法快
% 当时由于聚类要消耗大量的时间，因此总速度不如一般的近邻方法
% =====================================================================
%   Copyright Wang Chuanting.
%   $Revision: 1.0 $  $Date: 2008/05/09 09:40:34 $
% ======================================================================

% ======================================================================
% －－－首先进行聚类－－－
% randn是均值为0方差为1的正态分布,形成间隔为3的随机数
clear,close all;
% tic
X = [randn(200,2)+ones(200,2);...
     randn(200,2)-2*ones(200,2);...
     randn(200,2)+4*ones(200,2);];    % X 600*2的矩阵
% －－－每个水平均划分为l个子集－－－
[row,col]=size(X);
all_idx=0;L=3;l=3;    
%计算总节点的数目
for i=1:L
    all_idx=all_idx+l^i;  % 3^1 + 3^2 + 3^2 = 3+9+27 = 39
end
Xp=cell(all_idx,1);     % 初始化Xp为39*1的矩阵 节点对应的样本子集
Mp=zeros(all_idx,col);  % Mp为39*2的矩阵  每个节点的均值
Rp=zeros(all_idx,1);    % Rp 39*1         从均值到该类的最远距离
p=1;
for i=1:L
   if i==1
       % idx 类标签; C 中心坐标 sumd 累加距离 D :每个点距离三个中心点的距离
       [IDX,C,sumd,D] = kmeans(X,l);  % 对样本X进行kmeans分类，returns distances from each point to every centroid in the N-by-l matrix D.
        for j=1:l
            Xp(p)={X((IDX==j),:)};    % 标签为J的行号 IDX==j  抽取出所有类的样本
            Mp(p,:)=C(j,:);           % 均值 = 中心点坐标
            Rp(p)=max(D((IDX==j),j)); % 最远距离      max(D((IDX=j),j))
            p=p+1;                    
        end   
   else       % i = 2, 3
       endk=p-1;begink=endk-l^(i-1)+1;            % endk = 3,12(3*3两个for循环) ,begink = 3/12-3^(i-1)+1  : 1, 4      1-3(3*3=9); 4-12(9*3=27) 对应两层树结构
       for k=begink:endk                          % k = 
           [IDX,C,sumd,D] = kmeans(Xp{k,1},l);
           X1=Xp{k,1};
           for j=1:l                
                Xp(p)={X1((IDX==j),:)};
                Mp(p,:)=C(j,:);
                Rp(p)=max(D((IDX==j),j));
                p=p+1;
           end   
       end
   end
end
% ====================================================================
% －－－进行树搜索－－－
tic
%x=randn(1,2);               % 待判样本 随机生成，xy坐标
x=input('input the x: ');
B=inf;CurL=1;p=0;TT=1;      % inf无穷大
while TT==1                 % 步骤2
    Xcurp=cell(1);          % []
    CurTable=cell(l,1);     % 3*1 当前目录表中的子样本集
    CurPinT=zeros(l,1);     % 3*1 在当前目录表中的子样本结点
    Dx=zeros(l,1);          
    RpCur=zeros(l,1);       % 当前目录表中结点p对应的Rp
    %当前节点的直接后继放入目录表   
    for i=1:l   
        CurTable(i,1)=Xp(i+p*l,1);  %
        CurPinT(i)=i+p*l;
        Dx(i)=norm(x-Mp(i+p*l,:))^2;% 距离,norm计算矩阵范数,norm()^2 ,欧氏距离
        RpCur(i)=Rp(i+p*l);
    end    

    while 1 %步骤3
        [rowT,colT]=size(CurTable); % 3*1
        for i=1:rowT                   
            if Dx(i)>B+RpCur(i)+eps % 从目录表中去掉当前节点p
                CurTable(i,:)=[];
                CurPinT(i)=[];
                Dx(i)=[];
                RpCur(i)=[];
                break;
            end
        end
        [CurRowT,CurColT]=size(CurTable); % 3*1
        if CurRowT==0 % 步骤4    目录表中已经没有节点，后退一个水平，令L=L-1，直到L为0则 ！停止！
           CurL=CurL-1;p=floor((p-1)/3);    % floor 向负无穷方向取整，即p后退一个水平
           if CurL==0
              TT=0; break;  
           else             % 若L不为0则转步骤3
               % 转步骤3
           end
        elseif CurRowT>0    % 步骤5
            [Dxx,Dxind]=sort(Dx,'ascend'); %排序
            p1=CurPinT(Dxind(1)); % 选择最近节点,为执行节点,并从目录表中去除该节点
            p=p1;
            %从当前目录表去掉p1
            for j=1:CurRowT
                if CurPinT(j)==p1
                    Xcurp(1,1)=CurTable(j,1); % 执行节点
                    CurTable(j,:)=[];         % 目录表中去除该节点
                    CurPinT(j)=[];
                    CurD=Dx(j);               % 记录D(x,Mp)
                    Dx(j)=[];
                    RpCur(j)=[];                    
                    break;
                end
            end
            if CurL==L          % 当前的水平L是最终水平，步骤6：对现在执行节点中每个x做规则2检验
                XcurpMat=cell2mat(Xcurp);
                [CurpRow,CurpCol]=size(XcurpMat);
                CurpMean=Mp(p,:);
                for k=1:CurpRow
                    Dxi=norm((XcurpMat(k,:)-CurpMean))^2;
                    if CurD>Dxi+B+eps
                        % 规则2检验。若大于，则xi不是x的最近邻，不计算Dx
                    else
                        Dxxi=norm((x-XcurpMat(k,:)))^2; % 否则计算Dx
                        if Dxxi<B+eps                   % 若成立，置B，NN=i,继续进行步骤3, while
                            B=Dxxi;Xnn=XcurpMat(k,:);
                        end
                    end
                end
            else    % 步骤5   否则L=L+1,转步骤2
                CurL=CurL+1;
                break;
            end
        end
    end % while 步骤3
end % while TT==1 步骤2
B,Xnn;NN=find(X(:,1)==Xnn(1)); % 找到元素所在位置{}
time1=toc;
% ====================================================================
figure, plot(X(1:200,1),X(1:200,2),'m.')
hold on,plot(X(201:400,1),X(201:400,2),'b.')
hold on,plot(X(401:600,1),X(401:600,2),'g.')   
hold on,plot(Xnn(1),Xnn(2),'kx ','MarkerSize',10,'LineWidth',2)
hold on,plot(x(1),x(2),'r+','MarkerSize',10,'LineWidth',2)
legend('Cluster 1','Cluster 2','Cluster 3','NN','x','Location','NW')


