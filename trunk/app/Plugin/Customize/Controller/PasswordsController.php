<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class PasswordsController
 */
class PasswordsController extends CustomizeAppController
{

    public $name = 'Passwords';

    public $uses = array(
        'User'
    );

    public function index()
    {
        $this->Structures->set('password_update_by_user');
        $this->User->id = $this->Session->read('Auth.User.id');
        
        $this->hook();
        if (empty($this->request->data)) {
            if ($this->Session->read('Auth.User.force_password_reset'))
                AppController::addWarningMsg(__('your password has expired. please change your password for security reason.'));
            $this->set('data', $this->User->read());
        } else {
            $conditions = array(
                'User.id' => $this->User->id,
                'User.password' => Security::hash($this->request->data['FunctionManagement']['old_password'], null, true)
            );
            // Check user entered his old password
            if ($this->User->find('count', array(
                'conditions' => $conditions
            ))) {
                if ($this->User->savePassword($this->request->data, true)) {
                    $this->Session->write('Auth.User.force_password_reset', '0');
                    $this->atimFlash(__('your data has been updated'), '/Customize/Passwords/index');
                } else {
                    $this->request->data = array();
                }
            } else {
                $this->User->validationErrors['old_password'][] = __('your old password is invalid');
                $this->request->data = array();
            }
        }
    }
}