<?php

class TreatmentMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster', 
		'Clinicalannotation.TreatmentControl', 
		'Clinicalannotation.DiagnosisMaster',
		'Protocol.ProtocolMaster'
	);
	var $paginate = array('TreatmentMaster'=>array('limit'=>10,'order'=>'TreatmentMaster.start_date DESC'));

	function listall($participant_id) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		$this->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		$this->set('protocol_list', $protocol_list);

		// find all TXCONTROLS, for ADD form
		$this->set('treatment_controls', $this->TreatmentControl->find('all'));

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

		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$treatment_master_data['TreatmentMaster']['treatment_control_id'])));
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id));
		$this->set('protocol_list', $protocol_list);

		// set structure alias based on control data
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		$this->set('diagnosis_data', $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.id' => $this->data['TreatmentMaster']['diagnosis_master_id']))));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function edit( $participant_id, $tx_master_id ) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$treatment_master_data['TreatmentMaster']['treatment_control_id'])));
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		$this->set('protocol_list', $protocol_list);
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']);

		// set DIAGANOSES section
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		
		$dx_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		foreach($dx_data as &$dx_tmp_data){
			$dx_tmp_data['TreatmentMaster']['diagnosis_master_id'] = $this->data['TreatmentMaster']['diagnosis_master_id'];
		}
		$this->set('data_for_checklist', $dx_data);		
		
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
					$this->flash( 'your data has been updated','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}
		$this->Structures->Set('empty', 'empty_structure');			
	}
	
	function add($participant_id=null, $treatment_control_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$treatment_control_id));
		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$treatment_control_id)));
		
		// Override generated menu to prevent selection of Administration menu item on ADD action
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/treatment_masters/listall/%%Participant.id%%'));
		
		$this->set('protocol_list', $protocol_list);
		
		// set DIAGANOSES radio list form
		$this->set( 'data_for_checklist', $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id))) );
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['TreatmentMaster']['participant_id'] = $participant_id;
			$this->data['TreatmentMaster']['treatment_control_id'] = $treatment_control_id;
			$this->data['TreatmentMaster']['tx_method'] = $tx_control_data['TreatmentControl']['tx_method'];
			
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {
				if ( $this->TreatmentMaster->save($this->data) ) {
					$this->flash( 'Your data has been added.','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
				}
			}
		 } 	
		$this->Structures->Set('empty', 'empty_structure');
	}

	function delete( $participant_id, $tx_master_id ) {
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		if( $this->TreatmentMaster->atim_delete( $tx_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
		}
	}
}

?>