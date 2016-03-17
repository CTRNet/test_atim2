<?php

class AliquotInternalUseCustom extends AliquotInternalUse {
	var $useTable = 'aliquot_internal_uses';
	var $name = 'AliquotInternalUse';

	function validates($options = array()){
		$val_res = parent::validates($options);
		
		if(array_key_exists('type', $this->data['AliquotInternalUse']) && $this->data['AliquotInternalUse']['type'] == 'received from bank') {
			$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			//Get aliquot master id
			$aliquot_master_id = null;
			if(array_key_exists('aliquot_master_id', $this->data['AliquotInternalUse'])) {
				$aliquot_master_id = $this->data['AliquotInternalUse']['aliquot_master_id'];
			} else if($this->id) {
				$tmp_data = $this->find('first', array('conditions' => array('AliquotInternalUse.id' => $this->id), 'fields' => array('AliquotInternalUse.aliquot_master_id'), 'recursive' => '-1'));
				$aliquot_master_id = $tmp_data['AliquotInternalUse']['aliquot_master_id'];
			}
			if($aliquot_master_id) {
				$aliquot_data = $aliquot_master_model->find('first', array('conditions' => array('ALiquotMaster.id' => $aliquot_master_id), 'recursive' => '-1'));
				if($aliquot_data['AliquotMaster']['procure_created_by_bank'] == 'p') {
					$this->validationErrors['type'][] = 'this aliquot can not be defined as received from bank';
					$val_res = false;
				}
			} else {
				$this->validationErrors['type'][] = 'the system is unable to validate all aliquots are transferred aliquots - please use create uses/events aliquot specific';
				$val_res = false;
			}
		}
	
		return $val_res;
	}
}

?>
