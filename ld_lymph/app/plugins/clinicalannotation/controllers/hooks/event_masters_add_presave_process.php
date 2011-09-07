<?php
			
	if(($event_control_data['EventControl']['disease_site'] == 'ld lymph.') && ($event_control_data['EventControl']['event_type'] == 'p/e and imaging')) {
		$this->data['EventDetail']['initial_pet_suv_max'] = $this->getPeAndImagingScore($this->data, $event_control_data['EventControl']);
	}


?>
