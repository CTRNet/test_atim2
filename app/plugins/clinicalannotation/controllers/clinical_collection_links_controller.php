<?php

class ClinicalCollectionLinksController extends ClinicalannotationAppController {
	
	var $uses = array('Clinicalannotation.ClinicalCollectionLinks');
	var $paginate = array('ClinicalCollectionLinks'=>array('limit'=>10,'order'=>'ClinicalCollectionLinks.id ASC'));	
	
	function listall( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		// Find all unlinked, make sure participantID = NULL
		$this->data = $this->paginate($this->ClinicalCollectionLinks);
	}
	
	function detail( $participant_id, $clinical_collection_links_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_links_id) );
		$this->data = $this->ClinicalCollectionLinks->find('first',array('conditions'=>array('ClinicalCollectionLinks.id'=>$clinical_collection_links_id)));
	}
	
	function add( $participant_id ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/'.$particiant_id) );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		
		if ( !empty($this->data) ) {
			if ( $this->ClinicalCollectionLinks->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.$this->ClinicalCollectionLinks->id );
		}
	}
	
	function edit( $participant_id, $clinical_collection_links_id) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_links_id) );
		
		if ( !empty($this->data) ) {
			$this->ClinicalCollectionLinks->id = $clinical_collection_links_id;
			if ( $this->ClinicalCollectionLinks->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.$clinical_collection_links_id );
		} else {
			$this->data = $this->ClinicalCollectionLinks->find('first',array('conditions'=>array('ClinicalCollectionLinks.id'=>$clinical_collection_links_id)));
		}
	}

	function delete( $participant_id=null, $clinical_collection_link_id=null ) {
/*  TODO: Code from eventum issue #573
	$unlink_collection = array(
		'ClinicalCollectionLink' => array(
		'participant_id' => null,
		'diagnosis_master_id' => null,
		'consent_master_id' => null,
		'id' => $clinical_collection_link_id,
		'modified_by' => $this->othAuth->user('id')));
 */
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

	}
}

?>