<?php

class ProfilesController extends CustomizeAppController
{

    public $name = 'Profiles';

    public $uses = array(
        'User'
    );

    static $database_user_encrypted_string = '**************';

    function index()
    {
        $this->Structures->set('users' . (Configure::read('reset_forgotten_password_feature') ? ',forgotten_password_reset_questions' : ''));
        
        $this->hook();
        
        $this->request->data = $this->User->find('first', array(
            'conditions' => array(
                'User.id' => $this->Session->read('Auth.User.id')
            )
        ));
        
        if (Configure::read('reset_forgotten_password_feature')) {
            foreach ($this->User->getForgottenPasswordResetFormFields() as $question_field_name => $answer_field_name) {
                $this->request->data['User'][$answer_field_name] = strlen($this->request->data['User'][$answer_field_name]) ? self::$database_user_encrypted_string : '';
            }
        }
    }

    function edit()
    {
        $this->Structures->set('users' . (Configure::read('reset_forgotten_password_feature') ? ',forgotten_password_reset_questions' : ''));
        
        $user_data = $this->User->getOrRedirect($this->Session->read('Auth.User.id'));
        
        $this->hook();
        
        if (empty($this->request->data)) {
            
            $this->request->data = $user_data;
            
            if (Configure::read('reset_forgotten_password_feature')) {
                foreach ($this->User->getForgottenPasswordResetFormFields() as $question_field_name => $answer_field_name) {
                    $this->request->data['User'][$answer_field_name] = strlen($this->request->data['User'][$answer_field_name]) ? self::$database_user_encrypted_string : '';
                }
            }
        } else {
            
            $this->request->data['User']['id'] = $this->Session->read('Auth.User.id');
            $this->request->data['User']['group_id'] = $this->Session->read('Auth.User.group_id');
            $this->request->data['Group']['id'] = $this->Session->read('Auth.User.group_id');
            
            $this->User->id = $this->Session->read('Auth.User.id');
            
            $submitted_data_validates = true;
            
            if ($this->request->data['User']['username'] != $user_data['User']['username']) {
                $this->User->validationErrors['username'][] = __('a user name can not be changed');
                $submitted_data_validates = false;
            }
            
            if (array_key_exists('flag_active', $this->request->data['User']) && ! $this->request->data['User']['flag_active']) {
                unset($this->request->data['User']['flag_active']);
                $this->User->validationErrors[][] = __('you cannot deactivate yourself');
                $submitted_data_validates = false;
            }
            
            if (Configure::read('reset_forgotten_password_feature')) {
                $unique_question = array();
                $unique_answer = array();
                $formatted_answers = array();
                foreach ($this->User->getForgottenPasswordResetFormFields() as $question_field_name => $answer_field_name) {
                    // Format answer
                    $this->request->data['User'][$answer_field_name] = trim($this->request->data['User'][$answer_field_name]);
                    // Check answer
                    if ($this->request->data['User'][$answer_field_name] === self::$database_user_encrypted_string) {
                        // User won't change the question/answer set
                        if ($user_data['User'][$question_field_name] !== $this->request->data['User'][$question_field_name]) {
                            $this->User->validationErrors[$question_field_name][] = __('the question has been modified. please enter a new answer.');
                            $submitted_data_validates = false;
                        }
                    } else {
                        // New question answer
                        // - Check question is unique
                        if (in_array($this->request->data['User'][$question_field_name], $unique_question)) {
                            $this->User->validationErrors[$question_field_name][] = __('a question can not be used twice.');
                            $submitted_data_validates = false;
                        }
                        $unique_question[] = $this->request->data['User'][$question_field_name];
                        // - Check answer is unique
                        if (in_array($this->request->data['User'][$answer_field_name], $unique_answer)) {
                            $this->User->validationErrors[$answer_field_name][] = __('a same answer can not be written twice.');
                            $submitted_data_validates = false;
                        }
                        $unique_answer[] = $this->request->data['User'][$answer_field_name];
                        // - Check anser length
                        if (strlen($this->request->data['User'][$answer_field_name]) < 10) {
                            $this->User->validationErrors[$answer_field_name][] = __('the length of the answer should be bigger than 10.');
                            $submitted_data_validates = false;
                        }
                    }
                }
            }
            unset($this->request->data['User']['username']);
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                
                if (Configure::read('reset_forgotten_password_feature')) {
                    foreach ($this->User->getForgottenPasswordResetFormFields() as $question_field_name => $answer_field_name) {
                        if ($this->request->data['User'][$answer_field_name] === self::$database_user_encrypted_string) {
                            unset($this->request->data['User'][$question_field_name]);
                            unset($this->request->data['User'][$answer_field_name]);
                        } else {
                            $this->request->data['User'][$answer_field_name] = $this->User->hashSecuritAsnwer($this->request->data['User'][$answer_field_name]);
                        }
                    }
                }
                
                $this->User->addWritableField(array(
                    'group_id'
                ));
                if ($this->User->save($this->request->data)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Customize/Profiles/index');
                    return;
                }
            }
            
            // Reset username
            $this->request->data['User']['username'] = $user_data['User']['username'];
        }
    }
}