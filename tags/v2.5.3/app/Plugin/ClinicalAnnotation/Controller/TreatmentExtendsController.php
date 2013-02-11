<?php

class TreatmentExtendsController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.TreatmentExtend',
		'ClinicalAnnotation.TreatmentMaster',
		'ClinicalAnnotation.TreatmentControl',
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl',
		'Protocol.ProtocolExtend');
		
	var $paginate = array('TreatmentExtend'=>array('limit' => pagination_amount,'order'=>'TreatmentExtend.id ASC'));

	function add($participant_id, $tx_master_id) {
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}else if(empty($tx_master_data['TreatmentControl']['extend_tablename']) || empty($tx_master_data['TreatmentControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of treatment', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			return;
		}	
		
		// Set Extend tablename to use
		$this->TreatmentExtend = AppModel::atimInstantiateExtend($this->TreatmentExtend, $tx_master_data['TreatmentControl']['extend_tablename']);
		
		// Set form alias and menu
		$this->Structures->set($tx_master_data['TreatmentControl']['extend_form_alias'] );
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
			foreach($this->request->data as $key => $new_row) {
				$line_counter++;
				$this->TreatmentExtend->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$this->TreatmentExtend->set($new_row);
				if(!$this->TreatmentExtend->validates()){
					foreach($this->TreatmentExtend->validationErrors as $field => $msgs) {	
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][] = $line_counter;
						$submitted_data_validates = false;
					}
				}				
			}
			
			echo $this->TreatmentExtend->addWritableField('treatment_master_id');
			$this->TreatmentExtend->writable_fields_mode = 'addgrid';
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if(empty($errors)) {
				foreach($this->request->data as $new_data) {
					$new_data['TreatmentExtend']['treatment_master_id'] = $tx_master_id;				
					$this->TreatmentExtend->id = null;
					$this->TreatmentExtend->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
					if(!$this->TreatmentExtend->save( $new_data , false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				$this->atimFlash( 'your data has been saved', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id );

			} else  {
				$this->TreatmentExtend->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg);
						$lines_strg = implode(",", array_unique($lines));
						if(!empty($lines_strg)) {
							$msg .= ' - ' . str_replace('%s', $lines_strg, __('see line %s'));
						}
						$this->TreatmentExtend->validationErrors[$field][] = $msg;
					}
				}	
				
				
			}
		} 
	}

	function edit($participant_id, $tx_master_id, $tx_extend_id) {
				
		// Get treatment data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}else if(empty($tx_master_data['TreatmentControl']['extend_tablename']) || empty($tx_master_data['TreatmentControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of treatment', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			return;
		}	
		
		// Set Extend tablename to use
		$this->TreatmentExtend = AppModel::atimInstantiateExtend($this->TreatmentExtend, $tx_master_data['TreatmentControl']['extend_tablename']);
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.treatment_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}			
		
		// Set form alias and menu data
		$this->Structures->set($tx_master_data['TreatmentControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id, 'TreatmentExtend.id'=>$tx_extend_id));
		
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
			$this->request->data['TreatmentExtend']['treatment_master_id'] = $tx_master_id;
			$this->TreatmentExtend->addWritableField('treatment_master_id');
			$this->TreatmentExtend->writable_fields_mode = 'addgrid';
			
			$this->TreatmentExtend->id = $tx_extend_id;
			if ($submitted_data_validates && $this->TreatmentExtend->save($this->request->data)) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			}
		}
	}

	function delete($participant_id, $tx_master_id, $tx_extend_id) {
		// Get treatment data
		
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($tx_master_data)) {
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}else if(empty($tx_master_data['TreatmentControl']['extend_tablename']) || empty($tx_master_data['TreatmentControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of treatment', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			return;
		}	
		
		// Set Extend tablename to use
		$this->TreatmentExtend = AppModel::atimInstantiateExtend($this->TreatmentExtend, $tx_master_data['TreatmentControl']['extend_tablename']);
		
		// Get extend data
		$tx_extend_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id, 'TreatmentExtend.treatment_master_id'=>$tx_master_id)));
		if(empty($tx_extend_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}			
		
		$arr_allow_deletion = $this->TreatmentExtend->allowDeletion($tx_extend_id);
			
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		if($arr_allow_deletion['allow_deletion']) {		
			if( $this->TreatmentExtend->atimDelete( $tx_extend_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			} else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
	
	function importDrugFromChemoProtocol($participant_id, $tx_master_id){
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(is_numeric($tx_master_data['TreatmentMaster']['protocol_master_id'])){
			$prot_master_data = $this->ProtocolMaster->find('first', array('conditions' => array('ProtocolMaster.id' => $tx_master_data['TreatmentMaster']['protocol_master_id'])));
			
			//init proto extend
			$this->ProtocolExtend = AppModel::atimInstantiateExtend($this->ProtocolExtend, $prot_master_data['ProtocolControl']['extend_tablename']);
			$prot_extend_data = $this->ProtocolExtend->find('all', array('conditions'=>array('ProtocolExtend.protocol_master_id' => $tx_master_data['TreatmentMaster']['protocol_master_id'])));
			$drugs_id = array();
			
			$this->TreatmentExtend = AppModel::atimInstantiateExtend($this->TreatmentExtend, $tx_master_data['TreatmentControl']['extend_tablename']);
			$data = array();
			if(empty($prot_extend_data)){
				$this->flash( 'there is no drug defined in the associated protocol', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
			}else{
				foreach($prot_extend_data as $prot_extend){
					$data[]['TreatmentExtend'] = array(
						'treatment_master_id' => $tx_master_id,
						'drug_id' => $prot_extend['ProtocolExtend']['drug_id'],
						'method' => $prot_extend['ProtocolExtend']['method'],
						'dose' => $prot_extend['ProtocolExtend']['dose']);
				}
				$this->TreatmentExtend->check_writable_fields = false;
				if($this->TreatmentExtend->saveAll($data)){
					$this->atimFlash( 'drugs from the associated protocol were imported', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
				}else{
					$this->flash( 'unknown error', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}else{
			$this->flash( 'there is no protocol associated with this treatment', '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>