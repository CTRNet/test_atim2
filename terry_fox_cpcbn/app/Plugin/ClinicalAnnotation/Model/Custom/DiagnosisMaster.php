<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function getAllTumorDiagnosesIds($diagnosis_master_id) {
		$all_linked_diagmosises_ids = array();
		$studied_diagnosis_data = $this->find('first', array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id), 'recursive' => '-1'));
		if(!empty($studied_diagnosis_data)) {
			$all_linked_diagmosises = $this->find('all', array('conditions' => array('DiagnosisMaster.primary_id' => $studied_diagnosis_data['DiagnosisMaster']['primary_id']), 'fields' => array('DiagnosisMaster.id'), 'recursive' => '-1'));
			$all_linked_diagmosises_ids = array();
			foreach($all_linked_diagmosises as $new_dx) $all_linked_diagmosises_ids[] = $new_dx['DiagnosisMaster']['id'];
		}
		return $all_linked_diagmosises_ids;
	}

}

?>