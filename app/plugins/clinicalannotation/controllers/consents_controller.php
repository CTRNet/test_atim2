<?php

class ConsentsController extends ClinicalannotationAppController {

	var $uses = array(
		'ClinicalAnnotation.Consent',
		'ClinicalAnnotation.Participant',
		'Provider.Provider'
	);
	
	var $paginate = array('Consent'=>array('limit'=>10,'order'=>'Consent.date ASC')); 

	function listall( $participant_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->data = $this->paginate($this->Consent, array('Consent.participant_id'=>$participant_id));
	}	

	function detail( $participant_id=null, $consent_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Consent.id'=>$consent_id) );
		$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
	}
	
	function add( $participant_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );	
		if ( !empty($this->data) ) {
			$this->data['Consent']['participant_id'] = $participant_id;
			if ( $this->Consent->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$participant_id.'/'.$this->Consent->id );
			}
		}
	}

	function edit( $participant_id=null, $consent_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Consent.id'=>$consent_id) );
		if ( !empty($this->data) ) {
			$this->Consent->id = $consent_id;
			if ( $this->Consent->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$participant_id.'/'.$consent_id );
			}
		} else {
			$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
		}
	}

	function delete( $participant_id=null, $consent_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id', NULL, TRUE ); }
		
		if( $this->Consent->del( $consent_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/consents/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/consents/listall/'.$participant_id );
		}
	}
}

?>