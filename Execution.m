classdef Execution
    
    %
    % Excution object excute trading signals and calculate trading return
    %

    %/ object property 
    properties
       Signal; %/ Binary Variable 1: Filled 0: Fail to fill
       SettledPrice;
       TransactionCost;
       Slippage;
    end
    
    %/ object methods
    methods
        
        %/ constructor
        function obj = Excution(TransactionCost,Slippage)
            obj.TransactionCost = TransactionCost;
            obj.Slippage = Slippage;
        end
        
        
        %/ excution function
        function obj = Execute(obj, MarketData, Order)
            Index = find(strcmp(Order.Symbol,MarketData.Symbols),'first');
            MarketPrice = 1;
            
            
        end
    end
    
end

