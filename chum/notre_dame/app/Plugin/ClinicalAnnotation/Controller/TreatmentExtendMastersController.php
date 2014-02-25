<?php

class TreatmentExtendMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.TreatmentExtendMaster',
		'ClinicalAnnotation.TreatmentExtendControl',
		'ClinicalAnnotation.TreatmentMaster',
		'ClinicalAnnotation.TreatmentControl',
		
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl',
		'Protocol.ProtocolExtendMaster');
		
	var $paginate = array();

	function add($participant_id, $tx_master_id) {
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->getOrRedirect($tx_master_id);
		if($tx_master_data['TreatmentMaster']['participant_id'] != $participant_id) $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		if(!$tx_master_data['TreatmentControl']['treatment_extend_control_id']){
			$this->flash(__('no additional data has to be defined for this type of treatment'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			return;
		}
		
		$tx_extend_control_data = $this->TreatmentExtendControl->getOrRedirect($tx_master_data['TreatmentControl']['treatment_extend_control_id']);
	
		// Set form alias and menu
		$this->Structures->set($tx_extend_control_data['TreatmentExtendControl']['form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/detail/%%Participant.id%%/%%TreatmentMaster.id%%'));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( empty($this->request->data) ) {
			$this->request->data[] = array();
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			
			$errors = array();
			$line_counter = 0;
			foreach($this->request->data as &$new_row) {
				$line_counter++;
				$new_row['TreatmentExtendMaster']['treatment_extend_control_id'] = $tx_master_data['TreatmentControl']['treatment_extend_control_id'];
				$new_row['TreatmentExtendMaster']['treatment_master_id'] = $tx_master_id;
				$this->TreatmentExtendMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$this->TreatmentExtendMaster->set($new_row);
				if(!$this->TreatmentExtendMaster->validates()){
					foreach($this->TreatmentExtendMaster->validationErrors as $field => $msgs) {	
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][] = $line_counter;
						$submitted_data_validates = false;
					}
				}
				$new_row = $this->TreatmentExtendMaster->data;
			}
			
			echo $this->TreatmentExtendMaster->addWritableField(array('treatment_master_id', 'treatment_extend_control_id'));
			$this->TreatmentExtendMaster->writable_fields_mode = 'addgrid';
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if(empty($errors)) {
				AppModel::acquireBatchViewsUpdateLock();
				
				foreach($this->request->data as $new_data) {
					$this->TreatmentExtendMaster->id = null;
					$this->TreatmentExtendMaster->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					if(!$this->TreatmentExtendMaster->save( $new_data , false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				AppModel::releaseBatchViewsUpdateLock();
				
				$this->atimFlash(__('your data has been saved'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id );

			} else  {
				$this->TreatmentExtendMaster->validationErrors = array();
				$this->TreatmentExtendDetail->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg);
						$lines_strg = implode(",", array_unique($lines));
						if(!empty($lines_strg)) {
							$msg .= ' - ' . str_replace('%s', $lines_strg, __('see line %s'));
						}
						$this->TreatmentExtendMaster->validationErrors[$field][] = $msg;
					}
				}		
			}
		} 
	}

	function edit($participant_id, $tx_master_id, $tx_extend_id) {
		// Get treatment extend data
		$tx_extend_data = $this->TreatmentExtendMaster->getOrRedirect($tx_extend_id);
		if($tx_extend_data['TreatmentMaster']['id'] != $tx_master_id) $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		
		// Set form alias and menu data
		$this->Structures->set($tx_extend_data['TreatmentExtendControl']['form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id, 'TreatmentExtendMaster.id'=>$tx_extend_id));
		
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/detail/%%Participant.id%%/%%TreatmentMaster.id%%'));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->request->data)) {
			$this->request->data = $tx_extend_data;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			//To allow particiant Last Modification update
			$this->request->data['TreatmentExtendMaster']['treatment_master_id'] = $tx_master_id;
			$this->TreatmentExtendMaster->addWritableField('treatment_master_id');
			$this->TreatmentExtendMaster->writable_fields_mode = 'addgrid';
			
			$this->TreatmentExtendMaster->id = $tx_extend_id;
			if ($submitted_data_validates && $this->TreatmentExtendMaster->save($this->request->data)) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			}
		}
	}

	function delete($participant_id, $tx_master_id, $tx_extend_id) {
		// Get treatment extend data
		$tx_extend_data = $this->TreatmentExtendMaster->getOrRedirect($tx_extend_id);
		if($tx_extend_data['TreatmentMaster']['id'] != $tx_master_id) $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		
		$arr_allow_deletion = $this->TreatmentExtendMaster->allowDeletion($tx_extend_id);
			
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		if($arr_allow_deletion['allow_deletion']) {		
			if( $this->TreatmentExtendMaster->atimDelete( $tx_extend_id ) ) {
				$this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			}	
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
	
	function importDrugFromChemoProtocol($participant_id, $tx_master_id){
		$tx_master_data = $this->TreatmentMaster->getOrRedirect($tx_master_id);
		if($tx_master_data['TreatmentMaster']['participant_id'] != $participant_id) $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		
		if(is_numeric($tx_master_data['TreatmentMaster']['protocol_master_id'])){
			$protcol_data = $this->ProtocolMaster->getOrRedirect($tx_master_data['TreatmentMaster']['protocol_master_id']);
			$prot_extend_data = $this->ProtocolExtendMaster->find('all', array('conditions'=>array('ProtocolExtendMaster.protocol_master_id' => $tx_master_data['TreatmentMaster']['protocol_master_id'])));
			$data = array();
			if(empty($prot_extend_data)){
				$this->flash(__('there is no drug defined in the associated protocol'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			}else{
				foreach($prot_extend_data as $prot_extend){
					$data[] = array(
						'TreatmentExtendMaster' => array(
							'treatment_master_id' => $tx_master_id,
							'treatment_extend_control_id' => $tx_master_data['TreatmentControl']['treatment_extend_control_id']),
						'TreatmentExtendDetail' => array(
							'drug_id' => $prot_extend['ProtocolExtendDetail']['drug_id'],
							'method' => $prot_extend['ProtocolExtendDetail']['method'],
							'dose' => $prot_extend['ProtocolExtendDetail']['dose'])
					);
				}
				$this->TreatmentExtendMaster->check_writable_fields = false;
				if($this->TreatmentExtendMaster->saveAll($data)){
					$this->atimFlash(__('drugs from the associated protocol were imported'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
				}else{
					$this->flash(__('unknown error'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}else{
			$this->flash(__('there is no protocol associated with this treatment'), '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>