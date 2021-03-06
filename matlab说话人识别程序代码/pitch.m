%由自相关法求取基音周期
function s=pitch(x,y)
%读取语音信号，原始语音采样频率为96000Hz
signal=wavread(strcat(x,y));
signal=trim(signal);
%分帧
FrameLen = 450;
FrameInc = 128;
temp = enframe(signal, FrameLen, FrameInc);
[m,n] = size(temp);
t=1;
%每帧进行预处理(滤波)并求取基音周期
while t<=m
    j=1;
    for i=1:n
        newsignal(j)=temp(t,i);
        j=j+1;
    end   
    %低通滤波
    f=900;
    fs=8000;
    [B,A]=butter(30,2*f/fs);
    newsignal=filter(B,A,newsignal);    
    %设置门限电平
    amax=max(newsignal(1:100));
    bmax=max(newsignal(n-99:n));
    cl=0.68*min(amax,bmax);
    %中心削波，三电平量化
     for i=1:n
        if newsignal(i)>cl
            newsignal(i)=newsignal(i)-cl;
        elseif newsignal(i)<-cl
            newsignal(i)=newsignal(i)+cl;
        else
            newsignal(i)=0;
        end
     end
     newsignal0=sign(newsignal);    
     %求取信号的互相关值R(k),Rk(1)对应于短时能量
     Rk=zeros(1,150);
     for i=21:300
         Rk(1)=Rk(1)+newsignal(i)*newsignal0(i); 
     end
     
     for i=20:150
         for j=21:300
             Rk(i)=Rk(i)+newsignal(j)*newsignal0(j+i);
         end
     end    
     %基音周期即为使R(k)为最大值Rmax时位置k的值与采样频率fs的倒数的乘积
     Rmax=max(Rk(20:150));
     if Rmax<0.25*Rk(1)
        p=0;                    %本帧为清音，令其基音周期值为0
     else
        [y,p]=max(Rk(20:150));  
     end    
     s(t)=p;
     t=t+1;
end
s=s*1/fs;




