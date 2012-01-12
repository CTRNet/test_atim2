<?php

class GroupsController extends AdministrateAppController {
	
	var $uses = array('Group',	'Aco', 'Aro', 'User');
	
	var $paginate = array('Group'=>array('limit' => pagination_amount,'order'=>'Group.name ASC')); 
	
	function index() {
		$this->set("atim_menu", $this->Menus->get('/Administrate/Groups/index'));
		$this->hook();
		$this->request->data = $this->paginate($this->Group, array());
	}
	
	function detail($group_id) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		$this->hook();
		$this->request->data = $this->Group->find('first',array('conditions'=>array('Group.id'=>$group_id)));
	}
	

	function add() {
		$this->set("atim_menu", $this->Menus->get('/Administrate/Groups/index'));
		$this->hook();
		if (!empty($this->request->data)) {
			$group_data = $this->Group->find('first', array('conditions' => array('Group.name' => $this->request->data['Group']['name'])));
			if(empty($group_data)){
				$this->Group->create();
				if ($this->Group->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					$group_id = $this->Group->id;
					
					$aro_data = $this->Aro->find('first', array('conditions' => 'Aro.model="Group" AND Aro.foreign_key = "'.$group_id.'"'));
					$aro_data['Aro']['alias'] = 'Group::'.$group_id;
					$this->Aro->id = $aro_data['Aro']['id'];
					$this->Aro->save($aro_data);
					
					$this->atimFlash('your data has been saved', '/Administrate/permissions/tree/'.$group_id);
				} else {
					$this->flash('The Group could not be saved. Please, try again.', '/Administrate/Groups/add/');
				}
			}else{
				$this->Group->validationErrors['name'] = 'this name is already in use';
			}
		}
	}

	function edit($group_id = null ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		
		if (!$group_id && empty($this->request->data)) {
			$this->Session->setFlash(__('Invalid Group'));
			$this->redirect(array('action'=>'index'));
		}
		
		$this->hook();
		
		if (!empty($this->request->data)) {
			$this->Group->id = $group_id;
			if ($this->Group->save($this->request->data)) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash('your data has been updated', '/Administrate/Groups/detail/'.$group_id);
			} else {
				$this->flash('The Group could not be saved. Please, try again.', '/Administrate/Groups/edit/'.$group_id);
			}
		}
		if (empty($this->request->data)) {
			$this->Group->bindToPermissions();
			$this->request->data = $this->Group->find('first', array('conditions' => 'Group.id="'.$group_id.'"', 'recursive' => 2));
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

	function delete( $group_id = null ) {
		if (!$group_id) {
			$this->flash('Invalid id for Group', '/Administrate/Groups/index/');
		}
		
		$this->request->data = $this->User->find('first',array('conditions'=>array('User.group_id'=>$group_id)));
		$this->hook();

		if(empty($this->request->data)){
			if ($this->Group->atim_delete($group_id)) {
				$this->atimFlash('Group deleted', '/Administrate/Groups/index/');
			}
		}else{
			$this->flash('this group is being used and cannot be deleted', '/Administrate/Groups/detail/'.$group_id."/");
		}
	}

}

?>