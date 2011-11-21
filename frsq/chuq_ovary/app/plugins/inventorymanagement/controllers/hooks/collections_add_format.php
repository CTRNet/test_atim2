<?php
	
	if(!$need_to_save){
		$this->data['Collection']['acquisition_label'] = (!empty($ccl_data)? $ccl_data['Participant']['participant_identifier'] : __('n/a', true)). ' ' . date("Y-m-d");
	}

?>
