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
 * Class ProfilesController
 */
App::uses('CustomizeAppController', 'Customize.Controller');

class ProfilesController extends CustomizeAppController
{

    public $name = 'Profiles';

    public $uses = array(
        'User'
    );

    public static $databaseUserEncryptedString = '**************';

    public function index()
    {
        $this->Structures->set('users' . (Configure::read('reset_forgotten_password_feature') ? ',forgotten_password_reset_questions' : ''));
        
        $this->hook();
        
        $this->request->data = $this->User->find('first', array(
            'conditions' => array(
                'User.id' => $this->Session->read('Auth.User.id')
            )
        ));
        
        if (Configure::read('reset_forgotten_password_feature')) {
            foreach ($this->User->getForgottenPasswordResetFormFields() as $questionFieldName => $answerFieldName) {
                $this->request->data['User'][$answerFieldName] = strlen($this->request->data['User'][$answerFieldName]) ? self::$databaseUserEncryptedString : '';
            }
        }
    }

    public function edit()
    {
        $this->Structures->set('users' . (Configure::read('reset_forgotten_password_feature') ? ',forgotten_password_reset_questions' : ''));
        
        $userData = $this->User->getOrRedirect($this->Session->read('Auth.User.id'));
        
        $this->hook();
        
        if (empty($this->request->data)) {
            
            $this->request->data = $userData;
            
            if (Configure::read('reset_forgotten_password_feature')) {
                foreach ($this->User->getForgottenPasswordResetFormFields() as $questionFieldName => $answerFieldName) {
                    $this->request->data['User'][$answerFieldName] = strlen($this->request->data['User'][$answerFieldName]) ? self::$databaseUserEncryptedString : '';
                }
            }
        } else {
            
            $this->request->data['User']['id'] = $this->Session->read('Auth.User.id');
            $this->request->data['User']['group_id'] = $this->Session->read('Auth.User.group_id');
            $this->request->data['Group']['id'] = $this->Session->read('Auth.User.group_id');
            
            $this->User->id = $this->Session->read('Auth.User.id');
            
            $submittedDataValidates = true;
            
            if ($this->request->data['User']['username'] != $userData['User']['username']) {
                $this->User->validationErrors['username'][] = __('a user name can not be changed');
                $submittedDataValidates = false;
            }
            
            if (array_key_exists('flag_active', $this->request->data['User']) && ! $this->request->data['User']['flag_active']) {
                unset($this->request->data['User']['flag_active']);
                $this->User->validationErrors[][] = __('you cannot deactivate yourself');
                $submittedDataValidates = false;
            }
            
            if (Configure::read('reset_forgotten_password_feature')) {
                $uniqueQuestion = array();
                $uniqueAnswer = array();
                $formattedAnswers = array();
                foreach ($this->User->getForgottenPasswordResetFormFields() as $questionFieldName => $answerFieldName) {
                    // Format answer
                    $this->request->data['User'][$answerFieldName] = trim($this->request->data['User'][$answerFieldName]);
                    // Check answer
                    if ($this->request->data['User'][$answerFieldName] === self::$databaseUserEncryptedString) {
                        // User won't change the question/answer set
                        if ($userData['User'][$questionFieldName] !== $this->request->data['User'][$questionFieldName]) {
                            $this->User->validationErrors[$questionFieldName][] = __('the question has been modified. please enter a new answer.');
                            $submittedDataValidates = false;
                        }
                    } else {
                        // New question answer
                        // - Check question is unique
                        if (in_array($this->request->data['User'][$questionFieldName], $uniqueQuestion)) {
                            $this->User->validationErrors[$questionFieldName][] = __('a question can not be used twice.');
                            $submittedDataValidates = false;
                        }
                        $uniqueQuestion[] = $this->request->data['User'][$questionFieldName];
                        // - Check answer is unique
                        if (in_array($this->request->data['User'][$answerFieldName], $uniqueAnswer)) {
                            $this->User->validationErrors[$answerFieldName][] = __('a same answer can not be written twice.');
                            $submittedDataValidates = false;
                        }
                        $uniqueAnswer[] = $this->request->data['User'][$answerFieldName];
                        // - Check anser length
                        if (strlen($this->request->data['User'][$answerFieldName]) < 10) {
                            $this->User->validationErrors[$answerFieldName][] = __('the length of the answer should be bigger than 10.');
                            $submittedDataValidates = false;
                        }
                    }
                }
            }
            unset($this->request->data['User']['username']);
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                if (Configure::read('reset_forgotten_password_feature')) {
                    foreach ($this->User->getForgottenPasswordResetFormFields() as $questionFieldName => $answerFieldName) {
                        if ($this->request->data['User'][$answerFieldName] === self::$databaseUserEncryptedString) {
                            unset($this->request->data['User'][$questionFieldName]);
                            unset($this->request->data['User'][$answerFieldName]);
                        } else {
                            $this->request->data['User'][$answerFieldName] = $this->User->hashSecuritAsnwer($this->request->data['User'][$answerFieldName]);
                        }
                    }
                }
                
                $this->User->addWritableField(array(
                    'group_id'
                ));
                if ($this->User->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Customize/Profiles/index');
                    return;
                }
            }
            
            // Reset username
            $this->request->data['User']['username'] = $userData['User']['username'];
        }
    }
}