<?php
App::uses('AppController', 'Controller');

/**
 * Class PostsController
 * @property Post $Post
 */
class PostsController extends AppController
{
	var $name = 'Posts';

	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('index', 'view');
	}

	function index() {
		$this->Post->recursive = 0;
		$this->set('posts', $this->paginate());
	}

	function view($id = null) {
		if (!$id) {
			$this->Flash->error(__('Invalid Post.'));
			$this->redirect(array('action'=>'index'));
		}
		$this->set('post', $this->Post->read(null, $id));
	}

	function add() {
		if (!empty($this->request->data)) {
			$this->Post->create();
			if ($this->Post->save($this->request->data)) {
				$this->Flash->success(__('The Post has been saved'));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Flash->error(__('The Post could not be saved. Please, try again.'));
			}
		}
	}

	function edit($id = null) {
		if (!$id && empty($this->request->data)) {
			$this->Flash->error(__('Invalid Post'));
			$this->redirect(array('action'=>'index'));
		}
		if (!empty($this->request->data)) {
			if ($this->Post->save($this->request->data)) {
				$this->Flash->success(__('The Post has been saved'));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Flash->error(__('The Post could not be saved. Please, try again.'));
			}
		}
		if (empty($this->request->data)) {
			$this->request->data = $this->Post->read(null, $id);
		}
	}

	function delete($id = null) {
		if (!$id) {
			$this->Flash->error(__('Invalid id for Post'));
			$this->redirect(array('action'=>'index'));
		}
		if ($this->Post->del($id)) {
			$this->Flash->success(__('Post deleted'));
			$this->redirect(array('action'=>'index'));
		}
	}

}