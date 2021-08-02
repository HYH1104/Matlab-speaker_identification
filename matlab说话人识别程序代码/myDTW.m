function [cost] = myDTW(featureMatrix,RefMatrix)
F = featureMatrix;
R = RefMatrix;
[r1,c1]=size(F);        
[r2,c2]=size(R);       
localDistance = zeros(r1,r2);
for n=1:r1
    for m=1:r2
        FR=F(n,:)-R(m,:);
        FR=FR.^2;
        localDistance(n,m)=sqrt(sum(FR));
    end
end
D = zeros(r1+1,r2+1);  
D(1,:) = inf;           
D(:,1) = inf;           
D(1,1) = 0;
D(2:(r1+1), 2:(r2+1)) = localDistance;

for i = 1:r1; 
 for j = 1:r2;
   [dmin] = min([D(i, j), D(i, j+1), D(i+1, j)]);
   D(i+1,j+1) = D(i+1,j+1)+dmin;
 end
end

cost = D(r1+1,r2+1);    

