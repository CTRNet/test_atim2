<?php

class StudySummariesController extends StudyAppController
{

    public $uses = array(
        'Study.StudySummary',
        
        'ClinicalAnnotation.MiscIdentifier',
        'ClinicalAnnotation.MiscIdentifierControl',
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.AliquotInternalUse',
        'Order.Order',
        'Order.OrderLine'
    );

    public $paginate = array(
        'StudySummary' => array(
            'limit' => 5,
            'order' => 'StudySummary.title'
        ),
        'Participant' => array(
            'limit' => 5,
            'order' => 'Participant.last_name ASC, Participant.first_name ASC'
        ),
        'MiscIdentifier' => array(
            'limit' => 5,
            'order' => 'MiscIdentifier.study_summary_id ASC,MiscIdentifierControl.misc_identifier_name ASC'
        ),
        'ConsentMaster' => array(
            'limit' => 5,
            'order' => 'ConsentMaster.date_first_contact ASC'
        ),
        'AliquotMaster' => array(
            'limit' => 5,
            'order' => 'AliquotMaster.barcode ASC'
        ),
        'Order' => array(
            'limit' => 5,
            'order' => 'Order.date_order_placed DESC'
        ),
        'OrderLine' => array(
            'limit' => 5,
            'order' => 'OrderLine.date_required DESC'
        ),
        'TmaSlide' => array(
            'limit' => 5,
            'order' => 'TmaSlide.barcode DESC'
        )
    );

    public function search($searchId = '')
    {
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->StudySummary, 'studysummaries', '/Study/StudySummaries/search');
        
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

    public function detail($studySummaryId)
    {
        // MANAGE DATA
        $this->request->data = $this->StudySummary->getOrRedirect($studySummaryId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        $this->Structures->set('empty', 'emptyStructure');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function add()
    {
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/search'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $submittedDataValidates = true;
            // ... special validations
            
            // 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->StudySummary->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudySummaries/detail/' . $this->StudySummary->id);
                }
            }
        }
    }

    public function edit($studySummaryId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studySummaryData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            // 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->StudySummary->id = $studySummaryId;
                if ($this->StudySummary->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudySummaries/detail/' . $studySummaryId);
                }
            }
        }
    }

    public function delete($studySummaryId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        
        $arrAllowDeletion = $this->StudySummary->allowDeletion($studySummaryId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // DELETE DATA
            if ($this->StudySummary->atimDelete($studySummaryId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Study/StudySummaries/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudySummaries/detail/' . $studySummaryId);
        }
    }

    public function listAllLinkedRecords($studySummaryId, $specificListHeader = null)
    {
        if (! $this->request->is('ajax')) {
            $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
            $this->set('atimMenuVariables', array(
                'StudySummary.id' => $studySummaryId
            ));
        }
        
        // $linkedRecordsProperties: Keep value to null or false if custom paginate has to be done
        $linkedRecordsProperties = array(
            'participants' => array(
                'ClinicalAnnotation.MiscIdentifier.study_summary_id',
                '/ClinicalAnnotation/MiscIdentifiers/listall/',
                'miscidentifiers_for_participant_search',
                '/ClinicalAnnotation/Participants/profile/%%Participant.id%%'
            ),
            'consents' => array(
                'ClinicalAnnotation.ConsentMaster.study_summary_id',
                '/ClinicalAnnotation/ConsentMasters/listall/',
                'consent_masters,consent_masters_study',
                '/ClinicalAnnotation/ConsentMasters/detail/%%ConsentMaster.participant_id%%/%%ConsentMaster.id%%'
            ),
            'aliquots' => array(
                'InventoryManagement.AliquotMaster.study_summary_id',
                '/InventoryManagement/AliquotMasters/detail/',
                'view_aliquot_joined_to_sample_and_collection',
                '/InventoryManagement/AliquotMasters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%'
            ),
            'aliquot uses' => array(
                'InventoryManagement.AliquotInternalUse.study_summary_id',
                '/InventoryManagement/AliquotMasters/detail/',
                'aliquotinternaluses',
                '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%'
            ),
            'orders' => array(
                'Order.Order.default_study_summary_id',
                '/Order/Orders/detail/',
                'orders',
                '/Order/Orders/detail/%%Order.id%%'
            ),
            'order lines' => array(
                'Order.OrderLine.study_summary_id',
                '/Order/Orders/detail/',
                'orders,orderlines',
                '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%'
            ),
            'tma slides' => array(
                'StorageLayout.TmaSlide.study_summary_id',
                '/StorageLayout/TmaSlides/detail/',
                'tma_slides,tma_blocks_for_slide_creation',
                '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%'
            ),
            'tma slide uses' => array(
                'StorageLayout.TmaSlideUse.study_summary_id',
                '/StorageLayout/TmaSlideUses/listAll/',
                'tma_slide_uses,tma_slides_for_use_creation',
                '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%'
            )
        );
        
        $hookLink = $this->hook('format_properties');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! $specificListHeader) {
            
            // Manage All Lists Display
            $this->set('linkedRecordsHeaders', array_keys($linkedRecordsProperties));
        } else {
            
            // Manage Display Of A Specific List
            if (! array_key_exists($specificListHeader, $linkedRecordsProperties))
                $this->redirect('/Pages/err_plugin_system_error', null, true);
            if ($linkedRecordsProperties[$specificListHeader]) {
                list ($pluginModelForeignKey, $permissionLink, $structureAlias, $detailsUrl) = $linkedRecordsProperties[$specificListHeader];
                list ($plugin, $model, $foreignKey) = explode('.', $pluginModelForeignKey);
                if (! isset($this->{$model})) {
                    $this->{$model} = AppModel::getInstance($plugin, $model, true);
                }
                $this->request->data = $this->paginate($this->{$model}, array(
                    "$model.$foreignKey" => $studySummaryId
                ));
                $this->Structures->set($structureAlias);
                $this->set('detailsUrl', $detailsUrl);
                $this->set('permissionLink', $permissionLink);
            } else {
                // Manage custom display
                $hookLink = $this->hook('format_custom_list_display');
                if ($hookLink) {
                    require ($hookLink);
                }
            }
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function autocompleteStudy()
    {
        
        // -- NOTE ----------------------------------------------------------
        //
        // This function is linked to functions of the StudySummary model
        // called getStudyIdFromStudyDataAndCode() and
        // getStudyDataAndCodeForDisplay().
        //
        // When you override the autocompleteStudy() function, check
        // if you need to override these functions.
        //
        // ------------------------------------------------------------------
        
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        // query the database
        $term = str_replace(array( "\\", '%', '_'), array("\\\\", '\%', '\_'), $_GET['term']);
        $terms = array();
        foreach (explode(' ', $term) as $keyWord) {
        	$terms[] = array("StudySummary.title LIKE" => '%'.$keyWord.'%');
        }
		
        $conditions = array(
            'AND' => $terms
        );
        $fields = 'StudySummary.*';
        $order = 'StudySummary.title ASC';
        $joins = array();
        
        $hookLink = $this->hook('query_args');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $data = $this->StudySummary->find('all', array(
            'conditions' => $conditions,
            'fields' => $fields,
            'order' => $order,
            'joins' => $joins,
            'limit' => 10
        ));
        
        // build javascript textual array
        $result = "";
        foreach ($data as $dataUnit) {
            $result .= '"' . str_replace(array('\\', '"'), array('\\\\', '\"'), $this->StudySummary->getStudyDataAndCodeForDisplay($dataUnit)) . '", ';
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('result', "[" . $result . "]");
    }
}