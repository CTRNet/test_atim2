<?php

class ProtocolMastersController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolControl', 
		'Protocol.ProtocolMaster');
		
	var $paginate = array('ProtocolMaster'=>array('limit' => pagination_amount,'order'=>'ProtocolMaster.code DESC'));
	
	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get("/Protocol/ProtocolMasters/search/"));
		$this->searchHandler($search_id, $this->ProtocolMaster, 'protocolmasters', '/Protocol/ProtocolMasters/search');
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}
	
	function add($protocol_control_id) {
		$protocol_control_data = $this->ProtocolControl->find('first',array('conditions'=>array('ProtocolControl.id'=>$protocol_control_id)));
		if (empty($protocol_control_data) ) { 
			$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}
		
		$this->set( 'atim_menu_variables', array('ProtocolControl.id'=>$protocol_control_id)); 
		$this->set('atim_menu', $this->Menus->get("/Protocol/ProtocolMasters/search/"));
		$this->Structures->set($protocol_control_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->request->data) ) {
			$this->request->data = array();
			$this->request->data['ProtocolControl']['tumour_group'] = $protocol_control_data['ProtocolControl']['tumour_group'];
			$this->request->data['ProtocolControl']['type'] = $protocol_control_data['ProtocolControl']['type'];
			
		} else {
			
			$this->request->data['ProtocolMaster']['protocol_control_id'] = $protocol_control_id;
			$this->request->data['ProtocolMaster']['type'] = $protocol_control_data['ProtocolControl']['type'];
			$this->request->data['ProtocolMaster']['tumour_group'] = $protocol_control_data['ProtocolControl']['tumour_group'];

			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->request->data) ){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/Protocol/ProtocolMasters/detail/'.$this->ProtocolMaster->getLastInsertId());
			}
		} 
	}
	
	function detail($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		$this->request->data = $protocol_data;
			
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		$this->Structures->set($protocol_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function edit( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }			
		
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id) );
		$this->Structures->set($protocol_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->request->data) ) {
			$this->request->data = $protocol_data;
			$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
			if($is_used['is_used']){
				AppController::addWarningMsg(__('warning').": ".__($is_used['msg']));
			}
			$submitted_data_validates = false;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			$this->ProtocolMaster->id = $protocol_master_id;
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash( 'your data has been updated','/Protocol/ProtocolMasters/detail/'.$protocol_master_id.'/');
			}
		}		
	}
	
	function delete( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
			
		$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
				
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($is_used['is_used']) {
			$this->flash($is_used['msg'], '/Protocol/ProtocolMasters/detail/'.$protocol_master_id.'/');
		} else {
			if( $this->ProtocolMaster->atim_delete( $protocol_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/Protocol/ProtocolMasters/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/Protocol/ProtocolMasters/index/');
			}
		}
	}
}

?>