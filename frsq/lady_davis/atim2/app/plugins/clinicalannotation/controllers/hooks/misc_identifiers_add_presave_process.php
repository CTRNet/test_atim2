<?php
/**
 * Ensures that we cannot create same identifier twice, that different identifier share the same increment and that creating an identifier
 * that was deleted restores it instead of creating a new one.
 */

if($this->data['MiscIdentifier']['identifier_name'] == "collection"){
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
	}
}
?>