<?php

class ParticipantCustom extends Participant {
	
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function beforeSave($options = array()){
		$ret_val = parent::beforeSave();
		if(isset($this->data['Participant']['qcroc_initials'])) $this->data['Participant']['qcroc_initials'] = strtoupper($this->data['Participant']['qcroc_initials']); 
		return $ret_val; 
	}
	
	function buildAddLinkForQcrocForm($participant_id) {
		$add_links = array(__('add collection') => array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$participant_id, 'icon' => 'collection'));
	
		$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
		$tx_controls_list = $tx_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($tx_controls_list as $treatment_control) {
			$add_links[__($treatment_control['TreatmentControl']['tx_method'])] = array('link'=> '/ClinicalAnnotation/TreatmentMasters/add/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/', 'icon' => 'treatments');
		}
		ksort($add_links);
		return $add_links;
	}
	
}
