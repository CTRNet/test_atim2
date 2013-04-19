<?php
	
	if($tx_control_data['TreatmentControl']['tx_method'] == 'surgery') $this->DiagnosisMaster->updateCalculatedFields($participant_id);
