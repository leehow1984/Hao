classdef PairTradingData
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    
    %define object properties
    properties
        Dates;
        YMidPrice; %/ 1 X M
        YBidPrice;  %/ 1 X M
        YAskPrice;  %/ 1 X M
        YRescPrice;  %/ 1 X M
        XMidPrice;  %/ 1 X M
        XBidPrice;  %/ 1 X M
        XAskPrice;  %/ 1 X M
        XRescPrice;     %/ 1 X M
        YRetVec;
        XRetVec;
        DataType;
        YSymbols; %/  1 X N cell
        XSymbols; %/  1 X N cell
    end
    %/ define object function
    methods
        %/ object constructor
        function obj = PairTradingData(Dates,Ybid,Yask,Xbid, Xask,YSymbols,XSymbols,DataType)
           %/ load external data 
           obj.Dates = Dates;
           obj.YBidPrice = Ybid;
           obj.YAskPrice = Yask;
           obj.XBidPrice = Xbid;
           obj.XAskPrice = Xask;
           obj.DataType  = DataType;
           
           %/ load security ticker
           obj.YSymbols = YSymbols;
           obj.XSymbols = XSymbols;
           
           
           %/ calculate mid price
           obj.YMidPrice = (obj.YAskPrice + obj.YBidPrice)/2;
           %/ calculate mid price
           obj.XMidPrice = (obj.XAskPrice + obj.XBidPrice)/2;
           
           %/ if data type is historical data then calculate historical
           %/ return and rescaled prices
           if strcmp(DataType,'Historical')
              %/ calculate Rescale y price
              obj.YRetVec = (obj.YMidPrice(2:end,:) - obj.YMidPrice(1:end-1,:))./obj.YMidPrice(1:end-1,:);
              obj.YRescPrice = zeros(size(obj.YRetVec,1) + 1, size(obj.YRetVec,2));
              obj.YRescPrice(1,:) = 1; 
              for i = 1:size(obj.YRetVec,1)
                  obj.YRescPrice(i + 1, :) =  obj.YRescPrice(i, :) .* (obj.YRetVec(i,:)+1);
              end
           
              %/ calculate Rescale X price
              obj.XRetVec = (obj.XMidPrice(2:end,:) - obj.XMidPrice(1:end-1,:))./obj.XMidPrice(1:end-1,:);
              obj.XRescPrice = zeros(size(obj.XRetVec,1) + 1, size(obj.XRetVec,2));
              obj.XRescPrice(1,:) = 1; 
              for i = 1:size(obj.XRetVec,1)
                  obj.XRescPrice(i + 1, :) =  obj.XRescPrice(i, :) .* (obj.XRetVec(i,:)+1);
              end  
           end
           
           
        end
    end
    
end

