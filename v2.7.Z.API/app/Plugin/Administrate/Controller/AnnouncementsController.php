<?php

/**
 * Class AnnouncementsController
 */
class AnnouncementsController extends AdministrateAppController
{

    public $uses = array(
        'User',
        'Administrate.Announcement',
        'Administrate.Bank'
    );

    public $paginate = array(
        'Announcement' => array(
            'order' => 'Announcement.date_start DESC'
        )
    );

    /**
     * @param $linkedModel
     * @param int $bankOrGroupId
     * @param int $userId
     */
    public function add($linkedModel, $bankOrGroupId = 0, $userId = 0)
    {
        if ($linkedModel == 'user') {
            
            // Get user data
            
            $user = $this->User->getOrRedirect($userId);
            if ($user['Group']['id'] != $bankOrGroupId) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $userId
            ));
        } elseif ($linkedModel == 'bank') {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/bank'));
            $this->set('atimMenuVariables', array(
                'Bank.id' => $bankOrGroupId
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
                $this->request->data['Announcement']['bank_id'] = $bankOrGroupId;
                $this->Announcement->addWritableField(array(
                    'bank_id'
                ));
            } else {
                $this->request->data['Announcement']['group_id'] = $bankOrGroupId;
                $this->request->data['Announcement']['user_id'] = $userId;
                $this->Announcement->addWritableField(array(
                    'group_id',
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
     * @param $linkedModel
     * @param int $bankOrGroupId
     * @param int $userId
     */
    public function index($linkedModel, $bankOrGroupId = 0, $userId = 0)
    {
        $conditions = array();
        
        if ($linkedModel == 'user') {
            
            // Get user data
            
            $user = $this->User->getOrRedirect($userId);
            if ($user['Group']['id'] != $bankOrGroupId) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Set conditions
            
            $conditions = array(
                'Announcement.group_id' => $bankOrGroupId,
                'Announcement.user_id' => $userId
            );
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $userId
            ));
        } elseif ($linkedModel == 'bank') {
            
            // Set conditions
            
            $conditions = array(
                'Announcement.bank_id' => $bankOrGroupId
            );
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/bank'));
            $this->set('atimMenuVariables', array(
                'Bank.id' => $bankOrGroupId
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
     * @param null $announcementId
     */
    public function detail($announcementId = null)
    {
        $this->request->data = $this->Announcement->getOrRedirect($announcementId);
        
        if (isset($this->request->data['Announcement']['user_id'])) {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $this->request->data['Announcement']['group_id'],
                'User.id' => $this->request->data['Announcement']['user_id']
            ));
        } else {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/bank'));
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
     * @param null $announcementId
     */
    public function edit($announcementId = null)
    {
        $announcementData = $this->Announcement->getOrRedirect($announcementId);
        
        if (isset($announcementData['Announcement']['user_id'])) {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atimMenuVariables', array(
                'Group.id' => $announcementData['Announcement']['group_id'],
                'User.id' => $announcementData['Announcement']['user_id']
            ));
        } else {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atimMenu', $this->Menus->get('/Administrate/Announcements/index/bank'));
            $this->set('atimMenuVariables', array(
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
        
        $flashUrl = (! empty($announcementData['Announcement']['user_id'])) ? "/Administrate/Announcements/index/user/" . $announcementData['Announcement']['group_id'] . '/' . $announcementData['Announcement']['user_id'] : "/Administrate/Announcements/index/bank/" . $announcementData['Announcement']['bank_id'];
        
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