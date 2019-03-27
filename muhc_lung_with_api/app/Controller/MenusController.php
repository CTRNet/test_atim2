<?php

/**
 * Class MenusController
 */
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

    public function beforeFilter()
    {
        parent::beforeFilter();
        
        // Don't restrict the index action so that users with NO permissions
        // who have VALID login credentials will not trigger an infinite loop.
        if ($this->AtimAuth->user()) {
            $this->AtimAuth->allowedActions = array(
                'index'
            );
        }else{
            $this->redirect('/users/login');
        }
    }

    /**
     *
     * @param null $setOfMenus
     */
    public function index($setOfMenus = null)
    {
        if (! $setOfMenus) {
            $menuData = $this->Menu->find('all', array(
                'conditions' => array(
                    "Menu.parent_id" => "MAIN_MENU_1",
                    "Menu.flag_active" => 1
                ),
                'order' => 'Menu.display_order ASC'
            ));
            $this->set('atimMenu', $this->Menus->get('/menus'));
            
            // msg about expired messages
            $participantMessageModel = AppModel::getInstance('ClinicalAnnotation', 'ParticipantMessage', true);
            $this->set('dueMessagesCount', $participantMessageModel->find('count', array(
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
                        ),
                        array(
                            "Announcement.date_start <= '" . date("Y-m-d") . "'",
                            "Announcement.date_end >= '" . date("Y-m-d") . "'"
                        ),
                        array(
                            "Announcement.date_start <= '" . date("Y-m-d") . "'",
                            "Announcement.date_end IS NULL"
                        ),
                        array(
                            "Announcement.date_start  IS NULL",
                            "Announcement.date_end >= '" . date("Y-m-d") . "'"
                        )
                    )
                )
            );
            $announcementModel = AppModel::getInstance('', 'Announcement', true);
            $this->set('dueAnnoucementsCount', $announcementModel->find('count', array(
                'conditions' => $conditions
            )));
            
            // msg about unlinked participant collections
            $groupModel = AppModel::getInstance('', 'Group');
            $group = $groupModel->find('first', array(
                'conditions' => array(
                    'Group.id' => $this->Session->read('Auth.User.group_id')
                )
            ));
            $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection');
            $conditions = array(
                'Collection.collection_property' => 'participant collection',
                'Collection.participant_id' => null
            );
            if ($group['Group']['bank_id']) {
                $this->set('bankFilter', true);
                $conditions['Collection.bank_id'] = $group['Group']['bank_id'];
            }
            $this->set('unlinkedPartColl', $collectionModel->find('count', array(
                'conditions' => $conditions
            )));
            
            // msg about uncompleted user questions to reset forgotten password
            if (Configure::read('reset_forgotten_password_feature')) {
                $userModel = AppModel::getInstance('', 'User');
                $user = $userModel->find('first', array(
                    'conditions' => array(
                        'User.id' => $this->Session->read('Auth.User.id')
                    )
                ));
                $missingForgottenPasswordResetAnswers = false;
                foreach ($userModel->getForgottenPasswordResetFormFields() as $questionField => $answerField) {
                    if (! strlen($user['User'][$questionField]) || ! strlen($user['User'][$answerField]))
                        $missingForgottenPasswordResetAnswers = true;
                }
                $this->set('missingForgottenPasswordResetAnswers', $missingForgottenPasswordResetAnswers);
            }
            
            // ser questions to reset forgotten passwor
            
            if (ini_get("max_input_vars") <= Configure::read('databrowser_and_report_results_display_limit')) {
                AppController::addWarningMsg(__('PHP "max_input_vars" is <= than atim databrowser_and_report_results_display_limit'));
            }
            
            if (convertFromKMG(ini_get("upload_max_filesize")) <= Configure::read('maxUploadFileSize')) {
                AppController::addWarningMsg(__('warning_PHP upload_max_filesize is <= than atim maxUploadFileSize, problem in uploading'));
            }
            
            if (convertFromKMG(ini_get("post_max_size")) < convertFromKMG(ini_get("upload_max_filesize"))) {
                AppController::addWarningMsg(__('warning_PHP post_max_size is <= than upload_max_filesize, problem in uploading'));
            }
        } elseif ($setOfMenus == "tools") {
            $this->set('atimMenu', $this->Menus->get('/menus/tools'));
            $menuData = $this->Menu->find('all', array(
                'conditions' => array(
                    "Menu.parent_id" => "core_CAN_33",
                    "Menu.flag_active" => 1
                ),
                'order' => 'Menu.display_order ASC'
            ));
        } elseif ($setOfMenus == "datamart") {
            $menuData = $this->Menu->find('all', array(
                'conditions' => array(
                    "Menu.parent_id" => "qry-CAN-1",
                    "Menu.flag_active" => 1
                ),
                'order' => 'Menu.display_order ASC'
            ));
            $this->set('atimMenu', $this->Menus->get('/menus/Datamart/'));
        }
        
        foreach ($menuData as &$currentItem) {
            $currentItem['Menu']['at'] = false;
            $currentItem['Menu']['allowed'] = AppController::checkLinkPermission($currentItem['Menu']['use_link']);
        }
        
        $hookLink = $this->hook();
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('menuData', $menuData);
        $this->set('setOfMenus', $setOfMenus);
    }

    public function update()
    {
        $passedInVariables = $_GET;
        
        // set MENU array, based on passed in ALIAS
        
        $ajaxMenu = $this->Menus->get($passedInVariables['alias']);
        $this->set('ajaxMenu', $ajaxMenu);
        
        // set MENU VARIABLES
        
        // unset GET vars not needed for MENU
        unset($passedInVariables['alias']);
        unset($passedInVariables['url']);
        
        $ajaxMenuVariables = array();
        foreach ($passedInVariables as $key => $val) {
            
            // make corrections to var NAMES, due to frustrating cake/ajax functions
            $key = str_replace('amp;', '', $key);
            $key = str_replace('_', '.', $key);
            
            $ajaxMenuVariables[$key] = $val;
        }
        
        $this->set('ajaxMenuVariables', $ajaxMenuVariables);
    }
}