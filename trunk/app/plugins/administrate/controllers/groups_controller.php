<?php

class GroupsController extends AdministrateAppController {
	
	var $uses = array('Administrate.Group',	'Aco', 'Aro');
	
	var $paginate = array('Group'=>array('limit' => pagination_amount,'order'=>'Group.name ASC')); 
	
	function index() {
		$this->set("atim_menu", $this->Menus->get('/administrate/groups/index'));
		$this->hook();
		$this->data = $this->paginate($this->Group, array());
	}
	
	function detail($group_id) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		$this->hook();
		$this->data = $this->Group->find('first',array('conditions'=>array('Group.id'=>$group_id)));
	}
	

	function add() {
		$this->hook();
		if (!empty($this->data)) {
			$group_data = $this->Group->find('first', array('conditions' => array('Group.name' => $this->data['Group']['name'])));
			if(empty($group_data)){
				$this->Group->create();
				if ($this->Group->save($this->data)) {
					
					$group_id = $this->Group->id;
					
					$aro_data = $this->Aro->find('first', array('conditions' => 'Aro.model="Group" AND Aro.foreign_key = "'.$group_id.'"'));
					$aro_data['Aro']['alias'] = 'Group::'.$group_id;
					$this->Aro->id = $aro_data['Aro']['id'];
					$this->Aro->save($aro_data);
					
					$this->flash('your data has been saved', '/administrate/permissions/tree/'.$group_id);
				} else {
					$this->flash('The Group could not be saved. Please, try again.', '/administrate/groups/add/');
				}
			}else{
				$this->Group->validationErrors['name'] = 'this name is already in use';
			}
		}
	}

	function edit($group_id = null ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id) );
		
		if (!$group_id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid Group', true));
			$this->redirect(array('action'=>'index'));
		}
		
		$this->hook();
		
		if (!empty($this->data)) {
			$this->Group->id = $group_id;
			if ($this->Group->save($this->data)) {
				$this->flash('your data has been updated', '/administrate/groups/detail/'.$group_id);
			} else {
				$this->flash('The Group could not be saved. Please, try again.', '/administrate/groups/edit/'.$group_id);
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

	function delete( $group_id = null ) {
		if (!$group_id) {
			$this->flash('Invalid id for Group', '/administrate/groups/index/');
		}
		
		$this->data = $this->Group->find('first',array('conditions'=>array('Group.id'=>$group_id)));	
		$this->hook();

		if(empty($this->data['User'])){
			if ($this->Group->del($group_id)) {
				$this->flash('Group deleted', '/administrate/groups/index/');
			}
		}else{
			$this->flash('this group is being used and cannot be deleted', '/administrate/groups/detail/'.$group_id."/");
		}
	}

}

?>