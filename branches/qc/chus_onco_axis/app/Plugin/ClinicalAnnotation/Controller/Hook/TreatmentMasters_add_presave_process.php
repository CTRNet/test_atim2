<?php 

if($tx_control_data['TreatmentControl']['tx_method'] == 'systemic therapy') {
	if(array_key_exists('TreatmentDetail', $this->request->data) && array_key_exists('num_cycles', $this->request->data['TreatmentDetail'] && $this->request->data['TreatmentMaster']['protocol_master_id'])) {
		$selected_protocol_master_id = $this->request->data['TreatmentMaster']['protocol_master_id'];
		$selected_protocol = $this->ProtocolMaster->getOrRedirect($selected_protocol_master_id);
		foreach(array('num_cycles', 'completed_cycles', 'frequence', 'frequence_unit') as $new_field) {
			if(!strlen($this->request->data['TreatmentDetail'][$new_field])) $this->request->data['TreatmentDetail'][$new_field] = $selected_protocol['ProtocolDetail'][$new_field];
		}
		AppController::addWarningMsg('updated cycle and frequence information based on selected regimen');
	}
}





