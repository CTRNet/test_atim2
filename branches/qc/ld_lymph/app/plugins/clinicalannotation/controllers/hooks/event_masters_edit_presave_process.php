<?php
		
	if(($event_master_data['EventControl']['disease_site'] == 'ld lymph.') && ($event_master_data['EventControl']['event_type'] == 'p/e and imaging')) {
		$this->data['EventDetail']['initial_pet_suv_max'] = $this->getPeAndImagingScore($this->data, $event_master_data['EventControl']);
	}


?>
