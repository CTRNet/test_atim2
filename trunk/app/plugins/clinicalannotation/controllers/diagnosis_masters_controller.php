<?php

class DiagnosisMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.DiagnosisMaster', 
		'Clinicalannotation.DiagnosisDetail',
		'Clinicalannotation.DiagnosisControl',
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.EventMaster',
		'Clinicalannotation.ClinicalCollectionLink',
		'codingicd10.CodingIcd10'
	);
	var $paginate = array('DiagnosisMaster'=>array('limit'=>10,'order'=>'DiagnosisMaster.dx_date')); 
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		$this->data = $this->paginate($this->DiagnosisMaster, array('DiagnosisMaster.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.status' => 'active'))));
		
		foreach($this->data as &$dx) {
			$dx['DiagnosisMaster']['primary_icd10_code'] .= " - ".$this->CodingIcd10->getDescription($dx['DiagnosisMaster']['primary_icd10_code']);
		}

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }			
	}

	function detail( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
	
		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		$this->data = $dx_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.diagnosis_control_id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id']) );
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
	
		$this->data['DiagnosisMaster']['primary_icd10_code'] .= " - ".$this->CodingIcd10->getDescription($this->data['DiagnosisMaster']['primary_icd10_code']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add( $participant_id=null, $dx_control_id=null ) {
		if (( !$participant_id ) && ( !$dx_control_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, "tableId"=>$dx_control_id));
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/diagnosis_masters/listall/') );
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_control_id)));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
		$this->Structures->set('empty', 'empty_structure');

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$this->data['DiagnosisMaster']['participant_id'] = $participant_id;
			$this->data['DiagnosisMaster']['diagnosis_control_id'] = $dx_control_id;
			$this->data['DiagnosisMaster']['type'] = $dx_control_data['DiagnosisControl']['controls_type']; 

			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				if ( $this->DiagnosisMaster->save( $this->data )) {
					$this->flash( 'your data has been saved', '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$this->DiagnosisMaster->id.'/' );
				}
			}
		}
		
		$this->buildAndSetExistingDx($participant_id, 0, 0);
	}

	function edit( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	

		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_master_id));
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
			$this->data = $dx_master_data;
		} else {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				$this->DiagnosisMaster->id = $diagnosis_master_id;
				if ( $this->DiagnosisMaster->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id );
				}
			}
		}
		
		$this->Structures->set('empty', 'empty_structure');
		$this->buildAndSetExistingDx($participant_id, $diagnosis_master_id, $dx_master_data['DiagnosisMaster']['primary_number']);
	}

	function delete( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
	
		// MANAGE DATA
		$diagnosis_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if (empty($diagnosis_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$arr_allow_deletion = $this->allowDiagnosisDeletion($diagnosis_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->DiagnosisMaster->atim_delete( $diagnosis_master_id ) ) {
				$this->flash( 'your data has been deleted', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id);
		}		
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $diagnosis_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowDiagnosisDeletion($diagnosis_master_id) {
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');
		
		// Check for existing records linked to the participant. If found, set error message and deny delete
		$nbr_linked_collection = $this->ClinicalCollectionLink->find('count', array('conditions' => array('ClinicalCollectionLink.diagnosis_master_id' => $diagnosis_master_id, 'ClinicalCollectionLink.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_collection';
		}
		
		$nbr_events = $this->EventMaster->find('count', array('conditions'=>array('EventMaster.diagnosis_master_id'=>$diagnosis_master_id, 'EventMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_events > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_events';
		}

		$nbr_treatment = $this->TreatmentMaster->find('count', array('conditions'=>array('TreatmentMaster.diagnosis_master_id'=>$diagnosis_master_id, 'TreatmentMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_treatment > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_treatment';
		}		
		return $arr_allow_deletion;
	}	
	
	function buildAndSetExistingDx($participant_id, $current_dx_id, $current_dx_primary_number) {
		$existing_dx = $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.id != '.$current_dx_id)));
		//sort by dx number
		if(empty($existing_dx)){
			$sorted_dx[0] = array();
		}else{
			foreach($existing_dx as $dx){
				if(isset($sorted_dx[$dx['DiagnosisMaster']['primary_number']])){
					array_push($sorted_dx[$dx['DiagnosisMaster']['primary_number']], $dx);
				}else{
					$sorted_dx[$dx['DiagnosisMaster']['primary_number']][0] = $dx;
				}
			}
			if(!isset($sorted_dx[0])){
				$sorted_dx[0] = array();
			}
			if(!isset($sorted_dx[$current_dx_primary_number])){
				$sorted_dx[$current_dx_primary_number] = array();			
			}
		}
		ksort($sorted_dx);
		$this->set('existing_dx', $sorted_dx);	
	}
}

?>