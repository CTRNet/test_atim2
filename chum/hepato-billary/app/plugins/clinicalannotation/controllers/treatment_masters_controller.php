<?php

class TreatmentMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster', 
		'Clinicalannotation.TreatmentExtend',
		'Clinicalannotation.TreatmentControl', 
		'Clinicalannotation.DiagnosisMaster',
		'Protocol.ProtocolMaster'
	);
	
	var $paginate = array('TreatmentMaster'=>array('limit' => pagination_amount,'order'=>'TreatmentMaster.start_date DESC'));

	function listall($participant_id, $trt_control_id = null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// set FILTER, used as this->data CONDITIONS
		if ( !isset($_SESSION['TrtMaster_filter']) || !$trt_control_id ) {
			$_SESSION['TrtMaster_filter'] = array();
			$_SESSION['TrtMaster_filter']['TreatmentMaster.participant_id'] = $participant_id;
			
			$this->Structures->set('treatmentmasters');
		} else {
			$_SESSION['TrtMaster_filter']['TreatmentMaster.tx_control_id'] = $trt_control_id;
			
			$filter_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$trt_control_id)));
			if(empty($filter_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
			$this->Structures->set($filter_data['TreatmentControl']['form_alias']);
		}
				
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		$this->data = $this->paginate($this->TreatmentMaster, $_SESSION['TrtMaster_filter']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// find all TXCONTROLS, for ADD form
		$this->set('treatment_controls', $this->TreatmentControl->find('all', array('conditions' => array('TreatmentControl.flag_active' => "1"))));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function detail($participant_id, $tx_master_id) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		$this->data = $treatment_master_data;

		$this->set('diagnosis_data', (empty($this->data['TreatmentMaster']['diagnosis_master_id'])? array(): $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.id' => $this->data['TreatmentMaster']['diagnosis_master_id'])))));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id));
		
		// set structure alias based on control data
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function edit( $participant_id, $tx_master_id ) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		if(!empty($treatment_master_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			foreach($this->ProtocolMaster->getProtocolPermissibleValuesFromId($treatment_master_data['TreatmentControl']['applied_protocol_control_id']) as $new_available_protocol) {
				$available_protocols[$new_available_protocol['value']] = $new_available_protocol['default'];
			}
			$this->set('available_protocols', $available_protocols);
		}
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		foreach($dx_data as &$dx_tmp_data){
			// Define treatment data to take in consideration
			$treatment_master_data_to_use = $treatment_master_data['TreatmentMaster'];
			if(!empty($this->data)) {
				// User submitted data: take updated data in consideration in case data validation is wrong and form is redisplayed
				$treatment_master_data_to_use = $this->data['TreatmentMaster'];
			}
			
			// Set data to display correctly selected diagnosis			
			if($dx_tmp_data['DiagnosisMaster']['id'] == $treatment_master_data_to_use['diagnosis_master_id'] ){
				$dx_tmp_data['TreatmentMaster'] = $treatment_master_data_to_use;
			}
		}
		$this->set('data_for_checklist', $dx_data);		
			
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->Set('empty', 'empty_structure');
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->data)) {
			$this->data = $treatment_master_data;
		} else {
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
						
			if($submitted_data_validates) {
				$this->TreatmentMaster->id = $tx_master_id;
				if ($this->TreatmentMaster->save($this->data)) {
					$this->atimFlash( 'your data has been updated','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}
	}
	
	function add($participant_id=null, $tx_control_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$tx_control_id)));
		if(empty($tx_control_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		if(!empty($tx_control_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			foreach($this->ProtocolMaster->getProtocolPermissibleValuesFromId($tx_control_data['TreatmentControl']['applied_protocol_control_id']) as $new_available_protocol) {
				$available_protocols[$new_available_protocol['value']] = $new_available_protocol['default'];
			}
			$this->set('available_protocols', $available_protocols);
		}

		$this->set('initial_display', (empty($this->data)? true : false));
			
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		if(!empty($this->data)) {
			// User submitted data: take updated data in consideration in case data validation is wrong and form is redisplayed
			foreach($dx_data as &$dx_tmp_data){
				// Set data to display correctly selected diagnosis			
				if($dx_tmp_data['DiagnosisMaster']['id'] == $this->data['TreatmentMaster']['diagnosis_master_id'] ){
					$dx_tmp_data['TreatmentMaster'] = $this->data['TreatmentMaster'];
				}
			}
		}
		$this->set('data_for_checklist', $dx_data);					
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$tx_control_id));
		
		// Override generated menu to prevent selection of Administration menu item on ADD action
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/treatment_masters/listall/%%Participant.id%%'));
		
		// Set trt header
		$this->set('tx_header', __($tx_control_data['TreatmentControl']['disease_site'], true) . ' - ' . __($tx_control_data['TreatmentControl']['tx_method'], true));
		
		// set DIAGANOSES radio list form
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']); 			
		$this->Structures->Set('empty', 'empty_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['TreatmentMaster']['participant_id'] = $participant_id;
			$this->data['TreatmentMaster']['tx_control_id'] = $tx_control_id;
			$this->data['TreatmentMaster']['tx_method'] = $tx_control_data['TreatmentControl']['tx_method'];
			$this->data['TreatmentMaster']['disease_site'] = $tx_control_data['TreatmentControl']['disease_site'];
			
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {
				if ( $this->TreatmentMaster->save($this->data) ) {
					$this->atimFlash( 'your data has been saved','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
				}
			}
		 }
	}

	function delete( $participant_id, $tx_master_id ) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		
		$arr_allow_deletion = $this->allowTrtDeletion($tx_master_id, $treatment_master_data['TreatmentControl']['extend_tablename']);
						
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->TreatmentMaster->atim_delete( $tx_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $tx_master_id Id of the studied record.
	 * @param $tx_extend_tablename
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2010-04-18
	 */
	 
	function allowTrtDeletion($tx_master_id, $tx_extend_tablename){
		if(!empty($tx_extend_tablename)) {
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_extend_tablename);
			$nbr_extends = $this->TreatmentExtend->find('count', array('conditions'=>array('TreatmentExtend.tx_master_id'=>$tx_master_id), 'recursive' => '-1'));
			if ($nbr_extends > 0) { return array('allow_deletion' => false, 'msg' => 'at least one drug is defined as treatment component'); }
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}

?>