classdef PairTradingData
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    %define object properties
    properties
        Dates;
        YMidPrice;
        YBidPrice;
        YAskPrice;
        YRescPrice;
        XMidPrice;
        XBidPrice;
        XAskPrice;
        XRescPrice;        
    end
    %define object function
    methods
        % object constructor
        function obj = PairTradingData(Dates,Ybid,Yask,Xbid, Xask)
           %/ load external data 
           obj.Dates = Dates;
           obj.YBidPrice = Ybid;
           obj.YAskPrice = Yask;
           obj.XBidPrice = Xbid;
           obj.XAskPrice = Xask;
           
           %/ calculate mid price
           obj.YMidPrice = (obj.YAskPrice + obj.YBidPrice)/2;
           %/ calculate mid price
           obj.XMidPrice = (obj.XAskPrice + obj.XBidPrice)/2;           
           %/ calculate Rescale y price
           RetVec = (obj.YMidPrice(2:end,:) - obj.YMidPrice(1:end-1,:))./obj.YMidPrice(1:end-1,:);
           obj.YRescPrice = zeros(size(RetVec,1) + 1, size(RetVec,2));
           obj.YRescPrice(1,:) = 1; 
           for i = 1:size(RetVec,1)
               obj.YRescPrice(i + 1, :) =  obj.YRescPrice(i, :) .* (RetVec(i,:)+1);
           end
            %/ calculate Rescale X price
           RetVec = (obj.XMidPrice(2:end,:) - obj.XMidPrice(1:end-1,:))./obj.XMidPrice(1:end-1,:);
           obj.XRescPrice = zeros(size(RetVec,1) + 1, size(RetVec,2));
           obj.XRescPrice(1,:) = 1; 
           for i = 1:size(RetVec,1)
               obj.XRescPrice(i + 1, :) =  obj.XRescPrice(i, :) .* (RetVec(i,:)+1);
           end           
           
        end
        
        
    end
    
end

