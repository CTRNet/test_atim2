<?php

class ClinicalCollectionLinksController extends ClinicalannotationAppController {
	
	var $components = array();
	
	var $uses = array(
		'Clinicalannotation.Participant', 
		'Clinicalannotation.ClinicalCollectionLink', 
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.DiagnosisMaster',
		
		'Inventorymanagement.Collection'
	);
	
	var $paginate = array('ClinicalCollectionLinks'=>array('limit' => pagination_amount,'order'=>'Collection.acquisition_label ASC'));	
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$this->data = $this->paginate($this->ClinicalCollectionLink, array('ClinicalCollectionLink.participant_id'=>$participant_id));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $clinical_collection_link_id ) {
		if (( !$participant_id ) || ( !$clinical_collection_link_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		
		$clinical_collection_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_link_id,'ClinicalCollectionLink.participant_id'=>$participant_id)));
		if(empty($clinical_collection_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		$this->data = $clinical_collection_data;	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLink.id'=>$clinical_collection_link_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		// Set collections list
		$collection_data = $this->Collection->find('all', array('conditions' => array('Collection.deleted' => '0', 'ClinicalCollectionLink.participant_id IS NULL', 'collection_property' => 'participant collection')));
		$this->set( 'collection_data', $collection_data );
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ConsentMaster.participant_id' => $participant_id)));
		$this->set( 'consent_data', $consent_data );
	
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id)));
		$this->set( 'diagnosis_data', $diagnosis_data );
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		// MANAGE DATA RECORD
		
		if ( !empty($this->data) ) {
			// Launch Save Process
			
			$this->data['ClinicalCollectionLink']['participant_id'] = $participant_id;
			$tmp_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.collection_id' => $this->data['ClinicalCollectionLink']['collection_id'])));
			$this->ClinicalCollectionLink->id = $tmp_data['ClinicalCollectionLink']['id'];
			if(strlen($this->ClinicalCollectionLink->id) == 0){
				$this->data['ClinicalCollectionLink']['deleted'] = 1;
			} 
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			if ( $submitted_data_validates && $this->ClinicalCollectionLink->save($this->data) ) {
				if(isset($this->data['ClinicalCollectionLink']['deleted'])){
					$this->redirect('/inventorymanagement/collections/add/'.$this->ClinicalCollectionLink->getLastInsertId());
				}else{
					$this->atimFlash( 'your data has been updated','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$this->ClinicalCollectionLink->id );
				}
				return;
			}
		}
	}
	
	function edit( $participant_id, $clinical_collection_link_id) {
		if (( !$participant_id ) || ( !$clinical_collection_link_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
	
		$clinical_collection_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_link_id,'ClinicalCollectionLink.participant_id'=>$participant_id)));
		if(empty($clinical_collection_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		// Set collection data	
		$collection_data = $this->Collection->find('all', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id)));
		$this->set( 'collection_data', $collection_data );
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ConsentMaster.participant_id' => $participant_id)));
		$this->set( 'consent_data', $consent_data );
		
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id)));
		$this->set( 'diagnosis_data', $diagnosis_data );
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_link_id) );
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
			
		// MANAGE DATA RECORD
		
		if ( !empty($this->data) ) {
			// Launch Save Process
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
			if ($submitted_data_validates && $this->ClinicalCollectionLink->save($this->data) ) {
				$this->atimFlash( 'your data has been updated','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id );
				return;
			}
		} else {
			// Launch Initial Display Process
			$this->data = $clinical_collection_data;
		}
	}

	function delete( $participant_id, $clinical_collection_link_id ) {
		if (( !$participant_id ) || ( !$clinical_collection_link_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA		
		
		$clinical_collection_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_link_id,'ClinicalCollectionLink.participant_id'=>$participant_id)));
		if(empty($clinical_collection_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		$arr_allow_deletion = $this->allowClinicalCollectionLinkDeletion($clinical_collection_link_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if($arr_allow_deletion['allow_deletion']) {
			$this->data = array('ClinicalCollectionLink' => array(
				'collection_id' => $clinical_collection_data['ClinicalCollectionLink']['collection_id'],
				'participant_id' => null,
				'diagnosis_master_id' => null,
				'consent_master_id' => null));
				
			$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
			if ($this->ClinicalCollectionLink->save($this->data)){
				$this->atimFlash( 'your data has been deleted' , '/clinicalannotation/clinical_collection_links/listall/'.$participant_id.'/');
			}else{
				$this->flash( 'error deleting data - contact administrator','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id.'/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id);
		}
	}
	
	/**
	 * Define if a collection could be separated from the participant.
	 * 
	 * @param $clinical_collection_link_id Id of the link
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
	 */
	 
	function allowClinicalCollectionLinkDeletion($clinical_collection_link_id){
		//empty function to allow easy customization
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>