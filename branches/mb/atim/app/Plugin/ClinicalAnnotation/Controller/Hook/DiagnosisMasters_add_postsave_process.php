<?php
         // new April 16 2018 , changed this to calculate correct age at dx and not just by year
		 //revised as a postsave July 25 2018, as it was causing errors for day ot year unknown
		 
		 $dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		
         $end_date=  $dx_master_data['DiagnosisMaster']['dx_date'];
		 echo $end_date;
         $start_date= $participant_data['Participant']['date_of_birth'];
		 echo $start_date;
		 
		 		 
		 $start_dt=date_create($start_date);
		 $end_dt=date_create($end_date);
		 
		 $dtinter=date_diff($start_dt,$end_dt);
		 
		 
		 echo $dtinter->format("%a");
		 
         $agedx = floor($dtinter->format("%a")/365.2425);
         echo $agedx;

         if ($agedx > 0){
		 
		 $query_to_update = "UPDATE diagnosis_masters SET diagnosis_masters.age_at_dx = ".$agedx." WHERE ".$diagnosis_master_id."=diagnosis_masters.id";"";
	     $this->DiagnosisMaster->tryCatchQuery($query_to_update);
	     $this->DiagnosisMaster->tryCatchQuery(str_replace("diagnosis_masters", "diagnosis_masters_revs", $query_to_update));
         }
 	
?>
