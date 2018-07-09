% ================main======================
clear,clc,close all;

v=input(['请选择演示程序：\n 0  退出\n 1  Fisher法\n 2  感知器准则\n',...
    ' 3  最小二乘准则\n 4  快速近邻法\n 5  剪辑近邻法与压缩近邻法\n',...
    ' 6  二叉决策树\n 7  K－近邻法\n']);
while 1   
    if v==0
        return;
    elseif v==1
        Fisher
    elseif v==2
        SinglePerceptron
    elseif v==3
        Widrow_Hoff
    elseif v==4
        FastNN
    elseif v==5
        Condensing
    elseif v==6
        decisionTree
    elseif v==7
        KNN
    end
    v=input('');
end