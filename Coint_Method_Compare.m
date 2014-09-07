%% Trading Set Up: trading parameter and trading portfolio  
lookback = 300;
lookfwd = 60;
portfolio = Portfolio(100);
portfolio.Direction = 0;
tradinglog = cell(0,1);
Strategy = PairTradingStrategy(0,3,40);
Ycol = 2;
Xcol = 4:6;


EG_PV_Vec = zeros(1,1);
EG2_PV_Vec = zeros(1,1);
Hao_PV_Vec = zeros(1,1);

for i = lookback+2:size(Data,1)
    %1. generate market data  
    NewMarketData = MarketData(datenum(Data(i,1)),transpose(Data(1,2:end)), transpose(cell2mat(Data(i,2:end))),transpose(cell2mat(Data(i,2:end))));
    %2. Generate historical training data     
    TrainingData = PairTradingData(datenum(Data(i-lookback:i-1)),...
                                   cell2mat((Data(i-lookback:i-1,Ycol))),... %y bid
                                   cell2mat((Data(i-lookback:i-1,Ycol))),... %y ask
                                   cell2mat((Data(i-lookback:i-1,Xcol))),... %x bid
                                   cell2mat((Data(i-lookback:i-1,Xcol))),... %x ask
                                   Data(1,Ycol),... %y symbol
                                   Data(1,Xcol),... %x symbol
                                   'Historical');
    
                               
     %% / Engle-Granger Test                           
     [EG_h,EG_pValue,EG_stat,EG_cValue,EG_reg1,EG_reg2] = egcitest([TrainingData.YMidPrice TrainingData.XMidPrice]);
     %/ Print result
     display(strcat(datestr(TrainingData.Dates(end,1)),' EG Test Stationary = ', num2str(EG_h), '  PVAL = ', num2str(EG_pValue)));  
     EG_PV_Vec(i,1) = EG_pValue;
     
     plot(EG_reg1.res);
     pause(0.01)
     
     
     
     
     
    
     %% standardize
     stdreg1res = (EG_reg1.res - mean(EG_reg1.res))./std(EG_reg1.res);
     [EG2_stationarity, EG2_Pval] = adftest(stdreg1res,'model','AR','lags',0);
     EG2_PV_Vec(i,1) = EG2_Pval;
     display(strcat(datestr(TrainingData.Dates(end,1)),' EG2 Test Stationary = ', num2str(EG2_stationarity), '  PVAL = ', num2str(EG2_Pval)));  
     
    %% / My Own Method 
     YRetVec = TrainingData.YRetVec;
     XRetVec = TrainingData.XRetVec;
    
      %/ if size of X > 2 then use PCs to aviod co-linearity
      %in the following linear regression
      if size(XRetVec,2) > 1
         pccoef = princomp(XRetVec);
         pccomponent = XRetVec * pccoef;
       else
         pccoef = 1;
         pccomponent = XRetVec;
      end

      %/ linear regression on ret     
      RegSt = regstats(YRetVec,pccomponent,'linear',{'beta','r'});
      ResIndex = zeros(1,1);
      ResIndex(1,1) = 1;
      for j = 1:size(RegSt.r)
          ResIndex(j+ 1,:) = ResIndex(j,:) * (1 + RegSt.r(j,1));
      end
      
      StdResIndex = (ResIndex - mean(ResIndex))/std(ResIndex);
             
      %/ check stationarity 
     [Hao_stationarity, Hao_Pval] = adftest(StdResIndex,'model','AR','lags',0);
     
      %/ Print result
     display(strcat(datestr(TrainingData.Dates(end,1)),' ADF Test Stationary = ', num2str(Hao_stationarity), '  PVAL = ', num2str(Hao_Pval)));
     Hao_PV_Vec(i,1) = Hao_Pval;
     
     %plot(EG_PV_Vec);
     %hold all;
     %plot(EG2_PV_Vec);
     %hold all;
     %plot(Hao_PV_Vec);
     %pause(0.01);
     %clf('reset')
    
end    




