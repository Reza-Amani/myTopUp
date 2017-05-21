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

   int number_of_hits;
   double sum_ac1;
   double higher_c1;
   
   void log_to_file(int file_handle);
   bool check_another_bar(Pattern &_check_pattern, int _correlation_thresh, int _max_hit);

};
ExamineBar::ExamineBar(int _barno, Pattern* _pattern)
{
   barno=_barno; pattern=_pattern;
   number_of_hits=0;
   sum_ac1=0;
   higher_c1=0;
}

void ExamineBar::log_to_file(int file_handle)
{  //TOCOMPLETE
   FileWrite(file_handle,"","Bar",barno);
   cont;
   FileWrite(file_handle,"","hits",number_of_hits);
   cont;
   if(number_of_hits!=0)
      FileWrite(file_handle,"","aveC1",sum_ac1/number_of_hits);
   cont;
   if(number_of_hits!=0)
      FileWrite(file_handle,"","higherC1",higher_c1,higher_c1/number_of_hits);
   cont;
   FileWrite(file_handle,"","resulthC1",pattern.fc1-pattern.close[0],pattern.ac1);
   cont;
   pattern.log_to_file(file_handle);

}

bool ExamineBar::check_another_bar(Pattern &_check_pattern, int _correlation_thresh, int _max_hit)
{  //returns true, if the number of matches is above 100
   if((pattern & _check_pattern) >= _correlation_thresh)
   {  //found a match!
      number_of_hits++;
      sum_ac1+=_check_pattern.ac1;
      if(_check_pattern.fc1>_check_pattern.close[0])
         higher_c1++;

   }
   return (number_of_hits>=_max_hit);
}