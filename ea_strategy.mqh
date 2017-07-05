//+------------------------------------------------------------------+
//|                                                    ea_tragic.mq4 |
//|                             Copyright 2013, david2wang  建单策略 |
//|                                       http://www.wangzhengjun.cn |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, david2wang  建单策略"
#property link      "http://www.wangzhengjun.cn"
extern int   CurrentPeriods     =1440;//日
extern double upper_Fractals=0.0;
extern double lower_Fractals=0.0;
extern double double_balance_stoploss=0.0;
 
/*PERIOD_M1 1 1 分钟 
PERIOD_M5 5 5分钟 
PERIOD_M15 15 15 分钟 
PERIOD_M30 30 30 分钟 
PERIOD_H1 60 1 小时 
PERIOD_H4 240 4 小时 
PERIOD_D1 1440 每天 
PERIOD_W1 10080 每星期 
*/
//buy bla 
double buy_b_sign(int tp,int Periods)
{int i;
double blan_sign;
  if(tp==1)
  {
         for(i=1;i<500;i++)
         {//
           if(iHigh(NULL,Periods,i+1)>iHigh(NULL,Periods,i))
           {
              blan_sign=iHigh(NULL,Periods,i+1);
              return(blan_sign);
              break;
           }
 
         }
   }
  
  if(tp==2)
  {
         for(i=1;i<500;i++)
         {//
             if((iHigh(NULL,Periods,i+2)>iHigh(NULL,Periods,i+1))&&(iHigh(NULL,Periods,i+1)>iHigh(NULL,Periods,i)))
           {
                blan_sign=iHigh(NULL,Periods,i+2);
                  return(blan_sign);
                  break;
           }
 
         }
   }

}

double sell_b_sign(int tp,int Periods)
{     int i;
      double blan_sign;
        if(tp==1)
  {
         for(i=1;i<500;i++)
         {//
           if(iLow(NULL,Periods,i+1)<iLow(NULL,Periods,i))
           {
              blan_sign=iLow(NULL,Periods,i+1);
              return(blan_sign);
              break;
           }
 
         }
   }
  
  if(tp==2)
  {
         for(i=1;i<500;i++)
         {//
             if((iLow(NULL,Periods,i+2)<iLow(NULL,Periods,i+1))&&(iLow(NULL,Periods,i+1)<iLow(NULL,Periods,i)))
           {
                blan_sign=iLow(NULL,Periods,i+2);
                  return(blan_sign);
                  break;
           }
 
         }
   }
}
int run_balance(int tp,double currentprice,int Periods)
{//首先得到平衡线的高点，然后比较当前值，如果突破。就执行 


   double myTheeth=iAlligator(NULL,Periods,13,8,8,5,5,4,MODE_SMMA,PRICE_CLOSE,MODE_GATORTEETH,1);
    double db_buy_line,db_sell_line;//平衡线
   if(currentprice>myTheeth)
   {
         if(tp==1)
         {
            db_buy_line=buy_b_sign(1,Periods);
            double_balance_stoploss=db_buy_line;
            if(currentprice>db_buy_line)
            {
            return(1);
            }
      
   
         }
         if(tp==2)
         {
            db_sell_line=sell_b_sign(2,Periods);
            double_balance_stoploss=db_sell_line;
            if(currentprice<db_sell_line)
            {
            return(2);
            }
   
         }
   }
   
   
    if(currentprice<myTheeth)
   {
         if(tp==1)
         {
            db_buy_line=buy_b_sign(2,Periods);
            double_balance_stoploss=db_buy_line;
             if(currentprice>db_buy_line)
            {
            return(1);
            }
   
         }
         if(tp==2)
         {
            db_sell_line=sell_b_sign(1,Periods);
            double_balance_stoploss=db_sell_line;
            if(currentprice<db_sell_line)
            {
               return(2);
            }
   
   
         }
   }

}

int run_strategy_fractals()
{
   if(breakout(iClose(NULL,CurrentPeriods,1))==1)
      {//向上突破
           if(isgreenzone(CurrentPeriods)==1)
           {
               //orderDeal(1);//发出订单
           
           }
      }//++++++++++++++++++++++++
      
      if(breakout(iClose(NULL,CurrentPeriods,1))==2)
      {//向下breakout
           if(isgreenzone(CurrentPeriods)==2)
           {
               // orderDeal(1);//发出order
           }
       }//+++   




}

int breakout(double currentval)
{//currentval,当前值
//突破信息，如果发生突
     
       upper_Fractals=getFractals(1,CurrentPeriods);//上区间
       lower_Fractals=getFractals(-1,CurrentPeriods);  //下区间
       double myTheeth=iAlligator(NULL,CurrentPeriods,13,8,8,5,5,4,MODE_SMMA,PRICE_CLOSE,MODE_GATORTEETH,1);
   
       if((currentval>upper_Fractals)&&(currentval>myTheeth))
       {//向上突破
             return(1);
       }
       if((currentval<lower_Fractals)&&(currentval<myTheeth))
       {//向下突破
          return(2);
         }

        return(0);
   
   
  }
  //____________________________________________________________________________
  //----------------------------------------------------------------------------
  //____________________________________________________________________________
  //----------------------------------------------------------------------------
  

//funname:getFractals
//得到分形的区间，tp=1,得到上分形 tp=-1得到下分形，Periods时间

/**/
double getFractals(int tp,int Periods)
{//
      if(tp==1)
      {//upper
          double val;
            for(int i=0;i<1000;i++)
            { 
                 val =iFractals(NULL, Periods, MODE_UPPER, i);
                 if(val>0)
                 {
                   break;
                }
            } 
            return(val);
   
      }
      if(tp==-1)
      {//Low
             for( i=0;i<1000;i++)
            { 
                 val =iFractals(NULL,Periods, MODE_LOWER, i);
                 if(val>0)
                 {
                   break;
                }
            } 
            return(val);
   
   
      }
   


}
 //____________________________________________________________________________
  //----------------------------------------------------------------------------
  //____________________________________________________________________________
  //----------------------------------------------------------------------------
  
int isgreenzone(int Periods)
{/*绿色区域表示可以执行相关策略*/
      int    AcSignal,AoSignal;
      AcSignal=FUNAcSignal(Periods);
      AoSignal=FUNAoSignal(Periods);
      if((AcSignal==1)&&(AoSignal==1))
      {
         return(1);
      }
      if((AcSignal==2)&&(AoSignal==2))
      {
         return(2);
      }
      return(0);

}
int FUNAcSignal(int Periods)
   { double AC1;
     int    myAcSignal;
     AC1=iAC(NULL,Periods,1);
     if(AC1>0)       {  myAcSignal=1;       }         
     if(AC1<0)       {  myAcSignal=2;       }
     return(myAcSignal);
   }
int FUNAoSignal(int Periods)
   {  double AO1;
      int    myAoSignal;
      AO1=iAO(NULL,Periods,1);
      if(AO1>0)      {  myAoSignal=1;        }
      if(AO1<0)      {  myAoSignal=2;        }
      return(myAoSignal);
   }
    //____________________________________________________________________________
  //----------------------------------------------------------------------------
  //____________________________________________________________________________
  //----------------------------------------------------------------------------
  