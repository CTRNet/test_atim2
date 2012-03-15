<?php

class TreatmentMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.TreatmentMaster', 
		'ClinicalAnnotation.TreatmentExtend', 
		'ClinicalAnnotation.TreatmentControl', 
		'ClinicalAnnotation.DiagnosisMaster',
		'Protocol.ProtocolMaster'
	);
	
	var $paginate = array('TreatmentMaster'=>array('limit' => pagination_amount,'order'=>'TreatmentMaster.start_date DESC'));

	function listall($participant_id){
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		$this->request->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id' => $participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// find all TXCONTROLS, for ADD form
		$this->set('add_links', $this->TreatmentControl->getAddLinks($participant_id));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function detail($participant_id, $tx_master_id, $is_ajax = 0){
		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->request->data = $treatment_master_data;
		
		$this->set('diagnosis_data', $this->DiagnosisMaster->getRelatedDiagnosisEvents($this->request->data['TreatmentMaster']['diagnosis_master_id']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id));
		
		// set structure alias based on control data
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'diagnosis_structure');
		$this->set('is_ajax', $is_ajax);
		
		if($treatment_master_data['TreatmentControl']['extend_tablename']){
			$this->TreatmentExtend = AppModel::atimInstantiateExtend($this->TreatmentExtend, $treatment_master_data['TreatmentControl']['extend_tablename']);
			$this->set('tx_extend_data', $this->TreatmentExtend->find('all', array('conditions' => array('TreatmentExtend.treatment_master_id' => $tx_master_id))));
			$this->Structures->set($treatment_master_data['TreatmentControl']['extend_form_alias'], 'extend_form_alias');
			if(!empty($treatment_master_data['TreatmentControl']['extended_data_import_process'])) {
				$this->set('extended_data_import_process', $treatment_master_data['TreatmentControl']['extended_data_import_process']);
			}
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}		
	}
	
	function edit( $participant_id, $tx_master_id ) {
		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		

		if(!empty($treatment_master_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			ProtocolMaster::$protocol_dropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($treatment_master_data['TreatmentControl']['applied_protocol_control_id']);
		}
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		$dx_id = isset($this->request->data['TreatmentMaster']['diagnosis_master_id']) ? $this->request->data['TreatmentMaster']['diagnosis_master_id'] : $treatment_master_data['TreatmentMaster']['diagnosis_master_id'];
		$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $dx_id, 'TreatmentMaster');
		
		$this->set('radio_checked', $dx_id > 0);
		$this->set('data_for_checklist', $dx_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->Set('empty', 'empty_structure');
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->request->data)) {
			$this->request->data = $treatment_master_data;
		} else {
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
						
			if($submitted_data_validates) {
				$this->TreatmentMaster->id = $tx_master_id;
				if ($this->TreatmentMaster->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}
	}
	
	function add($participant_id, $tx_control_id, $diagnosis_master_id = null) {
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		$tx_control_data = $this->TreatmentControl->getOrRedirect($tx_control_id);

		if(!empty($tx_control_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			$this->ProtocolMaster;//lazy load
			ProtocolMaster::$protocol_dropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($tx_control_data['TreatmentControl']['applied_protocol_control_id']);
		}

		$this->set('initial_display', (empty($this->request->data)? true : false));
			
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		if(isset($this->request->data['TreatmentMaster']['diagnosis_master_id'])){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $this->request->data['TreatmentMaster']['diagnosis_master_id'], 'TreatmentMaster');
		}else if($diagnosis_master_id){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $diagnosis_master_id, 'TreatmentMaster');
		}
		
		$this->set('data_for_checklist', $dx_data);					
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$tx_control_id));
		
		// Override generated menu to prevent selection of Administration menu item on ADD action
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
		
		// Set trt header
		$this->set('tx_header', __($tx_control_data['TreatmentControl']['disease_site']) . ' - ' . __($tx_control_data['TreatmentControl']['tx_method']));
		
		// set DIAGANOSES radio list form
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias'], 'atim_structure', array('model_table_assoc' => array('TreatmentDetail' => $tx_control_data['TreatmentControl']['detail_tablename']))); 			
		$this->Structures->Set('empty', 'empty_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->request->data) ) {
			$this->request->data['TreatmentMaster']['participant_id'] = $participant_id;
			$this->request->data['TreatmentMaster']['treatment_control_id'] = $tx_control_id;
			$this->TreatmentMaster->addWritableField(array('participant_id', 'treatment_control_id', 'diagnosis_master_id'));
			$this->TreatmentMaster->addWritableField('treatment_master_id', $tx_control_data['TreatmentControl']['detail_tablename']);
			
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {
				if ( $this->TreatmentMaster->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved','/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
				}
			}
		 }else{
		 	$this->request->data['TreatmentMaster']['diagnosis_master_id'] = $diagnosis_master_id;
		 }
	}

	function delete( $participant_id, $tx_master_id ) {

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		
		$this->TreatmentMaster->set($treatment_master_data);
		$arr_allow_deletion = $this->TreatmentMaster->allowDeletion($tx_master_id);
						
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->TreatmentMaster->atimDelete( $tx_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/TreatmentMasters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>