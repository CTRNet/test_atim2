<?php

class PasswordsAdminController extends AdministrateAppController
{

    var $name = 'Passwords';

    var $uses = array(
        'User'
    );

    function index($group_id, $user_id)
    {
        $this->set('atim_menu_variables', array(
            'Group.id' => $group_id,
            'User.id' => $user_id
        ));
        $this->Structures->set('password_update_by_administartor');
        
        $this->User->id = $user_id;
        
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
                    $this->atimFlash(__('your data has been updated'), '/Administrate/PasswordsAdmin/index/' . $group_id . '/' . $user_id);
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
