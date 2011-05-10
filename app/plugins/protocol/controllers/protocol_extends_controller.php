<?php

class ProtocolExtendsController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolExtend',
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl');
		
	var $paginate = array('ProtocolExtend'=>array('limit' => pagination_amount,'order'=>'ProtocolExtend.id DESC'));

	function listall($protocol_master_id){
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}
				
		$this->ProtocolExtend = AppModel::atimInstantiateExtend($this->ProtocolExtend, $protocol_master_data['ProtocolControl']['extend_tablename']);
		$this->data = $this->paginate($this->ProtocolExtend, array('ProtocolExtend.protocol_master_id'=>$protocol_master_id));

		$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
		if($is_used['is_used']){
			AppController::addWarningMsg(__('warning', true).": ".__($is_used['msg'], true));
		}
			
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias']);
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
	}

	function detail($protocol_master_id, $protocol_extend_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_id)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}
		
		// Set tablename to use
		$this->ProtocolExtend = AppModel::atimInstantiateExtend($this->ProtocolExtend, $protocol_master_data['ProtocolControl']['extend_tablename']);
		
		// Get extend data
		$prot_extend_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id,'ProtocolExtend.protocol_master_id'=>$protocol_master_id)));
		if(empty($prot_extend_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		$this->data = $prot_extend_data;
	  	
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id, 'ProtocolExtend.id'=>$protocol_extend_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}

		// Set tablename to use
		$this->ProtocolExtend = AppModel::atimInstantiateExtend($this->ProtocolExtend, $protocol_master_data['ProtocolControl']['extend_tablename']);
		
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if ( !empty($this->data) ) {
			$this->data['ProtocolExtend']['protocol_master_id'] = $protocol_master_id;
				
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
				
			if ($submitted_data_validates && $this->ProtocolExtend->save( $this->data ) ) {
				$this->atimFlash( 'your data has been saved', '/protocol/protocol_extends/listall/'.$protocol_master_id );
			}
		}
	}

	function edit($protocol_master_id, $protocol_extend_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_id)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}

		// Set form alias/tablename to use
		$this->ProtocolExtend = AppModel::atimInstantiateExtend($this->ProtocolExtend, $protocol_master_data['ProtocolControl']['extend_tablename']);
		
		// Get extend data
		$prot_extend_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id,'ProtocolExtend.protocol_master_id'=>$protocol_master_id)));
		if(empty($prot_extend_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias']);
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id,'ProtocolExtend.id'=>$protocol_extend_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if (empty($this->data)) {
			$this->data = $prot_extend_data;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			$this->ProtocolExtend->id = $protocol_extend_id;
			if ($submitted_data_validates && $this->ProtocolExtend->save($this->data)) {
				$this->atimFlash( 'your data has been updated','/protocol/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id);
			}
		}
	}

	function delete($protocol_master_id, $protocol_extend_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_id)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}
		
		// Set extend data
		$this->ProtocolExtend = AppModel::atimInstantiateExtend($this->ProtocolExtend, $protocol_master_data['ProtocolControl']['extend_tablename']);
		$prot_extend_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id,'ProtocolExtend.protocol_master_id'=>$protocol_master_id)));
		if(empty($prot_extend_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		$arr_allow_deletion = $this->ProtocolExtend->allowDeletion($protocol_extend_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->ProtocolExtend->atim_delete( $protocol_extend_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/protocol/protocol_extends/listall/'.$protocol_master_id);
			} else {
				$this->flash( 'error deleting data - contact administrator', '/protocol/protocol_extends/listall/'.$protocol_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/protocol/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id);
		}
		
	}
}

?>