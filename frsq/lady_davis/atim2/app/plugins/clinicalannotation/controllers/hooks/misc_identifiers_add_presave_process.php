<?php
/**
 * Ensures that we cannot the same identifier twice, that different identifier share the same increment and that creating an identifier
 * that was deleted restores it instead of creating a new one.
 */

if($this->data['MiscIdentifier']['identifier_name'] == "biopsy"
|| $this->data['MiscIdentifier']['identifier_name'] == "metastasis"
|| $this->data['MiscIdentifier']['identifier_name'] == "tumor"){
	$mi = $this->MiscIdentifier->find('first', array('conditions' =>array('MiscIdentifier.participant_id' => $participant_id, 'MiscIdentifier.identifier_name' => $this->data['MiscIdentifier']['identifier_name'])));
	$mi_deleted = $this->MiscIdentifier->find('first', array('conditions' =>array('MiscIdentifier.participant_id' => $participant_id, 'MiscIdentifier.identifier_name' => $this->data['MiscIdentifier']['identifier_name'], 'MiscIdentifier.deleted' => '1')));
	if(!empty($mi_deleted)){
		//undelete this one
		$this->MiscIdentifier->id = $mi_deleted['MiscIdentifier']['id'];
		$this->data['MiscIdentifier']['deleted'] = 0;
		$this->data['MiscIdentifier']['deleted_date'] = NULL;
		$is_incremented_identifier = false;
	}else if(!empty($mi)){
		//do not allow double creation
		$submitted_data_validates = false;
		$this->MiscIdentifier->validationErrors[] = __("an identifier of this type already exists for the current participant.", true);
	}else{
		echo "CC";
		$mi = $this->MiscIdentifier->find('first', array('conditions' =>array('MiscIdentifier.participant_id' => $participant_id, 'MiscIdentifier.identifier_name IN("biopsy", "metastasis", "tumor")')));
		if(!empty($mi)){
			echo "DD";
			//we don't need auto increment, we already have a value
			$is_incremented_identifier = false;
			$this->data['MiscIdentifier']['identifier_value'] = strtoupper(substr($this->data['MiscIdentifier']['identifier_name'], 0, 1)).' '.substr($mi['MiscIdentifier']['identifier_value'], strpos($mi['MiscIdentifier']['identifier_value'], ' ') + 1);
		}
	}	
}
?>