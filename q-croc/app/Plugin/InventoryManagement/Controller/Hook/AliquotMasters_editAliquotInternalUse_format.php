<?php 
	
	$qcroc_is_transfer = false;
	if($use_data['AliquotInternalUse']['qcroc_is_transfer']) {
		$this->Structures->set('qcroc_aliquot_transfer');
		$qcroc_is_transfer = true;
	}
	$this->set('qcroc_is_transfer',$qcroc_is_transfer);
	