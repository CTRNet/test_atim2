<?php

/**
 * Class GroupsController
 */
class GroupsController extends AdministrateAppController
{

    public $uses = array(
        'Group',
        'Aco',
        'Aro',
        'User'
    );

    public $paginate = array(
        'Group' => array(
            'order' => 'Group.name ASC'
        )
    );

    public function index()
    {
        $this->set("atimMenu", $this->Menus->get('/Administrate/Groups/index'));
        $this->hook();
        $this->request->data = $this->paginate($this->Group, array());
    }

    /**
     *
     * @param $groupId
     */
    public function detail($groupId)
    {
        $this->set('displayEditButton', (($groupId == 1) ? false : true));
        if ($groupId == 1)
            AppController::addWarningMsg('the group administrators cannot be edited');
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId
        ));
        $this->hook();
        $this->request->data = $this->Group->find('first', array(
            'conditions' => array(
                'Group.id' => $groupId
            )
        ));
    }

    public function add()
    {
        $this->set("atimMenu", $this->Menus->get('/Administrate/Groups/index'));
        $this->hook();
        if (! empty($this->request->data)) {
            $groupData = $this->Group->find('first', array(
                'conditions' => array(
                    'Group.name' => $this->request->data['Group']['name']
                )
            ));
            if (empty($groupData)) {
                if ($this->Group->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $groupId = $this->Group->id;
                    
                    $aroData = $this->Aro->find('first', array(
                        'conditions' => 'Aro.model="Group" AND Aro.foreign_key = "' . $groupId . '"'
                    ));
                    $aroData['Aro']['alias'] = 'Group::' . $groupId;
                    $this->Aro->id = $aroData['Aro']['id'];
                    $this->Aro->save($aroData);
                    
                    $this->atimFlash(__('your data has been saved'), '/Administrate/Permissions/tree/' . $groupId);
                }
            } else {
                $this->Group->validationErrors['name'][] = 'this name is already in use';
            }
        }
    }

    /**
     *
     * @param $groupId
     */
    public function edit($groupId)
    {
        if ($groupId == 1) {
            $this->atimFlashWarning(__('the group administrators cannot be edited'), '/Administrate/Groups/detail/1');
        }
        $this->Group->getOrRedirect($groupId);
        
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId
        ));
        
        if (! $groupId && empty($this->request->data)) {
            $this->Session->setFlash(__('Invalid Group'));
            $this->redirect(array(
                'action' => 'index'
            ));
        }
        
        $this->hook();
        
        if (! empty($this->request->data)) {
            $duplicatedName = $this->Group->find('count', array(
                'conditions' => array(
                    "Group.id != $groupId",
                    'Group.name' => $this->request->data['Group']['name']
                )
            ));
            if ($duplicatedName) {
                $this->Group->validationErrors['name'][] = 'this name is already in use';
            } else {
                $this->Group->id = $groupId;
                $this->Group->data = array();
                $this->Aco->pkeySafeguard = false;
                $this->Aro->pkeySafeguard = false;
                $this->Aco->checkWritableFields = false;
                $this->Aro->checkWritableFields = false;
                if ($this->Group->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Administrate/Groups/detail/' . $groupId);
                }
            }
        }
        if (empty($this->request->data)) {
            $this->Group->bindToPermissions();
            $this->request->data = $this->Group->find('first', array(
                'conditions' => 'Group.id="' . $groupId . '"',
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
                foreach ($stack as $groupId => $alias) {
                    if ($done)
                        break;
                    $newStack[$groupId] = $alias;
                    if ($groupId == $ac['Aco']['parent_id'])
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
     * @param $groupId
     */
    public function delete($groupId)
    {
        if ($groupId == 1) {
            $this->atimFlashWarning(__('the group administrators cannot be deleted'), '/Administrate/Groups/detail/1');
        }
        $this->request->data = $this->User->find('first', array(
            'conditions' => array(
                'User.group_id' => $groupId
            )
        ));
        $this->hook();
        
        if (empty($this->request->data)) {
            if ($this->Group->atimDelete($groupId)) {
                $this->atimFlash(__('Group deleted'), '/Administrate/Groups/index/');
            }
        } else {
            $this->atimFlashWarning(__('this group is being used and cannot be deleted'), '/Administrate/Groups/detail/' . $groupId . "/");
        }
    }
}