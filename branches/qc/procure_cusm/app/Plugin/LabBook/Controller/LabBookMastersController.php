<?php

/**
 * Class LabBookMastersController
 */
class LabBookMastersController extends LabBookAppController
{

    public $components = array();

    public $uses = array(
        'Labbook.LabBookMaster',
        'Labbook.LabBookControl',
        
        'InventoryManagement.SampleMaster',
        'InventoryManagement.Realiquoting',
        'InventoryManagement.DerivativeDetail'
    );

    public $paginate = array(
        'LabBookMaster' => array(
            'order' => 'LabBookMaster.created ASC'
        )
    );

    /*
     * --------------------------------------------------------------------------
     * DISPLAY FUNCTIONS
     * --------------------------------------------------------------------------
     */
    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/labbook/LabBookMasters/search/'));
        $this->searchHandler($searchId, $this->LabBookMaster, 'labbookmasters', '/labbook/LabBookMasters/search');
        
        // find all lab_book data control types to build add button
        $this->set('labBookControlsList', $this->LabBookControl->find('all', array(
            'conditions' => array(
                'LabBookControl.flag_active' => '1'
            )
        )));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }

    /**
     *
     * @param $labBookMasterId
     * @param bool $fullDetailScreen
     */
    public function detail($labBookMasterId, $fullDetailScreen = true)
    {
        if (! $labBookMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } elseif ($labBookMasterId == '-1') {
            $this->atimFlashWarning(__('no lab book is linked to this record'), "javascript:history.back()");
            return;
        }
        
        // MAIN FORM
        
        $labBook = $this->LabBookMaster->getOrRedirect($labBookMasterId);
        $this->request->data = $labBook;
        
        $this->set('atimMenu', $this->Menus->get('/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'));
        $this->set('atimMenuVariables', array(
            'LabBookMaster.id' => $labBookMasterId
        ));
        
        $this->Structures->set($labBook['LabBookControl']['form_alias']);
        
        $this->set('fullDetailScreen', $fullDetailScreen);
        
        if ($fullDetailScreen) {
            
            // DERIVATIVES
            $this->set('derivativesList', $this->LabBookMaster->getLabBookDerivativesList($labBookMasterId));
            $this->Structures->set('lab_book_derivatives_summary', 'lab_book_derivatives_summary');
            
            // REALIQUOTINGS
            $this->set('realiquotingsList', $this->LabBookMaster->getLabBookRealiquotingsList($labBookMasterId));
            $this->Structures->set('lab_book_realiquotings_summary', 'lab_book_realiquotings_summary');
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $controlId
     * @param bool $isAjax
     */
    public function add($controlId, $isAjax = false)
    {
        if (! $controlId) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($isAjax) {
            $this->layout = 'ajax';
            Configure::write('debug', 0);
        }
        $this->set('isAjax', $isAjax);
        
        // MANAGE DATA
        
        $controlData = $this->LabBookControl->getOrRedirect($controlId);
        $this->set('bookType', __($controlData['LabBookControl']['book_type']));
        $initialData = array();
        $initialData['LabBookMaster']['lab_book_control_id'] = $controlId;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Set menu
        $atimMenu = $this->Menus->get(isset($_SESSION['batch_process_data']['lab_book_menu']) ? $_SESSION['batch_process_data']['lab_book_menu'] : '/labbook/LabBookMasters/index/');
        $this->set('atimMenu', $atimMenu);
        
        $this->set('atimMenuVariables', array(
            'LabBookControl.id' => $controlId
        ));
        
        // set structure alias based on VALUE from CONTROL table
        $this->Structures->set($controlData['LabBookControl']['form_alias']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $initialData;
        } else {
            // Validates and set additional data
            $submittedDataValidates = true;
            
            $this->LabBookMaster->set($this->request->data);
            if (! $this->LabBookMaster->validates()) {
                $submittedDataValidates = false;
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save lab_book data data
                $boolSaveDone = true;
                
                $this->LabBookMaster->id = null;
                if ($this->LabBookMaster->save($this->request->data, false)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $urlToRedirect = '/labbook/LabBookMasters/detail/' . $this->LabBookMaster->id;
                    if (isset($_SESSION['batch_process_data']['lab_book_next_step'])) {
                        $urlToRedirect = $_SESSION['batch_process_data']['lab_book_next_step'];
                    }
                    if ($isAjax) {
                        echo $this->request->data['LabBookMaster']['code'];
                        exit();
                    } else {
                        $this->atimFlash(__('your data has been saved'), $urlToRedirect);
                    }
                }
            }
        }
    }

    /**
     *
     * @param $labBookMasterId
     */
    public function edit($labBookMasterId)
    {
        if (! $labBookMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the lab_book data data
        $labBook = $this->LabBookMaster->getOrRedirect($labBookMasterId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Set menu
        $this->set('atimMenu', $this->Menus->get('/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'));
        $this->set('atimMenuVariables', array(
            'LabBookMaster.id' => $labBookMasterId
        ));
        
        // set structure alias based on VALUE from CONTROL table
        $this->Structures->set($labBook['LabBookControl']['form_alias']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $labBook;
        } else {
            // Validates and set additional data
            $submittedDataValidates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->LabBookMaster->id = $labBookMasterId;
                if ($this->LabBookMaster->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->LabBookMaster->synchLabbookRecords($labBookMasterId, $this->request->data['LabBookDetail']);
                    $this->atimFlash(__('your data has been updated'), '/labbook/LabBookMasters/detail/' . $labBookMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $labBookMasterId
     */
    public function editSynchOptions($labBookMasterId)
    {
        if (! $labBookMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the lab_book data data
        $labBook = $this->LabBookMaster->getOrRedirect($labBookMasterId);
        
        $this->Structures->set('lab_book_derivatives_summary', 'lab_book_derivatives_summary');
        $this->Structures->set('lab_book_realiquotings_summary', 'lab_book_realiquotings_summary');
        
        $this->set('atimMenu', $this->Menus->get('/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'));
        $this->set('atimMenuVariables', array(
            'LabBookMaster.id' => $labBookMasterId
        ));
        
        // set structure alias based on VALUE from CONTROL table
        $this->Structures->set($labBook['LabBookControl']['form_alias']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = array(
                'derivative' => $this->LabBookMaster->getLabBookDerivativesList($labBookMasterId),
                'realiquoting' => $this->LabBookMaster->getLabBookRealiquotingsList($labBookMasterId)
            );
        } else {
            
            // Validates and set additional data
            $submittedDataValidates = true;
            
            if (isset($this->request->data['derivative'])) {
                foreach ($this->request->data['derivative'] as $newRecord) {
                    $this->DerivativeDetail->set($newRecord);
                    if (! $this->DerivativeDetail->validates())
                        $submittedDataValidates = false;
                }
            }
            
            if (isset($this->request->data['realiquoting'])) {
                foreach ($this->request->data['realiquoting'] as $newRecord) {
                    $this->Realiquoting->set($newRecord);
                    if (! $this->Realiquoting->validates())
                        $submittedDataValidates = false;
                }
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if (isset($this->request->data['derivative'])) {
                    $hookLinkDerivative = $this->hook('postsave_process_derivative');
                    foreach ($this->request->data['derivative'] as $newRecord) {
                        $this->DerivativeDetail->id = $newRecord['DerivativeDetail']['id'];
                        if (! $this->DerivativeDetail->save(array(
                            'DerivativeDetail' => $newRecord['DerivativeDetail']
                        ), false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        if ($hookLinkDerivative) {
                            require ($hookLinkDerivative);
                        }
                    }
                }
                
                if (isset($this->request->data['realiquoting'])) {
                    $hookLinkRealiquoting = $this->hook('postsave_process_realiquoting');
                    foreach ($this->request->data['realiquoting'] as $newRecord) {
                        $this->Realiquoting->id = $newRecord['Realiquoting']['id'];
                        if (! $this->Realiquoting->save(array(
                            'Realiquoting' => $newRecord['Realiquoting']
                        ), false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        if ($hookLinkRealiquoting) {
                            require ($hookLinkRealiquoting);
                        }
                    }
                }
                
                $this->LabBookMaster->synchLabbookRecords($labBookMasterId, $labBook['LabBookDetail']);
                
                $this->atimFlash(__('your data has been updated'), '/labbook/LabBookMasters/detail/' . $labBookMasterId);
            }
        }
    }

    /**
     *
     * @param $labBookMasterId
     */
    public function delete($labBookMasterId)
    {
        if (! $labBookMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $labBookData = $this->LabBookMaster->getOrRedirect($labBookMasterId);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->LabBookMaster->allowLabBookDeletion($labBookMasterId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook();
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->LabBookMaster->atimDelete($labBookMasterId, true)) {
                $this->atimFlash(__('your data has been deleted'), '/labbook/LabBookMasters/index/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/labbook/LabBookMasters/index/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/labbook/LabBookMasters/detail/' . $labBookMasterId);
        }
    }

    public function autocomplete()
    {
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        $term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
        $this->set('result', $this->LabBookMaster->find('list', array(
            'fields' => array(
                'LabBookMaster.code'
            ),
            'conditions' => array(
                'LabBookMaster.code LIKE ' => $term . '%'
            ),
            'limit' => 10
        )));
    }
}