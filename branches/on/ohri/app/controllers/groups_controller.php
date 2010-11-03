<?php
class GroupsController extends AppController {

	var $name = 'Groups';
	var $helpers = array('Html', 'Form');
	
	var $uses = array('Group','Aro');
	
	function index() {
		$this->Group->recursive = 0;
		$this->set('groups', $this->paginate());
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid Group.', true));
			$this->redirect(array('action'=>'index'));
		}
		$this->set('group', $this->Group->read(null, $id));
	}

	function add() {
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

	function edit($id = null) {
		if (!$id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid Group', true));
			$this->redirect(array('action'=>'index'));
		}
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
			$this->data = $this->Group->find('first', array('conditions' => 'Group.id="'.$id.'"', 'recursive' => 2));
		}
		
		$aco = $this->Aco->find('all', array('order' => 'Aco.lft ASC'));
		
		$parent_id = 0;
		$stack = array();
		$aco_options = array();
		foreach($aco as $ac){
			if( in_array($ac['Aco']['parent_id'], array_keys($stack)) ){
				$new_stack = array();
				$done = false;
				foreach($stack as $id => $alias){
					if($done) break;
					$new_stack[$id] = $alias;
					if($id == $ac['Aco']['parent_id']) $done = true;
				}
				$stack = $new_stack;
			}
			$stack[$ac['Aco']['id']] = $ac['Aco']['alias'];
			$aco_options[$ac['Aco']['id']] = join('/',$stack);
		}
		$this->set('aco_options',$aco_options);
	}

	function delete($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid id for Group', true));
			$this->redirect(array('action'=>'index'));
		}
		if ($this->Group->del($id)) {
			$this->Session->setFlash(__('Group deleted', true));
			$this->redirect(array('action'=>'index'));
		}
	}

}
?>