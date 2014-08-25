classdef Order
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Symbol; % 1 X N cell
        OrderType; % 1 X N cell
        Quantity;  % 1 X N matrix
        Direction; % 1 X N matrix
        OrderPrice; % 1 X N matrix
        
        ExecuteSignal;
        ExecuteSetteledPrice;
        ExecuteTransactionCost;
    end
    
    methods
        
        %/ constructor
        function obj = Order(Symbol,OrderType,Quantity,Direction, OrderPrice)
            %/ check parameters
            if size(Symbols,1) > 1 || ~iscell(Symbols)
               error('Symbols needs to be a 1 x N cell ');
            end
            
            if size(OrderType,1) > 1 || iscell(OrderType)
               error('OrderType needs to be a 1 X N cell');
            else
               for i = 1:size(OrderType,1) 
                   if strcmp(OrderType(i,1), 'MarketOrder') ~= 1 && strcmp(OrderType(i,1), 'LimitOrder') ~= 1
                      error('OrderType can only be MarketOrder or LimitOrder');
                   end    
               end 
            end
            
            if size(Quantity,1) > 1 || ismatrix(Quantity)
               error('Quantity can only be 1 X N matrix');
            end
            
            if size(Direction,1) > 1 || ismatrix(Direction)
               error('Direction can only be 1 X N matrix');
            end
             if size(OrderPrice,1) > 1 || ismatrix(OrderPrice)
               error('Direction can only be 1 X N matrix');
            end           
            

            %/ load order parameters
            obj.Symbol = Symbol;
            obj.OrderType = OrderType;
            obj.Quantity = Quantity;
            obj.Direction = Direction;
            obj.OrderPrice = OrderPrice;
            %/ construct execution obj
            OrderExecution = Execution(TCostRate,Slippage);
            %/ execute order
            [obj.ExecuteSignal,obj.ExecuteSetteledPrice,obj.ExecuteTransactionCost] = OrderExecution.Excute(MarketData, obj); 
        end
    end
    
end

