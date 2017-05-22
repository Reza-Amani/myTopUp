//+------------------------------------------------------------------+
//|                                                 EA7_patterns.mq4 |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      ""
#property version   "1.00"
#property strict

#include <MyHeaders\MyMath.mqh>
#include <MyHeaders\Pattern.mqh>
#include <MyHeaders\ExamineBar.mqh>
#include <MyHeaders\Screen.mqh>
#include <MyHeaders\Tools.mqh>

///////////////////////////////inputs
input int      pattern_len=5;
input int      correlation_thresh=93;
input int      hit_threshold=66;
input int      min_hit=40;
input int      history=20000;
input double   i_Lots=1;
//////////////////////////////parameters
//////////////////////////////objects
Screen screen;
int file=FileOpen("./tradefiles/EAlog.csv",FILE_WRITE|FILE_CSV,',');

//+------------------------------------------------------------------+
//| operation                                                        |
//+------------------------------------------------------------------+
int search()
{  //returns 1 if opens a trade to proceed to next state
   //0 if unsuccessful search
   
}
int handle()
{  //returns 1 if closes the trade to return to base state
   //0 if remains here
   
   return 1;
}
//+------------------------------------------------------------------+
//| standard function                                                |
//+------------------------------------------------------------------+
int OnInit()
{
   screen.add_L1_comment("EA started-");
   if(file<0)
   {
      screen.add_L1_comment("file error");
      Print("Failed to open the file");
      Print("Error code ",GetLastError());
      return(INIT_FAILED);
   }
   screen.add_L1_comment("file ok-");
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason)
{
}
void OnTick()
{
   if(IsTradeAllowed()==false)
      return;
   //just wait for new bar
   static datetime Time0=0;
   if (Time0 == Time[0])
      return;
   Time0 = Time[0];
   
   switch(state)
   {
      case 0:
         if(search())  //chasing opurtunities and open trade if there is a valuable match
            state=1;
         break;
      case 1:
         if(handle())   //at the end of the first bar, probably close it
            state=0;
         break;
   }
}
//+------------------------------------------------------------------+
