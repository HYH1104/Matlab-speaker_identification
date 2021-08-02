function trimmedX = trim(x)
Ts = 0.001;          
Tsh = 0.0005;       
Fs = 8000;         
counter1 = 0;   
counter2 = 0;
ZCRCountf = 0;      
ZCRCountb = 0;      
w_sam = fix(Ts*Fs);                   
o_sam = fix(Tsh*Fs);                
lengthX = length(x);
segs = fix((lengthX-w_sam)/o_sam)+1;  
win = hamming(w_sam);
Limit = o_sam*(segs-1)+1;             
FrmIndex = 1:o_sam:Limit;                                                
ZCR_Vector = zeros(1,segs);                                                               
for t = 1:segs
    ZCRCounter = 0; 
    nextIndex = (t-1)*o_sam+1;
    for r = nextIndex+1:(nextIndex+w_sam-1)
        if (x(r) >= 0) && (x(r-1) >= 0)
         
        elseif (x(r) >= 0) && (x(r-1) < 0)
         ZCRCounter = ZCRCounter + 1;
        elseif (x(r) < 0) && (x(r-1) < 0)
         
        elseif (x(r) < 0) && (x(r-1) >= 0)
         ZCRCounter = ZCRCounter + 1;
        end
    end
    ZCR_Vector(t) = ZCRCounter;
end

Erg_Vector = zeros(1,segs);
for u = 1:segs
    nextIndex = (u-1)*o_sam+1;
   Energy = x(nextIndex:nextIndex+w_sam-1).*win;
    Erg_Vector(u) = sum(abs(Energy));
end


IMX = max(Erg_Vector);         
ITM=0.2*IMX^2;
IZCT=0.8*max(ZCR_Vector);

for i = 1:length(Erg_Vector)
    if ((Erg_Vector(i))^2 > ITM)
        counter1 = counter1 + 1;
        indexi(counter1) = i;
    end
end
for j=1:length(ZCR_Vector)
    if (ZCR_Vector(j)>IZCT)
        counter2=counter2+1;
        indexj(counter2)=j;
    end
end

start=min([indexi,indexj]);
finish=max([indexi,indexj]);

x_start = FrmIndex(start);     
x_finish = FrmIndex(finish); 
trimmedX = x(x_start:x_finish); 
                                








