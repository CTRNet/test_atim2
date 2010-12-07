<?php
				// ----------------- !!! AUTOMATIC UPDATING 
				// CUSTOM CODE ADDED MAY20 2009 - BY MARY NATIVIDAD
				// CUSTOM CODE revised feb 24 2010 - BY MARY NATIVIDAD

				 if ($this->data['EventMaster']['event_type']=='followup' && $this->data['EventMaster']['disease_site']=='breast'){

                    // UPDATE STATUS TIME  !!! check date functions in php  THIS DOES NOT WORK
                   echo $this->data['EventMaster']['event_date'];  
                   echo $diagnosis_data['DiagnosisMaster']['dx_date']; 
				   echo (DATE_FORMAT($this->data['EventMaster']['event_date'], '%Y%m')) - (DATE_FORMAT($diagnosis_data['DiagnosisMaster']['dx_date'], '%y%m'));
                    // $this->data['EventDetail']['status_time']= (DATE_FORMAT($this->data['EventMaster']['event_date'], '%Y%m')) - (DATE_FORMAT($diagnosis_data['DiagnosisMaster']['dx_date'], '%y%m'));

                    // GET PARTICIPANT DATA  
            	    $this->Participant->id = $participant_id;
            	    $participant_data = $this->Participant->read();

 
                
                    // UPDATE LAST_CHART_CHECKED_DATE  TO cht_checked , cht_checked always defaults to current date
					// also update certainty - status fields for corresponding fields

					$this->data['EventDetail']['cht_checked']=date("Y-m-d");
					$this->data['EventDetail']['cht_checked_certainty']='c';
				    $this->data['Participant']['last_chart_checked_date'] =  $this->data['EventDetail']['cht_checked'];
                    $this->data['Participant']['last_chart_checked_date_certainty'] =  $this->data['EventDetail']['cht_checked_certainty'];



                      // UPDATE PARTICIPANT VITAL_STATUS IF THERE IS A DATE OF DEATH

                         if (!($participant_data['Participant']['date_of_death'] == '0000-00-00' ||
                              $participant_data['Participant']['date_of_death'] == NULL))
                         {
						      
						     $this->data['Participant']['vital_status'] ='dead';
                              

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
						     }
						 
						 }

				    // SAVE THE PARTICIPANT DATA
				       $this->Participant->save( $this->data['Participant'] );
				 }
				// ----------------- !!! END AUTOMATIC UPDATING 
 	
?>
