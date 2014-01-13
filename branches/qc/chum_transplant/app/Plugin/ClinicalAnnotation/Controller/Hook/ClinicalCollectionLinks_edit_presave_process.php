<?php 
	
	if(empty($this->request->data['Collection']['treatment_master_id'])) {
		$this->Collection->validationErrors['treatment_master_id'][] = __('the transplant linked to the collection has to be selected');
		$submitted_data_validates = false;
	}
	$this->Structures->set('treatmentmasters,chum_transplant_txd_transplants', 'atim_structure_tx');
	
	$fields[] = 'acquisition_label';
	