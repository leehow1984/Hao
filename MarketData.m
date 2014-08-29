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
        function [MidPrice,BidPrice,AskPrice] = FindCurrentPrice(obj, Symbols)
            if size(Symbols,1) ~= 1 || iscell(Symbols) == 0
               error('Symbols must be a 1 * N 1 Cell');
            end
            
            Index = cell2mat(cellfun(@(x) find(strcmp(x,obj.Symbols)),Symbols,'UniformOutput', false));
            BidPrice = transpose(obj.BidPrice(Index,1));
            AskPrice = transpose(obj.AskPrice(Index,1));
            MidPrice = transpose(obj.MidPrice(Index,1));
        
        end
    end
    
end

