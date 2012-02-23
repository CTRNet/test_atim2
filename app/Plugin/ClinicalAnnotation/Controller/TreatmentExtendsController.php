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
	
	function detail($participant_id, $tx_master_id, $tx_extend_id) {
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
		$this->request->data = $tx_extend_data;
		
		// Set form alias and alias
		$this->Structures->set($tx_master_data['TreatmentControl']['extend_form_alias'] );
	    $this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }			
	}

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
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->request->data) ) {
			$this->request->data['TreatmentExtend']['treatment_master_id'] = $tx_master_id;
			echo $this->TreatmentExtend->addWritableField('treatment_master_id');
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if ($submitted_data_validates && $this->TreatmentExtend->save( $this->request->data ) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been saved', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id );
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
			
			$this->TreatmentExtend->id = $tx_extend_id;
			if ($submitted_data_validates && $this->TreatmentExtend->save($this->request->data)) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/TreatmentExtends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
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
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id);
			} else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id);
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/TreatmentExtends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
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
				$this->flash( 'there is no drug defined in the associated protocol', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id);
			}else{
				foreach($prot_extend_data as $prot_extend){
					$data[]['TreatmentExtend'] = array(
						'treatment_master_id' => $tx_master_id,
						'drug_id' => $prot_extend['ProtocolExtend']['drug_id'],
						'method' => $prot_extend['ProtocolExtend']['method'],
						'dose' => $prot_extend['ProtocolExtend']['dose']);
				}
				if($this->TreatmentExtend->saveAll($data)){
					$this->atimFlash( 'drugs from the associated protocol were imported', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id);
				}else{
					$this->flash( 'unknown error', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}else{
			$this->flash( 'there is no protocol associated with this treatment', '/ClinicalAnnotation/TreatmentExtends/listall/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>