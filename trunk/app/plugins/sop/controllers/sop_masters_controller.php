<?php

class SopMastersController extends SopAppController {

	var $uses = array('Sop.SopControl', 'Sop.SopMaster');
	var $paginate = array('SopMaster'=>array('limit' => pagination_amount,'order'=>'SopMaster.title DESC'));
	
	function listall() {
		$this->hook();
		
		$this->data = $this->paginate($this->SopMaster, array());
		
		// find all EVENTCONTROLS, for ADD form
		$this->set( 'sop_controls', $this->SopControl->find('all', array()) );
	}

	
	function add($sop_control_id=null) {
		
		$this->set( 'atim_menu_variables', array('SopControl.id'=>$sop_control_id)); 
		$this_data = $this->SopControl->find('first',array('conditions'=>array('SopControl.id'=>$sop_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set($this_data['SopControl']['form_alias']);
		
		$atim_menu = $this->Menus->get('/sop/sop_masters/listall/');		
		$this->set('atim_menu', $atim_menu);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->data) ) {
			
			$this->data['SopMaster']['sop_control_id'] = $sop_control_id;
			$this->data['SopMaster']['type'] = $this_data['SopControl']['type'];
			$this->data['SopMaster']['sop_group'] = $this_data['SopControl']['sop_group'];
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
						
			if($submitted_data_validates) {
				if ( $this->SopMaster->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/sop/sop_masters/detail/'.$this->SopMaster->getLastInsertId());
				}
			}
		} 
	}
	
	function detail($sop_master_id) {
		if ( !$sop_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('SopMaster.id'=>$sop_master_id));
		
		$this->data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->data['SopControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}

	function edit( $sop_master_id  ) {
		if ( !$sop_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('SopMaster.id'=>$sop_master_id) );
		$this_data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this_data['SopControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		if ( !empty($this->data) ) {
			
			$this->SopMaster->id = $sop_master_id;
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
						
			if($submitted_data_validates) {
				if ( $this->SopMaster->save($this->data) ) $this->atimFlash( 'your data has been updated','/sop/sop_masters/detail/'.$sop_master_id.'/');
			}
		}
	}
	
	function delete( $sop_master_id ) {
		if ( !$sop_master_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->SopMaster->allowDeletion($sop_master_id);

		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {
			if( $this->SopMaster->atim_delete( $sop_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/sop/sop_masters/listall/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/sop/sop_masters/listall/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/sop/sop_masters/detail/'.$sop_master_id);
		}	
	}
	
}

?>
