<?php

class MenusController extends AppController
{

    public $components = array(
        'Session',
        'SessionAcl'
    );

    public $uses = array(
        'Menu',
        'Announcement'
    );

    function beforeFilter()
    {
        parent::beforeFilter();
        
        // Don't restrict the index action so that users with NO permissions
        // who have VALID login credentials will not trigger an infinite loop.
        if ($this->Auth->user()) {
            $this->Auth->allowedActions = array(
                'index'
            );
        }
    }

    function index($set_of_menus = NULL)
    {
        if (! $set_of_menus) {
            $menu_data = $this->Menu->find('all', array(
                'conditions' => array(
                    "Menu.parent_id" => "MAIN_MENU_1",
                    "Menu.flag_active" => 1
                ),
                'order' => 'Menu.display_order ASC'
            ));
            $this->set('atim_menu', $this->Menus->get('/menus'));
            
            // msg about expired messages
            $participant_message_model = AppModel::getInstance('ClinicalAnnotation', 'ParticipantMessage', true);
            $this->set('due_messages_count', $participant_message_model->find('count', array(
                'conditions' => array(
                    'ParticipantMessage.done' => 0,
                    'ParticipantMessage.due_date <' => now()
                )
            )));
            
            // msg about due announcements
            $conditions = array(
                array(
                    'OR' => array(
                        array(
                            'Announcement.bank_id' => $_SESSION['Auth']['User']['Group']['bank_id']
                        ),
                        array(
                            'Announcement.group_id' => $_SESSION['Auth']['User']['group_id'],
                            'Announcement.user_id' => $_SESSION['Auth']['User']['id']
                        )
                    )
                ),
                array(
                    'OR' => array(
                        array(
                            "Announcement.date = '" . date("Y-m-d") . "'"
                        ),
                        array(
                            "Announcement.date_start <= '" . date("Y-m-d") . "'",
                            "Announcement.date_end >= '" . date("Y-m-d") . "'"
                        )
                    )
                )
            );
            $announcement_model = AppModel::getInstance('', 'Announcement', true);
            $this->set('due_annoucements_count', $announcement_model->find('count', array(
                'conditions' => $conditions
            )));
            
            // msg about unlinked participant collections
            $group_model = AppModel::getInstance('', 'Group');
            $group = $group_model->find('first', array(
                'conditions' => array(
                    'Group.id' => $this->Session->read('Auth.User.group_id')
                )
            ));
            $collection_model = AppModel::getInstance('InventoryManagement', 'Collection');
            $conditions = array(
                'Collection.collection_property' => 'participant collection',
                'Collection.participant_id' => null
            );
            if ($group['Group']['bank_id']) {
                $this->set('bank_filter', true);
                $conditions['Collection.bank_id'] = $group['Group']['bank_id'];
            }
            $this->set('unlinked_part_coll', $collection_model->find('count', array(
                'conditions' => $conditions
            )));
            
            // msg about uncompleted user questions to reset forgotten password
            if (Configure::read('reset_forgotten_password_feature')) {
                $user_model = AppModel::getInstance('', 'User');
                $user = $user_model->find('first', array(
                    'conditions' => array(
                        'User.id' => $this->Session->read('Auth.User.id')
                    )
                ));
                $missing_forgotten_password_reset_answers = false;
                foreach ($user_model->getForgottenPasswordResetFormFields() as $question_field => $answer_field) {
                    if (! strlen($user['User'][$question_field]) || ! strlen($user['User'][$answer_field]))
                        $missing_forgotten_password_reset_answers = true;
                }
                $this->set('missing_forgotten_password_reset_answers', $missing_forgotten_password_reset_answers);
            }
        } elseif ($set_of_menus == "tools") {
            $this->set('atim_menu', $this->Menus->get('/menus/tools'));
            $menu_data = $this->Menu->find('all', array(
                'conditions' => array(
                    "Menu.parent_id" => "core_CAN_33",
                    "Menu.flag_active" => 1
                ),
                'order' => 'Menu.display_order ASC'
            ));
        } elseif ($set_of_menus == "datamart") {
            $menu_data = $this->Menu->find('all', array(
                'conditions' => array(
                    "Menu.parent_id" => "qry-CAN-1",
                    "Menu.flag_active" => 1
                ),
                'order' => 'Menu.display_order ASC'
            ));
            $this->set('atim_menu', $this->Menus->get('/menus/Datamart/'));
        }
        
        foreach ($menu_data as &$current_item) {
            $current_item['Menu']['at'] = false;
            $current_item['Menu']['allowed'] = AppController::checkLinkPermission($current_item['Menu']['use_link']);
        }
        
        $hook_link = $this->hook();
        if ($hook_link) {
            require ($hook_link);
        }
        
        $this->set('menu_data', $menu_data);
        $this->set('set_of_menus', $set_of_menus);
    }

    function update()
    {
        $passed_in_variables = $_GET;
        
        // set MENU array, based on passed in ALIAS
        
        $ajax_menu = $this->Menus->get($passed_in_variables['alias']);
        $this->set('ajax_menu', $ajax_menu);
        
        // set MENU VARIABLES
        
        // unset GET vars not needed for MENU
        unset($passed_in_variables['alias']);
        unset($passed_in_variables['url']);
        
        $ajax_menu_variables = array();
        foreach ($passed_in_variables as $key => $val) {
            
            // make corrections to var NAMES, due to frustrating cake/ajax functions
            $key = str_replace('amp;', '', $key);
            $key = str_replace('_', '.', $key);
            
            $ajax_menu_variables[$key] = $val;
        }
        
        $this->set('ajax_menu_variables', $ajax_menu_variables);
    }
}