clear  
%p1,p2是训练数据  
p1=[1.24,1.27;1.36,1.74;1.38,1.64;1.38,1.82;1.38,1.90;  
1.40,1.70;1.48,1.82;1.54,1.82;1.56,2.08];  
p2=[1.14,1.82;1.18,1.96;1.20,1.86;1.26,2.00  
1.28,2.00;1.30,1.96];  
p=[p1;p2]';  
pr=minmax(p)  
%goal是训练数据p的标准输出结果  
goal=[ones(1,9),zeros(1,6);zeros(1,9),ones(1,6)];  
%plot(p1(:,1),p1(:,2),'h',p2(:,1),p2(:,2),'o')  
%创建一个前向反馈后向传播神经网络-即BP神经网络  
net=newff(pr,[3,2],{'logsig','logsig'});  
%设置训练参数  
net.trainParam.show = 10;  
net.trainParam.lr = 0.05;  
net.trainParam.goal = 1e-10;  
net.trainParam.epochs = 50000;  
%训练网络  
net = train(net,p,goal);  
x=[1.24 1.80;1.28 1.84;1.40 2.04]';  
%测试训练结果  
y1=sim(net,p1')  
y2=sim(net,p2')  
y=sim(net,x)  