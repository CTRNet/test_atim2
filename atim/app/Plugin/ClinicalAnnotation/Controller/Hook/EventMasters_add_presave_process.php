<?php


				// --- START OF CLL CALC FIELDS
				// NOV 29 2010 MARY NATIVIDAD
				// v2.4.3a changes to event masters , need to change if statements to event_control_id
				// CLL CONTROL FU event_control_id=38

				if ($this->request->data['EventMaster']['event_control_id']==38){

				
				 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT STUDY
				 $end_date=   $this->request->data['EventMaster']['event_date'];  
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
				 $this->request->data['EventDetail']['cll_age_at_study']=$diff_in_yrs;
				 }
				 // end diff in years >0

				} 

                // END OF CLL CONTROL FU


				// CLL FU OR PRES control id =39, 40

				if ($this->request->data['EventMaster']['event_control_id']==39 || $this->request->data['EventMaster']['event_control_id']==40){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT STUDY
				 $end_date=   $this->request->data['EventMaster']['event_date'];  
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
				 $this->request->data['EventDetail']['cll_age_at_study']=$diff_in_yrs;
				 }
				 // end diff in years >0

				 // BMI
				 $cll_height=$this->request->data['EventDetail']['cll_height_at_sample'];
				 echo $cll_height;
				 
				 $cll_weight=$this->request->data['EventDetail']['cll_weight_at_sample'];
				 echo $cll_weight;
				 
				 $cll_height_m= $cll_height * 0.01;
				 echo $cll_height_m;

				 $bmi_calc=	$cll_weight/ ($cll_height_m*$cll_height_m);
				 echo$bmi_calc;

				 $this->request->data['EventDetail']['cll_bmi']=$bmi_calc;
				
				}
				// --- !!! END OF CLL CALC FIELDS


				// CLL FU LAB combo control id =41

				if ($this->request->data['EventMaster']['event_control_id']==41 ){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT STUDY
				 $end_date=   $this->request->data['EventMaster']['event_date'];  
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
				 $this->request->data['EventDetail']['cll_age_at_study']=$diff_in_yrs;
				 }
				 // end diff in years >0

				
				}
				// --- !!! END OF CLL FU LAB COMBO CALC FIELDS



				// --- !!! START OF MMY CALC FIELDS

				if ($this->request->data['EventMaster']['event_control_id']==44 || $this->request->data['EventMaster']['event_control_id']==45){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();



				 // AGE AT DONATION
				 $end_date=   $this->request->data['EventMaster']['event_date'];  
	     		 echo $end_date;

	     		 $start_date= $participant_data['Participant']['date_of_birth'];
				 echo $start_date;

                 $start_year = substr($start_date,0,4);
                 echo $start_year;

                 $end_year = $end_date['year'];
				 echo $end_year;

                 $diff_in_yrs = ($end_year - $start_year);
				 echo $diff_in_yrs;

				 if ($diff_in_yrs > 0 && $this->request->data['EventMaster']['event_control_id']==44){
				 $this->request->data['EventDetail']['age_at_presentation']=$diff_in_yrs;

				 }
				 // end diff in years >0

				 if ($diff_in_yrs > 0 && $this->request->data['EventMaster']['event_control_id']==45){
				 $this->request->data['EventDetail']['age_at_followup']=$diff_in_yrs;
				 }
				 // end diff in years >0 

				 // AUTOFILL DATES BASED ON EVENTDATE I.E FU DATE
				 // 
				 // if ($this->request->data['EventMaster']['event_control_id']==45){
				 // 
                 // $this->request->data['EventDetail']['ht_wt_bmi_date']=$end_date;	                 
                 // $this->request->data['EventDetail']['Bonemarrowbiopsy_date']=$end_date;	         
                 // $this->request->data['EventDetail']['Hematology_date']=$end_date;	                 
                 // $this->request->data['EventDetail']['Chemistry_date']=$end_date;	                 
                 // $this->request->data['EventDetail']['Immunology_date']=$end_date;	                 
                 // $this->request->data['EventDetail']['LightChainIsotype_date']=$end_date;	         
                 // $this->request->data['EventDetail']['SerumFreeLtChLevels_date']=$end_date;	     
                 // $this->request->data['EventDetail']['FlowCytometry_date']=$end_date;	             
                 // $this->request->data['EventDetail']['Cytogenetics_date']=$end_date;	             
				 // 
				 // } // END AUTOFILL DATES BASED ON EVENTDATE I.E FU DATE



				 // FILL STATUS TIME IN MMY FU
				 if ($this->request->data['EventMaster']['event_control_id']==45){
				 
                    // UPDATE FU STATUS TIME
					$end_date=   $this->request->data['EventMaster']['event_date'];  
					$dx_id_selected=$this->request->data['EventMaster']['diagnosis_master_id'];

					if ($dx_id_selected>0){
            	    $this->DiagnosisMaster->id = $dx_id_selected;
            	    $dx_selected = $this->DiagnosisMaster->read();


	     			$start_date= $dx_selected['DiagnosisMaster']['dx_date']; 

                    $start_year = substr($start_date,0,4);
                    
                    $start_month = substr($start_date,5,2);

                    $end_year = $end_date['year'];

                    $end_month = $end_date['month'];

                    $diff_in_months = ($end_year - $start_year) * 12 - $start_month + $end_month;

					$this->request->data['EventDetail']['status_time']=$diff_in_months;
                    }
                 
				 } // END FILL STATUS TIME



				 // BMI
				 $mmy_height=$this->request->data['EventDetail']['height'];
				 echo $mmy_height;
				 
				 $mmy_weight=$this->request->data['EventDetail']['weight'];
				 echo $mmy_weight;
				 
				 $mmy_height_m= $mmy_height * 0.01;
				 echo $mmy_height_m;

				 $bmi_calc=	$mmy_weight/ ($mmy_height_m*$mmy_height_m);
				 echo $bmi_calc;

				 $this->request->data['EventDetail']['bmi']=$bmi_calc;

				
				}

				// CALC FOR AGE AT LAB
				if ($this->request->data['EventMaster']['event_control_id']==47){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
				 // AGE AT Lab
				 $end_date=   $this->request->data['EventMaster']['event_date'];  
	     		 echo $end_date;

	     		 $start_date= $participant_data['Participant']['date_of_birth'];
				 echo $start_date;

                 $start_year = substr($start_date,0,4);
                 echo $start_year;

                 $end_year = $end_date['year'];
				 echo $end_year;

                 $diff_in_yrs = ($end_year - $start_year);
				 echo $diff_in_yrs;


				 if ($diff_in_yrs > 0 && $this->request->data['EventMaster']['event_control_id']==47){
				 $this->request->data['EventDetail']['age_at_lab']=$diff_in_yrs;
				 }
				 // end diff in years >0 


				
				}


				// --- !!! END OF MMY CALC FIELDS


				// FILL STATUS TIME LUNG AND OV , general

				if ($this->request->data['EventMaster']['event_control_id']==66 || $this->request->data['EventMaster']['event_control_id']==71 || $this->request->data['EventMaster']['event_control_id']==20){
				
                 // GET PARTICIPANT DATA  
            	 $this->Participant->id = $participant_id;
            	 $participant_data = $this->Participant->read();

				 
                    // UPDATE FU STATUS TIME
					$end_date=   $this->request->data['EventMaster']['event_date'];  
					$dx_id_selected=$this->request->data['EventMaster']['diagnosis_master_id'];

					if ($dx_id_selected>0){
            	    $this->DiagnosisMaster->id = $dx_id_selected;
            	    $dx_selected = $this->DiagnosisMaster->read();


	     			$start_date= $dx_selected['DiagnosisMaster']['dx_date']; 

                    $start_year = substr($start_date,0,4);
                    
                    $start_month = substr($start_date,5,2);

                    $end_year = $end_date['year'];

                    $end_month = $end_date['month'];

                    $diff_in_months = ($end_year - $start_year) * 12 - $start_month + $end_month;

					$this->request->data['EventDetail']['status_time']=$diff_in_months;
                    }
                 
				 } // END FILL STATUS TIME LUNG AND OV general




				// ----------------- !!! AUTOMATIC UPDATING 
				// CUSTOM CODE ADDED MAY20 2009 - BY MARY NATIVIDAD
				// CUSTOM CODE revised feb 24 2010 - BY MARY NATIVIDAD
				// BREAST FU CONTROL ID 35
				 if ($this->request->data['EventMaster']['event_control_id']==35){

                    // UPDATE FU STATUS TIME
					$end_date=   $this->request->data['EventMaster']['event_date'];  
					$dx_id_selected=$this->request->data['EventMaster']['diagnosis_master_id'];

					if ($dx_id_selected>0){
            	    $this->DiagnosisMaster->id = $dx_id_selected;
            	    $dx_selected = $this->DiagnosisMaster->read();


	     			$start_date= $dx_selected['DiagnosisMaster']['dx_date']; 

                    $start_year = substr($start_date,0,4);
                    
                    $start_month = substr($start_date,5,2);

                    $end_year = $end_date['year'];

                    $end_month = $end_date['month'];

                    $diff_in_months = ($end_year - $start_year) * 12 - $start_month + $end_month;

					$this->request->data['EventDetail']['status_time']=$diff_in_months;
                    }
                    // END STATUS TIME    

                    // GET PARTICIPANT DATA  
            	    $this->Participant->id = $participant_id;
            	    $participant_data = $this->Participant->read();

 
                
                    // UPDATE LAST_CHART_CHECKED_DATE  TO cht_checked , cht_checked always defaults to current date
					// also update certainty - status fields for corresponding fields

					$this->request->data['EventDetail']['cht_checked']=date("Y-m-d");
					$this->request->data['EventDetail']['cht_checked_certainty']='c';
				    $this->request->data['Participant']['last_chart_checked_date'] =  $this->request->data['EventDetail']['cht_checked'];
                    $this->request->data['Participant']['last_chart_checked_date_accuracy'] =  $this->request->data['EventDetail']['cht_checked_certainty'];



                      // UPDATE PARTICIPANT VITAL_STATUS IF THERE IS A DATE OF DEATH

                         if (!($participant_data['Participant']['date_of_death'] == '0000-00-00' ||
                              $participant_data['Participant']['date_of_death'] == NULL))
                         {
						      
						     $this->request->data['Participant']['vital_status'] ='dead';
                          
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
				               $this->request->data['Participant']['time_to_death'] =$diff_in_yrs;
				               }



						 }
                     
                     
                      // UPDATE PARTICIPANT VITAL_STATUS IF EVENT DETAIL VITAL STATUS NOT BLANK AND NOT DEAD   


                		 if (($this->request->data['EventDetail']['vital_status']=='unknown' ||
                              substr($this->request->data['EventDetail']['vital_status'],0,5)=='alive' ||
                              $this->request->data['EventDetail']['vital_status']=='lost contact') &&
                              ($participant_data['Participant']['date_of_death'] == '0000-00-00' ||
                              $participant_data['Participant']['date_of_death'] == NULL))

                		 
                		 { 
 						     if ($this->request->data['EventDetail']['vital_status']=='unknown') {
						     $this->request->data['Participant']['vital_status'] ='unknown';
                             }

						     if (substr($this->request->data['EventDetail']['vital_status'],0,5)=='alive') {
						     $this->request->data['Participant']['vital_status'] ='alive';
                             }

						     if ($this->request->data['EventDetail']['vital_status']=='lost contact') {
						     $this->request->data['Participant']['vital_status'] ='unknown';
                             }



						 }


					  // UPDATE PARTICIPANT DATE OF DEATH if blank WITH EVENT DATE IF VITAL STATUS = died of ...

						 if (substr($this->request->data['EventDetail']['vital_status'],0,4)=='died') {                       
             				 $this->request->data['Participant']['vital_status'] ='dead';
                          
                             if ($participant_data['Participant']['date_of_death'] == '0000-00-00' || $participant_data['Participant']['date_of_death'] == NULL)
                             {
                                $this->request->data['Participant']['date_of_death'] = $this->request->data['EventMaster']['event_date'];
                                $this->request->data['Participant']['date_of_death_accuracy'] = $this->request->data['EventMaster']['event_date_accuracy'];

                             // calc age at death 
							   $end_date=   $this->request->data['Participant']['date_of_death'];  
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
				               $this->request->data['Participant']['time_to_death'] =$diff_in_yrs;
				               }


						     }
						 
						 }

				    // SAVE THE PARTICIPANT DATA
				       $this->Participant->save( $this->request->data['Participant'] );
				 }
				// ----------------- !!! END AUTOMATIC UPDATING 
 	
?>
