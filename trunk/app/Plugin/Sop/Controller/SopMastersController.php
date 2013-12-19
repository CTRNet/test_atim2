<?php

class SopMastersController extends SopAppController {

	var $uses = array('Sop.SopControl', 'Sop.SopMaster');
	var $paginate = array('SopMaster'=>array('limit' => pagination_amount,'order'=>'SopMaster.title DESC'));
	
	function listall() {
		$this->request->data = $this->paginate($this->SopMaster, array());
		
		// find all EVENTCONTROLS, for ADD form
		$this->set( 'sop_controls', $this->SopControl->find('all', array('conditions' => array('SopControl.flag_active' => '1'))) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add($sop_control_id) {
		$this->set( 'atim_menu_variables', array('SopControl.id'=>$sop_control_id)); 
		$this_data = $this->SopControl->find('first',array('conditions'=>array('SopControl.id'=>$sop_control_id, 'SopControl.flag_active' => '1')));
		if(empty($this_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	
		$this->set('sop_control_data', $this_data['SopControl']);	
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set($this_data['SopControl']['form_alias']);
		
		$atim_menu = $this->Menus->get('/Sop/SopMasters/listall/');		
		$this->set('atim_menu', $atim_menu);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->request->data) ) {
			
			$this->request->data['SopMaster']['sop_control_id'] = $sop_control_id;
			$this->SopMaster->addWritableField('sop_control_id');
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
						
			if($submitted_data_validates) {
				if ( $this->SopMaster->save($this->request->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}		
									
					$this->atimFlash( 'your data has been updated','/Sop/SopMasters/detail/'.$this->SopMaster->getLastInsertId());
				}
			}
		} 
	}
	
	function detail($sop_master_id) {
		if ( !$sop_master_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('SopMaster.id'=>$sop_master_id));
		
		$this->request->data = $this->SopMaster->getOrRedirect($sop_master_id);
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->request->data['SopControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}

	function edit( $sop_master_id  ) {
		$this->set( 'atim_menu_variables', array('SopMaster.id'=>$sop_master_id) );
		$this_data = $this->SopMaster->getOrRedirect($sop_master_id);
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this_data['SopControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		if ( empty($this->request->data) ) {
			$this->request->data = $this_data;
			
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
						
			$this->SopMaster->id = $sop_master_id;
			if($submitted_data_validates) {
				if ( $this->SopMaster->save($this->request->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}		
					
					$this->atimFlash( 'your data has been updated','/Sop/SopMasters/detail/'.$sop_master_id.'/');
				}
			}
		}
	}
	
	function delete( $sop_master_id ) {
		if ( !$sop_master_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		$this_data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		if(empty($this_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->SopMaster->allowDeletion($sop_master_id);

		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {
			if( $this->SopMaster->atimDelete( $sop_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/Sop/SopMasters/listall/');
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/Sop/SopMasters/listall/');
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/Sop/SopMasters/detail/'.$sop_master_id);
		}	
	}
	
}

?>
