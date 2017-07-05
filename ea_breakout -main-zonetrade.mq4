//+------------------------------------------------------------------+
//|                                                  ea_breakout.mq4 |
//|                                                       david wang |
//|                                                     分形突破交易 |
//+------------------------------------------------------------------+
#property copyright "david wang"
#property link      "分形突破交易"

int rundebug=1;
double support_price_quickorder=10;//支持快成
double fixed_stoploss=0;//oanda 1000表示1美元 forex 100表示1 usd
int int_current_period=5;
double buyvol=0.01;

extern int   CurrentPeriods=5;//r
extern int dbl_magic_num=20051;
extern int parent_max_order_num=1;//max executed max order number
int parent_order_type=-1;
extern int max_order_num=1;//max executed max order number
extern string magicstring="Gold Fractale Main Trade";



//下面定义全局变量
int temp_int_Op_BUY=0;
int temp_int_Op_SELL=0;
int temp_int_Op_BUYLIMIT=0;
int temp_int_Op_SELLLIMIT=0;
int temp_int_OP_SELLSTOP=0;
int temp_int_OP_BUYSTOP=0;
int temp_int_parent_order_num=0;//上级已经有分形交易突破
//-------------------------------

 double upper_Fractals=0.0;
 double lower_Fractals=0.0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
    int int_dt_limit=queryLimit(0,0);//查询Ea的执行条件_时间
    CurrentPeriods=Period();
   ini_order_num();
     if((temp_int_Op_BUY+temp_int_Op_SELL)>0)
   { //如果有订单的话，可以监察订单的状态    
        generater_order_stoploss( buyvol);
  
   }/////   
 
    if((int_dt_limit==0)&&(temp_int_parent_order_num==1))
   {//开始执行相关策略,，没有订单的情形
          int int_risk=query_risk();//系统查+
          if(int_risk==1)
           {//在高风险市场中，EA不执行
               return(0);
           }//++++++++++
          run_strategy_zone();
          
        //+++++++++++++
        
        
   }//---------------------------------------------------------------------------- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//下面是订单处理
  int generater_order_stoploss(double buyvol)
  {   
   bool   result,bexecute;
   double price,order_profit,order_stoploss;
   int    cmd,error;
//----
       int or_t=OrdersTotal();
 
   for(int pos=0;pos<or_t;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)) 
      {
          
          if(OrderMagicNumber()==dbl_magic_num)
          {
                order_stoploss=OrderStopLoss();
                 
                  if(order_stoploss==0)
                  {
                      generater_neworder_stoploss(buyvol,OrderTicket());
            
                  }
          
          }
       }
    }


}
   int generater_neworder_stoploss(double buyvol,int order_num)
  {/*新订单的止损问题*/
       bool   result;
    double price,order_profit,order_stoploss,val;
   int    cmd,error;
   fixed_stoploss=MathAbs(Ask-Bid)*2;
 
//----
   if(OrderSelect(order_num,SELECT_BY_TICKET,MODE_TRADES))
     {
            

     
            cmd=OrderType();
            order_stoploss=OrderStopLoss();
           
            if(cmd==OP_BUY)
            {  
                price=Bid-fixed_stoploss;
                
               

            }
            else   
            {
                price=Ask+fixed_stoploss;
                
            }
             if(order_stoploss!=price)
             {
                           result= OrderModify(OrderTicket(),OrderOpenPrice(),price,0,0,Blue);
                            if(result)
                              {
                                  return(1);
                              }
                              else
                              {  
                                  return(0);
                              }
              }

      
      }
     
    
 
  }//+++++++++++++
  //+++++++++++++++



int gen_order_buy(double buyvol)
{  int order_num;
   int orderid;
  // double buyvol=0.01;//0.1手,forex只对
    order_num=OrderSend(Symbol(),OP_BUY,buyvol,Ask,support_price_quickorder,0,0,magicstring,dbl_magic_num,0,Green);
   
     if(order_num<0)
      { return(0);
        
      }
      else
      {  
        generater_neworder_stoploss(buyvol,order_num);
         
      }
      
        return(-1);
 
 }

 
 int gen_order_sell(double buyvol)
{  int order_num;
   int orderid;
   //double buyvol=0.01;//0.1手,forex只对
   
     //sell
     order_num=OrderSend(Symbol(),OP_SELL,buyvol,Bid,support_price_quickorder,0,0,magicstring,dbl_magic_num,0,Green);
       if(order_num<0)
      { return(0);
        
      }
      else
      {  
        generater_neworder_stoploss(buyvol,order_num);
         
      }
   return(1);
   } //=======================================================================
   




