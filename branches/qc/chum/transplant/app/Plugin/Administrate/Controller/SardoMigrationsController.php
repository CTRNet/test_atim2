<?php

class SardoMigrationsController extends AdministrateAppController
{

    var $uses = array(
        'Administrate.SardoImportSummary',
        'Administrate.SardoDataImportTry'
    );

    var $paginate = array(
        'SardoImportSummary' => array(
            'order' => 'SardoImportSummary.message_type ASC'
        ),
        'SardoDataImportTry' => array(
            'order' => 'SardoDataImportTry.datetime_try DESC'
        )
    );

    public function listAll($messageType = 'all')
    {
        if (! in_array($messageType, array('all', 'csv', 'profile_reproductive', 'main', 'tries'))) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->set('messageType', $messageType);
        
        if ($messageType == 'all') {
            
            // Main form
            
        } elseif ($messageType == 'csv') {
            
            // Export data in csv
            $config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data) ? $this->request->data[0] : array()));
            unset($this->request->data[0]);
            unset($this->request->data['Config']);
            $this->configureCsv($config);
            
            $this->Structures->set('qc_nd_sardo_migrations_messages', 'atim_structure_messages');
            
            $this->request->data = $this->SardoImportSummary->find('all', array());
            
            Configure::write('debug', 0);
            $this->layout = false;
            
        } elseif ($messageType == 'tries') {
            
            $this->Structures->set('qc_nd_sardo_migrations_summary', 'atim_structure_messages');
            $this->request->data = $this->paginate($this->SardoDataImportTry, array());
            
        } else {
            
            // Sub-Form (messages list)
            
            $this->Structures->set('qc_nd_sardo_migrations_messages', 'atim_structure_messages');
            
            $condtions = array();
            if ($messageType == 'profile_reproductive') {
                $condtions['SardoImportSummary.message_type'] = 'MESSAGE';
                $condtions['SardoImportSummary.message'] = 'Profile & Reproductive History Creation/Update summary';
            } else {
                $condtions[] = array(
                    'NOT' => array(
                        "SardoImportSummary.data_type" => "Process"
                    )
                );
                $condtions[] = array(
                    'NOT' => array(
                        "SardoImportSummary.message" => "Profile & Reproductive History Creation/Update summary"
                    )
                );
            }
            $this->request->data = $this->paginate($this->SardoImportSummary, $condtions);
            if (! $this->Session->read('flag_show_confidential')) {
                foreach ($this->request->data as &$newData) {
                    if ($newData['SardoImportSummary']['message'] == 'Creation/Update summary')
                        $newData['SardoImportSummary']['details'] = CONFIDENTIAL_MARKER;
                }
            }
        }
    }
}