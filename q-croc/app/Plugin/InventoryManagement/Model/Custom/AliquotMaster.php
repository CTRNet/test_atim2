<?php

class AliquotMasterCustom extends AliquotMaster {

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
	
	function calculateTimeRemainedInRNAlater($qcroc_collection_date, $qcroc_collection_time, $date_sample_received) {
		$error = '';
		$time_remained = '';
		if(!empty($qcroc_collection_date) && !empty($qcroc_collection_time) && !empty($date_sample_received)) {
			$res  = $this->getSpentTime($qcroc_collection_date.' '.$qcroc_collection_time, $date_sample_received);			
			if(!empty($res['message'])) {
				$error = __('unable to calculate time sample remained in rnalater'). ' (' .  __($res['message']) .')';
			} else {				
				$time_remained = $res['days'];
			}
		}		
		return array('time_remained' => $time_remained, 'error' => $error);
	}

}

?>
