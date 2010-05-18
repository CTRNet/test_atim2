<?php

class DrugsController extends DrugAppController {

	var $uses = array(
		'Drug.Drug',
		'Protocol.ProtocolExtend',
		'Clinicalannotation.TreatmentExtend');
		
	var $paginate = array('Drug'=>array('limit' => pagination_amount,'order'=>'Drug.generic_name ASC')); 

	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function search() {
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Drug, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Drug']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/drug/drugs/search';
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add() {	
		
		$this->set( 'atim_menu', $this->Menus->get('/drug/drugs/index/') );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
						
			if ( $submitted_data_validates && $this->Drug->save($this->data) ) {
				$this->flash( 'your data has been updated','/drug/drugs/detail/'.$this->Drug->id );
			}
		}
  	}
  
	function edit( $drug_id ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_drug_funct_param_missing', NULL, TRUE ); }
		
		$drug_data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		if(empty($drug_data)) { $this->redirect( '/pages/err_drug_no_data', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
		
		if ( empty($this->data) ) {
			$this->data = $drug_data;
		} else { 			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {
				$this->Drug->id = $drug_id;
				if ( $this->Drug->save($this->data) ) {
					$this->flash( 'your data has been updated','/drug/drugs/detail/'.$drug_id );
				}
			}
		}
  	}
	
	function detail( $drug_id ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_drug_funct_param_missing', NULL, TRUE ); }

		$drug_data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		if(empty($drug_data)) { $this->redirect( '/pages/err_drug_no_data', NULL, TRUE ); }
		$this->data = $drug_data;
			
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
  
	function delete( $drug_id ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_drug_funct_param_missing', NULL, TRUE ); }

		$drug_data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		if(empty($drug_data)) { $this->redirect( '/pages/err_drug_no_data', NULL, TRUE ); }
				
		$arr_allow_deletion = $this->allowDrugDeletion($drug_id);
			
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {
		
			if( $this->Drug->atim_delete( $drug_id ) ) {
				$this->flash( 'your data has been deleted', '/drug/drugs/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/drug/drugs/index/');
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/drug/drugs/detail/'.$drug_id);
		}	
  	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $drug_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowDrugDeletion($drug_id){
		
		$this->TreatmentExtend = new TreatmentExtend(false, 'txe_chemos');
		$returned_nbr = $this->TreatmentExtend->find('count', array('conditions' => array('TreatmentExtend.drug_id' => $drug_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one participant chemotherapy'); }
		
		$this->ProtocolExtend = new ProtocolExtend(false, 'pe_chemos');
		$returned_nbr = $this->ProtocolExtend->find('count', array('conditions' => array('ProtocolExtend.drug_id' => $drug_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'drug is defined as a component of at least one chemotherapy protocol'); }

		return array('allow_deletion' => true, 'msg' => '');
	}	

}

?>