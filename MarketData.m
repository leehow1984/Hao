classdef MarketData
    %
    %   Market Data Obj
    %   Date: 1XN Cell 
    %   Symbols: 1 X N Cell
    
    properties
        TimeStamp;
        Symbols;
        BidPrice;
        AskPrice;
        MidPrice;
    end
    
    methods
        %/ Constructor
        function obj = MarketData(TimeStamp,Symbols,BidPrice,AskPrice)
            obj.TimeStamp = TimeStamp;
            obj.Symbols = Symbols;
            obj.BidPrice = BidPrice;
            obj.AskPrice = AskPrice;
            obj.MidPrice = (obj.BidPrice + obj.AskPrice)/2;
        end
        
        %/ find current price given tickers
        %/ tickers ~ N * 1
        function PriceMatrix = FindCurrentPrice(obj, Symbols)
            if size(Symbols,2) ~= 1 || iscell(Symbols) == 0
               error('Symbols must be a N * 1 Cell');
            end
            
            Index = find(strcmp(Symbols,obj.Symbols));
            
            
        end
    end
    
end

