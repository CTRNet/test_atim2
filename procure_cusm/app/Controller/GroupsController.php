<?php

/**
 * Class GroupsController
 */
class GroupsController extends AppController
{

    public $name = 'Groups';

    public $helpers = array(
        'Html',
        'Form'
    );

    public $uses = array(
        'Group',
        'Aro'
    );

    public function index()
    {
        $this->Group->recursive = 0;
        $this->set('groups', $this->paginate());
    }

    /**
     *
     * @param null $id
     */
    public function view($id = null)
    {
        if (! $id) {
            $this->Session->setFlash(__('Invalid Group.'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        $this->set('group', $this->Group->read(null, $id));
    }

    public function add()
    {
        if (! empty($this->request->data)) {
            $this->Group->create();
            if ($this->Group->save($this->request->data)) {
                
                $groupId = $this->Group->id;
                
                $aroData = $this->Aro->find('first', array(
                    'conditions' => 'Aro.model="Group" AND Aro.foreign_key = "' . $groupId . '"'
                ));
                $aroData['Aro']['alias'] = 'Group::' . $groupId;
                $this->Aro->id = $aroData['Aro']['id'];
                $this->Aro->save($aroData);
                
                $this->Session->setFlash(__('The Group has been saved'));
                $this->redirect(array(
                    'action' => 'index'
                ));
            } else {
                $this->Session->setFlash(__('The Group could not be saved. Please, try again.'));
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
            $this->Session->setFlash(__('Invalid Group'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        if (! empty($this->request->data)) {
            if ($this->Group->save($this->request->data)) {
                foreach ($this->request->data['Aro']['Permission'] as $permission) {
                    if ($permission['remove'] && $permission['id']) {
                        $this->Permission->delete($permission['id']);
                    } elseif (! $permission['remove']) {
                        $this->Permission->id = isset($permission['id']) ? $permission['id'] : null;
                        $permission['_read'] = $permission['_create'];
                        $permission['_update'] = $permission['_create'];
                        $permission['_delete'] = $permission['_create'];
                        $this->Permission->save(array(
                            'Permission' => $permission
                        ));
                        $this->Permission->id = null;
                    }
                }
                $this->Session->setFlash(__('The Group has been saved'));
                $this->redirect(array(
                    'action' => 'index'
                ));
            } else {
                $this->Session->setFlash(__('The Group could not be saved. Please, try again.'));
            }
        }
        if (empty($this->request->data)) {
            $this->Group->bindToPermissions();
            $this->request->data = $this->Group->find('first', array(
                'conditions' => 'Group.id="' . $id . '"',
                'recursive' => 2
            ));
        }
        
        $aco = $this->Aco->find('all', array(
            'order' => 'Aco.lft ASC'
        ));
        
        $parentId = 0;
        $stack = array();
        $acoOptions = array();
        foreach ($aco as $ac) {
            if (in_array($ac['Aco']['parent_id'], array_keys($stack))) {
                $newStack = array();
                $done = false;
                foreach ($stack as $id => $alias) {
                    if ($done)
                        break;
                    $newStack[$id] = $alias;
                    if ($id == $ac['Aco']['parent_id'])
                        $done = true;
                }
                $stack = $newStack;
            }
            $stack[$ac['Aco']['id']] = $ac['Aco']['alias'];
            $acoOptions[$ac['Aco']['id']] = join('/', $stack);
        }
        $this->set('acoOptions', $acoOptions);
    }

    /**
     *
     * @param null $id
     */
    public function delete($id = null)
    {
        if (! $id) {
            $this->Session->setFlash(__('Invalid id for Group'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        if ($this->Group->del($id)) {
            $this->Session->setFlash(__('Group deleted'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
    }
}