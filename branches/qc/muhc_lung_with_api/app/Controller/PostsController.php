<?php

/**
 * Class PostsController
 */
class PostsController extends AppController
{

    public $name = 'Posts';

    public $helpers = array(
        'Html',
        'Form'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->AtimAuth->allowedActions = array(
            'index',
            'view'
        );
    }

    public function index()
    {
        $this->Post->recursive = 0;
        $this->set('posts', $this->paginate());
    }

    /**
     *
     * @param null $id
     */
    public function view($id = null)
    {
        if (! $id) {
            $this->Session->setFlash(__('Invalid Post.'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        $this->set('post', $this->Post->read(null, $id));
    }

    public function add()
    {
        if (! empty($this->request->data)) {
            $this->Post->create();
            if ($this->Post->save($this->request->data)) {
                $this->Session->setFlash(__('The Post has been saved'));
                $this->redirect(array(
                    'action' => 'index'
                ));
            } else {
                $this->Session->setFlash(__('The Post could not be saved. Please, try again.'));
            }
        }
    }

    /**
     *
     * @param null $id
     */
    public function edit($id = null)
    {
        if (! $id && empty($this->request->data)) {
            $this->Session->setFlash(__('Invalid Post'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        if (! empty($this->request->data)) {
            if ($this->Post->save($this->request->data)) {
                $this->Session->setFlash(__('The Post has been saved'));
                $this->redirect(array(
                    'action' => 'index'
                ));
            } else {
                $this->Session->setFlash(__('The Post could not be saved. Please, try again.'));
            }
        }
        if (empty($this->request->data)) {
            $this->request->data = $this->Post->read(null, $id);
        }
    }

    /**
     *
     * @param null $id
     */
    public function delete($id = null)
    {
        if (! $id) {
            $this->Session->setFlash(__('Invalid id for Post'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        if ($this->Post->del($id)) {
            $this->Session->setFlash(__('Post deleted'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
    }
}