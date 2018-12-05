<?php

				 // FILL time to tx
				 
					$end_date=   $this->request->data['TreatmentMaster']['start_date'];  
					$dx_id_selected=$this->request->data['TreatmentMaster']['diagnosis_master_id'];

					if ($dx_id_selected>0){
            	    $this->DiagnosisMaster->id = $dx_id_selected;
            	    $dx_selected = $this->DiagnosisMaster->read();


	     			$start_date= $dx_selected['DiagnosisMaster']['dx_date']; 

                    $start_year = substr($start_date,0,4);
                    
                    $start_month = substr($start_date,5,2);

                    $end_year = $end_date['year'];

                    $end_month = $end_date['month'];

                    $diff_in_months = ($end_year - $start_year) * 12 - $start_month + $end_month;

					$this->request->data['TreatmentMaster']['time_to_tx']=$diff_in_months;
                    }
                 
?>
