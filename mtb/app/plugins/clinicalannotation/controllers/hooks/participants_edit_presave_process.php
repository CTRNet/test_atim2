<?php

         $end_date=   $this->data['Participant']['date_of_death'];  
         echo $end_date;

         $start_date= $this->data['Participant']['date_of_birth'];
         echo $start_date;

         $start_year = $start_date['year'];
         echo $start_year;

         $end_year = $end_date['year'];
         echo $end_year;

         $diff_in_yrs = ($end_year - $start_year);
         echo $diff_in_yrs;

         if ($diff_in_yrs > 0){
         $this->data['Participant']['time_to_death'] =$diff_in_yrs;
         }

         if (!($diff_in_yrs > 0)){
         $this->data['Participant']['time_to_death'] ='';
         }

 	
?>
