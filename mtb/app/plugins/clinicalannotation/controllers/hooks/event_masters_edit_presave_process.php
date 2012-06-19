<?php


				// --- START OF CLL CALC FIELDS
				// NOV 29 2010 MARY NATIVIDAD

				// CLL CONTROL FU 
				if ($event_master_data['EventMaster']['event_control_id']==38){

				
				 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT STUDY
				 $end_date=   $this->data['EventMaster']['event_date'];  
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
				 $this->data['EventDetail']['cll_age_at_study']=$diff_in_yrs;
				 }
				 // end diff in years

				} 

                // END OF CLL CONTROL FU

				// CLL FU PRES 
				if ($event_master_data['EventMaster']['event_control_id']==39 || $event_master_data['EventMaster']['event_control_id']==40){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT STUDY
				 $end_date=   $this->data['EventMaster']['event_date'];  
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
				 $this->data['EventDetail']['cll_age_at_study']=$diff_in_yrs;
                 }
				 // end diff in years

				 // BMI
				 $cll_height=$this->data['EventDetail']['cll_height_at_sample'];
				 echo $cll_height;
				 
				 $cll_weight=$this->data['EventDetail']['cll_weight_at_sample'];
				 echo $cll_weight;
				 
				 $cll_height_m= $cll_height * 0.01;
				 echo $cll_height_m;

				 $bmi_calc=	$cll_weight/ ($cll_height_m*$cll_height_m);
				 echo$bmi_calc;

				 $this->data['EventDetail']['cll_bmi']=$bmi_calc;
				
				}
				// --- !!! END OF CLL CALC FIELDS


				// --- !!! START OF MMY CALC FIELDS

                // MMY FU PRES 
				if ($event_master_data['EventMaster']['event_control_id']==44 || $event_master_data['EventMaster']['event_control_id']==45){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT DONATION
				 $end_date=   $this->data['EventMaster']['event_date'];  
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
				 $this->data['EventDetail']['age_at_donation']=$diff_in_yrs;
                 }
				 // end diff in years

				 // BMI
				 $mmy_height=$this->data['EventDetail']['height'];
				 echo $mmy_height;
				 
				 $mmy_weight=$this->data['EventDetail']['weight'];
				 echo $mmy_weight;
				 
				 $mmy_height_m= $mmy_height * 0.01;
				 echo $mmy_height_m;

				 $bmi_calc=	$mmy_weight/ ($mmy_height_m*$mmy_height_m);
				 echo $bmi_calc;

				 $this->data['EventDetail']['bmi']=$bmi_calc;
				
				}
				// --- !!! END OF MMY CALC FIELDS




				// ----------------- !!! AUTOMATIC UPDATING 
				// CUSTOM CODE ADDED FEB 8 2010 - BY MARY NATIVIDAD
				// BREAST FU
                if ($event_master_data['EventMaster']['event_control_id']==35) {

					// UPDATE FU STATUS TIME
					$end_date=   $this->data['EventMaster']['event_date'];  
					$dx_id_selected=$this->data['EventMaster']['diagnosis_master_id'];

					if ($dx_id_selected>0){
            	    $this->DiagnosisMaster->id = $dx_id_selected;
            	    $dx_selected = $this->DiagnosisMaster->read();


	     			$start_date= $dx_selected['DiagnosisMaster']['dx_date']; 

                    $start_year = substr($start_date,0,4);
                    
                    $start_month = substr($start_date,5,2);

                    $end_year = $end_date['year'];

                    $end_month = $end_date['month'];

                    $diff_in_months = ($end_year - $start_year) * 12 - $start_month + $end_month;

					$this->data['EventDetail']['status_time']=$diff_in_months;
                    }
                    // END STATUS TIME    



                    // GET PARTICIPANT DATA  
            	    $this->Participant->id = $participant_id;
            	    $participant_data = $this->Participant->read();

                      // IN EDIT THE CHRT_CHECKED DATE ALWAYS DEFAULTS TO CURRENT DATE REGARDLESS IF ANYTHING WAS CHANGED ON EDIT AND SUBMIT
                      // UPDATE LAST_CHART_CHECKED_DATE  TO cht_checked , cht_checked always defaults to current date
					  // also update certainty - status fields for corresponding fields
					  $this->data['EventDetail']['cht_checked']=date("Y-m-d");
					  $this->data['EventDetail']['cht_checked_certainty']='c';
				      $this->data['Participant']['last_chart_checked_date'] =  $this->data['EventDetail']['cht_checked'];
                      $this->data['Participant']['last_chart_checked_date_certainty'] =  $this->data['EventDetail']['cht_checked_certainty'];

					  //echo date('c');
					  //echo date('Y m d');

                      // UPDATE PARTICIPANT VITAL_STATUS IF THERE IS A DATE OF DEATH

                         if (!($participant_data['Participant']['date_of_death'] == '0000-00-00' ||
                              $participant_data['Participant']['date_of_death'] == NULL))
                         {
						      
						     $this->data['Participant']['vital_status'] ='dead';
                              
							 // calc age at death 

							   $end_date=   $participant_data['Participant']['date_of_death'];  
	     		               echo $end_date;

	     		               $start_date= $participant_data['Participant']['date_of_birth'];
				               echo $start_date;

                               $start_year = substr($start_date,0,4);
                               echo $start_year;

                               $end_year = substr($end_date,0,4);
				               echo $end_year;

                               $diff_in_yrs = ($end_year - $start_year);
				               echo $diff_in_yrs;

				               if ($diff_in_yrs > 0){
				               $this->data['Participant']['time_to_death'] =$diff_in_yrs;
				               }


						 }
                     
                     
                      // UPDATE PARTICIPANT VITAL_STATUS IF EVENT DETAIL VITAL STATUS NOT BLANK AND NOT DEAD   


                		 if (($this->data['EventDetail']['vital_status']=='unknown' ||
                              substr($this->data['EventDetail']['vital_status'],0,5)=='alive' ||
                              $this->data['EventDetail']['vital_status']=='lost contact') &&
                              ($participant_data['Participant']['date_of_death'] == '0000-00-00' ||
                              $participant_data['Participant']['date_of_death'] == NULL))

                		 
                		 { 
 						     if ($this->data['EventDetail']['vital_status']=='unknown') {
						     $this->data['Participant']['vital_status'] ='unknown';
                             }

						     if (substr($this->data['EventDetail']['vital_status'],0,5)=='alive') {
						     $this->data['Participant']['vital_status'] ='alive';
                             }

						     if ($this->data['EventDetail']['vital_status']=='lost contact') {
						     $this->data['Participant']['vital_status'] ='unknown';
                             }



						 }


					  // UPDATE PARTICIPANT DATE OF DEATH if blank WITH EVENT DATE IF VITAL STATUS = died of ...

						 if (substr($this->data['EventDetail']['vital_status'],0,4)=='died') {                       
             				 $this->data['Participant']['vital_status'] ='dead';
                          
                             if ($participant_data['Participant']['date_of_death'] == '0000-00-00' || $participant_data['Participant']['date_of_death'] == NULL)
                             {
                                $this->data['Participant']['date_of_death'] = $this->data['EventMaster']['event_date'];
                                $this->data['Participant']['dod_certainty'] = $this->data['EventMaster']['event_date_certainty'];

                             // calc age at death 
							   $end_date=   $this->data['Participant']['date_of_death'];  
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
				               $this->data['Participant']['time_to_death'] =$diff_in_yrs;
				               }

						     }
						 
						 }


				    // SAVE THE PARTICIPANT DATA

				       $this->Participant->save( $this->data['Participant'] );
				}
				// ----------------- !!! END AUTOMATIC UPDATING 
 	
?>
