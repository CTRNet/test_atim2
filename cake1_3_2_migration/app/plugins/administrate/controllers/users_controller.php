<?php

class UsersController extends AdministrateAppController {
	//TODO: add a feature to move a user from a group to another	
	var $uses = array('User', 'Group');
	var $paginate = array('User'=>array('limit' => pagination_amount,'order'=>'User.username ASC')); 
	
	function listall($group_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->User, array('User.group_id'=>$group_id));
	}
	
	function detail($group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$this->hook();
		
		$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
		if(empty($this->data)){
			$this->redirect( '/pages/err_no_data', null, true );
		}
	}

	function add($group_id){
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		$this->Structures->set('users');
			
		if($this->Group->hasPermissions($group_id)){
			$hook_link = $this->hook('format');
			if($hook_link){
				require($hook_link); 
			}
			
			if(!empty($this->data)){
				$tmp_data = $this->User->find('first', array('conditions' => array('User.username' => $this->data['User']['username']))); 
				if(!empty($tmp_data)){
					$this->User->validationErrors[] = __('this user name is already in use', true);
				}
				$this->data['Generated']['field1'] = Security::hash($this->data['Generated']['field1'], null, true);
				$submitted_data_validates = true;
				if($this->data['User']['password'] != $this->data['Generated']['field1']){
					$this->User->validationErrors[] = __('password and password validation do not match', true);
				}
				$this->data['User']['group_id'] = $group_id;
				
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				if($submitted_data_validates) {
					if($this->User->save($this->data)){
						$this->flash( 'your data has been saved', '/administrate/users/detail/'.$group_id.'/'.$this->User->getLastInsertId().'/' );
					}
				}
				//reset password display
				$this->data['User']['password'] = "";
				$this->data['Generated']['field1'] = "";
			}
		}else{
			$this->flash(__('you cannot create a user for that group because it has no permission', true), "/administrate/users/listall/".$group_id."/");
		}
	}
	
	function edit($group_id, $user_id){
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id) );
	
		$this->Structures->set('users');
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(!empty($this->data)){
			$this->data['User']['id'] = $user_id;
			$this->data['User']['group_id'] = $group_id;
			$this->data['Group']['id'] = $group_id;
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				if($this->User->save($this->data)){
					$this->flash( 'your data has been saved', '/administrate/users/detail/'.$group_id.'/'.$user_id.'/' );
				}
			}
		}
		
		$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
		if(empty($this->data)){
			$this->redirect( '/pages/err_no_data', null, true );
		}
	}
}

?>