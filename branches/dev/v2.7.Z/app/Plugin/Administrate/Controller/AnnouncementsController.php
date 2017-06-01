<?php

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

    function add($linked_model, $bank_or_group_id = 0, $user_id = 0)
    {
        if ($linked_model == 'user') {
            
            // Get user data
            
            $user = $this->User->getOrRedirect($user_id);
            if ($user['Group']['id'] != $bank_or_group_id) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atim_menu_variables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $user_id
            ));
        } else 
            if ($linked_model == 'bank') {
                
                // MANAGE FORM, MENU AND ACTION BUTTONS
                
                $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/bank'));
                $this->set('atim_menu_variables', array(
                    'Bank.id' => $bank_or_group_id
                ));
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        
        $this->set('linked_model', $linked_model);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (! empty($this->request->data)) {
            
            if ($linked_model == 'bank') {
                $this->request->data['Announcement']['bank_id'] = $bank_or_group_id;
                $this->Announcement->addWritableField(array(
                    'bank_id'
                ));
            } else {
                $this->request->data['Announcement']['group_id'] = $bank_or_group_id;
                $this->request->data['Announcement']['user_id'] = $user_id;
                $this->Announcement->addWritableField(array(
                    'group_id',
                    'user_id'
                ));
            }
            
            $submitted_data_validates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                if ($this->Announcement->save($this->request->data)) {
                    $url_to_flash = '/Administrate/Announcements/detail/' . $this->Announcement->id;
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been saved'), $url_to_flash);
                }
            }
        }
    }

    function index($linked_model, $bank_or_group_id = 0, $user_id = 0)
    {
        $conditions = array();
        
        if ($linked_model == 'user') {
            
            // Get user data
            
            $user = $this->User->getOrRedirect($user_id);
            if ($user['Group']['id'] != $bank_or_group_id) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Set conditions
            
            $conditions = array(
                'Announcement.group_id' => $bank_or_group_id,
                'Announcement.user_id' => $user_id
            );
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atim_menu_variables', array(
                'Group.id' => $user['Group']['id'],
                'User.id' => $user_id
            ));
        } else 
            if ($linked_model == 'bank') {
                
                // Set conditions
                
                $conditions = array(
                    'Announcement.bank_id' => $bank_or_group_id
                );
                
                // MANAGE FORM, MENU AND ACTION BUTTONS
                
                $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/bank'));
                $this->set('atim_menu_variables', array(
                    'Bank.id' => $bank_or_group_id
                ));
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        
        $this->set('linked_model', $linked_model);
        
        $this->request->data = $this->paginate($this->Announcement, $conditions);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function detail($announcement_id = null)
    {
        $this->request->data = $this->Announcement->getOrRedirect($announcement_id);
        
        if (isset($this->request->data['Announcement']['user_id'])) {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atim_menu_variables', array(
                'Group.id' => $this->request->data['Announcement']['group_id'],
                'User.id' => $this->request->data['Announcement']['user_id']
            ));
        } else {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/bank'));
            $this->set('atim_menu_variables', array(
                'Bank.id' => $this->request->data['Announcement']['bank_id']
            ));
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function edit($announcement_id = null)
    {
        $announcement_data = $this->Announcement->getOrRedirect($announcement_id);
        
        if (isset($announcement_data['Announcement']['user_id'])) {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/user'));
            $this->set('atim_menu_variables', array(
                'Group.id' => $announcement_data['Announcement']['group_id'],
                'User.id' => $announcement_data['Announcement']['user_id']
            ));
        } else {
            
            // MANAGE FORM, MENU AND ACTION BUTTONS
            
            $this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/bank'));
            $this->set('atim_menu_variables', array(
                'Bank.id' => $announcement_data['Announcement']['bank_id']
            ));
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            
            $this->request->data = $announcement_data;
        } else {
            
            $this->Announcement->id = $announcement_id;
            if ($this->Announcement->save($this->request->data)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been updated'), '/Administrate/Announcements/detail/' . $announcement_id . '/');
            }
        }
    }

    function delete($announcement_id = null)
    {
        
        // MANAGE DATA
        $announcement_data = $this->Announcement->getOrRedirect($announcement_id);
        if (empty($announcement_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arr_allow_deletion = $this->Announcement->allowDeletion($announcement_id);
        
        $flash_url = (! empty($announcement_data['Announcement']['user_id'])) ? "/Administrate/Announcements/index/user/" . $announcement_data['Announcement']['group_id'] . '/' . $announcement_data['Announcement']['user_id'] : "/Administrate/Announcements/index/bank/" . $announcement_data['Announcement']['bank_id'];
        
        // CUSTOM CODE
        $hook_link = $this->hook('delete');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($arr_allow_deletion['allow_deletion']) {
            if ($this->Announcement->atimDelete($announcement_id)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been deleted'), $flash_url);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $flash_url);
            }
        } else {
            $this->atimFlashWarning(__($arr_allow_deletion['msg']), $flash_url /*'/Administrate/Announcements/detail/'.$announcement_id.'/'*/);
        }
    }
}