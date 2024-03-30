CreditCardCustomerData = table2array(CreditCardCustomerData);
sa = [];
K = [];
for k = 1:20
    [idx, c, sumd] = kmedoids(CreditCardCustomerData, k);
    sa = [sa,sum(sumd)];
    K = [K,k];
end


[idx, c, sumd] = kmedoids(CreditCardCustomerData, 3);
gscatter(CreditCardCustomerData(:,1),CreditCardCustomerData(:,2), idx);