<?php

class ProtocolExtendMastersController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolExtendMaster',
		'Protocol.ProtocolExtendControl',
			
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl');
		
	var $paginate = array();

	function listall($protocol_master_id){
		$protocol_master_data = $this->ProtocolMaster->getOrRedirect($protocol_master_id);
		if(!$protocol_master_data['ProtocolControl']['protocol_extend_control_id']){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			return;
		}
		
		$protocol_extend_control_data = $this->ProtocolExtendControl->getOrRedirect($protocol_master_data['ProtocolControl']['protocol_extend_control_id']);
		$this->request->data = $this->paginate($this->ProtocolExtendMaster, array('ProtocolExtendMaster.protocol_master_id'=>$protocol_master_id, 'ProtocolExtendMaster.protocol_extend_control_id'=>$protocol_master_data['ProtocolControl']['protocol_extend_control_id']));
		
		$this->Structures->set($protocol_extend_control_data['ProtocolExtendControl']['detail_form_alias']);
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
	}

	function detail($protocol_master_id, $protocol_extend_master_id) {
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->getOrRedirect($protocol_master_id);
		if(!$protocol_master_data['ProtocolControl']['protocol_extend_control_id']){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			return;
		}
		
		$condtions = array('ProtocolExtendMaster.id' => $protocol_extend_master_id, 'ProtocolExtendMaster.protocol_master_id' => $protocol_master_id);
		$this->request->data = $this->ProtocolExtendMaster->find('first', array('conditions' => $condtions));
		if(empty($this->request->data)) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$this->Structures->set($this->request->data['ProtocolExtendControl']['detail_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id, 'ProtocolExtendMaster.id'=>$protocol_extend_master_id));
		$this->set( 'atim_menu', $this->Menus->get('/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%') );

		$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
		if($is_used['is_used']){
			AppController::addWarningMsg(__('warning').": ".__($is_used['msg']));
		}
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->getOrRedirect($protocol_master_id);
		if(!$protocol_master_data['ProtocolControl']['protocol_extend_control_id']){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			return;
		}

		// Set tablename to use
		$protocol_extend_control_data = $this->ProtocolExtendControl->getOrRedirect($protocol_master_data['ProtocolControl']['protocol_extend_control_id']);
		
		$this->Structures->set($protocol_extend_control_data['ProtocolExtendControl']['detail_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		$this->set( 'atim_menu', $this->Menus->get('/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%') );

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if ( !empty($this->request->data) ) {			
			$this->request->data['ProtocolExtendMaster']['protocol_master_id'] = $protocol_master_id;
			$this->request->data['ProtocolExtendMaster']['protocol_extend_control_id'] = $protocol_master_data['ProtocolControl']['protocol_extend_control_id'];
			$this->ProtocolExtendMaster->addWritableField(array('protocol_master_id', 'protocol_extend_control_id'));
				
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
				
			if ($submitted_data_validates && $this->ProtocolExtendMaster->save( $this->request->data ) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been saved', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id );
			}
		}
	}

	function edit($protocol_master_id, $protocol_extend_master_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_master_id)) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->getOrRedirect($protocol_master_id);
		if(!$protocol_master_data['ProtocolControl']['protocol_extend_control_id']){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			return;
		}

		$condtions = array('ProtocolExtendMaster.id' => $protocol_extend_master_id, 'ProtocolExtendMaster.protocol_master_id' => $protocol_master_id);
		$prot_extend_data = $this->ProtocolExtendMaster->find('first', array('conditions' => $condtions));
		if(empty($prot_extend_data)) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$this->Structures->set($prot_extend_data['ProtocolExtendControl']['detail_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id, 'ProtocolExtendMaster.id'=>$protocol_extend_master_id));
		$this->set( 'atim_menu', $this->Menus->get('/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%') );
		
		$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
		if($is_used['is_used']){
			AppController::addWarningMsg(__('warning').": ".__($is_used['msg']));
		}
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if (empty($this->request->data)) {
			$this->request->data = $prot_extend_data;
			
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			$this->ProtocolExtendMaster->id = $protocol_extend_master_id;
			if ($submitted_data_validates && $this->ProtocolExtendMaster->save($this->request->data)) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/Protocol/ProtocolExtendMasters/detail/'.$protocol_master_id.'/'.$protocol_extend_master_id);
			}
		}
	}

	function delete($protocol_master_id, $protocol_extend_master_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_master_id)) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->getOrRedirect($protocol_master_id);
		if(!$protocol_master_data['ProtocolControl']['protocol_extend_control_id']){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			return;
		}
		
		// Set extend data
		$condtions = array('ProtocolExtendMaster.id' => $protocol_extend_master_id, 'ProtocolExtendMaster.protocol_master_id' => $protocol_master_id);
		$prot_extend_data = $this->ProtocolExtendMaster->find('first', array('conditions' => $condtions));
		if(empty($prot_extend_data)) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$arr_allow_deletion = $this->ProtocolExtendMaster->allowDeletion($protocol_extend_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->ProtocolExtendMaster->atimDelete( $protocol_extend_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			} else {
				$this->flash( 'error deleting data - contact administrator', '/Protocol/ProtocolMasters/detail/'.$protocol_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/Protocol/ProtocolExtendMaster/detail/'.$protocol_master_id.'/'.$protocol_extend_master_id);
		}
		
	}
}

?>