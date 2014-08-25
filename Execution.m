classdef Execution
    
    %
    % Excution object excute trading signals and calculate trading return
    %

    %/ object property 
    properties
       Slippage;
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
        function [Signal,SettledPrice,TransactionCost] = Execute(obj, MarketData, Order)
            Index = find(strcmp(Order.Symbol,MarketData.Symbols),'first');
            %/ calculate transaction cost
            if OrderDirection == 1 %/ if it is a buy order
               SettledPrice = MarketData.AskPrice(Index,1);
               Signal = 1; 
               TransactionCost = (obj.SettledPrice * Order.Quantity)*obj.TCostRate; 
            elseif OrderDirection == -1 %/ if it is a sell order
               SettledPrice = MarketData.BidPrice(Index,1);
               Signal = 1; 
               TransactionCost = (obj.SettledPrice * Order.Quantity)*obj.TCostRate;  
            end
            
            
        end
        
        
    end
    
end

