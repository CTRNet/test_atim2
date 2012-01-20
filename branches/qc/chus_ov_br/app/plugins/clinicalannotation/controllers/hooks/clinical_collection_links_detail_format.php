<?php

		$this->MiscIdentifier = AppModel::getInstance('clinicalannotation', 'MiscIdentifier', true);
		$miscidentifier_data = $this->MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.id' => $clinical_collection_data['ClinicalCollectionLink']['misc_identifier_id'])));
		$this->set( 'miscidentifier_data', $miscidentifier_data );
		
		$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');

?>