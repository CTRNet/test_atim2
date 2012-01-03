<?php

class ProtocolMastersController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolControl', 
		'Protocol.ProtocolMaster');
		
	var $paginate = array('ProtocolMaster'=>array('limit' => pagination_amount,'order'=>'ProtocolMaster.code DESC'));
	
	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get("/protocol/protocol_masters/search/"));
		$this->searchHandler($search_id, $this->ProtocolMaster, 'protocolmasters', '/protocol/protocol_masters/search');
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
			$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}
		
		$this->set( 'atim_menu_variables', array('ProtocolControl.id'=>$protocol_control_id)); 
		$this->set('atim_menu', $this->Menus->get("/protocol/protocol_masters/search/"));
		$this->Structures->set($protocol_control_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->data) ) {
			$this->data = array();
			$this->data['ProtocolControl']['tumour_group'] = $protocol_control_data['ProtocolControl']['tumour_group'];
			$this->data['ProtocolControl']['type'] = $protocol_control_data['ProtocolControl']['type'];
			
		} else {
			
			$this->data['ProtocolMaster']['protocol_control_id'] = $protocol_control_id;
			$this->data['ProtocolMaster']['type'] = $protocol_control_data['ProtocolControl']['type'];
			$this->data['ProtocolMaster']['tumour_group'] = $protocol_control_data['ProtocolControl']['tumour_group'];

			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->data) ){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/protocol/protocol_masters/detail/'.$this->ProtocolMaster->getLastInsertId());
			}
		} 
	}
	
	function detail($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		$this->data = $protocol_data;
			
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		$this->Structures->set($protocol_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function edit( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }			
		
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id) );
		$this->Structures->set($protocol_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->data) ) {
			$this->data = $protocol_data;
			$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
			if($is_used['is_used']){
				AppController::addWarningMsg(__('warning', true).": ".__($is_used['msg'], true));
			}
			$submitted_data_validates = false;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			$this->ProtocolMaster->id = $protocol_master_id;
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash( 'your data has been updated','/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
			}
		}		
	}
	
	function delete( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
			
		$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
				
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($is_used['is_used']) {
			$this->flash($is_used['msg'], '/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
		} else {
			if( $this->ProtocolMaster->atim_delete( $protocol_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/protocol/protocol_masters/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/protocol/protocol_masters/index/');
			}
		}
	}
}

?>