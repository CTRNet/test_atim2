<?php

/**
 * Class AdminUsersController
 */
class AdminUsersController extends AdministrateAppController
{

    public $uses = array(
        'User',
        'Group'
    );

    public $paginate = array(
        'User' => array(
            'order' => 'User.username ASC'
        )
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->Structures->set('users');
    }

    /**
     *
     * @param $groupId
     */
    public function listall($groupId)
    {
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId
        ));
        $this->Structures->set('users,users_form_for_admin');
        
        $this->hook();
        
        $this->request->data = $this->paginate($this->User, array(
            'User.group_id' => $groupId
        ));
    }

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function detail($groupId, $userId)
    {
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        $this->Structures->set('users,users_form_for_admin');
        
        $this->hook();
        
        $this->request->data = $this->User->getOrRedirect($userId);
        
        if ($this->request->data['User']['group_id'] != $groupId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }

    /**
     *
     * @param $groupId
     */
    public function add($groupId)
    {
        $isLdap = Configure::read("if_use_ldap_authentication");
        $isLdap = ! empty($isLdap);
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId
        ));
        $this->Structures->set('users,users_form_for_admin');
        $this->set("atimMenu", $this->Menus->get('/Administrate/Groups/detail/%%Group.id%%/'));
        
        if ($this->Group->hasPermissions($groupId)) {
            $hookLink = $this->hook('format');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (! empty($this->request->data)) {
                $tmpData = $this->User->find('first', array(
                    'conditions' => array(
                        'User.username' => $this->request->data['User']['username']
                    )
                ));
                if (! empty($tmpData)) {
                    $this->User->validationErrors[][] = __('this user name is already in use');
                }
                
                $passwordData = array(
                    'User' => array(
                        'new_password' => $this->request->data['User']['password'],
                        'confirm_password' => $this->request->data['Generated']['field1']
                    )
                );
                $submittedDataValidates = $this->User->validatePassword($passwordData, $this->request->data['User']['username']);
                
                $this->request->data['User']['password'] = Security::hash($this->request->data['User']['password'], null, true);
                $this->request->data['User']['password_modified'] = date("Y-m-d H:i:s");
                $this->request->data['User']['group_id'] = $groupId;
                $this->request->data['User']['flag_active'] = true;
                $this->User->addWritableField(array(
                    'group_id',
                    'flag_active',
                    'password_modified'
                ));
                $aroM = AppModel::getInstance('', 'Aro', true);
                $aroM->checkWritableFields = false;
                
                $hookLink = $this->hook('presave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if ($submittedDataValidates) {
                    if (! empty($isLdap)) {
                        $this->request->data['force_password_reset'] = 1;
                    }
                    
                    if ($this->User->save($this->request->data)) {
                        $hookLink = $this->hook('postsave_process');
                        if ($hookLink) {
                            require ($hookLink);
                        }
                        $this->atimFlash(__('your data has been saved'), '/Administrate/AdminUsers/detail/' . $groupId . '/' . $this->User->getLastInsertId() . '/');
                    }
                }
                // reset password display
                $this->request->data['User']['password'] = "";
                $this->request->data['Generated']['field1'] = "";
            }
        } else {
            $this->atimFlashError(__('you cannot create a user for that group because it has no permission'), "/Administrate/AdminUsers/listall/" . $groupId . "/");
        }
    }

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function edit($groupId, $userId)
    {
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        $userData = $this->User->getOrRedirect($userId);
        
        $this->Structures->set('users,users_form_for_admin');
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $userData;
        } else {
            $this->request->data['User']['id'] = $userId;
            $this->request->data['User']['group_id'] = $groupId;
            $this->request->data['Group']['id'] = $groupId;
            
            $submittedDataValidates = true;
            
            if ($this->request->data['User']['username'] != $userData['User']['username']) {
                $this->User->validationErrors['username'][] = __('a user name can not be changed');
                $submittedDataValidates = false;
            }
            
            unset($this->request->data['User']['username']);
            
            if ($userId == $_SESSION['Auth']['User']['id'] && ! $this->request->data['User']['flag_active']) {
                unset($this->request->data['User']['flag_active']);
                $this->User->validationErrors[][] = __('you cannot deactivate yourself');
                $submittedDataValidates = false;
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->User->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Administrate/AdminUsers/detail/' . $groupId . '/' . $userId . '/');
                    return;
                }
            }
            
            // Reset username
            $this->request->data['User']['username'] = $userData['User']['username'];
        }
    }

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function delete($groupId, $userId)
    {
        // to be used in a hook
        $arrAllowDeletion = array(
            "allow_deletion" => $userId != $_SESSION['Auth']['User']['id'],
            "msg" => null
        );
        
        if (! $arrAllowDeletion['allow_deletion']) {
            $arrAllowDeletion['msg'] = 'you cannot delete yourself';
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $announcementM = AppModel::getInstance('', 'Announcement', true);
            $announcementConditions = array(
                'Announcement.user_id' => $userId
            );
            $announcements = $announcementM->find('first', array(
                'conditions' => $announcementConditions
            ));
            if ($announcements) {
                $arrAllowDeletion = array(
                    'allow_deletion' => false,
                    'msg' => 'at least one announcement is linked to that user'
                );
            }
        }
        
        $aroM = AppModel::getInstance('', 'Aro', true);
        $aroM->checkWritableFields = false;
        $aroM->pkeySafeguard = false;
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $this->User->id = $userId;
            $this->User->atimDelete($userId);
            $this->atimFlash(__('your data has been deleted'), "/Administrate/Groups/detail/" . $groupId);
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), "/Administrate/AdminUsers/detail/$groupId/$userId");
        }
    }

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/Administrate/Groups/index'));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->User, 'users', '/Administrate/AdminUsers/search');
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('searchId', $searchId);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function changeGroup($groupId, $userId)
    {
        $user = $this->User->getOrRedirect($userId);
        if ($user['Group']['id'] != $groupId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($userId == $_SESSION['Auth']['User']['id']) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('atimMenu', $this->Menus->get('/Administrate/AdminUsers/detail'));
        $this->set('atimMenuVariables', array(
            'Group.id' => $user['Group']['id'],
            'User.id' => $userId
        ));
        
        $this->Structures->set('group_select');
        
        if ($this->request->data) {
            $this->Group->getOrRedirect($this->request->data['Group']['id']);
            $this->User->id = $userId;
            $this->User->data = array();
            $this->User->addWritableField('group_id');
            $this->User->save(array(
                'User' => array(
                    'group_id' => $this->request->data['Group']['id']
                )
            ), false);
            $this->SystemVar->setVar('permission_timestamp', time());
            $this->atimFlash(__('your data has been saved'), '/Administrate/AdminUsers/detail/' . $this->request->data['Group']['id'] . '/' . $userId . '/');
        } else {
            $this->request->data = $user;
        }
    }
}