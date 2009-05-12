<?php

class DrugsController extends DrugAppController {

	var $uses = array('Drug', 'ProtocolExtend', 'TreatmentExtend');
	var $paginate = array('Drug'=>array('limit'=>10,'order'=>'Drug.generic_name ASC')); 

	function listall( ) {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}

	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/drug/drugs/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Drug->save($this->data) ) $this->flash( 'Your data has been updated.','/drug/drugs/detail/'.$this->Drug->id );
		}
	}

	function edit( $drug_id=null ) {
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		if ( !empty($this->data) ) {
			$this->Drug->id = $drug_id;
			if ( $this->Drug->save($this->data) ) $this->flash( 'Your data has been updated.','/drug/drugs/detail/'.$drug_id );
		} else {
			$this->data = $this->Drug->find('first',array('conditions'=>array('Participant.id'=>$drug_id)));
		}
	}

	function detail( $drug_id=null ) {
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		$this->data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
	}

	function delete( $drug_id=null ) {

	}
	
	function allowDrugDeletion($drug_id) {
/*		
		$studied_treatment_extend_list = array('txe_chemos');
		
		if(!empty($studied_treatment_extend_list)) {
			foreach($studied_treatment_extend_list as $id => $extend_tablename) {
				
				$this->TreatmentExtend = new TreatmentExtend( false, $extend_tablename );
				
				$criteria = 'TreatmentExtend.drug_id ="' .$drug_id.'"';			 
				$record_nbr = $this->TreatmentExtend->findCount($criteria);
				
				if($record_nbr > 0){
					return FALSE;
				}
				
			}
		}
		
		$studied_protocol_extend_list = array('pe_chemos');
			
		if(!empty($studied_protocol_extend_list)) {
			foreach($studied_protocol_extend_list as $id => $extend_tablename) {
				
				$this->ProtocolExtend = new ProtocolExtend( false, $extend_tablename );
				
				$criteria = 'ProtocolExtend.drug_id ="' .$drug_id.'"';			 
				$record_nbr = $this->ProtocolExtend->findCount($criteria);
				
				if($record_nbr > 0){
					return FALSE;
				}
				
			}
		}		
		
		// Etc
		
		return TRUE;
		*/
	}
}

?>