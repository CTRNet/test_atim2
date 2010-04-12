<?php
 
 	// --------------------------------------------------------------------------------
	// Build Participant identifier
	// -------------------------------------------------------------------------------- 	
	if($submitted_data_validates) {
		$max_id_data = $this->Participant->query("SELECT MAX(id) AS max_id FROM participants"); 
		$max_id = (empty($max_id_data[0][0]['max_id']))? 0 : $max_id_data[0][0]['max_id'];
		$this->data['Participant']['participant_identifier'] = 'P-'.($max_id + 1);
	}
 
?>
