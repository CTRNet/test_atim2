<?php 
		
foreach($this->request->data as &$tree_node){
	$procure_is_transferred_aliquot = false;
	if(isset($tree_node['AliquotMaster'])) {
		//ALiquot is a transferred parent
		if($this->Realiquoting->find('count', array('conditions' => array('Realiquoting.parent_aliquot_master_id' => $tree_node['AliquotMaster']['id'], 'Realiquoting.procure_central_is_transfer' => '1'), 'recursive' => '-1'))) $procure_is_transferred_aliquot = true;
	}
	if($procure_is_transferred_aliquot) {
		$keys_disabled = array_keys($tree_node['css'], 'disabled');
		if(!$keys_disabled) {
			$tree_node['css'][] = 'transfered_aliquot';
		} else {
			foreach($keys_disabled as $new_key) unset($tree_node['css'][$new_key]);
			$tree_node['css'][] = 'disabled_transfered_aliquot';
		}
	}
}

	
	