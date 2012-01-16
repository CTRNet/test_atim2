<?php

class AdminUsersController extends AdministrateAppController {
	var $uses = array('User', 'Group');
	var $paginate = array('User'=>array('limit' => pagination_amount,'order'=>'User.username ASC'));

	function beforeFilter(){
		parent::beforeFilter();
		$this->Structures->set('users');
	}
	
	function listall($group_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		
		$this->hook();
		
		$this->request->data = $this->paginate($this->User, array('User.group_id'=>$group_id));
	}
	
	function detail($group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$this->hook();
		
		$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
		if(empty($this->request->data)){
			$this->redirect( '/Pages/err_no_data', null, true );
		}
	}

	function add($group_id){
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		$this->Structures->set('users');
		$this->set("atim_menu", $this->Menus->get('/Administrate/users/listall/%%Group.id%%/'));
			
		if($this->Group->hasPermissions($group_id)){
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link); 
			}
			
			if(!empty($this->request->data)){
				$tmp_data = $this->User->find('first', array('conditions' => array('User.username' => $this->request->data['User']['username']))); 
				if(!empty($tmp_data)){
					$this->User->validationErrors[] = __('this user name is already in use');
				}
				
				$hashed_pwd = Security::hash($this->request->data['Generated']['field1'], null, true);
				$password_data = array('User' => array('new_password' => $this->request->data['User']['password'], 'confirm_password' => $this->request->data['Generated']['field1']));
				$this->User->validatePassword($password_data);
				
				$this->request->data['User']['password'] = Security::hash($this->request->data['User']['password'], null, true);
				$submitted_data_validates = empty($this->User->validationErrors);
				$this->request->data['User']['group_id'] = $group_id;
				$this->request->data['User']['flag_active'] = true;
				
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				if($submitted_data_validates) {
					if($this->User->save($this->request->data)){
						$hook_link = $this->hook('postsave_process');
						if( $hook_link ) {
							require($hook_link);
						}
						$this->atimFlash( 'your data has been saved', '/Administrate/users/detail/'.$group_id.'/'.$this->User->getLastInsertId().'/' );
					}
				}
				//reset password display
				$this->request->data['User']['password'] = "";
				$this->request->data['Generated']['field1'] = "";
			}
		}else{
			$this->flash(__('you cannot create a user for that group because it has no permission'), "/Administrate/users/listall/".$group_id."/");
		}
	}
	
	function edit($group_id, $user_id){
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id) );
	
		$this->Structures->set('users');
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(!empty($this->request->data)){
			$this->request->data['User']['id'] = $user_id;
			$this->request->data['User']['group_id'] = $group_id;
			$this->request->data['Group']['id'] = $group_id;
			
			$submitted_data_validates = true;
			
			if($user_id == $_SESSION['Auth']['User']['id'] && !$this->request->data['User']['flag_active']){
				unset($this->request->data['User']['flag_active']);
				AppController::addWarningMsg(__('you cannot deactivate yourself'));
			}
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				if($this->User->save($this->request->data)){
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved', '/Administrate/users/detail/'.$group_id.'/'.$user_id.'/' );
				}
			}
		}
		
		$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
		if(empty($this->request->data)){
			$this->redirect( '/Pages/err_no_data', null, true );
		}
	}
	
	function delete($group_id, $user_id){
		//to be used in a hook
		$arr_allow_deletion = array(
			"allow_deletion"	=> $user_id != $_SESSION['Auth']['User']['id'],
			"msg"				=> null
		);
		
		if(!$arr_allow_deletion['allow_deletion']){
			$arr_allow_deletion['msg'] = 'you cannot delete yourself';
		}

		$hook_link = $this->hook('delete');
		if($hook_link){
			require($hook_link);
		}

		if ($arr_allow_deletion['allow_deletion']) {
			$this->User->atim_delete($user_id);
			$this->atimFlash(__('your data has been deleted'), "/Administrate/users/listall/".$group_id);
		} else {
			$this->flash( $arr_allow_deletion['msg'], 'javascript:history.back()');
		}
	}
	
	function search($search_id = 0){
		$this->set( 'atim_menu', $this->Menus->get('/Administrate/Groups') );
		$this->searchHandler($search_id, $this->User, 'users', '/Administrate/users/search');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
}

