<?php

/**
 * Class PasswordsAdminController
 */
class PasswordsAdminController extends AdministrateAppController
{

    public $name = 'Passwords';

    public $uses = array(
        'User'
    );

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function index($groupId, $userId)
    {
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        $this->Structures->set('password_update_by_administartor');
        
        $this->User->id = $userId;
        
        if (empty($this->request->data)) {
            $this->set('data', $this->User->read());
        } else {
            // Check administrator entered his password
            $conditions = array(
                'User.id' => $this->Session->read('Auth.User.id'),
                'User.password' => Security::hash($this->request->data['FunctionManagement']['admin_user_password_for_change'], null, true)
            );
            if ($this->User->find('count', array(
                'conditions' => $conditions
            ))) {
                if ($this->User->savePassword($this->request->data, false)) {
                    $this->atimFlash(__('your data has been updated'), '/Administrate/PasswordsAdmin/index/' . $groupId . '/' . $userId);
                } else {
                    $this->request->data = array();
                }
            } else {
                $this->User->validationErrors['admin_user_password_for_change'][] = __('your own password is invalid');
                $this->request->data = array();
            }
        }
    }
}