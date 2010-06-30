<?php
if(empty($this->data)){
	if($clinical_collection_link_id != 0){
		//set aquisition label to match participant HB identifier if it exists
		App::import('Model', "Clinicalannotation.MiscIdentifier");
		$this->MiscIdentifier = new MiscIdentifier();
		App::import('Model', "Clinicalannotation.ClinicalCollectionLink");
		$this->ClinicalCollectionLink = new ClinicalCollectionLink();
		
		$ccl = $this->ClinicalCollectionLink->find('first', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id, 'ClinicalCollectionLink.deleted' => 1)));
		$identifier = $this->MiscIdentifier->find('first', array('conditions' => array('MiscIdentifier.participant_id' => $ccl['Participant']['id'], "misc_identifier_control_id" => 3)));
		if(!empty($identifier)){
			$this->set("default_acquisition_label", $identifier['MiscIdentifier']['identifier_value']);
		}
	}
} 
?>