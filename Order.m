classdef Order
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Symbol;
        OrderType;
        Quantity;
        Direction;
        OrderPrice;
    end
    
    methods
        
        %/ constructor
        function obj = Order(Symbol,OrderType,Quantity,Direction, OrderPrice)
            obj.Symbol = Symbol;
            obj.OrderType = OrderType;
            obj.Quantity = Quantity;
            obj.Direction = Direction;
            obj.OrderPrice = OrderPrice;
        end
    end
    
end

