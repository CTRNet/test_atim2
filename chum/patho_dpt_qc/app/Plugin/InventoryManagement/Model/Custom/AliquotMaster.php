<?php
class AliquotMasterCustom extends AliquotMaster{
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	function regenerateAliquotBarcode() {
		$aliquots_to_update = $this->find('all', array('conditions' => array("AliquotMaster.barcode IS NULL OR AliquotMaster.barcode LIKE ''"), 'fields' => array('AliquotMaster.id')));
		foreach($aliquots_to_update as $new_aliquot) {
			$new_aliquot_id = $new_aliquot['AliquotMaster']['id'];
			$aliquot_data = array('AliquotMaster' => array('barcode' => $new_aliquot_id), 'AliquotDetail' => array());
				
			$this->id = $new_aliquot_id;
			$this->data = null;
			$this->addWritableField(array('barcode'));
			$this->save($aliquot_data, false);
		}
	}
	
	function regenerateAliquotLabel() {
		// List and update all blocks with label to update
		$query = "SELECT Collection.acquisition_label, AliquotMaster.id, AliquotMaster.aliquot_label, AliquotDetail.patho_dpt_block_code
			FROM collections Collection
			INNER JOIN aliquot_masters AliquotMaster ON Collection.id = AliquotMaster.collection_id
			INNER JOIN ad_blocks AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
			WHERE AliquotMaster.aliquot_label != CONCAT(Collection.acquisition_label, ' ', AliquotDetail.patho_dpt_block_code) AND AliquotMaster.deleted <> 1;";
		$aliquot_to_update = $this->tryCatchQuery($query);
		foreach($aliquot_to_update as $new_aliquot) {
			$this->id = $new_aliquot['AliquotMaster']['id'];
			$this->data = null;
			$this->addWritableField(array('aliquot_label'));
			$this->save(array('AliquotMaster' => array('aliquot_label' => ($new_aliquot['Collection']['acquisition_label'].' '.$new_aliquot['AliquotDetail']['patho_dpt_block_code']))), false);
		}
		
		// List and update all core with label to update
		$query = "SELECT AliquotMasterBlock.aliquot_label, AliquotMasterCore.id, AliquotMasterCore.aliquot_label
			FROM aliquot_masters AliquotMasterBlock
			INNER JOIN aliquot_controls AliquotControlBlock ON AliquotControlBlock.id = AliquotMasterBlock.aliquot_control_id AND AliquotControlBlock.aliquot_type = 'block'
			INNER JOIN realiquotings Realiquoting ON Realiquoting.parent_aliquot_master_id = AliquotMasterBlock.id AND Realiquoting.deleted <> 1
			INNER JOIN aliquot_masters AliquotMasterCore ON Realiquoting.child_aliquot_master_id = AliquotMasterCore.id AND AliquotMasterCore.deleted <> 1
			INNER JOIN aliquot_controls AliquotControlCore ON AliquotControlCore.id = AliquotMasterCore.aliquot_control_id AND AliquotControlCore.aliquot_type = 'core'
			WHERE AliquotMasterBlock.deleted <> 1 AND AliquotMasterBlock.aliquot_label != AliquotMasterCore.aliquot_label;";
		$aliquot_to_update = $this->tryCatchQuery($query);
		foreach($aliquot_to_update as $new_aliquot) {
			$this->id = $new_aliquot['AliquotMasterCore']['id'];
			$this->data = null;
			$this->addWritableField(array('aliquot_label'));
			$this->save(array('AliquotMaster' => array('aliquot_label' => $new_aliquot['AliquotMasterBlock']['aliquot_label'])), false);
		}
		$query = "SELECT Collection.acquisition_label, AliquotMasterCore.id, AliquotMasterCore.aliquot_label
			FROM aliquot_masters AliquotMasterCore
			INNER JOIN aliquot_controls AliquotControlCore ON AliquotControlCore.id = AliquotMasterCore.aliquot_control_id AND AliquotControlCore.aliquot_type = 'core'
			INNER JOIN collections Collection ON Collection.id = AliquotMasterCore.collection_id
			WHERE AliquotMasterCore.deleted <> 1 AND AliquotMasterCore.id NOT IN (SELECT child_aliquot_master_id FROM realiquotings WHERE deleted <> 1)
			AND AliquotMasterCore.aliquot_label != CONCAT(Collection.acquisition_label,' ?');";
		$aliquot_to_update = $this->tryCatchQuery($query);	
		foreach($aliquot_to_update as $new_aliquot) {
			$this->id = $new_aliquot['AliquotMasterCore']['id'];
			$this->data = null;
			$this->addWritableField(array('aliquot_label'));
			$this->save(array('AliquotMaster' => array('aliquot_label' => $new_aliquot['Collection']['acquisition_label'].' ?')), false);
		}
	}
	
	function summary($variables=array()) {
		$return = false;
	
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, __($result['AliquotControl']['aliquot_type']) . ' : '. $result['AliquotMaster']['aliquot_label'].' ['. $result['AliquotMaster']['barcode'].']'),
					'title'		  		=> array(null, __($result['AliquotControl']['aliquot_type']) . ' : '. $result['AliquotMaster']['aliquot_label'].' ['. $result['AliquotMaster']['barcode'].']'),
					'data'				=> $result,
					'structure alias'	=> 'aliquot_masters'
			);
		}
	
		return $return;
	}
}
