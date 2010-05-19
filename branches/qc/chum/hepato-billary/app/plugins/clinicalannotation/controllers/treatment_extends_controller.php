<?php

class TreatmentExtendsController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.TreatmentExtend',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.TreatmentControl',
		'Drug.Drug');
		
	var $paginate = array('TreatmentExtend'=>array('limit' => pagination_amount,'order'=>'TreatmentExtend.id ASC'));
	
	function listall($participant_id, $tx_master_id) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment Master data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// List trt extends
		$this->data = $this->paginate($this->TreatmentExtend, array('TreatmentExtend.tx_master_id'=>$tx_master_id));
		
		$this->set('drug_list', $this->getDrugList($tx_master_data['TreatmentMaster']['tx_method']));
		
		// Set forms and menu data
		$this->Structures->set( $tx_master_data['TreatmentControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}

	function detail($participant_id, $tx_master_id, $tx_extend_id) {
		if (( !$participant_id ) && ( !$tx_master_id ) && ( !$tx_extend_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.tx_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		$this->data = $tx_extend_data;
		
		$this->set('drug_list', $this->getDrugList($tx_master_data['TreatmentMaster']['tx_method']));
	    
		// Set form alias and alias
		$this->Structures->set($tx_master_data['TreatmentControl']['extend_form_alias'] );
	    $this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }			
	}

	function add($participant_id, $tx_master_id) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		$this->set('drug_list', $this->getDrugList($tx_master_data['TreatmentMaster']['tx_method']));
		
		// Set form alias and menu
		$this->Structures->set($tx_master_data['TreatmentControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['TreatmentExtend']['tx_master_id'] = $tx_master_id;
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ($submitted_data_validates && $this->TreatmentExtend->save( $this->data ) ) {
				$this->flash( 'your data has been saved', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );
			}
		} 
	}

	function edit($participant_id, $tx_master_id, $tx_extend_id) {
		if (( !$participant_id ) && ( !$tx_master_id ) && ( !$tx_extend_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.tx_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }			
		
		$this->set('drug_list', $this->getDrugList($tx_master_data['TreatmentMaster']['tx_method']));
	    
		// Set form alias and menu data
		$this->Structures->set($tx_master_data['TreatmentControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id, 'TreatmentExtend.id'=>$tx_extend_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
			$this->data = $tx_extend_data;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			$this->TreatmentExtend->id = $tx_extend_id;
			if ($submitted_data_validates && $this->TreatmentExtend->save($this->data)) {
				$this->flash( 'your data has been updated','/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
			}
		}
	}

	function delete($participant_id, $tx_master_id, $tx_extend_id) {
		if (( !$participant_id ) && ( !$tx_master_id ) && ( !$tx_extend_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.tx_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }			
		
		$arr_allow_deletion = $this->allowTrtExtDeletion($tx_extend_id, $tx_master_data['TreatmentControl']['extend_tablename']);
			
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {		
			if( $this->TreatmentExtend->atim_delete( $tx_extend_id ) ) {
				$this->flash( 'your data has been deleted', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id);
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id);
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $tx_extend_id Id of the studied record.
	 * @param $extend_tablename
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowTrtExtDeletion($tx_extend_id, $extend_tablename){
		return array('allow_deletion' => true, 'msg' => '');
	}	
	
	function getDrugList($tx_method) {
		// Get drugs
		$drug_list = array();
		
		switch(strtolower($tx_method)) {
			case "chemotherapy":
				$drug_list = $this->Drug->find('all', array('order' => array('Drug.generic_name')));
				break;
			default:
				// No list to build
		}	
		
		// Format for display
		$formated_drug_list = array();
		foreach($drug_list as $new_drug) {
			$formated_drug_list[$new_drug['Drug']['id']] = $new_drug['Drug']['generic_name'] . (empty($new_drug['Drug']['type'])? '' : ' (' . __($new_drug['Drug']['type'] ,true). ')');
		}
		
		return $formated_drug_list;
	}

}

?>