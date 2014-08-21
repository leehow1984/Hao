classdef Execution
    
    %
    % Excution object excute trading signals and calculate trading return
    %

    %/ object property 
    properties
       Signal; %/ Binary Variable 1: Filled 0: Fail to fill
       SettledPrice;
       TransactionCost;
       TCostRate;
    end
    
    %/ object methods
    methods
        
        %/ constructor
        function obj = Excution(TCostRate,Slippage)
            obj.TCostRate = TCostRate;
            obj.Slippage = Slippage;
        end
        
        
        %/ excution function(assume order are filled successfully @ bid/ask price)
        function obj = Execute(obj, MarketData, Order)
            Index = find(strcmp(Order.Symbol,MarketData.Symbols),'first');
            
            %/ calculate transaction cost
            if OrderDirection == 1 %/ if it is a buy order
               obj.SettledPrice = MarketData.AskPrice(Index,1);
               obj.Signal = 1; 
               obj.TransactionCost = (obj.SettledPrice * Order.Quantity)*obj.TCostRate; 
            elseif OrderDirection == -1 %/ if it is a sell order
               obj.SettledPrice = MarketData.BidPrice(Index,1);
               obj.Signal = 1; 
               obj.TransactionCost = (obj.SettledPrice * Order.Quantity)*obj.TCostRate;  
            end
            
            
        end
        
        
    end
    
end

