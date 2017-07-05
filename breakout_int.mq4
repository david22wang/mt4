//+------------------------------------------------------------------+
//|                                                 breakout_int.mq4 |
//|                                                       david wang |
//|                                                     ����ͻ�ƽ��� |
//+------------------------------------------------------------------+
#property copyright "david wang"
#property link      "�̶�ֵͻ�ƽ���"
//���佻��
//
/*------------------------------------------------------------------+
�������
���Թ̶�ֵ���佻�ף��������ʱ��������ֵȡ��Сֵ��ֵ�����ֵ
����������23.52;;����Ϊ��23-24��������ͻ��24�����룬����������ϣ���������
��������
�������һ�������Ľ��׷���Ͳ�һ���������رպ����һ��
��һ�������еĶ���

------------------------------------------------------------------+*/

extern int dbl_magic_num=20051;//2��ʾ������
extern double support_price_quickorder=50;//���ٳɽ�\
extern double supportrvalue=0.5;//����ֹ��ֵ����ratioһ�룬�Լ��趨-------
extern int ratio=2;//�����,��֧��С����ֻ֧������

extern double stoplossvalue=0.0;//��ʼ��ֹ��ֵ
extern double buyvol=0.1;//���׵�����
extern string magicstring="Gold Trade";
  
//���涨��ȫ�ֱ���
int temp_int_Op_BUY=0;
int temp_int_Op_SELL=0;
int temp_int_Op_BUYLIMIT=0;
int temp_int_Op_SELLLIMIT=0;
int temp_int_OP_SELLSTOP=0;
int temp_int_OP_BUYSTOP=0;
//-------------------------------


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
     double oop,opp,t_opp;
    
      int tp,pos;
  
    stoplossvalue=2*MathAbs(Bid-Ask)/Point;
    int int_dt_limit=queryLimit(0,0);//��ѯEa��ִ������_ʱ��
    ini_order_num();//��ʼ����������---------------
 
 
   
      
     if((temp_int_Op_BUY+temp_int_Op_SELL)>1)
   { //����ж����Ļ������Լ�충����״̬    
      generate_order_profit(buyvol);
   
      //==============================================
  
   }//
   
     double dn=MathFloor(Bid/ratio);
        double dn1=MathFloor(Ask/ratio);
        if(dn!=dn1)
        {//����������ӣ���Ҫ���ڹؼ��㣬������
            return(0);
        }//---------------------------------------
     dn=dn*ratio;//��������
     double up=dn+1*ratio;//��������
    
     
   if((int_dt_limit==0)&&((temp_int_Op_BUY+temp_int_Op_SELL+temp_int_Op_BUYLIMIT+temp_int_Op_SELLLIMIT+temp_int_OP_SELLSTOP+temp_int_OP_BUYSTOP)==0))
   {//�ҵ���û��
        int os1= OrderSend(Symbol(),OP_BUYSTOP,buyvol,up,support_price_quickorder,up-stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
       if(os1>0)
       {
         int os2=  OrderSend(Symbol(),OP_SELLSTOP,buyvol,dn,support_price_quickorder,dn+stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
         if(os2<0)
         {//ɾ����һ������
         
            OrderDelete(os1);//����ǳ����ͻ�ɾ����һ����¼
         }//---------------------------------------------------------------------------------
       }//---------------------------------------------------------------------------------
     
       
   
   }
     if((int_dt_limit==0)&&((temp_int_Op_BUYLIMIT+temp_int_Op_SELLLIMIT+temp_int_OP_SELLSTOP+temp_int_OP_BUYSTOP)==1))//ʱ��������ֻ��һ���ҵ�����ʾ���ٳɽ�һ��
    {//#5
           for(pos=OrdersTotal()-1;pos>=0;pos--)
            {//#4
                        if(OrderSelect(pos,SELECT_BY_POS)) 
                        {//#3
                            
                             if(OrderMagicNumber()==dbl_magic_num)//#2
                              {
                                     
                                    if( (OrderType()==OP_BUYSTOP)||(OrderType()==OP_SELLSTOP ))
                                    {//��Ҫ���ų��ҵ�#1
                                        OrderDelete(OrderTicket());
                                        break;
                                     }//#1
                                     
                                     
                                 }//#2
                         }//#3
              } //#4------------------------------------  
         
    }
   
    if((int_dt_limit==0)&&((temp_int_Op_BUYLIMIT+temp_int_Op_SELLLIMIT+temp_int_OP_SELLSTOP+temp_int_OP_BUYSTOP)==0)&&((temp_int_Op_BUY+temp_int_Op_SELL)>0))//ʱ��������ֻ��һ���ҵ�����ʾ���ٳɽ�һ��
    {//#5-----------------------------------------------------------------------
         
         
             //������ɾ��һ���ҵ�
             t_opp=0;//��ʼ������
             
              for(pos=OrdersTotal()-1;pos>=0;pos--)
            {//#4
                        if(OrderSelect(pos,SELECT_BY_POS)) 
                        {//#3
                            
                             if(OrderMagicNumber()==dbl_magic_num)//#2
                              {//#2
                                    opp=MathRound(OrderOpenPrice());//��Ŀ���������۸�
                                   
                                   //  Alert(opp,"dn",dn,"up",up);//1390 1390 1392
                                     if((opp>(dn-Point))&&(opp<(up+Point)))
                                     {//�����Ŀ�����۸��ڳɽ������ڣ������µĶ���#0
                                         // Alert("ok");
                                     
                                     }//#0
                                     else
                                     {//#0
                                               os1= OrderSend(Symbol(),OP_BUYSTOP,buyvol,up,support_price_quickorder,up-stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
                                                if(os1>0)
                                                {
                                                   os2=  OrderSend(Symbol(),OP_SELLSTOP,buyvol,dn,support_price_quickorder,dn+stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
                                                  if(os2<0)
                                                  {//ɾ����һ������
         
                                                     OrderDelete(os1);//����ǳ����ͻ�ɾ����һ����¼
                                                  }//---------------------------------------------------------------------------------
                                                }//----------------------
                                                break;
                                     
                                     
                                     }//#0
                                     break;//��Ҫ�ǲ�ѯ���һ���ɽ���¼
                                     
           
                                   
                                     
                                     
                                     
                                     
                               }//#2
                         }//#3
              } //#4-----------------------------
              
                           
                           
    
    
    }//#5
  
   
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

 //�����������ຯ�� 
 //+------------------------------------------------------------------+
//| ��ѯ����                                         |
//+------------------------------------------------------------------+
int queryLimit(int debug,int tp)
  {
//----
   int temp_int_limit=1;
   
   if(tp==0)
   {//ʱ������
      
      int h=TimeHour(TimeCurrent());
      //Alert("hour:",h);
      if((h>-1)&&(h<25))
      {//ʱ����8�㵽12��,����������ʱ��
         temp_int_limit=0;
      }
     
   }//ʱ����������
  
   
//----
   return(temp_int_limit);
  }
  
  
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
   //�����ǳ�ʼ�����б���
    
    int or_t=OrdersTotal();
 
   for(int pos=0;pos<or_t;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)) 
      {
          
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


  //�����Ƕ���ִ���ຯ��
   
   int generate_order_profit(double buyvol)
  {  //������ִ�ж�����ִ���������
     //������ַ����ƣ����ø�����ֹ�����
     //������һ��������һ�����ر�����  
     int trade_tp=0;//��������

     double myarray[100];
     ArrayInitialize(myarray,0.0);
     
      for(int i=0;i<OrdersTotal();i++)
      {//#2 
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {//#1   
                    if(OrderMagicNumber()==dbl_magic_num)
                      {//fixed 2013-5-6#0
                              
                            if( OrderType()==OP_BUY)
                              {  myarray[i]=1;
                                
                              }    
                               
                           if( OrderType()==OP_SELL)
                              {
                                 myarray[i]=-1; 
                              } 
                               
                     }//#0
                 }//#1  
                         
  
      }//#2 
      if((myarray[ArrayMaximum(myarray)]==1)&&(myarray[ArrayMaximum(myarray)]==-1))
      {//close all Order
      //#00000000000000
      
               int trade_tps=0;
               for(i=0;i<OrdersTotal();i++)
               {//#2 
                       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                        {//#1   
                             if(OrderMagicNumber()==dbl_magic_num)
                               {//fixed 2013-5-6#0
                                    
                                      if( OrderType()==OP_BUY)
                                      {   if((trade_tps==0)||(trade_tps==1))//����Ҫ�������һ������--------------
                                           {
                                                OrderClose(OrderTicket(),OrderLots(),Bid,support_price_quickorder,Red);
                                                trade_tps=1;
                                          }
                                                              
                                      }    
                               
                                   if( OrderType()==OP_SELL)
                                      {
                                         if((trade_tps==0)||(trade_tps==2))//����Ҫ�������һ������-----------
                                           {
                                          OrderClose(OrderTicket(),OrderLots(),Ask,support_price_quickorder,Red);
                                           trade_tps=2;
                                          }
                                      } 
                      
                      
                                }//#0
                          }//#1  
                         
  
               }//#2 
      
      }//#00000000000000--------------------------------------------------------------
      
      

 
  
  }//------------------------------------
  //-----