<?php

/**
 * Class AnnouncementsController
 */
App::uses('AdministrateAppController', 'Administrate.Controller');

class AnnouncementsController extends AdministrateAppController
{

    public $uses = array(
        'User',
        'Announcement',
        'Administrate.Bank'
    );

    public $paginate = array(
        'Announcement' => array(
            'order' => 'Announcement.date_start DESC'
        )
    );

    /**
     *
     * @param $linkedModel
     * @param int $bankOrUserId
     */
    public function add($linkedModel, $bankOrUserId = 0)
    {
        if ($linkedModel == 'user') {
            
            // Get user data
            
            $user = $this->User->getOrRedirect($bankOrUserId);
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $bankOrUserId
            ));
        } elseif ($linkedModel == 'bank') {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Banks/detail'));
            $this->set('atimMenuVariables', array(
                'Bank.id' => $bankOrUserId
            ));
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('linkedModel', $linkedModel);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            
            if ($linkedModel == 'bank') {
                $this->request->data['Announcement']['bank_id'] = $bankOrUserId;
                $this->Announcement->addWritableField(array(
                    'bank_id'
                ));
            } else {
                $this->request->data['Announcement']['user_id'] = $bankOrUserId;
                $this->Announcement->addWritableField(array(
                    'user_id'
                ));
            }
            
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->Announcement->save($this->request->data)) {
                    $urlToFlash = '/Administrate/Announcements/detail/' . $this->Announcement->id;
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), $urlToFlash);
                }
            }
        }
    }

    /**
     *
     * @param $linkedModel
     * @param int $bankOrUserId
     */
    public function index($linkedModel, $bankOrUserId = 0)
    {
        $conditions = array();
        
        if ($linkedModel == 'user') {
            
            // Get user data
            
            $user = $this->User->getOrRedirect($bankOrUserId);
            
            // Set conditions
            
            $conditions = array(
                'Announcement.user_id' => $bankOrUserId
            );
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $bankOrUserId
            ));
        } elseif ($linkedModel == 'bank') {
            
            // Set conditions
            
            $conditions = array(
                'Announcement.bank_id' => $bankOrUserId
            );
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Banks/detail'));
            $this->set('atimMenuVariables', array(
                'Bank.id' => $bankOrUserId
            ));
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('linkedModel', $linkedModel);
        
        $this->request->data = $this->paginate($this->Announcement, $conditions);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $announcementId
     */
    public function detail($announcementId = null)
    {
        $this->request->data = $this->Announcement->getOrRedirect($announcementId);
        
        if (isset($this->request->data['Announcement']['user_id'])) {
            
            $user = $this->User->getOrRedirect($this->request->data['Announcement']['user_id']);
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $this->request->data['Announcement']['user_id']
            ));
        } else {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Banks/detail'));
            $this->set('atimMenuVariables', array(
                'Bank.id' => $this->request->data['Announcement']['bank_id']
            ));
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $announcementId
     */
    public function edit($announcementId = null)
    {
        $announcementData = $this->Announcement->getOrRedirect($announcementId);
        
        if (isset($announcementData['Announcement']['user_id'])) {
            
            $user = $this->User->getOrRedirect($announcementData['Announcement']['user_id']);
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Announcement.id' => $announcementId,
                'Group.id' => $user['Group']['id'],
                'User.id' => $announcementData['Announcement']['user_id']
            ));
        } else {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Banks/detail'));
            $this->set('atimMenuVariables', array(
                'Announcement.id' => $announcementId,
                'Bank.id' => $announcementData['Announcement']['bank_id']
            ));
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            
            $this->request->data = $announcementData;
        } else {
            
            $this->Announcement->id = $announcementId;
            if ($this->Announcement->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Announcements/detail/' . $announcementId . '/');
            }
        }
    }

    /**
     *
     * @param null $announcementId
     */
    public function delete($announcementId = null)
    {
        
        // MANAGE DATA
        $announcementData = $this->Announcement->getOrRedirect($announcementId);
        if (empty($announcementData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->Announcement->allowDeletion($announcementId);
        
        $flashUrl = (! empty($announcementData['Announcement']['user_id'])) ? "/Administrate/Announcements/index/user/" . $announcementData['Announcement']['user_id'] : "/Administrate/Banks/detail/" . $announcementData['Announcement']['bank_id'];
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->Announcement->atimDelete($announcementId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), $flashUrl);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $flashUrl);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), $flashUrl /*'/Administrate/Announcements/detail/'.$announcementId.'/'*/);
        }
    }
}