//+------------------------------------------------------------------+
//|                                                   ExamineBar.mqh |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      "https://www.mql5.com"
#property strict

#include <MyHeaders\Pattern.mqh>

class ExamineBar
{
  public:
   ExamineBar(int _barno, Pattern* _pattern);
   int barno;
   Pattern* pattern;

   int number_of_hits,c1_higher_cnt;
   double sum_c1;
   
   void log_to_file(int file_handle);
   bool check_another_bar(Pattern &_check_pattern, int _correlation_thresh, int _max_hit);

};
ExamineBar::ExamineBar(int _barno, Pattern* _pattern)
{
   barno=_barno; pattern=_pattern;
   number_of_hits=0;c1_higher_cnt=0;
   sum_c1=0;
}

void ExamineBar::log_to_file(int file_handle)
{  //TOCOMPLETE
   FileWrite(file_handle,"","Bar",barno);
   cont;
   FileWrite(file_handle,"","hits",number_of_hits);
   cont;
   FileWrite(file_handle,"","C1higher",c1_higher_cnt);
   cont;
   FileWrite(file_handle,"","aveC1",sum_c1/MyMath::max(1,number_of_hits));
   cont;
   pattern.log_to_file(file_handle);

}

bool ExamineBar::check_another_bar(Pattern &_check_pattern, int _correlation_thresh, int _max_hit)
{  //returns true, if the number of matches is above 100
   if((pattern & _check_pattern) >= _correlation_thresh)
   {  //found a match!
      number_of_hits++;
      //if(c1_higher_cnt;
      sum_c1+=_check_pattern.fc1;

   }
   return (number_of_hits>=_max_hit);
}