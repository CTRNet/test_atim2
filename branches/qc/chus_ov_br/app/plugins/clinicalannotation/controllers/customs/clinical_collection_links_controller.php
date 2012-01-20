<?php

class ClinicalCollectionLinksControllerCustom extends ClinicalCollectionLinksController {

	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	

		$this->paginate['ClinicalCollectionLink'] = array(
			'limit' => pagination_amount , 
			'order' => 'Collection.collection_datetime DESC',
			'fields' => array('*'),
			'joins' => array(
				DiagnosisMaster::joinOnDiagnosisDup('ClinicalCollectionLink.diagnosis_master_id'), 
				DiagnosisMaster::$join_diagnosis_control_on_dup,
				ConsentMaster::joinOnConsentDup('ClinicalCollectionLink.consent_master_id'), 
				ConsentMaster::$join_consent_control_on_dup,
				array(
		            'table' => 'misc_identifiers',
		            'alias' => 'MiscIdentifier',
		            'type' => 'left',
		            'conditions'=> array('ClinicalCollectionLink.misc_identifier_id = MiscIdentifier.id')
				)
        	)
        );

		$this->data = $this->paginate($this->ClinicalCollectionLink, array('ClinicalCollectionLink.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
}
	
?>
