<?php

class GroupsController extends AdministrateAppController {
	
	var $uses = array('Group');
	var $paginate = array('Group'=>array('limit'=>10,'order'=>'Group.name ASC')); 
	
	function index( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		$this->hook();
		$this->data = $this->paginate($this->Group, array('Group.bank_id'=>$bank_id));
	}
	
	function detail( $bank_id, $group_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id) );
		$this->hook();
		$this->data = $this->Group->find('first',array('conditions'=>array('Group.id'=>$group_id)));
		
		/*
		if (!$id) {
			$this->Session->setFlash(__('Invalid Group.', true));
			$this->redirect(array('action'=>'index'));
		}
		
		$this->set('group', $this->Group->read(null, $id));
		*/
	}
	

	function add() {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		
		$this->hook();
		
		if (!empty($this->data)) {
			$this->Group->create();
			if ($this->Group->save($this->data)) {
				
				$group_id = $this->Group->id;
				
				$aro_data = $this->Aro->find('first', array('conditions' => 'Aro.model="Group" AND Aro.foreign_key = "'.$group_id.'"'));
				$aro_data['Aro']['alias'] = 'Group::'.$group_id;
				$this->Aro->id = $aro_data['Aro']['id'];
				$this->Aro->save($aro_data);
				
				$this->Session->setFlash(__('The Group has been saved', true));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Session->setFlash(__('The Group could not be saved. Please, try again.', true));
			}
		}
	}

	function edit( $bank_id, $group_id = null ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id) );
		
		if (!$group_id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid Group', true));
			$this->redirect(array('action'=>'index'));
		}
		
		$this->hook();
		
		if (!empty($this->data)) {
			if ($this->Group->save($this->data)) {
				foreach($this->data['Aro']['Permission'] as $permission){
					if($permission['remove'] && $permission['id']){
						$this->Permission->delete( $permission['id'] );
					}else if(!$permission['remove']){
						$this->Permission->id = isset($permission['id']) ? $permission['id'] : NULL;
						$permission['_read'] = $permission['_create'];
						$permission['_update'] = $permission['_create'];
						$permission['_delete'] = $permission['_create'];
						$this->Permission->save( array('Permission' => $permission) );
						$this->Permission->id = NULL;
					}
				}
				$this->Session->setFlash(__('The Group has been saved', true));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Session->setFlash(__('The Group could not be saved. Please, try again.', true));
			}
		}
		if (empty($this->data)) {
			$this->Group->bindToPermissions();
			$this->data = $this->Group->find('first', array('conditions' => 'Group.id="'.$group_id.'"', 'recursive' => 2));
		}
		
		$aco = $this->Aco->find('all', array('order' => 'Aco.lft ASC'));
		
		$parent_id = 0;
		$stack = array();
		$aco_options = array();
		foreach($aco as $ac){
			if( in_array($ac['Aco']['parent_id'], array_keys($stack)) ){
				$new_stack = array();
				$done = false;
				foreach($stack as $group_id => $alias){
					if($done) break;
					$new_stack[$group_id] = $alias;
					if($group_id == $ac['Aco']['parent_id']) $done = true;
				}
				$stack = $new_stack;
			}
			$stack[$ac['Aco']['id']] = $ac['Aco']['alias'];
			$aco_options[$ac['Aco']['id']] = join('/',$stack);
		}
		$this->set('aco_options',$aco_options);
	}

	function delete( $bank_id, $group_id = null ) {
		if (!$group_id) {
			$this->Session->setFlash(__('Invalid id for Group', true));
			$this->redirect(array('action'=>'index'));
		}
		
		$this->hook();
		
		if ($this->Group->del($group_id)) {
			$this->Session->setFlash(__('Group deleted', true));
			$this->redirect(array('action'=>'index'));
		}
	}

	/*
	function index( $bank_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('groups') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		
			$criteria = array();
			$criteria[] = 'bank_id="'.$bank_id.'"';
			$criteria = array_filter($criteria);
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'groups', $this->Group->findAll( $criteria, NULL, $order, $limit, $page ) );
		
	}
	
	function detail( $bank_id, $group_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_87', $bank_id.'/'.$group_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('groups') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		
		$this->Group->id = $group_id;
		$this->set( 'data', $this->Group->read() );
	}
	
	function add( $bank_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('groups') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('groups') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		
		if ( !empty($this->data) ) {
			
			if ( $this->Group->save( $this->data ) ) {
				$this->flash( 'your data has been saved', '/groups/index/'.$bank_id );
			}
			
		}
		
	}
	
	function edit( $bank_id, $group_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('groups') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_87', $bank_id.'/'.$group_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('groups') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		
		if ( empty($this->data) ) {
			
			$this->Group->id = $group_id;
			$this->data = $this->Group->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->User->save( $this->data['Group'] ) ) {
				$this->flash( 'your data has been updated','/groups/detail/'.$bank_id.'/'.$group_id );
			}
			
		}
	}
	*/

}

?>