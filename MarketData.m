classdef MarketData
    %
    %   Market Data Obj
    %   Date: 1XN Cell 
    %   Symbols: 1 X N Cell
    
    properties
        Date;
        Symbols;
        BidPrice;
        AskPrice;
        MidPrice;
    end
    
    methods
        %/ Constructor
        function obj = MarketData(Date,Symbols,BidPrice,AskPrice)
            obj.Date = Date;
            obj.Symbols = Symbols;
            obj.BidPrice = BidPrice;
            obj.AskPrice = AskPrice;
            obj.MidPrice = (obj.BidPrice + obj.AskPrice)/2;
        end
    end
    
end

