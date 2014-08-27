classdef Execution
    
    %
    % Excution object excute trading signals and calculate trading return
    %

    %/ object property 
    properties
       Slippage;
       TCostRate;
       SettledPrice;
       Signal;
       TransactionCost;
    end
    
    %/ object methods
    methods
        
        %/ constructor
        function obj = Execution(TCostRate,Slippage , MarketData, Order)
            obj.TCostRate = TCostRate;
            obj.Slippage = Slippage;
        %/ excution function(assume order are filled successfully @ bid/ask price)
            Index = cell2mat(cellfun(@(x) find(strcmp(x,MarketData.Symbols)),Order.Symbol,'UniformOutput', false));
            %/ calculate transaction cost
            for i = 1:size(Order.Direction,2)
               if Order.Direction(1,i) == 1 %/ if it is a buy order
                  obj.SettledPrice(1,i) = MarketData.AskPrice(Index(1,i),1);
                  obj.Signal(1,i) = 1; 
                  obj.TransactionCost(1,i) = (obj.SettledPrice(1,i) * Order.Quantity(1,i))*obj.TCostRate; 
               elseif Order.Direction(1,i) == -1 %/ if it is a sell order
                  obj.SettledPrice(1,i) = MarketData.BidPrice(Index(1,i),1);
                  obj.Signal(1,i) = 1; 
                  obj.TransactionCost(1,i) = (obj.SettledPrice(1,i) * Order.Quantity(1,i))*obj.TCostRate;  
               end
            end
        end
        
        
    end
    
end

