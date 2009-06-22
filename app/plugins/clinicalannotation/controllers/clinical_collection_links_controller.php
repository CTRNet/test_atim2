<?php

class ClinicalCollectionLinksController extends ClinicalAnnotationAppController {
	var $uses = array('ClinicalCollectionLinks');
	var $paginate = array('ClinicalCollectionLinks'=>array('limit'=>10,'order'=>'ClinicalCollectionLinks.id ASC'));	
	
	function listall( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
	
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