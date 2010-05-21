<?php

class TreatmentExtendsController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.TreatmentExtend',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.TreatmentControl',
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl',
		'Protocol.ProtocolExtend',
		'Drug.Drug');
		
	var $paginate = array('TreatmentExtend'=>array('limit' => pagination_amount,'order'=>'TreatmentExtend.id ASC'));
	
	function listall($participant_id, $tx_master_id) {
		if (( !$participant_id ) && ( !$tx_master_id )) { 
			$this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); 
		}
				
		// Get treatment Master data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		
		if(empty($tx_master_data)) {
			$this->redirect( '/pages/err_clin_no_data', null, true ); 
		}else if($tx_master_data['TreatmentControl']['allow_administration'] == 0){
			$this->flash( 'no additional data has to be defined for this type of treatment', '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
		}	

		// Set Extend tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		
		// List trt extends
		$this->data = $this->paginate($this->TreatmentExtend, array('TreatmentExtend.tx_master_id'=>$tx_master_id));
		
		$this->set('drug_list', $this->Drug->getDrugListForTx($tx_master_data['TreatmentMaster']['tx_method']));
		
		// Set forms and menu data
		$this->Structures->set( $tx_master_data['TreatmentControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}	
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
		
		$this->set('drug_list', $this->Drug->getDrugListForTx($tx_master_data['TreatmentMaster']['tx_method']));
	    
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
		
		$this->set('drug_list', $this->Drug->getDrugListForTx($tx_master_data['TreatmentMaster']['tx_method']));
		
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
		
		$this->set('drug_list', $this->Drug->getDrugListForTx($tx_master_data['TreatmentMaster']['tx_method']));
	    
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
	
	function importFromProtocol($participant_id, $tx_master_id){
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(is_numeric($tx_master_data['TreatmentMaster']['protocol_master_id'])){
			$prot_master_data = $this->ProtocolMaster->find('first', array('conditions' => array('ProtocolMaster.id' => $tx_master_data['TreatmentMaster']['protocol_master_id'])));
			
			//init proto extend
			$this->ProtocolExtend = new ProtocolExtend(false, $prot_master_data['ProtocolControl']['extend_tablename']);
			$prot_extend_data = $this->ProtocolExtend->find('all', array('conditions'=>array('ProtocolExtend.protocol_master_id' => $tx_master_data['TreatmentMaster']['protocol_master_id'])));
			$drugs_id = array();
			
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
			$data = array();
			if(empty($prot_extend_data)){
				$this->flash( 'there is no drug defined in the associated protocol', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id);
			}else{
				foreach($prot_extend_data as $prot_extend){
					$data[]['TreatmentExtend'] = array(
						'tx_master_id' => $tx_master_id,
						'drug_id' => $prot_extend['ProtocolExtend']['drug_id'],
						'method' => $prot_extend['ProtocolExtend']['method'],
						'dose' => $prot_extend['ProtocolExtend']['dose']);
				}
				if($this->TreatmentExtend->saveAll($data)){
					$this->flash( 'drugs from the associated protocol were imported', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id);
				}else{
					$this->flash( 'unknown error', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}else{
			$this->flash( 'there is no protocol associated with this treatment', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>