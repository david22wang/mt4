//+------------------------------------------------------------------+
//|                                                  ea_breakout.mq4 |
//|                                                       david wang |
//|                                                     ����ͻ�ƽ��� |
//+------------------------------------------------------------------+
#property copyright "david wang"
#property link      "����ͻ�ƽ���"

int rundebug=1;
double support_price_quickorder=10;//֧�ֿ��
double fixed_stoploss=0;//oanda 1000��ʾ1��Ԫ forex 100��ʾ1 usd
int int_current_period=5;
double buyvol=0.01;

extern int   CurrentPeriods=5;//r
extern int dbl_magic_num=20051;
extern int parent_max_order_num=1;//max executed max order number
int parent_order_type=-1;
extern int max_order_num=1;//max executed max order number
extern string magicstring="Gold Fractale Main Trade";



//���涨��ȫ�ֱ���
int temp_int_Op_BUY=0;
int temp_int_Op_SELL=0;
int temp_int_Op_BUYLIMIT=0;
int temp_int_Op_SELLLIMIT=0;
int temp_int_OP_SELLSTOP=0;
int temp_int_OP_BUYSTOP=0;
int temp_int_parent_order_num=0;//�ϼ��Ѿ��з��ν���ͻ��
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
    int int_dt_limit=queryLimit(0,0);//��ѯEa��ִ������_ʱ��
    CurrentPeriods=Period();
   ini_order_num();
     if((temp_int_Op_BUY+temp_int_Op_SELL)>0)
   { //����ж����Ļ������Լ�충����״̬    
        generater_order_stoploss( buyvol);
  
   }/////   
 
    if((int_dt_limit==0)&&(temp_int_parent_order_num==1))
   {//��ʼִ����ز���,��û�ж���������
          int int_risk=query_risk();//ϵͳ��+
          if(int_risk==1)
           {//�ڸ߷����г��У�EA��ִ��
               return(0);
           }//++++++++++
          run_strategy_zone();
          
        //+++++++++++++
        
        
   }//---------------------------------------------------------------------------- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//�����Ƕ�������
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
  {/*�¶�����ֹ������*/
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
  // double buyvol=0.01;//0.1��,forexֻ��
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
   //double buyvol=0.01;//0.1��,forexֻ��
   
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
   




//�����Ƿ��ν��ײ����������׷���
void run_strategy_zone()
{
   
   if(parent_order_type==OP_BUY)
   {
      if(isgreenzone(CurrentPeriods)==1)
      {
         if(iClose(NULL,CurrentPeriods,1)>iClose(NULL,CurrentPeriods,2))
         {   if(GlobalVariableGet("lasttradeprice")!=iClose(NULL,CurrentPeriods,1))
            {
               gen_order_buy(buyvol);//��������
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
           gen_order_sell(buyvol);//����order
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
{/*��ɫ�����ʾ����ִ����ز���*/
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
��ѯ���׷��ն�-��ͨ��RSI����ѯ����
*/
  int query_risk()
  {//��ѯ���ղ�������
   int d_risk=0;
    double is1=75;//iRSI(NULL,parent_trend_period,14,PRICE_CLOSE,0);//
  //t��ng gu�� g��o j�� q�� sh�� de RSIl��i ch�� x��n f��ng xi��n d�� ��r�� gu�� d�� y�� 85��b�� n��ng m��i ��r�� gu��
      if(is1>=85.0)
      {
         d_risk=1;//��ʾ�߷����� buy
      }
       if(is1<=15.0)
      {
         d_risk=2;//��ʾ�߷�����sell
      }
       if(rundebug==1)
      {//����
        
      
      }
 //  Alert(d_risk);
  return(d_risk);
}
  
 
  
//____________________________________________________________________
  //------------------------------------------------------------------
 //�����������ຯ�� 
 //+------------------------------------------------------------------+
//| ��ѯ����                                         |
//+------------------------------------------------------------------+
int queryLimit(int debug,int tp)
  {
//----
   int int_limit=1;
   
   if(tp==0)
   {//ʱ������
      
      int h=TimeHour(TimeCurrent());
      //Alert("hour:",h);
      if((h>-1)&&(h<25))
      {//ʱ����8�㵽12��,����������ʱ��
         int_limit=0;
      }
     
   }//ʱ����������
  
//----
   return(int_limit);
  }
  
  
  //+------------------------------------------------------------------+
//��ѯ��������״̬[�ҵ�������]
//
//+------------------------------------------------------------------+

 //+------------------------------------------------------------------+
//��ѯ��������״̬[�ҵ�������]
//
//+------------------------------------------------------------------+


 //+------------------------------------------------------------------+
//��ѯ��������״̬[�ҵ�������]
//
//+------------------------------------------------------------------+
int ini_order_num()//��ʼ����������--------
{
    //��ʼ�����б���
      temp_int_Op_BUY=0;
      temp_int_Op_SELL=0;
      temp_int_Op_BUYLIMIT=0;
      temp_int_Op_SELLLIMIT=0;
      temp_int_OP_SELLSTOP=0;
      temp_int_OP_BUYSTOP=0;
      temp_int_parent_order_num=0;
   //�����ǳ�ʼ�����б���
    
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
               {//��Ҫ���ų��ҵ�#00
                 temp_int_Op_BUY++;
                 
                }//#00---------------
                 if(OrderType()==OP_SELL )
               {//��Ҫ���ų��ҵ�#00
                  temp_int_Op_SELL++;
                }//#00---------------
                 if(OrderType()==OP_BUYLIMIT)
               {//��Ҫ���ų��ҵ�#00
                   temp_int_Op_BUYLIMIT++;
            
                }//#00---------------
                
                 if(OrderType()==OP_SELLLIMIT)
               {//��Ҫ���ų��ҵ�#00
                 temp_int_Op_SELLLIMIT++;
                 
                }//#00---------------
                
                
                 if(OrderType()==OP_BUYSTOP)
               {//��Ҫ���ų��ҵ�#00
                   temp_int_OP_BUYSTOP++;
                }//#00---------------
                
                 if(OrderType()==OP_SELLSTOP)
               {//��Ҫ���ų��ҵ�#00
                 temp_int_OP_SELLSTOP++;
               }//#00-------------------------------------------
               //-------------------------------------------------------
               
               
          }

      }

   }
   return(0);//----------------------------------------

}//------------------------------


//===========================

//��������溯��
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