<?php

         $end_date=   $this->request->data['DiagnosisMaster']['dx_date'];  
         echo $end_date;

         $start_date= $participant_data['Participant']['date_of_birth'];
         echo $start_date;

         $start_year = substr($start_date,0,4);
         echo $start_year;

         $end_year = $end_date['year'];
         echo $end_year;

         $diff_in_yrs = ($end_year - $start_year);
         echo $diff_in_yrs;

         if ($diff_in_yrs > 0){
		 $this->request->data['DiagnosisMaster']['age_at_dx'] =$diff_in_yrs;
         }
 	
?>
