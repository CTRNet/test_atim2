<?php 
	
	foreach($this->request->data as $key => $new_record) {
		if($new_record['ViewAliquotUse']['qcroc_is_transfer'] == '1') unset($this->request->data[$key]);
	}
	
	$this->AliquotMaster;//lazy load
	$transfers_data = $this->AliquotInternalUse->find('all', array(
			'fields' => array('*'),
			'conditions' => array('AliquotInternalUse.aliquot_master_id' => $aliquot_master_id, 'AliquotInternalUse.qcroc_is_transfer' => '1'),
			'joins' => array(AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'), AliquotMaster::$join_aliquot_control_on_dup))
	);
	$this->Structures->set('qcroc_aliquot_transfer','qcroc_aliquot_transfer');
	$this->set('transfers_data', $transfers_data);
	