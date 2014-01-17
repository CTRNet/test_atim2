<?php

class DiagnosisMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.DiagnosisMaster', 
		'ClinicalAnnotation.DiagnosisDetail',
		'ClinicalAnnotation.DiagnosisControl',
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.TreatmentMaster',
		'ClinicalAnnotation.TreatmentControl',
		'ClinicalAnnotation.EventMaster',
		'ClinicalAnnotation.EventControl',
		'CodingIcd.CodingIcd10Who',
		'CodingIcd.CodingIcd10Ca',
		'CodingIcd.CodingIcdo3Topo',//required by model
		'CodingIcd.CodingIcdo3Morpho'//required by model
	);
	var $paginate = array('DiagnosisMaster'=>array('limit' => pagination_amount,'order'=>'DiagnosisMaster.dx_date'));

	function listall( $participant_id, $parent_dx_id = null, $is_ajax = 0 ) {
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		
		$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$event_master_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$dx_data = $this->DiagnosisMaster->find('all', array(
			'conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.parent_id' => $parent_dx_id ),
			'order' => array('DiagnosisMaster.dx_date')
		));
		$tx_data = $tx_model->find('all', array(
			'conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.diagnosis_master_id' => $parent_dx_id == null ? -1 : $parent_dx_id ),
			'order' => array('TreatmentMaster.start_date')
		));
		$event_data = $event_master_model->find('all', array(
			'conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.diagnosis_master_id' => $parent_dx_id == null ? -1 : $parent_dx_id),
			'order' => array('EventMaster.event_date')
		));
		$tmp_data = array();
		foreach($dx_data as &$unit){
			$tmp_data[$unit['DiagnosisMaster']['dx_date']][] = $unit;
		}
		foreach($tx_data as &$unit){
			$tmp_data[$unit['TreatmentMaster']['start_date']][] = $unit;
		}
		foreach($event_data as &$unit){
			$tmp_data[$unit['EventMaster']['event_date']][] = $unit;
		}
		ksort($tmp_data);
		$curr_data = array();
		foreach($tmp_data as &$date_data_arr){
			foreach($date_data_arr as &$unit){
				$curr_data[] = $unit;
			}
		}
		
		$ids = array();//ids already having child
		$can_have_child = $this->DiagnosisMaster->find('all', array(
			'fields' => array('DiagnosisMaster.id'),
			'conditions' => array('DiagnosisControl.category' => array('primary', 'secondary'), 'DiagnosisMaster.participant_id' => $participant_id),
			'recursive' => 0
		));
		$can_have_child = AppController::defineArrayKey($can_have_child, 'DiagnosisMaster', 'id', true);
		$can_have_child = array_keys($can_have_child);
		foreach($curr_data as $data){
			if(array_key_exists('DiagnosisMaster', $data)){
				$ids[] = $data['DiagnosisMaster']['id'];
			}
		}

		$ids_having_child = $this->DiagnosisMaster->hasChild($ids);
		$ids_having_child = array_fill_keys($ids_having_child, null);
		foreach($curr_data as &$data){
			if(array_key_exists('DiagnosisMaster', $data)){
				$data['children'] = array_key_exists($data['DiagnosisMaster']['id'], $ids_having_child);
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.flag_active' => 1))));
		$this->set('treatment_controls_list', $this->TreatmentControl->find('all', array('conditions' => array('TreatmentControl.flag_active' => 1))));
		$this->set('event_controls_list', $this->EventControl->find('all', array('conditions' => array('EventControl.flag_active' => 1))));
		$this->set('is_ajax', $is_ajax);
		$atim_structure['DiagnosisMaster'] = $this->Structures->get('form', 'view_diagnosis'); 
		$atim_structure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters'); 
		$atim_structure['EventMaster'] = $this->Structures->get('form', 'eventmasters'); 
		$this->set('atim_structure', $atim_structure);
		$this->set('can_have_child', $can_have_child);
		
		$external_link_model = AppModel::getInstance('', 'ExternalLink', true);
		$help_url = $external_link_model->find('first', array('conditions' => array('name' => 'diagnosis_module_wiki')));
		$this->set('help_url', $help_url['ExternalLink']['link']);
		
		$this->request->data = $curr_data;
		
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
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->request->data = $dx_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->setDiagnosisMenu($dx_master_data);
		if(($dx_master_data['DiagnosisControl']['category'] == 'primary') && ($dx_master_data['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown')) {
			$this->set('primary_ctrl_to_redefine_unknown', $this->DiagnosisControl->find('all', array('conditions' => array('NOT' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisControl']['id'], 'DiagnosisControl.controls_type' => 'primary diagnosis unknown'), 'DiagnosisControl.category' => 'primary', 'DiagnosisControl.flag_active' => 1)))); 
		}
		
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
				AppController::addWarningMsg(__('the current diagnosis date is before the parent diagnosis date'));
			}
		}
		
		// available child ctrl_id for creation
		$condition_not_category = array();
		$dx_ctrls = array();
		switch($dx_master_data['DiagnosisControl']['category']) {
			case 'secondary':
				$condition_not_category[] = 'secondary';
			case 'primary':
				$condition_not_category[] = 'primary';
				$dx_ctrls = $this->DiagnosisControl->find('all', array(
					'conditions' => array('NOT' => array("DiagnosisControl.category" => $condition_not_category), 'DiagnosisControl.flag_active' => 1),
					'order' => 'DiagnosisControl.display_order')
				);
				break;
				
			default:
		}
		$links = array();
		foreach ($dx_ctrls as $dx_ctrl){
			$links[] = array(
						'order' => $dx_ctrl['DiagnosisControl']['display_order'],
						'label' => __($dx_ctrl['DiagnosisControl']['category']) . ' - ' . __($dx_ctrl['DiagnosisControl']['controls_type']),
						'link' => '/ClinicalAnnotation/DiagnosisMasters/add/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'.$dx_ctrl['DiagnosisControl']['id']
			);
		}
		AppController::buildBottomMenuOptions($links);
		$this->set('child_controls_list', $links);
		
		$can_have_child = $this->DiagnosisMaster->find('all', array(
				'fields' => array('DiagnosisMaster.id'),
				'conditions' => array('DiagnosisControl.category' => array('primary', 'secondary'), 'DiagnosisMaster.participant_id' => $participant_id),
				'recursive' => 0
		));
		$can_have_child = AppController::defineArrayKey($can_have_child, 'DiagnosisMaster', 'id', true);
		$can_have_child = array_keys($can_have_child);
		$this->set('can_have_child', $can_have_child);
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.flag_active' => 1))));
		$this->set('treatment_controls_list', $this->TreatmentControl->find('all', array('conditions' => array('TreatmentControl.flag_active' => 1))));
		$this->set('event_controls_list', $this->EventControl->find('all', array('conditions' => array('EventControl.flag_active' => 1))));
		$this->set('is_ajax', $this->request->is('ajax'));
		$this->set('diagnosis_master_id', $diagnosis_master_id);
		$this->set('is_secondary', is_numeric($dx_master_data['DiagnosisMaster']['parent_id']));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		$events_data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.diagnosis_master_id' => $diagnosis_master_id)));
		if($this->request->data['DiagnosisControl']['flag_compare_with_cap']){
			foreach($events_data as $event_data){
				EventMaster::generateDxCompatWarnings($this->request->data, $event_data);
			}
		}
		
		$this->Structures->set('empty', 'empty_structure');
	}

	function add( $participant_id, $dx_control_id, $parent_id){
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$dx_ctrl = $this->DiagnosisControl->getOrRedirect($dx_control_id);
						
		$parent_dx = null;
		if($parent_id == 0){
			if($dx_ctrl['DiagnosisControl']['category'] != 'primary'){
				//is not a primary but has no parent
				$this->flash(__('invalid control id'), 'javascript:history.back();');
			}
		}else{
			$parent_dx = $this->DiagnosisMaster->find('first', array('conditions' => array('DiagnosisMaster.id' => $parent_id, 'DiagnosisMaster.participant_id' => $participant_id)));
			if(empty($parent_dx)){
				$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );				
			}
			if(($dx_ctrl['DiagnosisControl']['category'] == 'primary') || ($dx_ctrl['DiagnosisControl']['category'] == 'secondary') &&  ($parent_dx['DiagnosisControl']['category'] == 'secondary')) {
				$this->flash(__('invalid control id'), 'javascript:history.back();');
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$atim_menu_variables = array('Participant.id'=>$participant_id, "tableId"=>$dx_control_id, 'DiagnosisMaster.parent_id' => $parent_id);
		if(!empty($parent_dx)) {
			$this->setDiagnosisMenu($parent_dx, $atim_menu_variables);
		} else {
			$this->set( 'atim_menu_variables', $atim_menu_variables);
			$this->set( 'atim_menu', $this->Menus->get('/ClinicalAnnotation/DiagnosisMasters/listall/') );
		}
		$this->set('origin', $parent_id == 0 ? 'primary' : 'secondary');
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_control_id)));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias'].",".($parent_id == 0 ? "dx_origin_primary" : "dx_origin_wo_primary"), 'atim_structure', array('model_table_assoc' => array('DiagnosisDetail' => $dx_control_data['DiagnosisControl']['detail_tablename'])));
		$this->Structures->set('empty', 'empty_structure');

		$this->set( 'dx_ctrl', $dx_ctrl);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->request->data) ) {
			$this->DiagnosisMaster->patchIcd10NullValues($this->request->data);
			$this->request->data['DiagnosisMaster']['participant_id'] = $participant_id;
			$this->request->data['DiagnosisMaster']['diagnosis_control_id'] = $dx_control_id;
			
			$this->request->data['DiagnosisMaster']['parent_id'] = $parent_id == 0 ? null : $parent_id;
			$this->request->data['DiagnosisMaster']['primary_id'] = $parent_id == 0 ? null : (empty($parent_dx['DiagnosisMaster']['primary_id'])? $parent_dx['DiagnosisMaster']['id'] : $parent_dx['DiagnosisMaster']['primary_id']);
			
			$this->DiagnosisMaster->addWritableField(array('participant_id', 'diagnosis_control_id', 'parent_id', 'primary_id'));
			$this->DiagnosisMaster->addWritableField('diagnosis_master_id', $dx_control_data['DiagnosisControl']['detail_tablename']);
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {				
				if ( $this->DiagnosisMaster->save( $this->request->data )) {
					$diagnosis_master_id = $this->DiagnosisMaster->getLastInsertId();
				
					if($parent_id == 0){
						// Set primary_id of a Primary
						$query_to_update = "UPDATE diagnosis_masters SET diagnosis_masters.primary_id = diagnosis_masters.id WHERE diagnosis_masters.id = $diagnosis_master_id;";
						$this->DiagnosisMaster->tryCatchQuery($query_to_update);
						$this->DiagnosisMaster->tryCatchQuery(str_replace("diagnosis_masters", "diagnosis_masters_revs", $query_to_update));
					}
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					$this->atimFlash(__('your data has been saved'), '/ClinicalAnnotation/DiagnosisMasters/detail/'.$participant_id.'/'.$diagnosis_master_id.'/' );
				}
			}
		}
	}
	
	function edit( $participant_id, $diagnosis_master_id, $redefined_primary_control_id = null ) {
		
		// MANAGE DATA
		
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		if(!is_null($redefined_primary_control_id)) {
			
			// UNKNOWN PRIMARY REDEFINITION
			// User expected to change an unknown primary to a specific diagnosis
			
			$new_primary_ctrl = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $redefined_primary_control_id)));
			if(empty($new_primary_ctrl) 
			|| ($dx_master_data['DiagnosisControl']['category'] != 'primary')
			|| ($dx_master_data['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown')
			|| ($new_primary_ctrl['DiagnosisControl']['category'] != 'primary')
			|| ($new_primary_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown')) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			
			if($dx_master_data['DiagnosisControl']['detail_tablename'] != $new_primary_ctrl['DiagnosisControl']['detail_tablename']) {
				$this->DiagnosisMaster->tryCatchQuery("INSERT INTO ".$new_primary_ctrl['DiagnosisControl']['detail_tablename']." (`diagnosis_master_id`) VALUES ($diagnosis_master_id);");
			}
			$this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET diagnosis_control_id = $redefined_primary_control_id, deleted = 0 WHERE id = $diagnosis_master_id;");
			//Save empty data to add row in revs table
			$this->DiagnosisMaster->data = array();
			$this->DiagnosisMaster->id = $diagnosis_master_id;
			if(!$this->DiagnosisMaster->save(array())) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); ;
				
			$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
			if(empty($dx_master_data)){
				$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		
			$this->addWarningMsg(__('unknown primary has been redefined. complete primary data.'));
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->setDiagnosisMenu($dx_master_data);
		
		$this->Structures->set($dx_master_data['DiagnosisControl']['form_alias']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($this->request->data)) {
			$this->request->data = $dx_master_data;
		} else {
			$this->DiagnosisMaster->patchIcd10NullValues($this->request->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				$this->DiagnosisMaster->id = $diagnosis_master_id;
				if ( $this->DiagnosisMaster->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been updated'),'/ClinicalAnnotation/DiagnosisMasters/detail/'.$participant_id.'/'.$diagnosis_master_id );
				}
			}
		}
	}

	function delete( $participant_id, $diagnosis_master_id ) {
		// MANAGE DATA
		$diagnosis_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if (empty($diagnosis_master_data)) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$arr_allow_deletion = $this->DiagnosisMaster->allowDeletion($diagnosis_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->DiagnosisMaster->atimDelete( $diagnosis_master_id ) ) {
				$this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/DiagnosisMasters/listall/'.$participant_id );
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/ClinicalAnnotation/DiagnosisMasters/listall/'.$participant_id );
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/ClinicalAnnotation/DiagnosisMasters/detail/'.$participant_id.'/'.$diagnosis_master_id);
		}		
	}
	
	function setDiagnosisMenu($dx_master_data, $additional_menu_variables = array()) {
		if(!isset($dx_master_data['DiagnosisMaster']['id'])){
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		$primary_id = null;
		$progression_1_id = null;
		$progression_2_id = null;
		if($dx_master_data['DiagnosisMaster']['primary_id'] == $dx_master_data['DiagnosisMaster']['id']) {
			//Primary Display
			$primary_id = $dx_master_data['DiagnosisMaster']['id'];
			$menu_link = '/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.primary_id%%';
			
		} else if($dx_master_data['DiagnosisMaster']['primary_id'] == $dx_master_data['DiagnosisMaster']['parent_id']) {
			// Secondary or primary progression display
			$primary_id = $dx_master_data['DiagnosisMaster']['primary_id'];
			$progression_1_id = $dx_master_data['DiagnosisMaster']['id'];
			$menu_link = '/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_1_id%%'	;
			
		} else {
			// Secondary progression display
			$primary_id = $dx_master_data['DiagnosisMaster']['primary_id'];
			$progression_1_id = $dx_master_data['DiagnosisMaster']['parent_id'];
			$progression_2_id = $dx_master_data['DiagnosisMaster']['id'];
			$menu_link = '/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_2_id%%'	;
		}
		
		$this->set( 'atim_menu', $this->Menus->get($menu_link));
		$this->set( 'atim_menu_variables', array_merge(
			array('Participant.id'=>$dx_master_data['DiagnosisMaster']['participant_id'], 
				'DiagnosisMaster.id'=>$dx_master_data['DiagnosisMaster']['id'], 
				
				'DiagnosisMaster.primary_id'=>$primary_id,
				'DiagnosisMaster.progression_1_id'=>$progression_1_id,
				'DiagnosisMaster.progression_2_id'=>$progression_2_id),
			$additional_menu_variables)
		);
	}
}

?>