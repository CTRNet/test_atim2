<?php 

	if(!isset($qcroc_is_transfer)) {
		//FUNCTION in trunk should be changed to function addAliquotInternalUse($aliquot_master_id = null, $qcroc_is_transfer = false)
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	$this->set('qcroc_is_transfer', $qcroc_is_transfer);
	
	if($qcroc_is_transfer) {
		$this->Structures->set('qcroc_aliquot_transfer', 'aliquotinternaluses_structure');
		$this->Structures->set('qcroc_aliquot_transfer', 'aliquotinternaluses_volume_structure');
	}
	
	
	
	

	
	
	