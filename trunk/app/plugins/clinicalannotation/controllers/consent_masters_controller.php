<?php

class ConsentMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.ConsentDetail',
		'Clinicalannotation.ConsentControl',
		'Clinicalannotation.Participant',
		'Provider.Provider'
	);
	
	var $paginate = array('ConsentMaster'=>array('limit'=>10,'order'=>'ConsentMaster.date ASC')); 

	function listall( $participant_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes','Provider.deleted'=>'0')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->set('consent_controls_list', $this->ConsentControl->find('all', array('conditions' => array('ConsentControl.status' => 'active'))));
		
		$this->hook();
		
		$this->data = $this->paginate($this->ConsentMaster, array('ConsentMaster.participant_id'=>$participant_id));
	}	

	function detail( $participant_id=null, $consent_master_id=null) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$consent_master_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes','Provider.deleted'=>'0')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentMaster.id'=>$consent_master_id) );
		
		$this->hook();
		
		$this->data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id)));
		$storage_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $this->data['ConsentMaster']['consent_control_id'])));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['ConsentControl']['form_alias']));
		
	}
	
	function add( $participant_id=null, $consent_control_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes','Provider.deleted'=>'0')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentControl.id' => $consent_control_id) );
		
		$storage_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $consent_control_id)));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['ConsentControl']['form_alias']));
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['ConsentMaster']['participant_id'] = $participant_id;
			$this->data['ConsentMaster']['consent_control_id'] = $consent_control_id;
			$this->data['ConsentMaster']['type'] = $storage_data['ConsentControl']['controls_type'];
			if ( $this->ConsentMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/consent_masters/detail/'.$participant_id.'/'.$this->ConsentMaster->id );
			}
		}
	}

	function edit( $participant_id=null, $consent_master_id=null) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$consent_master_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id', NULL, TRUE ); }
		
		$facility_list = $this->Provider->find('all', array('conditions'=>array('Provider.active'=>'yes','Provider.deleted'=>'0')), array('fields' => array('Provider.id', 'Provider.name'), 'order' => array('Provider.name')));
		foreach ( $facility_list as $record ) {
			$facility_id_findall[ $record['Provider']['id'] ] = $record['Provider']['name'];
		}
		$this->set('facility_id_findall', $facility_id_findall);
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentMaster.id'=>$consent_master_id) );
		$storage_data = $this->ConsentMaster->find('first', array('conditions' => array('ConsentMaster.id' => $consent_master_id)));
		$storage_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $storage_data['ConsentMaster']['consent_control_id'])));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['ConsentControl']['form_alias']));
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->ConsentMaster->id = $consent_master_id;
			if ( $this->ConsentMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/consent_masters/detail/'.$participant_id.'/'.$consent_master_id );
			}
		} else {
			$this->data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id)));
		}
	}

	function delete( $participant_id=null, $consent_master_id=null) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$consent_master_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id', NULL, TRUE ); }
		
		$storage_data = $this->ConsentMaster->find('first', array('conditions' => array('ConsentMaster.id' => $consent_master_id)));
		$storage_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $storage_data['ConsentMaster']['consent_control_id'])));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['ConsentControl']['form_alias']));
		
		$this->hook();
		
		if( $this->ConsentMaster->atim_delete( $consent_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/consent_masters/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/consent_masters/listall/'.$participant_id );
		}
	}
}

?>