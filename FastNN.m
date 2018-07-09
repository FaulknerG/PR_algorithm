% ==========================���ٽ����㷨===============================
% ================���������ʹ�õ���Ҫ����==============================
% X��  ��������������� 
% l:   ���ֵ��Ӽ���Ŀ
% L:   ˮƽ��Ŀ
% Xp:  �ڵ�p��Ӧ�������Ӽ�
% Mp:   ����ľ�ֵ
% Rp:   ��Mp��Xi����Զ����
% =============������������ʹ�õ���Ҫ����=================================
% CurL:  ��ǰˮƽ
% p:     ��ǰ���
% CurTable:  ��ǰĿ¼���е���������
% CurPinT:   �ڵ�ǰĿ¼���е����������
% RpCur:     ��ǰĿ¼���н��p��Ӧ��Rp
% x:        ��������
% =====================================================================
% ʵ�������������㷨�ھ������֮�󣬽������������ٶȵ�ȷ��һ��Ľ��ڷ�����
% ��ʱ���ھ���Ҫ���Ĵ�����ʱ�䣬������ٶȲ���һ��Ľ��ڷ���
% =====================================================================
%   Copyright Wang Chuanting.
%   $Revision: 1.0 $  $Date: 2008/05/09 09:40:34 $
% ======================================================================

% ======================================================================
% ���������Ƚ��о��࣭����
% randn�Ǿ�ֵΪ0����Ϊ1����̬�ֲ�,�γɼ��Ϊ3�������
clear,close all;
% tic
X = [randn(200,2)+ones(200,2);...
     randn(200,2)-2*ones(200,2);...
     randn(200,2)+4*ones(200,2);];    % X 600*2�ľ���
% ������ÿ��ˮƽ������Ϊl���Ӽ�������
[row,col]=size(X);
all_idx=0;L=3;l=3;    
%�����ܽڵ����Ŀ
for i=1:L
    all_idx=all_idx+l^i;  % 3^1 + 3^2 + 3^2 = 3+9+27 = 39
end
Xp=cell(all_idx,1);     % ��ʼ��XpΪ39*1�ľ��� �ڵ��Ӧ�������Ӽ�
Mp=zeros(all_idx,col);  % MpΪ39*2�ľ���  ÿ���ڵ�ľ�ֵ
Rp=zeros(all_idx,1);    % Rp 39*1         �Ӿ�ֵ���������Զ����
p=1;
for i=1:L
   if i==1
       % idx ���ǩ; C �������� sumd �ۼӾ��� D :ÿ��������������ĵ�ľ���
       [IDX,C,sumd,D] = kmeans(X,l);  % ������X����kmeans���࣬returns distances from each point to every centroid in the N-by-l matrix D.
        for j=1:l
            Xp(p)={X((IDX==j),:)};    % ��ǩΪJ���к� IDX==j  ��ȡ�������������
            Mp(p,:)=C(j,:);           % ��ֵ = ���ĵ�����
            Rp(p)=max(D((IDX==j),j)); % ��Զ����      max(D((IDX=j),j))
            p=p+1;                    
        end   
   else       % i = 2, 3
       endk=p-1;begink=endk-l^(i-1)+1;            % endk = 3,12(3*3����forѭ��) ,begink = 3/12-3^(i-1)+1  : 1, 4      1-3(3*3=9); 4-12(9*3=27) ��Ӧ�������ṹ
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
% ����������������������
tic
%x=randn(1,2);               % �������� ������ɣ�xy����
x=input('input the x: ');
B=inf;CurL=1;p=0;TT=1;      % inf�����
while TT==1                 % ����2
    Xcurp=cell(1);          % []
    CurTable=cell(l,1);     % 3*1 ��ǰĿ¼���е���������
    CurPinT=zeros(l,1);     % 3*1 �ڵ�ǰĿ¼���е����������
    Dx=zeros(l,1);          
    RpCur=zeros(l,1);       % ��ǰĿ¼���н��p��Ӧ��Rp
    %��ǰ�ڵ��ֱ�Ӻ�̷���Ŀ¼��   
    for i=1:l   
        CurTable(i,1)=Xp(i+p*l,1);  %
        CurPinT(i)=i+p*l;
        Dx(i)=norm(x-Mp(i+p*l,:))^2;% ����,norm���������,norm()^2 ,ŷ�Ͼ���
        RpCur(i)=Rp(i+p*l);
    end    

    while 1 %����3
        [rowT,colT]=size(CurTable); % 3*1
        for i=1:rowT                   
            if Dx(i)>B+RpCur(i)+eps % ��Ŀ¼����ȥ����ǰ�ڵ�p
                CurTable(i,:)=[];
                CurPinT(i)=[];
                Dx(i)=[];
                RpCur(i)=[];
                break;
            end
        end
        [CurRowT,CurColT]=size(CurTable); % 3*1
        if CurRowT==0 % ����4    Ŀ¼�����Ѿ�û�нڵ㣬����һ��ˮƽ����L=L-1��ֱ��LΪ0�� ��ֹͣ��
           CurL=CurL-1;p=floor((p-1)/3);    % floor �������ȡ������p����һ��ˮƽ
           if CurL==0
              TT=0; break;  
           else             % ��L��Ϊ0��ת����3
               % ת����3
           end
        elseif CurRowT>0    % ����5
            [Dxx,Dxind]=sort(Dx,'ascend'); %����
            p1=CurPinT(Dxind(1)); % ѡ������ڵ�,Ϊִ�нڵ�,����Ŀ¼����ȥ���ýڵ�
            p=p1;
            %�ӵ�ǰĿ¼��ȥ��p1
            for j=1:CurRowT
                if CurPinT(j)==p1
                    Xcurp(1,1)=CurTable(j,1); % ִ�нڵ�
                    CurTable(j,:)=[];         % Ŀ¼����ȥ���ýڵ�
                    CurPinT(j)=[];
                    CurD=Dx(j);               % ��¼D(x,Mp)
                    Dx(j)=[];
                    RpCur(j)=[];                    
                    break;
                end
            end
            if CurL==L          % ��ǰ��ˮƽL������ˮƽ������6��������ִ�нڵ���ÿ��x������2����
                XcurpMat=cell2mat(Xcurp);
                [CurpRow,CurpCol]=size(XcurpMat);
                CurpMean=Mp(p,:);
                for k=1:CurpRow
                    Dxi=norm((XcurpMat(k,:)-CurpMean))^2;
                    if CurD>Dxi+B+eps
                        % ����2���顣�����ڣ���xi����x������ڣ�������Dx
                    else
                        Dxxi=norm((x-XcurpMat(k,:)))^2; % �������Dx
                        if Dxxi<B+eps                   % ����������B��NN=i,�������в���3, while
                            B=Dxxi;Xnn=XcurpMat(k,:);
                        end
                    end
                end
            else    % ����5   ����L=L+1,ת����2
                CurL=CurL+1;
                break;
            end
        end
    end % while ����3
end % while TT==1 ����2
B,Xnn;NN=find(X(:,1)==Xnn(1)); % �ҵ�Ԫ������λ��{}
time1=toc;
% ====================================================================
figure, plot(X(1:200,1),X(1:200,2),'m.')
hold on,plot(X(201:400,1),X(201:400,2),'b.')
hold on,plot(X(401:600,1),X(401:600,2),'g.')   
hold on,plot(Xnn(1),Xnn(2),'kx ','MarkerSize',10,'LineWidth',2)
hold on,plot(x(1),x(2),'r+','MarkerSize',10,'LineWidth',2)
legend('Cluster 1','Cluster 2','Cluster 3','NN','x','Location','NW')


