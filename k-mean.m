%Convert the data from table to array 
CreditCardCustomerData=table2array(CreditCardCustomerData);
%Claculate the optimised k value using elbow curve
sa=[];
K=[];
for k=1:20
[idx, c, sumd]=kmeans(CreditCardCustomerData,k);
sa=[sa,sum(sumd)];
K=[K,k];
end

idx=kmeans(CreditCardCustomerData,3);
gscatter(CreditCardCustomerData(:,1),CreditCardCustomerData(:,2),idx);