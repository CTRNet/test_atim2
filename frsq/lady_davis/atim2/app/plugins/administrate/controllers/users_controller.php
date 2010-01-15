<?php

class UsersController extends AdministrateAppController {
	
	var $uses = array('User');
	var $paginate = array('User'=>array('limit'=>10,'order'=>'User.username ASC')); 
	
	function listall( $bank_id, $group_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->User, array('User.group_id'=>$group_id));
	}
	
	function detail( $bank_id, $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$this->hook();
		
		$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
	}

	
	/*
	function index() {
		// nothing...
	}
	
	function listall( $bank_id, $group_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('users') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		
		// get ALL associatations based on PARENT model
		$criteria = array();
		$criteria['Group.id'] = $group_id;
		$criteria = array_filter($criteria);
		$results = $this->Group->findAll( $criteria );
		
		// clear criteria
		$criteria = array();
		
		// make NEW criteria of allowed ASSOCIATED ids
		foreach ( $results[0]['User'] as $user_id ) {
			$criteria[] = 'User.id="'.$user_id['id'].'"';
		}
		$criteria = array_filter($criteria);
		
		if(empty($criteria)) {
			// Just to launch the query to look for unexisting user and use pagination
			$criteria[] = 'User.id="-1"';
		}
		$criteria = '('.implode( ' OR ', $criteria ).')';
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$users_list = $this->User->findAll( $criteria, NULL, $order, $limit, $page );
		
		$this->set( 'users', $this->User->findAll( $criteria, NULL, $order, $limit, $page ) );
	
	}
	
	function detail( $bank_id, $group_id, $user_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_89', 'core_CAN_91', $bank_id.'/'.$group_id.'/'.$user_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('users') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		$this->set( 'user_id', $user_id );
		
		$this->User->id = $user_id;
		$this->set( 'data', $this->User->read() );
	}
	
	function add( $bank_id, $group_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('users') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('users') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		
		if ( !empty($this->data) ) {
			
			if ( $this->User->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/users/listall/'.$bank_id.'/'.$group_id );
			}
			
		}
		
	}
	
	function edit( $bank_id, $group_id, $user_id ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('users') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_89', 'core_CAN_91', $bank_id.'/'.$group_id.'/'.$user_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('users') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		$this->set( 'user_id', $user_id );
		
		if ( empty($this->data) ) {
			
			$this->User->id = $user_id;
			$this->data = $this->User->read();
			$this->set( 'data', $this->data );
			
		} else {
			
			if ( $this->User->save( $this->data['User'] ) ) {
				$this->flash( 'Your data has been updated.','/users/detail/'.$bank_id.'/'.$group_id.'/'.$user_id );
			}
			
		}
	}
	
	function delete( $bank_id, $group_id, $user_id ) {
		
		$this->User->del( $user_id );
		$this->flash( 'Your data has been deleted.', '/users/listall/'.$bank_id.'/'.$group_id );
		
	}
	*/
	
	/*** NOW WITH AROS ***/
	
	/*
	function index() {
		$this->User->recursive = 0;
		$this->set('users', $this->paginate());
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid User.', true));
			$this->redirect(array('action'=>'index'));
		}
		$this->set('user', $this->User->read(null, $id));
	}

	function add() {
		if (!empty($this->data)) {
			$this->User->create();
			if ($this->User->save($this->data)) {
				$this->Session->setFlash(__('The User has been saved', true));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Session->setFlash(__('The User could not be saved. Please, try again.', true));
			}
		}
	}

	function edit($id = null) {
		if (!$id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid User', true));
			$this->redirect(array('action'=>'index'));
		}
		if (!empty($this->data)) {
			if ($this->User->save($this->data)) {
			
				// Check if their permission group is changing
				$oldgroupid = $this->User->field('group_id');
				if ($oldgroupid !== $this->data['User']['group_id']) {    
					$aro =& $this->Acl->Aro;    
					$user = $aro->findByForeignKeyAndModel($this->data['User']['id'], 'User');    
					$group = $aro->findByForeignKeyAndModel($this->data['User']['group_id'], 'Group');                    
					
					// Save to ARO table    
					$aro->id = $user['Aro']['id'];    
					$aro->save(array('parent_id' => $group['Aro']['id']));
				}
			
				$this->Session->setFlash(__('The User has been saved', true));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Session->setFlash(__('The User could not be saved. Please, try again.', true));
			}
		}
		if (empty($this->data)) {
			$this->data = $this->User->read(null, $id);
		}
	}

	function delete($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid id for User', true));
			$this->redirect(array('action'=>'index'));
		}
		if ($this->User->del($id)) {
			$this->Session->setFlash(__('User deleted', true));
			$this->redirect(array('action'=>'index'));
		}
	}
	*/

}

?>