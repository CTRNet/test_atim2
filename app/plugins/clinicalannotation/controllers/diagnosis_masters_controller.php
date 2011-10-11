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
		'codingicd.CodingIcd10Who',
		'codingicd.CodingIcd10Ca',
		'codingicd.CodingIcdo3Topo',//required by model
		'codingicd.CodingIcdo3Morpho'//required by model
	);
	var $paginate = array('DiagnosisMaster'=>array('limit' => pagination_amount,'order'=>'DiagnosisMaster.dx_date'));

	function listall( $participant_id, $parent_dx_id = null, $is_ajax = 0 ) {
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		
		$tx_model = AppModel::getInstance("clinicalannotation", "TreatmentMaster", true);
		$event_master_model = AppModel::getInstance("clinicalannotation", "EventMaster", true);
		$this->data = array_merge($this->DiagnosisMaster->find('all', array(
				'conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.parent_id' => $parent_dx_id ),
				'order' => array('DiagnosisMaster.dx_date')
			)), $tx_model->find('all', array(
				'conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.diagnosis_master_id' => $parent_dx_id == null ? -1 : $parent_dx_id ),
				'order' => array('TreatmentMaster.start_date')
			)), $event_master_model->find('all', array(
				'conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.diagnosis_master_id' => $parent_dx_id == null ? -1 : $parent_dx_id),
				'order' => array('EventMaster.event_date')
			))
		);
		
		$ids = array();
		$no_add_ids = array();
		$can_have_child  = array('primary', 'secondary');
		foreach($this->data as $data){
			if(array_key_exists('DiagnosisMaster', $data)){
				$ids[] = $data['DiagnosisMaster']['id'];
				if(!in_array($data['DiagnosisMaster']['dx_origin'], $can_have_child)){
					$no_add_ids[] = $data['DiagnosisMaster']['id'];
				}
			}
		}
		pr($no_add_ids);
		$ids_having_child = $this->DiagnosisMaster->hasChild($ids);
		$ids_having_child = array_fill_keys($ids_having_child, null);
		foreach($this->data as &$data){
			if(array_key_exists('DiagnosisMaster', $data)){
				$data['children'] = array_key_exists($data['DiagnosisMaster']['id'], $ids_having_child);
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.flag_active' => 1))));
		$this->set('is_ajax', $is_ajax);
		$atim_structure['DiagnosisMaster'] = $this->Structures->get('form', 'diagnosismasters'); 
		$atim_structure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters'); 
		$atim_structure['EventMaster'] = $this->Structures->get('form', 'eventmasters'); 
		$this->set('atim_structure', $atim_structure);
		$this->set('no_add_ids', $no_add_ids);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}			
	}

	function detail( $participant_id, $diagnosis_master_id ) {
		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->data = $dx_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.diagnosis_control_id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id']) );
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
		
		//check for dates warning
		if(
			is_numeric($dx_master_data['DiagnosisMaster']['parent_id']) && 
			!empty($dx_master_data['DiagnosisMaster']['dx_date']) &&
			$dx_master_data['DiagnosisMaster']['dx_date_accuracy'] == 'c'
		){
			$parent_dx = $this->DiagnosisMaster->findById($dx_master_data['DiagnosisMaster']['parent_id']);
			if(
				!empty($parent_dx['DiagnosisMaster']['dx_date']) &&
				$parent_dx['DiagnosisMaster']['dx_date_accuracy'] == 'c' &&
				(strtotime($dx_master_data['DiagnosisMaster']['dx_date']) - strtotime($parent_dx['DiagnosisMaster']['dx_date']) < 0)
			){
				AppController::addWarningMsg(__('the current diagnosis date is before the parent diagnosis date', true));
			}
		}
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		$events_data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.diagnosis_master_id' => $diagnosis_master_id)));
		foreach($events_data as $event_data){
			EventMaster::generateDxCompatWarnings($this->data, $event_data);
		}
	}

	function add( $participant_id, $parent_id, $dx_control_id){
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		$dx_ctrl = $this->DiagnosisControl->redirectIfNonExistent($dx_control_id, __METHOD__, __LINE__, true);
		if(empty($participant_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		if($parent_id == 0){
			if(!$dx_ctrl['DiagnosisControl']['flag_primary']){
				//is not a primary but has no parent
				$this->flash('invalid control id', 'javascript:history.back();');
			}
		}else{
			$parent_dx = $this->DiagnosisMaster->find('first', array('conditions' => array('DiagnosisMaster.id' => $parent_id, 'DiagnosisMaster.participant_id' => $participant_id)));
			if(empty($parent_dx)){
				$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );				
			}
			
			if(
				//is a child but cannot be
				!$dx_ctrl['DiagnosisControl']['flag_secondary'] ||
				//is a secondary of a secondary
				$dx_ctrl['DiagnosisControl']['controls_type'] == 'secondary' && $parent_dx['DiagnosisMaster']['diagnosis_control_id'] == $dx_ctrl['DiagnosisControl']['id'] ||
				//is not having a secondary or primary parent
				!in_array($parent_dx['DiagnosisControl']['controls_type'], array('primary', 'secondary'))
			){
				$this->flash('invalid control id', 'javascript:history.back();');
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, "tableId"=>$dx_control_id, 'DiagnosisMaster.parent_id' => $parent_id));
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/diagnosis_masters/listall/') );
		$this->set('origin', $parent_id == 0 ? 'primary' : 'secondary');
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_control_id)));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias'].",".($parent_id == 0 ? "dx_origin_primary" : "dx_origin_wo_primary"));
		$this->Structures->set('empty', 'empty_structure');

		$this->set( 'dx_type', $dx_control_data['DiagnosisControl']['controls_type']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->data) ) {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$this->data['DiagnosisMaster']['participant_id'] = $participant_id;
			$this->data['DiagnosisMaster']['diagnosis_control_id'] = $dx_control_id;
			$this->data['DiagnosisMaster']['type'] = $dx_control_data['DiagnosisControl']['controls_type'];
			$this->data['DiagnosisMaster']['parent_id'] = $parent_id == 0 ? null : $parent_id;

			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				if ( $this->DiagnosisMaster->save( $this->data )) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved', '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$this->DiagnosisMaster->id.'/' );
				}
			}
		}
	}

	function edit( $participant_id, $diagnosis_master_id ) {
		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.diagnosis_control_id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id']));
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$structure_alias = $dx_control_data['DiagnosisControl']['form_alias'].', ';
		$structure_alias .= empty($dx_master_data['DiagnosisMaster']['parent_id']) ? 'dx_origin_primary' : 'dx_origin_wo_primary';  
		$this->Structures->set($structure_alias);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($this->data)) {
			$this->data = $dx_master_data;
		} else {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				$this->DiagnosisMaster->id = $diagnosis_master_id;
				if ( $this->DiagnosisMaster->save($this->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id );
				}
			}
		}
		
	}

	function delete( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { 
			$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}
	
		// MANAGE DATA
		$diagnosis_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if (empty($diagnosis_master_data)) {
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$arr_allow_deletion = $this->DiagnosisMaster->allowDeletion($diagnosis_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->DiagnosisMaster->atim_delete( $diagnosis_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id);
		}		
	}
}

?>