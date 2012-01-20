<?php

		$this->MiscIdentifier = AppModel::getInstance('clinicalannotation', 'MiscIdentifier', true);
		$miscidentifier_data = $this->MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.deleted' => '0', 'MiscIdentifier.participant_id' => $participant_id, "MiscIdentifierControl.misc_identifier_name LIKE '#FRSQ%'"), 'order' => array('MiscIdentifier.created DESC')));
		$this->set( 'miscidentifier_data', $miscidentifier_data );
		
		$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');

?>