//下面是分形交易策略中区域交易方法
void run_strategy_zone()
{
   
   if(parent_order_type==OP_BUY)
   {
      if(isgreenzone(CurrentPeriods)==1)
      {
         if(iClose(NULL,CurrentPeriods,1)>iClose(NULL,CurrentPeriods,2))
         {   if(GlobalVariableGet("lasttradeprice")!=iClose(NULL,CurrentPeriods,1))
            {
               gen_order_buy(buyvol);//发出订单
             }  
            if(!GlobalVariableCheck("lasttradeprice"))
            {
              GlobalVariableSet("lasttradeprice",iClose(NULL,CurrentPeriods,1));
            }
            
         }//---------------------------------------
         
      }
    }
    //----------------------------------------------------------------------------
   if(parent_order_type==OP_SELL)
   {
      if(isgreenzone(CurrentPeriods)==2)
      {
          if(iClose(NULL,CurrentPeriods,1)<iClose(NULL,CurrentPeriods,2))
         {
           gen_order_sell(buyvol);//发出order
         }//---------------------------------------
      }
    }
}


  //----------------------------------------------------------------------------
  //____________________________________________________________________________

  //----------------------------------------------------------------------------
  //____________________________________________________________________________
  //-------------------------------------------------------
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
  //________
  /********************************************
查询交易风险度-先通过RSI来查询风险
*/
  int query_risk()
  {//查询风险参数日线
   int d_risk=0;
    double is1=75;//iRSI(NULL,parent_trend_period,14,PRICE_CLOSE,0);//
  //tōng guò gāo jí qū shì de RSIlái chá xún fēng xiǎn dù ，rú guǒ dà yú 85，bú néng mǎi ，rú guǒ
      if(is1>=85.0)
      {
         d_risk=1;//表示高风险区 buy
      }
       if(is1<=15.0)
      {
         d_risk=2;//表示高风险区sell
      }
       if(rundebug==1)
      {//增加
        
      
      }
 //  Alert(d_risk);
  return(d_risk);
}
  
 
  
//____________________________________________________________________
  //------------------------------------------------------------------
 //下面是条件类函数 
 //+------------------------------------------------------------------+
//| 查询条件                                         |
//+------------------------------------------------------------------+
int queryLimit(int debug,int tp)
  {
//----
   int int_limit=1;
   
   if(tp==0)
   {//时间条件
      
      int h=TimeHour(TimeCurrent());
      //Alert("hour:",h);
      if((h>-1)&&(h<25))
      {//时间在8点到12点,采用是美国时间
         int_limit=0;
      }
     
   }//时间条件结束
  
//----
   return(int_limit);
  }
  
  
  //+------------------------------------------------------------------+
//查询订单数量状态[挂单不计算]
//
//+------------------------------------------------------------------+

 //+------------------------------------------------------------------+
//查询订单数量状态[挂单不计算]
//
//+------------------------------------------------------------------+


 //+------------------------------------------------------------------+
//查询订单数量状态[挂单不计算]
//
//+------------------------------------------------------------------+
int ini_order_num()//初始化订单数量--------
{
    //初始化所有变量
      temp_int_Op_BUY=0;
      temp_int_Op_SELL=0;
      temp_int_Op_BUYLIMIT=0;
      temp_int_Op_SELLLIMIT=0;
      temp_int_OP_SELLSTOP=0;
      temp_int_OP_BUYSTOP=0;
      temp_int_parent_order_num=0;
   //上面是初始化所有变量
    
    int or_t=OrdersTotal();
 
   for(int pos=0;pos<or_t;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)) 
      {
          
          if(OrderMagicNumber()==parent_max_order_num)
          {
               temp_int_parent_order_num++;
               parent_order_type=OrderType();
          }
          if(OrderMagicNumber()==dbl_magic_num)
          {
              
                if(OrderType()==OP_BUY)
               {//主要是排除挂单#00
                 temp_int_Op_BUY++;
                 
                }//#00---------------
                 if(OrderType()==OP_SELL )
               {//主要是排除挂单#00
                  temp_int_Op_SELL++;
                }//#00---------------
                 if(OrderType()==OP_BUYLIMIT)
               {//主要是排除挂单#00
                   temp_int_Op_BUYLIMIT++;
            
                }//#00---------------
                
                 if(OrderType()==OP_SELLLIMIT)
               {//主要是排除挂单#00
                 temp_int_Op_SELLLIMIT++;
                 
                }//#00---------------
                
                
                 if(OrderType()==OP_BUYSTOP)
               {//主要是排除挂单#00
                   temp_int_OP_BUYSTOP++;
                }//#00---------------
                
                 if(OrderType()==OP_SELLSTOP)
               {//主要是排除挂单#00
                 temp_int_OP_SELLSTOP++;
               }//#00-------------------------------------------
               //-------------------------------------------------------
               
               
          }

      }

   }
   return(0);//----------------------------------------

}//------------------------------


//===========================

//下面是描绘函数
void drawsome(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iHigh(NULL,0,i)+2);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 241);
     ObjectSet(str_obj_name, OBJPROP_COLOR, White);

   }
}
void drawsome1(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iHigh(NULL,0,i)+2);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 81);
      ObjectSet(str_obj_name, OBJPROP_COLOR, White);
   }
}

void drawany(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iLow(NULL,0,i)-22);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 241);
     ObjectSet(str_obj_name, OBJPROP_COLOR, White);

   }
}
void drawany1(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iLow(NULL,0,i)-2);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 81);
      ObjectSet(str_obj_name, OBJPROP_COLOR, White);
   }
}
void drawline(double val,int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_HLINE,0 ,0, val);
    
   }
}