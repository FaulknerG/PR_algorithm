% ================main======================
clear,clc,close all;

v=input(['��ѡ����ʾ����\n 0  �˳�\n 1  Fisher��\n 2  ��֪��׼��\n',...
    ' 3  ��С����׼��\n 4  ���ٽ��ڷ�\n 5  �������ڷ���ѹ�����ڷ�\n',...
    ' 6  ���������\n 7  K�����ڷ�\n']);
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