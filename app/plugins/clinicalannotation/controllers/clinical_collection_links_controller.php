<?php

class ClinicalCollectionLinksController extends ClinicalannotationAppController {
	
	var $uses = array('Clinicalannotation.ClinicalCollectionLink', 
		'Inventorymanagement.Collection',
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.DiagnosisMaster');
	
	var $paginate = array('ClinicalCollectionLinks'=>array('limit'=>10,'order'=>'ClinicalCollectionLinks.id ASC'));	
	
	function listall( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		$this->data = $this->paginate($this->ClinicalCollectionLink, array('ClinicalCollectionLink.participant_id'=>$participant_id));
	}
	
	function detail( $participant_id, $clinical_collection_links_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLink.id'=>$clinical_collection_links_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		$this->data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_links_id)));
	}
	
	function add( $participant_id ) {
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( !empty($this->data) ) {
			$this->data['ClinicalCollectionLink']['participant_id'] = $participant_id;
			$tmp_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.collection_id' => $this->data['ClinicalCollectionLink']['collection_id'])));
			$this->ClinicalCollectionLink->id = $tmp_data['ClinicalCollectionLink']['id']; 
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
		
			if ( $submitted_data_validates && $this->ClinicalCollectionLink->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$this->ClinicalCollectionLink->id );
		}
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
		
		$collection_data = $this->Collection->find('all', array('conditions' => array('Collection.deleted' => '0', 'ClinicalCollectionLink.participant_id IS NULL', 'collection_property' => 'participant collection')));
		$this->set( 'collection_data', $collection_data );

		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ClinicalCollectionLink.participant_id IS NULL', 'ConsentMaster.participant_id' => $participant_id)));
		$this->set( 'consent_data', $consent_data );
	
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions' => //array('DiagnosisMaster.deleted' => '0', 'ClinicalCollectionLink.participant_id IS NULL', 'DiagnosisMaster.participant_id' => $participant_id)));
			'DiagnosisMaster.deleted = 0 AND ClinicalCollectionLink.participant_id IS NULL AND DiagnosisMaster.participant_id='.$participant_id));
		$this->set( 'diagnosis_data', $diagnosis_data );
	}
	
	function edit( $participant_id, $clinical_collection_links_id) {
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( !empty($this->data) ) {
			$this->ClinicalCollectionLink->id = $clinical_collection_links_id;
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ($submitted_data_validates && $this->ClinicalCollectionLink->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_links_id );
		} else {
			$this->data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_links_id)));
		}
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_links_id) );
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
		
		$collection_data = $this->Collection->find('all', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_links_id)));
		$this->set( 'collection_data', $collection_data );
		
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => 
			'ConsentMaster.deleted = 0 '
			.'AND (ClinicalCollectionLink.participant_id IS NULL '
			.'OR (ClinicalCollectionLink.participant_id = '.$participant_id.' '
				.'AND ClinicalCollectionLink.id='.$clinical_collection_links_id.')) '
			.'AND ConsentMaster.participant_id = '.$participant_id));
		$this->set( 'consent_data', $consent_data );
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions' => 
			'DiagnosisMaster.deleted = 0 '
			.'AND (ClinicalCollectionLink.participant_id IS NULL '
			.'OR (ClinicalCollectionLink.participant_id = '.$participant_id.' '
				.'AND ClinicalCollectionLink.id='.$clinical_collection_links_id.')) '
			.'AND DiagnosisMaster.participant_id = '.$participant_id));
		$this->set( 'diagnosis_data', $diagnosis_data );
	}

	function delete( $participant_id, $clinical_collection_link_id ) {
		if($this->allowClinicalCollectionLinkDeletion($clinical_collection_link_id)){
			$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
			$data = $this->ClinicalCollectionLink->find('first', 'ClinicalCollectionLink.id='.$clinical_collection_link_id);
			$this->data = array('ClinicalCollectionLink' => array(
				'collection_id' => $data['ClinicalCollectionLink']['collection_id'],
				'participant_id' => null,
				'diagnosis_master_id' => null,
				'consent_master_id' => null));
				
			$arr_allow_deletion['allow_deletion'] = true;
			$submitted_data_validates = true;
			$hook_link = $this->hook('delete');
			if( $hook_link ) { require($hook_link); }
				
			if ($arr_allow_deletion['allow_deletion'] && $this->ClinicalCollectionLink->save($this->data)){
				$this->flash( 'Your data has been deleted.','/clinicalannotation/clinical_collection_links/listall/'.$participant_id.'/');
			}else{
				$this->flash( 'Deletion failed.','/clinicalannotation/clinical_collection_links/edit/'.$participant_id.'/'.$clinical_collection_link_id.'/');
			}
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
		return true;
	}
	
}

?>