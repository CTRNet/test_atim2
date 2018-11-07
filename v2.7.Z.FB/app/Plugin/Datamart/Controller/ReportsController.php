<?php

/**
 * Class ReportsController
 */
class ReportsController extends DatamartAppController
{

    public $uses = array(
        "Datamart.Report",
        "Datamart.DatamartStructure",
        "Datamart.BrowsingResult",
        "Datamart.BatchSet",
        "Structure"
    );

    public $paginate = array(
        'Report' => array(
            'order' => 'Report.name ASC'
        )
    );
    
    // -------------------------------------------------------------------------------------------------------------------
    // SELECT APP . 'View' . DS . 'Elements' . DS vs BATCHSET OR NODE DISTRIBUTION (trunk report)
    // -------------------------------------------------------------------------------------------------------------------
    /**
     *
     * @param $typeOfObjectToCompare
     * @param $batchSetOrNodeIdToCompare
     * @param bool $csvCreation
     * @param null $previousCurrentNodeId
     */
    public function compareToBatchSetOrNode($typeOfObjectToCompare, $batchSetOrNodeIdToCompare, $csvCreation = false, $previousCurrentNodeId = null)
    {
        // Get data of object to compare
        $comparedObjectDatamartStructureId = null;
        $comparedObjectElementIds = array();
        $selectedObjectTitle = null;
        switch ($typeOfObjectToCompare) {
            case 'batchset':
                // Get batch set data and check permissions on selected batch set
                $selectedBatchset = $this->BatchSet->getOrRedirect($batchSetOrNodeIdToCompare);
                if (! $this->BatchSet->isUserAuthorizedToRw($selectedBatchset, true))
                    return;
                if (! AppController::checkLinkPermission($selectedBatchset['DatamartStructure']['index_link'])) {
                    $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
                    return;
                }
                $comparedObjectDatamartStructureId = $selectedBatchset['DatamartStructure']['id'];
                foreach ($selectedBatchset['BatchId'] as $tmp)
                    $comparedObjectElementIds[] = $tmp['lookup_id'];
                $selectedObjectTitle = 'batchset';
                break;
            case 'node':
                $selectedDatabrowserNode = $this->BrowsingResult->findById($batchSetOrNodeIdToCompare);
                $comparedObjectDatamartStructureId = $selectedDatabrowserNode['DatamartStructure']['id'];
                $comparedObjectElementIds = explode(',', $selectedDatabrowserNode['BrowsingResult']['id_csv']);
                $selectedObjectTitle = 'databrowser node';
                break;
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get selected elements of either previous batchset or report or databrowser node
        $selectedElementsDatamartStructureData = null;
        $previouslyDisplayedObjectTitle = null;
        $tmpNodeOfSelectedElements = null;
        if ($previousCurrentNodeId) {
            // User just launched process to compare 2 nodes
            if (! empty($this->request->data))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                // Launched process from databrowser node on selected elements
            $tmpNodeOfSelectedElements = $this->BrowsingResult->findById($previousCurrentNodeId);
            $selectedElementsDatamartStructureData = array(
                'DatamartStructure' => $tmpNodeOfSelectedElements['DatamartStructure']
            );
            $previouslyDisplayedObjectTitle = 'databrowser node';
        } elseif (empty($this->request->data)) {
            // Sort on displayed data based on selected field
            if (! array_key_exists('sort', $this->passedArgs))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $selectedElementsDatamartStructureData = $this->DatamartStructure->findById($_SESSION['compareToBatchSetOrNode']['datamart_structure_id']);
            $previouslyDisplayedObjectTitle = $_SESSION['compareToBatchSetOrNode']['previously_displayed_object_title'];
        } elseif (array_key_exists('Config', $this->request->data) && $csvCreation) {
            // Export data in csv
            $config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data) ? $this->request->data[0] : array()));
            unset($this->request->data[0]);
            unset($this->request->data['Config']);
            $this->configureCsv($config);
            $selectedElementsDatamartStructureData = $this->DatamartStructure->findById($_SESSION['compareToBatchSetOrNode']['datamart_structure_id']);
            $previouslyDisplayedObjectTitle = $_SESSION['compareToBatchSetOrNode']['previously_displayed_object_title'];
        } elseif (array_key_exists('Report', $this->request->data)) {
            // Launched process from report on selected elements
            $selectedElementsDatamartStructureData = $this->DatamartStructure->findById($this->request->data['Report']['datamart_structure_id']);
            $previouslyDisplayedObjectTitle = 'report';
        } elseif (array_key_exists('node', $this->request->data)) {
            // Launched process from databrowser node on selected elements
            $tmpNodeOfSelectedElements = $this->BrowsingResult->findById($this->request->data['node']['id']);
            $selectedElementsDatamartStructureData = array(
                'DatamartStructure' => $tmpNodeOfSelectedElements['DatamartStructure']
            );
            $previouslyDisplayedObjectTitle = 'databrowser node';
        } elseif (array_key_exists('BatchSet', $this->request->data)) {
            // Launched process from previous batchset on selected elements
            $tmpBatchsetOfSelectedElements = $this->BatchSet->getOrRedirect($this->request->data['BatchSet']['id']);
            if (! $this->BatchSet->isUserAuthorizedToRw($tmpBatchsetOfSelectedElements, true))
                return;
            $selectedElementsDatamartStructureData = array(
                'DatamartStructure' => $tmpBatchsetOfSelectedElements['DatamartStructure']
            );
            $previouslyDisplayedObjectTitle = 'batchset';
        }
        
        // Get shared datamart structure
        if (! $selectedElementsDatamartStructureData || ($selectedElementsDatamartStructureData['DatamartStructure']['id'] != $comparedObjectDatamartStructureId))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $datamartStructure = $selectedElementsDatamartStructureData['DatamartStructure']; // Same Datamart Structure
        $this->set('$datamartStructureId', $datamartStructure['id']);
        
        // Get selected elements ids
        $model = null;
        $lookupKeyName = null;
        $modelInstance = null;
        $controlForeignKey = null;
        $studiedElementIdsToExport = null;
        if ($datamartStructure['control_master_model']) {
            if (isset($this->request->data[$datamartStructure['model']])) {
                $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
                $model = $datamartStructure['model'];
                $lookupKeyName = $modelInstance->primaryKey;
            } else {
                $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['control_master_model'], true);
                $model = $datamartStructure['control_master_model'];
                $lookupKeyName = $modelInstance->primaryKey;
            }
            $controlForeignKey = $modelInstance->getControlForeign();
        } else {
            $model = $datamartStructure['model'];
            $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
            $lookupKeyName = $modelInstance->primaryKey;
        }
        if ($csvCreation) {
            // Export data to csv
            $studiedElementIdsToExport = $this->request->data[$model][$lookupKeyName];
            $this->request->data[$model][$lookupKeyName] = explode(",", $_SESSION['compareToBatchSetOrNode']['selected_elements_ids']);
            // Nothing to do, selected elements are already submitted by form and recorded into $this->request->data[ $model ][ $lookupKeyName ]
        } elseif ($tmpNodeOfSelectedElements && ($previousCurrentNodeId || $this->request->data[$model][$lookupKeyName] == 'all')) {
            // Launched from node with elements > display limit or launched to compare 2 nodes: get all ids of node
            $this->request->data[$model][$lookupKeyName] = explode(",", $tmpNodeOfSelectedElements['BrowsingResult']['id_csv']);
        } elseif (empty($this->request->data)) {
            // Sort data
            $this->request->data[$model][$lookupKeyName] = explode(",", $_SESSION['compareToBatchSetOrNode']['selected_elements_ids']);
        }
        $selectedElementsIds = array_filter($this->request->data[$model][$lookupKeyName]);
        
        // Get diff results
        $allStudiedElements = $modelInstance->find('all', array(
            'conditions' => array(
                "$model.$lookupKeyName" => array_merge($comparedObjectElementIds, $selectedElementsIds)
            )
        ));
        $elementsIdsJustInSelectedObject = array_diff($comparedObjectElementIds, $selectedElementsIds);
        $elementsIdsJustInPreviouslyDispObject = array_diff($selectedElementsIds, $comparedObjectElementIds);
        $sortedAllStudiedElements = array(
            '1' => array(),
            '2' => array(),
            '3' => array()
        );
        $controlMasterIds = array();
        foreach ($allStudiedElements as $newStudiedElement) {
            if ($csvCreation && ! in_array($newStudiedElement[$model][$lookupKeyName], $studiedElementIdsToExport))
                continue;
            if ($controlForeignKey) {
                $controlMasterId = $newStudiedElement[$model][$controlForeignKey];
                $controlMasterIds[$controlMasterId] = $controlMasterId;
            }
            if (in_array($newStudiedElement[$model][$lookupKeyName], $elementsIdsJustInSelectedObject)) {
                $newStudiedElement['Generated']['batchset_and_node_elements_distribution_description'] = str_replace('%s_2', $selectedObjectTitle, __('data of selected %s_2 only (2)'));
                $sortedAllStudiedElements[3][] = $newStudiedElement;
            } elseif (in_array($newStudiedElement[$model][$lookupKeyName], $elementsIdsJustInPreviouslyDispObject)) {
                $newStudiedElement['Generated']['batchset_and_node_elements_distribution_description'] = str_replace('%s_1', $previouslyDisplayedObjectTitle, __("data of previously displayed %s_1 only (1)"));
                $sortedAllStudiedElements[2][] = $newStudiedElement;
            } else {
                $newStudiedElement['Generated']['batchset_and_node_elements_distribution_description'] = str_replace(array(
                    '%s_1',
                    '%s_2'
                ), array(
                    $previouslyDisplayedObjectTitle,
                    $selectedObjectTitle
                ), __('data both in previously displayed %s_1 and selected %s_2 (1 & 2)'));
                $sortedAllStudiedElements[1][] = $newStudiedElement;
            }
        }
        $diffResultsData = array_merge($sortedAllStudiedElements[1], $sortedAllStudiedElements[2], $sortedAllStudiedElements[3]);
        $this->set('diffResultsData', AppModel::sortWithUrl($diffResultsData, $this->passedArgs));
        
        // Manage structure for display
        $structureAlias = null;
        if ($controlMasterIds && (sizeof($controlMasterIds) == 1)) {
            $controlMasterId = array_shift($controlMasterIds);
            AppModel::getInstance("Datamart", "Browser", true);
            $alternateInfo = Browser::getAlternateStructureInfo($datamartStructure['plugin'], $modelInstance->getControlName(), $controlMasterId);
            $structureAlias = $alternateInfo['form_alias'];
        } else {
            $this->Structure = AppModel::getInstance("", "Structure", true);
            $atimStructureData = $this->Structure->find('first', array(
                'conditions' => array(
                    'Structure.id' => $datamartStructure['structure_id']
                ),
                'recursive' => - 1
            ));
            $structureAlias = $atimStructureData['structure']['Structure']['alias'];
        }
        $this->set('atimStructureForResults', $this->Structures->get('form', 'batchset_and_node_elements_distribution,' . $structureAlias));
        $this->set('datamartStructureId', $datamartStructure['id']);
        $this->set('typeOfObjectToCompare', $typeOfObjectToCompare);
        $this->set('batchSetOrNodeIdToCompare', $batchSetOrNodeIdToCompare);
        $this->set('csvCreation', $csvCreation);
        $this->set('header1', str_replace('%s_1', $previouslyDisplayedObjectTitle, __('data of previously displayed %s_1 (1)')));
        $this->set('header2', str_replace('%s_2', $selectedObjectTitle, __('data of selected %s_2 (2)')));
        
        if ($csvCreation) {
            // CSV cretion
            Configure::write('debug', 0);
            $this->layout = false;
        } else {
            // Results display
            // - Manage drop down action
            $this->set('datamartStructureModelName', $model);
            $this->set('datamartStructureKeyName', $lookupKeyName);
            if ($datamartStructure['index_link'])
                $this->set('datamartStructureLinks', $datamartStructure['index_link']);
            $datamartStructureActions = $this->DatamartStructure->getDropdownOptions($datamartStructure['plugin'], $datamartStructure['model'], $modelInstance->primaryKey, null, $datamartStructure['model'], $modelInstance->primaryKey);
            foreach ($datamartStructureActions as $key => $newAction) {
                if ($newAction['value'] && strpos($newAction['value'], 'Datamart/Csv/csv'))
                    unset($datamartStructureActions[$key]);
            }
            $sortArgs = array_key_exists('sort', $this->passedArgs) ? 'sort:' . $this->passedArgs['sort'] . '/direction:' . $this->passedArgs['direction'] : '';
            $csvAction = "javascript:setCsvPopup('Datamart/Reports/compareToBatchSetOrNode/$typeOfObjectToCompare/$batchSetOrNodeIdToCompare/1/$sortArgs');";
            $datamartStructureActions[] = array(
                'label' => __('export as CSV file (comma-separated values)'),
                'value' => sprintf($csvAction, 0)
            );
            $datamartStructureActions[] = array(
                'label' => __("initiate browsing"),
                'value' => "Datamart/Browser/batchToDatabrowser/" . $datamartStructure['model'] . "/report/"
            );
            $this->set('datamartStructureActions', $datamartStructureActions);
            // - Add session data
            $_SESSION['compareToBatchSetOrNode'] = array(
                'datamart_structure_id' => $datamartStructure['id'],
                'previously_displayed_object_title' => $previouslyDisplayedObjectTitle,
                'selected_elements_ids' => implode(",", $selectedElementsIds)
            );
        }
        if ($this->layout == false) {
            $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
        }
    }
    
    // -------------------------------------------------------------------------------------------------------------------
    // CUSTOM REPORTS DISPLAY AND MANAGEMENT
    // -------------------------------------------------------------------------------------------------------------------
    public function index()
    {
        $_SESSION['report'] = array(); // clear SEARCH criteria
        
        $this->request->data = $this->paginate($this->Report, array(
            'Report.flag_active' => '1',
            'Report.limit_access_from_datamart_structrue_function' => '0'
        ));
        
        // Translate data
        foreach ($this->request->data as $key => $data) {
            $this->request->data[$key]['Report']['name'] = __($this->request->data[$key]['Report']['name']);
            $this->request->data[$key]['Report']['description'] = __($this->request->data[$key]['Report']['description']);
        }
        
        $this->Structures->set("reports");
    }

    /**
     *
     * @param $reportId
     * @param bool $csvCreation
     */
    public function manageReport($reportId, $csvCreation = false)
    {
        $error = false;
        $totalMemory = getTotalMemoryCapacity($error);
        if ($error){
            AppController::forceMsgDisplayInPopup();
            AppController::addWarningMsg(__("the memory allocated to your query is low or undefined."));
        }
        ini_set("memory_limit", $totalMemory / 4 . "M");
        
        $reportId = ! empty($reportId) ? $reportId : "-1";
        $plugin = "Datamart";
        $controller = "Reports";
        $action = "manageReport";
        if (! empty($this->request->data)) {
            $_SESSION['post_data'][$plugin][$controller][$action][$reportId] = $this->request->data;
        } else {
            if (isset($_SESSION['post_data'][$plugin][$controller][$action][$reportId])) {
                convertArrayToJavaScript($_SESSION['post_data'][$plugin][$controller][$action][$reportId], 'jsPostData');
            }
        }
        
        // Get report data
        $report = $this->Report->find('first', array(
            'conditions' => array(
                'Report.id' => $reportId,
                'Report.flag_active' => '1'
            )
        ));
        if (empty($report) || empty($report['Report']['function']) || empty($report['Report']['form_alias_for_results']) || empty($report['Report']['form_type_for_results']) || ($report['Report']['form_type_for_results'] != 'index' && ! empty($report['Report']['associated_datamart_structure_id']))) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Set menu variables
        $this->set('atimMenuVariables', array(
            'Report.id' => $reportId
        ));
        $this->set('atimMenu', $this->Menus->get('/Datamart/Reports/manageReport/%%Report.id%%/'));
        
        if ($report['Report']['limit_access_from_datamart_structrue_function'] && empty($this->request->data) && (! $csvCreation) && ! array_key_exists('sort', $this->passedArgs)) {
            $this->atimFlashError(__('the selected report can only be launched from a batchset or a databrowser node'), "/Datamart/Reports/index");
        } elseif (empty($this->request->data) && (! empty($report['Report']['form_alias_for_search'])) && (! $csvCreation) && ! array_key_exists('sort', $this->passedArgs)) {
            
            // ** SEARCH FROM DISPLAY **
            
            $this->Structures->set($report['Report']['form_alias_for_search'], 'search_form_structure');
            $_SESSION['report'][$reportId]['search_criteria'] = array(); // clear SEARCH criteria
            $_SESSION['report'][$reportId]['sort_criteria'] = array(); // clear SEARCH criteria
        } else {
            
            // ** RESULTS/ACTIONS MANAGEMENT **
            
            $linkedDatamartStructure = null;
            $linkedModel = null;
            if ($report['Report']['form_type_for_results'] == 'index' && $report['Report']['associated_datamart_structure_id']) {
                // Load linked structure and model if required
                $linkedDatamartStructure = $this->DatamartStructure->find('first', array(
                    'conditions' => array(
                        "DatamartStructure.id" => $report['Report']['associated_datamart_structure_id']
                    )
                ));
                if (empty($linkedDatamartStructure))
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $linkedModel = AppModel::getInstance($linkedDatamartStructure['DatamartStructure']['plugin'], $linkedDatamartStructure['DatamartStructure']['model'], true);
                $this->set('linkedDatamartStructureId', $report['Report']['associated_datamart_structure_id']);
            }
            
            // Set criteria to build report/csv
            $criteriaToBuildReport = null;
            $criteriaToSortReport = array();
            if ($csvCreation) {
                if (array_key_exists('Config', $this->request->data)) {
                    $config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data) ? $this->request->data[0] : array()));
                    unset($this->request->data[0]);
                    unset($this->request->data['Config']);
                    $this->configureCsv($config);
                }
                // Get criteria from session data for csv
                $criteriaToBuildReport = $_SESSION['report'][$reportId]['search_criteria'];
                $criteriaToSortReport = isset($_SESSION['report'][$reportId]['sort_criteria']) ? $_SESSION['report'][$reportId]['sort_criteria'] : array();
                if ($linkedModel && isset($this->request->data[$linkedDatamartStructure['DatamartStructure']['model']][$linkedModel->primaryKey])) {
                    // Take care about selected items (the number of records did not reach the limit of items that could be displayed)
                    $ids = array_filter($this->request->data[$linkedDatamartStructure['DatamartStructure']['model']][$linkedModel->primaryKey]);
                    if (! empty($ids)) {
                        $criteriaToBuildReport['SelectedItemsForCsv'][$linkedDatamartStructure['DatamartStructure']['model']][$linkedModel->primaryKey] = $ids;
                    }
                }
            } elseif (array_key_exists('sort', $this->passedArgs)) {
                // Data sort: Get criteria from session data
                $criteriaToBuildReport = $_SESSION['report'][$reportId]['search_criteria'];
                $criteriaToSortReport = array(
                    'sort' => $this->passedArgs['sort'],
                    'direction' => $this->passedArgs['direction']
                );
                $_SESSION['report'][$reportId]['sort_criteria'] = $criteriaToSortReport;
            } else {
                // Get criteria from search form
                $criteriaToBuildReport = empty($this->request->data) ? array() : $this->request->data;
                // Manage data from csv file
                foreach ($criteriaToBuildReport as $model => $fieldsParameters) {
                    if (! ($model == 'exact_search' && ! is_array($fieldsParameters))) {
                        foreach ($fieldsParameters as $field => $parameters) {
                            if (preg_match('/^(.+)_with_file_upload$/', $field, $matches)) {
                                $matchedFieldName = $matches[1];
                                if (! isset($criteriaToBuildReport[$model][$matchedFieldName]))
                                    $criteriaToBuildReport[$model][$matchedFieldName] = array();
                                if (strlen($parameters['tmp_name'])) {
                                    if (! preg_match('/((\.txt)|(\.csv))$/', $parameters['name'])) {
                                        $this->redirect('/Pages/err_submitted_file_extension', null, true);
                                    } else {
                                        $handle = fopen($parameters['tmp_name'], "r");
                                        if ($handle) {
                                            while (($csvData = fgetcsv($handle, 1000, CSV_SEPARATOR, '"')) !== false) {
                                                $criteriaToBuildReport[$model][$matchedFieldName][] = $csvData[0];
                                            }
                                            fclose($handle);
                                        } else {
                                            $this->redirect('/Pages/err_opening_submitted_file', null, true);
                                        }
                                    }
                                }
                                unset($criteriaToBuildReport[$model][$field]);
                            }
                        }
                    }
                }
                
                // Manage data when launched from databrowser node having a nbr of elements > databrowser_and_report_results_display_limit
                if (array_key_exists('node', $criteriaToBuildReport)) {
                    $browsingResult = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $criteriaToBuildReport['node']['id']
                        )
                    ));
                    $datamartStructure = $browsingResult['DatamartStructure'];
                    if (empty($browsingResult) || empty($datamartStructure)) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    // Get model and key name
                    $model = null;
                    $lookupKeyName = null;
                    if ($datamartStructure['control_master_model']) {
                        if (isset($criteriaToBuildReport[$datamartStructure['model']])) {
                            $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
                            $model = $datamartStructure['model'];
                            $lookupKeyName = $modelInstance->primaryKey;
                        } else {
                            $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['control_master_model'], true);
                            $model = $datamartStructure['control_master_model'];
                            $lookupKeyName = $modelInstance->primaryKey;
                        }
                    } else {
                        $model = $datamartStructure['model'];
                        $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
                        $lookupKeyName = $modelInstance->primaryKey;
                    }
                    if ($criteriaToBuildReport[$model][$lookupKeyName] == 'all')
                        $criteriaToBuildReport[$model][$lookupKeyName] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
                }
                // Load search criteria in session
                $_SESSION['report'][$reportId]['search_criteria'] = $criteriaToBuildReport;
            }
            
            // Get and manage results
            $dataReturnedByFct = call_user_func_array(array(
                $this,
                $report['Report']['function']
            ), array(
                $criteriaToBuildReport
            ));
            if (empty($dataReturnedByFct) || (! array_key_exists('header', $dataReturnedByFct)) || (! array_key_exists('data', $dataReturnedByFct)) || (! array_key_exists('columns_names', $dataReturnedByFct)) || (! array_key_exists('error_msg', $dataReturnedByFct))) {
                // Wrong array keys returned by custom function
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            } elseif (! empty($dataReturnedByFct['error_msg'])) {
                // Error detected by custom function -> Display custom error message with empty form
                $this->request->data = array();
                $this->Structures->set('empty', 'result_form_structure');
                $this->set('resultFormType', 'index');
                $this->set('displayNewSearch', (empty($report['Report']['form_alias_for_search']) || $report['Report']['limit_access_from_datamart_structrue_function']) ? false : true);
                $this->set('csvCreation', false);
                $this->Report->validationErrors[][] = $dataReturnedByFct['error_msg'];
            } elseif (sizeof($dataReturnedByFct['data']) > Configure::read('databrowser_and_report_results_display_limit') && ! $csvCreation) {
                // Too many results
                $this->request->data = array();
                $this->Structures->set('empty', 'result_form_structure');
                $this->set('resultFormType', 'index');
                $this->set('displayNewSearch', (empty($report['Report']['form_alias_for_search']) || $report['Report']['limit_access_from_datamart_structrue_function']) ? false : true);
                $this->set('csvCreation', false);
                $this->Report->validationErrors[][] = __('the report contains too many results - please redefine search criteria') . ' [' . sizeof($dataReturnedByFct['data']) . ' ' . __('lines') . ']';
            } else {
                // Set data for display/csv
                $this->request->data = AppModel::sortWithUrl($dataReturnedByFct['data'], $criteriaToSortReport);
                $this->Structures->set($report['Report']['form_alias_for_results'], 'result_form_structure');
                $this->set('resultFormStructureAccuracy', array_key_exists('structure_accuracy', $dataReturnedByFct) ? $dataReturnedByFct['structure_accuracy'] : array());
                $this->set('resultFormType', $report['Report']['form_type_for_results']);
                $this->set('resultHeader', $dataReturnedByFct['header']);
                $this->set('resultColumnsNames', $dataReturnedByFct['columns_names']);
                $this->set('displayNewSearch', (empty($report['Report']['form_alias_for_search']) || $report['Report']['limit_access_from_datamart_structrue_function']) ? false : true);
                $this->set('csvCreation', $csvCreation);
                $this->set('chartsData', (isset($dataReturnedByFct['charts']) ? $dataReturnedByFct['charts'] : null));
                $this->Structures->set('empty', 'empty_structure');
                
                if ($csvCreation) {
                    Configure::write('debug', 0);
                    $this->layout = false;
                } elseif ($linkedDatamartStructure) {
                    // Code to be able to launch actions from report linked to structure and model
                    $this->set('linkedDatamartStructureModelName', $linkedDatamartStructure['DatamartStructure']['model']);
                    $this->set('linkedDatamartStructureKeyName', $linkedModel->primaryKey);
                    if ($linkedDatamartStructure['DatamartStructure']['index_link']) {
                        $this->set('linkedDatamartStructureLinks', $linkedDatamartStructure['DatamartStructure']['index_link']);
                    }
                    $linkedDatamartStructureActions = $this->DatamartStructure->getDropdownOptions($linkedDatamartStructure['DatamartStructure']['plugin'], $linkedDatamartStructure['DatamartStructure']['model'], $linkedModel->primaryKey, null, null, null, null, false);
                    $csvAction = "javascript:setCsvPopup('Datamart/Reports/manageReport/$reportId/1/');";
                    $linkedDatamartStructureActions[] = array(
                        'value' => '0',
                        'label' => __('export as CSV file (comma-separated values)'),
                        'value' => sprintf($csvAction, 0)
                    );
                    $linkedDatamartStructureActions[] = array(
                        'label' => __("initiate browsing"),
                        'value' => "Datamart/Browser/batchToDatabrowser/" . $linkedDatamartStructure['DatamartStructure']['model'] . "/report/"
                    );
                    $this->set('linkedDatamartStructureActions', $linkedDatamartStructureActions);
                }
                if ($this->layout == false) {
                    $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------------------------------------------------
    // FUNCTIONS ADDED TO THE CONTROLLER AS CUSTOM REPORT EXAMPLES
    // -------------------------------------------------------------------------------------------------------------------
    /**
     *
     * @param $parameters
     * @return array
     */
    public function bankActiviySummary($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        // 1- Build Header
        $startDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
        $endDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
        $header = array(
            'title' => __('from') . ' ' . (empty($parameters[0]['report_date_range_start']['year']) ? '?' : $startDateForDisplay) . ' ' . __('to') . ' ' . (empty($parameters[0]['report_date_range_end']['year']) ? '?' : $endDateForDisplay),
            'description' => 'n/a'
        );
        
        // 2- Search data
        $startDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
        $endDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
        
        $searchOnDateRange = true;
        if ((strpos($startDateForSql, '-9999') === 0) && (strpos($endDateForSql, '9999') === 0))
            $searchOnDateRange = false;
            
            // Get new participant
        if (! isset($this->Participant)) {
            $this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        }
        $conditions = $searchOnDateRange ? array(
            "Participant.created >= '$startDateForSql'",
            "Participant.created <= '$endDateForSql'"
        ) : array();
        $data['0']['new_participants_nbr'] = $this->Participant->find('count', (array(
            'conditions' => $conditions
        )));
        
        // Get new consents obtained
        if (! isset($this->ConsentMaster)) {
            $this->ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
        }
        $conditions = $searchOnDateRange ? array(
            "ConsentMaster.consent_signed_date >= '$startDateForSql'",
            "ConsentMaster.consent_signed_date <= '$endDateForSql'"
        ) : array();
        $allConsent = $this->ConsentMaster->find('count', (array(
            'conditions' => $conditions
        )));
        $conditions['ConsentMaster.consent_status'] = 'obtained';
        $allObtainedConsent = $this->ConsentMaster->find('count', (array(
            'conditions' => $conditions
        )));
        $data['0']['obtained_consents_nbr'] = "$allObtainedConsent/$allConsent";
        
        // Get new collections
        $conditions = $searchOnDateRange ? "col.collection_datetime >= '$startDateForSql' AND col.collection_datetime <= '$endDateForSql'" : 'TRUE';
        $newCollectionsNbr = $this->Report->tryCatchQuery("SELECT COUNT(*) FROM (
				SELECT DISTINCT col.participant_id 
				FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res;");
        $data['0']['new_collections_nbr'] = $newCollectionsNbr[0][0]['COUNT(*)'];
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function sampleAndDerivativeCreationSummary($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        // 1- Build Header
        $startDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_datetime_range_start']['year'], $parameters[0]['report_datetime_range_start']['month'], $parameters[0]['report_datetime_range_start']['day']);
        $endDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_datetime_range_end']['year'], $parameters[0]['report_datetime_range_end']['month'], $parameters[0]['report_datetime_range_end']['day']);
        
        $header = array(
            'title' => __('from') . ' ' . (empty($parameters[0]['report_datetime_range_start']['year']) ? '?' : $startDateForDisplay) . ' ' . __('to') . ' ' . (empty($parameters[0]['report_datetime_range_end']['year']) ? '?' : $endDateForDisplay),
            'description' => 'n/a'
        );
        
        $bankIds = array();
        if (isset($parameters[0]['bank_id'])) {
            foreach ($parameters[0]['bank_id'] as $bankId)
                if (! empty($bankId))
                    $bankIds[] = $bankId;
            if (! empty($bankIds)) {
                $bank = AppModel::getInstance("Administrate", "Bank", true);
                $bankList = $bank->find('all', array(
                    'conditions' => array(
                        'id' => $bankIds
                    )
                ));
                $bankNames = array();
                foreach ($bankList as $newBank)
                    $bankNames[] = $newBank['Bank']['name'];
                $header['description'] = __('bank') . ': ' . implode(',', $bankNames);
            }
        }
        
        // 2- Search data
        
        $bankConditions = empty($bankIds) ? 'TRUE' : 'col.bank_id IN (' . implode(',', $bankIds) . ')';
        
        $startDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_start'], 'start');
        $endDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_end'], 'end');
        
        $searchOnDateRange = true;
        if ((strpos($startDateForSql, '-9999') === 0) && (strpos($endDateForSql, '9999') === 0))
            $searchOnDateRange = false;
        
        $resFinal = array();
        $tmpResFinal = array();
        
        // Work on specimen
        
        $conditions = $searchOnDateRange ? "col.collection_datetime >= '$startDateForSql' AND col.collection_datetime <= '$endDateForSql'" : 'TRUE';
        $resSamples = $this->Report->tryCatchQuery("SELECT COUNT(*), sc.sample_type
			FROM sample_masters AS sm
			INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
			INNER JOIN collections AS col ON col.id = sm.collection_id
			WHERE col.participant_id IS NOT NULL
			AND col.participant_id != '0'
			AND sc.sample_category = 'specimen'
			AND ($conditions)
			AND ($bankConditions)
			AND sm.deleted != '1'
			GROUP BY sample_type;");
        $resParticipants = $this->Report->tryCatchQuery("SELECT COUNT(*), res.sample_type FROM (
				SELECT DISTINCT col.participant_id, sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'specimen'
				AND ($conditions)
				AND ($bankConditions)
				AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;");
        
        foreach ($resSamples as $data) {
            $tmpResFinal['specimen-' . $data['sc']['sample_type']] = array(
                'SampleControl' => array(
                    'sample_category' => 'specimen',
                    'sample_type' => $data['sc']['sample_type']
                ),
                '0' => array(
                    'created_samples_nbr' => $data[0]['COUNT(*)'],
                    'matching_participant_number' => null
                )
            );
        }
        foreach ($resParticipants as $data) {
            $tmpResFinal['specimen-' . $data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
        }
        
        // Work on derivative
        
        $conditions = $searchOnDateRange ? "der.creation_datetime >= '$startDateForSql' AND der.creation_datetime <= '$endDateForSql'" : 'TRUE';
        $resSamples = $this->Report->tryCatchQuery("SELECT COUNT(*), sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'derivative'
				AND ($conditions)
				AND ($bankConditions)
				AND sm.deleted != '1'
				GROUP BY sample_type;");
        $resParticipants = $this->Report->tryCatchQuery("SELECT COUNT(*), res.sample_type FROM (
					SELECT DISTINCT col.participant_id, sc.sample_type
					FROM sample_masters AS sm
					INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
					INNER JOIN collections AS col ON col.id = sm.collection_id
					INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
					WHERE col.participant_id IS NOT NULL
					AND col.participant_id != '0'
					AND sc.sample_category = 'derivative'
					AND ($conditions)
					AND ($bankConditions)
					AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;");
        
        foreach ($resSamples as $data) {
            $tmpResFinal['derivative-' . $data['sc']['sample_type']] = array(
                'SampleControl' => array(
                    'sample_category' => 'derivative',
                    'sample_type' => $data['sc']['sample_type']
                ),
                '0' => array(
                    'created_samples_nbr' => $data[0]['COUNT(*)'],
                    'matching_participant_number' => null
                )
            );
        }
        foreach ($resParticipants as $data) {
            $tmpResFinal['derivative-' . $data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
        }
        
        // Format data for report
        foreach ($tmpResFinal as $newSampleTypeData) {
            $resFinal[] = $newSampleTypeData;
        }
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $resFinal,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function bankActiviySummaryPerPeriod($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        if (empty($parameters[0]['report_date_range_period'])) {
            return array(
                'error_msg' => 'no period has been defined',
                'header' => null,
                'data' => null,
                'columns_names' => null
            );
        }
        $monthPeriod = ($parameters[0]['report_date_range_period'] == 'month') ? true : false;
        
        // 1- Build Header
        $startDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
        $endDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
        $header = array(
            'title' => __('from') . ' ' . (empty($parameters[0]['report_date_range_start']['year']) ? '?' : $startDateForDisplay) . ' ' . __('to') . ' ' . (empty($parameters[0]['report_date_range_end']['year']) ? '?' : $endDateForDisplay),
            'description' => 'n/a'
        );
        
        // 2- Search data
        $startDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
        $endDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
        
        $searchOnDateRange = true;
        if ((strpos($startDateForSql, '-9999') === 0) && (strpos($endDateForSql, '9999') === 0))
            $searchOnDateRange = false;
        
        $arrFormatMonthToString = AppController::getCalInfo(false);
        
        $tmpRes = array(
            array(
                'new_participants_nbr' => array(),
                'obtained_consents_nbr' => array(),
                'new_collections_nbr' => array()
            )
        );
        
        $dateKeyList = array();
        
        // Get new participant
        $conditions = $searchOnDateRange ? "Participant.created >= '$startDateForSql' AND Participant.created <= '$endDateForSql'" : 'TRUE';
        $participantRes = $this->Report->tryCatchQuery("SELECT COUNT(*), YEAR(Participant.created) AS created_year" . ($monthPeriod ? ", MONTH(Participant.created) AS created_month" : "") . " FROM participants AS Participant 
			WHERE ($conditions) AND Participant.deleted != 1 
			GROUP BY created_year" . ($monthPeriod ? ", created_month" : "") . ";");
        foreach ($participantRes as $newData) {
            $dateKey = '';
            $dateValue = __('unknown');
            if (! empty($newData['0']['created_year'])) {
                if ($monthPeriod) {
                    $dateKey = $newData['0']['created_year'] . "-" . ((strlen($newData['0']['created_month']) == 1) ? "0" : "") . $newData['0']['created_month'];
                    $dateValue = $arrFormatMonthToString[$newData['0']['created_month']] . ' ' . $newData['0']['created_year'];
                } else {
                    $dateKey = $newData['0']['created_year'];
                    $dateValue = $newData['0']['created_year'];
                }
            }
            
            $dateKeyList[$dateKey] = $dateValue;
            $tmpRes['0']['new_participants_nbr'][$dateValue] = $newData['0']['COUNT(*)'];
        }
        
        // Get new consents obtained
        $conditions = $searchOnDateRange ? "ConsentMaster.consent_signed_date >= '$startDateForSql' AND ConsentMaster.consent_signed_date <= '$endDateForSql'" : 'TRUE';
        $consentRes = $this->Report->tryCatchQuery("SELECT COUNT(*), YEAR(ConsentMaster.consent_signed_date) AS signed_year" . ($monthPeriod ? ", MONTH(ConsentMaster.consent_signed_date) AS signed_month" : "") . " FROM consent_masters AS ConsentMaster
			WHERE ($conditions) AND ConsentMaster.deleted != 1 
			GROUP BY signed_year" . ($monthPeriod ? ", signed_month" : "") . ";");
        foreach ($consentRes as $newData) {
            $dateKey = '';
            $dateValue = __('unknown');
            if (! empty($newData['0']['signed_year'])) {
                if ($monthPeriod) {
                    $dateKey = $newData['0']['signed_year'] . "-" . ((strlen($newData['0']['signed_month']) == 1) ? "0" : "") . $newData['0']['signed_month'];
                    $dateValue = $arrFormatMonthToString[$newData['0']['signed_month']] . ' ' . $newData['0']['signed_year'];
                } else {
                    $dateKey = $newData['0']['signed_year'];
                    $dateValue = $newData['0']['signed_year'];
                }
            }
            
            $dateKeyList[$dateKey] = $dateValue;
            $tmpRes['0']['obtained_consents_nbr'][$dateValue] = $newData['0']['COUNT(*)'];
        }
        
        // Get new collections
        $conditions = $searchOnDateRange ? "col.collection_datetime >= '$startDateForSql' AND col.collection_datetime <= '$endDateForSql'" : 'TRUE';
        $collectionRes = $this->Report->tryCatchQuery("SELECT COUNT(*), res.collection_year" . ($monthPeriod ? ", res.collection_month" : "") . " FROM (
				SELECT DISTINCT col.participant_id, YEAR(col.collection_datetime) AS collection_year" . ($monthPeriod ? ", MONTH(col.collection_datetime) AS collection_month" : "") . " FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res
			GROUP BY res.collection_year" . ($monthPeriod ? ", res.collection_month" : "") . ";");
        foreach ($collectionRes as $newData) {
            $dateKey = '';
            $dateValue = __('unknown');
            if (! empty($newData['res']['collection_year'])) {
                if ($monthPeriod) {
                    $dateKey = $newData['res']['collection_year'] . "-" . ((strlen($newData['res']['collection_month']) == 1) ? "0" : "") . $newData['res']['collection_month'];
                    $dateValue = $arrFormatMonthToString[$newData['res']['collection_month']] . ' ' . $newData['res']['collection_year'];
                } else {
                    $dateKey = $newData['res']['collection_year'];
                    $dateValue = $newData['res']['collection_year'];
                }
            }
            
            $dateKeyList[$dateKey] = $dateValue;
            $tmpRes['0']['new_collections_nbr'][$dateValue] = $newData['0']['COUNT(*)'];
        }
        
        ksort($dateKeyList);
        $errorMsg = null;
        if (sizeof($dateKeyList) > 20) {
            $errorMsg = 'number of report columns will be too big, please redefine parameters';
        }
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $tmpRes,
            'columns_names' => array_values($dateKeyList),
            'error_msg' => $errorMsg
        );
        
        // Build Graphics
        
        $pieCharts = array(
            'new_participants_nbr' => array(
                'type' => 'pieChart',
                'title' => __('participants'),
                'data' => array()
            ),
            'obtained_consents_nbr' => array(
                'type' => 'pieChart',
                'title' => __('consents'),
                'data' => array()
            ),
            'new_collections_nbr' => array(
                'type' => 'pieChart',
                'title' => __('collections'),
                'data' => array()
            )
        );
        $tmpMultiBarChartData = array(
            'new_participants_nbr' => array(),
            'obtained_consents_nbr' => array(),
            'new_collections_nbr' => array()
        );
        $tmpLineBarChartData = array(
            'new_participants_nbr' => array(),
            'obtained_consents_nbr' => array(),
            'new_collections_nbr' => array()
        );
        
        foreach (array_keys($tmpRes[0]) as $newDataKey) {
            $keyCounter = 0;
            foreach ($dateKeyList as $unusedData => $newDatePeriod) {
                // pieCharts
                $pieCharts[$newDataKey]['data'][] = array(
                    $newDatePeriod,
                    isset($tmpRes[0][$newDataKey][$newDatePeriod]) ? $tmpRes[0][$newDataKey][$newDatePeriod] : '0'
                );
                // tmpMultiBarChartData
                $tmpMultiBarChartData[$newDataKey][] = array(
                    $newDatePeriod,
                    isset($tmpRes[0][$newDataKey][$newDatePeriod]) ? $tmpRes[0][$newDataKey][$newDatePeriod] : '0'
                );
                // tmpLineBarChartData
                $previousValue = 0;
                if ($keyCounter != 0) {
                    list ($tmpUnusedValue, $previousValue) = $tmpLineBarChartData[$newDataKey][($keyCounter - 1)];
                }
                $keyCounter ++;
                $tmpLineBarChartData[$newDataKey][] = array(
                    $newDatePeriod,
                    (isset($tmpRes[0][$newDataKey][$newDatePeriod]) ? $tmpRes[0][$newDataKey][$newDatePeriod] : 0) + $previousValue
                );
            }
        }
        
        $multiBarChart = array(
            'type' => 'multiBarChart',
            'title' => __('summary'),
            'xAxis' => array(
                'ticks' => array(),
                'axisLabel' => __('date')
            ),
            'yAxis' => array(
                'axisLabel' => __('number of data')
            ),
            'data' => array(
                array(
                    'key' => __('participants'),
                    'values' => $tmpMultiBarChartData['new_participants_nbr']
                ),
                array(
                    'key' => __('consents'),
                    'values' => $tmpMultiBarChartData['obtained_consents_nbr']
                ),
                array(
                    'key' => __('collections'),
                    'values' => $tmpMultiBarChartData['new_collections_nbr']
                )
            )
        );
        
        $lineBarChart = array(
            'type' => 'lineChart',
            'title' => __('summary'),
            'xAxis' => array(
                'ticks' => array(),
                'axisLabel' => __('date')
            ),
            'yAxis' => array(
                'axisLabel' => __('number of data')
            ),
            'data' => array(
                array(
                    'key' => __('participants'),
                    'values' => $tmpLineBarChartData['new_participants_nbr']
                ),
                array(
                    'key' => __('consents'),
                    'values' => $tmpLineBarChartData['obtained_consents_nbr']
                ),
                array(
                    'key' => __('collections'),
                    'values' => $tmpLineBarChartData['new_collections_nbr']
                )
            )
        );
        
        $arrayToReturn['charts'] = array(
            'data' => array(
                $pieCharts['new_participants_nbr'],
                $pieCharts['obtained_consents_nbr'],
                $pieCharts['new_collections_nbr'],
                $multiBarChart
            ),
            'setting' => array(
                'top' => false,
                'popup' => false
            )
        );
        if (! $monthPeriod) {
            foreach ($lineBarChart['data'] as $keyA => $dataLevelA) {
                foreach ($dataLevelA['values'] as $keyb => $dataLevelb) {
                    if (! preg_match('/^[0-9]+$/', $dataLevelb[0])) {
                        unset($lineBarChart[$keyA]['values'][$keyb]);
                    }
                }
            }
            $arrayToReturn['charts']['data'][] = $lineBarChart;
        }
        
        return $arrayToReturn;
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function ctrnetCatalogueSubmissionFile($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        // 1- Build Header
        $header = array(
            'title' => __('report_ctrnet_catalogue_name'),
            'description' => 'n/a'
        );
        
        $bankIds = array();
        if (isset($parameters[0]['bank_id'])) {
            foreach ($parameters[0]['bank_id'] as $bankId)
                if (! empty($bankId))
                    $bankIds[] = $bankId;
            if (! empty($bankIds)) {
                $bank = AppModel::getInstance("Administrate", "Bank", true);
                $bankList = $bank->find('all', array(
                    'conditions' => array(
                        'id' => $bankIds
                    )
                ));
                $bankNames = array();
                foreach ($bankList as $newBank)
                    $bankNames[] = $newBank['Bank']['name'];
                $header['title'] .= ' (' . __('bank') . ': ' . implode(',', $bankNames) . ')';
            }
        }
        
        // 2- Search data
        
        $bankConditions = empty($bankIds) ? 'TRUE' : 'col.bank_id IN (' . implode(',', $bankIds) . ')';
        $aliquotTypeConfitions = $parameters[0]['include_core_and_slide'][0] ? 'TRUE' : "ac.aliquot_type NOT IN ('core','slide')";
        $whatmanPaperConfitions = $parameters[0]['include_whatman_paper'][0] ? 'TRUE' : "ac.aliquot_type NOT IN ('whatman paper')";
        $detailOtherCount = $parameters[0]['detail_other_count'][0] ? true : false;
        
        $data = array();
        
        // **all**
        
        $tmpData = array(
            'sample_type' => __('total'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' 
				AND ($bankConditions)
				AND ($aliquotTypeConfitions) 
				AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $data[] = $tmpData;
        
        // **FFPE**
        
        $tmpData = array(
            'sample_type' => __('FFPE'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => __('tissue') . ' ' . __('block') . ' (' . __('paraffin') . ')'
        );
        
        $sql = "	
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				INNER JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $data[] = $tmpData;
        
        // **frozen tissue**
        
        $tmpData = array(
            'sample_type' => __('frozen tissue'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquotTypeConfitions) 
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type,blk.block_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
			WHERE col.deleted != '1' AND ($bankConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type IN ('tissue')
				AND ($aliquotTypeConfitions) 
			AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType)
            $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']) . (empty($newType['blk']['block_type']) ? '' : ' (' . __($newType['blk']['block_type']) . ')');
        
        $data[] = $tmpData;
        
        // **blood**
        // **pbmc**
        // **buffy coat**
        // **blood cell**
        // **plasma**
        // **serum**
        // **rna**
        // **dna**
        // **cell culture**
        
        $sampleTypes = "'blood', 'pbmc', 'buffy coat',  'blood cell', 'plasma', 'serum', 'rna', 'dna', 'cell culture'";
        
        $tmpData = array();
        $sql = "
			SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
				SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ($sampleTypes)
				AND ($whatmanPaperConfitions)	
			) AS res GROUP BY sample_type, aliquot_type;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newRes) {
            $sampleType = $newRes['res']['sample_type'];
            $aliquotType = $newRes['res']['aliquot_type'];
            $tmpData[$sampleType . $aliquotType] = array(
                'sample_type' => __($sampleType) . ' ' . __($aliquotType),
                'cases_nbr' => $newRes[0]['nbr'],
                'aliquots_nbr' => '',
                'notes' => ''
            );
        }
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newRes) {
            $sampleType = $newRes['res']['sample_type'];
            $aliquotType = $newRes['res']['aliquot_type'];
            $tmpData[$sampleType . $aliquotType]['aliquots_nbr'] = $newRes[0]['nbr'];
            $data[] = $tmpData[$sampleType . $aliquotType];
        }
        
        // **Urine**
        
        $tmpData = array(
            'sample_type' => __('urine'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%urine%'
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bankConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%urine%'";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType)
            $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
        
        $data[] = $tmpData;
        
        // **Ascite**
        
        $tmpData = array(
            'sample_type' => __('ascite'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%ascite%'
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bankConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%ascite%'";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType)
            $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
        
        $data[] = $tmpData;
        
        // **other**
        
        $otherConditions = "sc.sample_type NOT LIKE '%ascite%' AND sc.sample_type NOT LIKE '%urine%' AND sc.sample_type NOT IN ('tissue', $sampleTypes)";
        
        if ($detailOtherCount) {
            
            $tmpData = array();
            $sql = "
				SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
					SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($otherConditions)
				) AS res GROUP BY sample_type, aliquot_type;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newRes) {
                $sampleType = $newRes['res']['sample_type'];
                $aliquotType = $newRes['res']['aliquot_type'];
                $tmpData[$sampleType . $aliquotType] = array(
                    'sample_type' => __($sampleType) . ' ' . __($aliquotType),
                    'cases_nbr' => $newRes[0]['nbr'],
                    'aliquots_nbr' => '',
                    'notes' => ''
                );
            }
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newRes) {
                $sampleType = $newRes['res']['sample_type'];
                $aliquotType = $newRes['res']['aliquot_type'];
                $tmpData[$sampleType . $aliquotType]['aliquots_nbr'] = $newRes[0]['nbr'];
                $data[] = $tmpData[$sampleType . $aliquotType];
            }
        } else {
            
            $tmpData = array(
                'sample_type' => __('other'),
                'cases_nbr' => '',
                'aliquots_nbr' => '',
                'notes' => ''
            );
            $sql = "
				SELECT count(*) AS nbr FROM (
					SELECT DISTINCT  %%id%%
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($otherConditions)
				) AS res;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
            
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
            
            $sql = "
				SELECT DISTINCT sc.sample_type,ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND ($otherConditions)";
            $queryResults = $this->Report->tryCatchQuery($sql);
            foreach ($queryResults as $newType)
                $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
            
            $data[] = $tmpData;
        }
        
        // Format data form display
        
        $finalData = array();
        foreach ($data as $newRow) {
            if ($newRow['cases_nbr']) {
                $finalData[][0] = $newRow;
            }
        }
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $finalData,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function participantIdentifiersSummary($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $header = null;
        $conditions = array();
        
        if (isset($parameters['SelectedItemsForCsv']['Participant']['id']))
            $parameters['Participant']['id'] = $parameters['SelectedItemsForCsv']['Participant']['id'];
        if (isset($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions['Participant.id'] = $participantIds;
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions['Participant.participant_identifier'] = $participantIdentifiers;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        // *** NOTE: It's user choice to display report in csv whatever the number of records ***
        // $tmpResCount = $miscIdentifierModel->find('count', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC')));
        // if($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
        // return array(
        // 'header' => null,
        // 'data' => null,
        // 'columns_names' => null,
        // 'error_msg' => 'the report contains too many results - please redefine search criteria');
        // }
        $miscIdentifiers = $miscIdentifierModel->find('all', array(
            'conditions' => $conditions,
            'order' => array(
                'MiscIdentifier.participant_id ASC'
            )
        ));
        $data = array();
        foreach ($miscIdentifiers as $newIdent) {
            $participantId = $newIdent['Participant']['id'];
            if (! isset($data[$participantId])) {
                $data[$participantId] = array(
                    'Participant' => array(
                        'id' => $newIdent['Participant']['id'],
                        'participant_identifier' => $newIdent['Participant']['participant_identifier'],
                        'first_name' => $newIdent['Participant']['first_name'],
                        'last_name' => $newIdent['Participant']['last_name']
                    ),
                    '0' => array(
                        'BR_Nbr' => null,
                        'PR_Nbr' => null,
                        'hospital_number' => null
                    )
                );
            }
            $data[$participantId]['0'][str_replace(array(
                ' ',
                '-'
            ), array(
                '_',
                '_'
            ), $newIdent['MiscIdentifierControl']['misc_identifier_name'])] = $newIdent['MiscIdentifier']['identifier_value'];
        }
        
        AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function getAllDerivatives($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $header = null;
        $conditions = array();
        // Get Parameters
        if (isset($parameters['SampleMaster']['sample_code'])) {
            // From databrowser
            $selectionLabels = array_filter($parameters['SampleMaster']['sample_code']);
            if ($selectionLabels)
                $conditions['SampleMaster.sample_code'] = $selectionLabels;
        } elseif (isset($parameters['ViewSample']['sample_master_id'])) {
            // From databrowser
            $sampleMasterIds = array_filter($parameters['ViewSample']['sample_master_id']);
            if ($sampleMasterIds)
                $conditions['SampleMaster.id'] = $sampleMasterIds;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Load Model
        $viewSampleModel = AppModel::getInstance("InventoryManagement", "ViewSample", true);
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        // Build Res
        $sampleMasterModel->unbindModel(array(
            'belongsTo' => array(
                'Collection'
            ),
            'hasOne' => array(
                'SpecimenDetail',
                'DerivativeDetail'
            ),
            'hasMany' => array(
                'AliquotMaster'
            )
        ));
        $tmpResCount = $sampleMasterModel->find('count', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        // *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => __('the report contains too many results - please redefine search criteria') . " [> $tmpResCount " . __('lines') . ']'
            );
        }
        $studiedSamples = $sampleMasterModel->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        $res = array();
        foreach ($studiedSamples as $newStudiedSample) {
            $allDerivativesSamples = $this->getChildrenSamples($viewSampleModel, array(
                $newStudiedSample['SampleMaster']['id']
            ));
            if ($allDerivativesSamples) {
                foreach ($allDerivativesSamples as $newDerivativeSample) {
                    if (array_key_exists('SelectedItemsForCsv', $parameters) && ! in_array($newDerivativeSample['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id']))
                        continue;
                    $res[] = array_merge($newStudiedSample, $newDerivativeSample);
                }
            }
        }
        return array(
            'header' => $header,
            'data' => $res,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    /**
     *
     * @param $viewSampleModel
     * @param array $parentSampleIds
     * @return array
     */
    public function getChildrenSamples($viewSampleModel, $parentSampleIds = array())
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        if (! empty($parentSampleIds)) {
            // $viewSampleModel->unbindModel(array('hasMany' => array('AliquotMaster')));
            $childrenSamples = $viewSampleModel->find('all', array(
                'conditions' => array(
                    'ViewSample.parent_id' => $parentSampleIds
                ),
                'fields' => array(
                    'ViewSample.*, DerivativeDetail.*'
                ),
                'order' => array(
                    'ViewSample.sample_code ASC'
                ),
                'recursive' => 0
            ));
            $childrenSampleIds = array();
            foreach ($childrenSamples as $tmpSample)
                $childrenSampleIds[] = $tmpSample['ViewSample']['sample_master_id'];
            $subChildrenSamples = $this->getChildrenSamples($viewSampleModel, $childrenSampleIds);
            return array_merge($childrenSamples, $subChildrenSamples);
        }
        return array();
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function getAllSpecimens($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $header = null;
        $conditions = array(
            "SampleMaster.id != SampleMaster.initial_specimen_sample_id"
        );
        // Get Parameters
        if (isset($parameters['SampleMaster']['sample_code'])) {
            // From databrowser
            $selectionLabels = array_filter($parameters['SampleMaster']['sample_code']);
            if ($selectionLabels)
                $conditions['SampleMaster.sample_code'] = $selectionLabels;
        } elseif (isset($parameters['ViewSample']['sample_master_id'])) {
            // From databrowser
            $sampleMasterIds = array_filter($parameters['ViewSample']['sample_master_id']);
            if ($sampleMasterIds)
                $conditions['SampleMaster.id'] = $sampleMasterIds;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Load Model
        $viewSampleModel = AppModel::getInstance("InventoryManagement", "ViewSample", true);
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        // Build Res
        $sampleMasterModel->unbindModel(array(
            'belongsTo' => array(
                'Collection'
            ),
            'hasOne' => array(
                'SpecimenDetail',
                'DerivativeDetail'
            ),
            'hasMany' => array(
                'AliquotMaster'
            )
        ));
        $tmpResCount = $sampleMasterModel->find('count', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        // *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => __('the report contains too many results - please redefine search criteria') . " [> $tmpResCount " . __('lines') . ']'
            );
        }
        $studiedSamples = $sampleMasterModel->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        $res = array();
        $tmpInitialSpecimens = array();
        foreach ($studiedSamples as $newStudiedSample) {
            $initialSpecimen = isset($tmpInitialSpecimens[$newStudiedSample['SampleMaster']['initial_specimen_sample_id']]) ? $tmpInitialSpecimens[$newStudiedSample['SampleMaster']['initial_specimen_sample_id']] : $viewSampleModel->find('first', array(
                'conditions' => array(
                    'ViewSample.sample_master_id' => $newStudiedSample['SampleMaster']['initial_specimen_sample_id']
                ),
                'fields' => array(
                    'ViewSample.*, SpecimenDetail.*'
                ),
                'order' => array(
                    'ViewSample.sample_code ASC'
                ),
                'recursive' => 0
            ));
            $tmpInitialSpecimens[$newStudiedSample['SampleMaster']['initial_specimen_sample_id']] = $initialSpecimen;
            if ($initialSpecimen) {
                if (! (array_key_exists('SelectedItemsForCsv', $parameters) && ! in_array($initialSpecimen['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id'])))
                    $res[] = array_merge($newStudiedSample, $initialSpecimen);
            }
        }
        return array(
            'header' => $header,
            'data' => $res,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function getAllChildrenStorage($parameters)
    {
        if (! AppController::checkLinkPermission('/StorageLayout/StorageMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $header = null;
        $conditions = array();
        // Get Parameters
        if (isset($parameters['StorageMaster']['selection_label'])) {
            // From databrowser
            $selectionLabels = array_filter($parameters['StorageMaster']['selection_label']);
            if ($selectionLabels)
                $conditions['StorageMaster.selection_label'] = $selectionLabels;
        } elseif (isset($parameters['ViewStorageMaster']['id'])) {
            // From databrowser
            $storageMasterIds = array_filter($parameters['ViewStorageMaster']['id']);
            if ($storageMasterIds)
                $conditions['StorageMaster.id'] = $storageMasterIds;
        } elseif (isset($parameters['NonTmaBlockStorage']['id'])) {
            // From databrowser
            $storageMasterIds = array_filter($parameters['NonTmaBlockStorage']['id']);
            if ($storageMasterIds)
                $conditions['StorageMaster.id'] = $storageMasterIds;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Load Model
        $storageMasterModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
        $storageControlModel = AppModel::getInstance("StorageLayout", "StorageControl", true);
        // Build Res
        $tmpResCount = $storageMasterModel->find('count', array(
            'conditions' => $conditions,
            'fields' => array(
                'StorageMaster.*'
            ),
            'order' => array(
                'StorageMaster.selection_label ASC'
            ),
            'recursive' => - 1
        ));
        // *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => __('the report contains too many results - please redefine search criteria') . " [> $tmpResCount " . __('lines') . ']'
            );
        }
        $tmaStorageContolIds = $storageControlModel->getTmaBlockStorageTypePermissibleValues();
        $tmaStorageContolIds = array_keys($tmaStorageContolIds);
        $studiedStorages = $storageMasterModel->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'StorageMaster.*'
            ),
            'order' => array(
                'StorageMaster.selection_label ASC'
            ),
            'recursive' => - 1
        ));
        $res = array();
        foreach ($studiedStorages as $newStudiedStorage) {
            $childrenStorageMasters = $storageMasterModel->children($newStudiedStorage['StorageMaster']['id'], false, array(
                'StorageMaster.*'
            ));
            if ($childrenStorageMasters) {
                foreach ($childrenStorageMasters as $newChild) {
                    if (! in_array($newChild['StorageMaster']['storage_control_id'], $tmaStorageContolIds)) {
                        if (array_key_exists('SelectedItemsForCsv', $parameters) && ! in_array($newChild['StorageMaster']['id'], $parameters['SelectedItemsForCsv']['NonTmaBlockStorage']['id']))
                            continue;
                        $res[] = array_merge($newStudiedStorage, array(
                            'ViewStorageMaster' => $newChild['StorageMaster'],
                            'NonTmaBlockStorage' => $newChild['StorageMaster']
                        ));
                    }
                }
            }
        }
        return array(
            'header' => $header,
            'data' => $res,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function getAllRelatedDiagnosis($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $header = null;
        $conditions = array();
        // Get Parameters
        if (isset($parameters['DiagnosisMaster']['id'])) {
            // From databrowser
            $diagnosisMasterIds = array_filter($parameters['DiagnosisMaster']['id']);
            if ($diagnosisMasterIds)
                $conditions['DiagnosisMaster.id'] = $diagnosisMasterIds;
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            // From databrowser
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions['Participant.participant_identifier'] = $participantIdentifiers;
        } elseif (isset($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions['DiagnosisMaster.participant_id'] = $participantIds;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Load Model
        $diagnosisMasterModel = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
        // Build Res
        $diagnosisMasterModel->bindModel(array(
            'belongsTo' => array(
                'Participant' => array(
                    'className' => 'ClinicalAnnotation.Participant',
                    'foreignKey' => 'participant_id'
                )
            )
        ), false);
        $diagnosisMasterModel->unbindModel(array(
            'hasMany' => array(
                'Collection'
            )
        ), false);
        $tmpResCount = $diagnosisMasterModel->find('count', array(
            'conditions' => $conditions,
            'fields' => array(
                'DISTINCT primary_id'
            ),
            'recursive' => 0
        ));
        // *** NOTE: Has to control the number of record because the next report code lines can be really time and memory consuming ***
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => __('the report contains too many results - please redefine search criteria') . " [> $tmpResCount " . __('lines') . ']'
            );
        }
        $tmpPrimaryIds = $diagnosisMasterModel->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'DISTINCT primary_id'
            ),
            'recursive' => 0
        ));
        $primaryIds = array();
        foreach ($tmpPrimaryIds as $newPrimaryId)
            $primaryIds[] = $newPrimaryId['DiagnosisMaster']['primary_id'];
        $conditions2 = array(
            'DiagnosisMaster.primary_id' => $primaryIds
        );
        if (isset($parameters['SelectedItemsForCsv']['DiagnosisMaster']['id']))
            $conditions2['DiagnosisMaster.id'] = $parameters['SelectedItemsForCsv']['DiagnosisMaster']['id'];
        $res = $diagnosisMasterModel->find('all', array(
            'conditions' => $conditions2,
            'fields' => array(
                'Participant.*',
                'DiagnosisMaster.*',
                'DiagnosisControl.*'
            ),
            'order' => array(
                'Participant.participant_identifier ASC',
                'DiagnosisMaster.primary_id ASC',
                'DiagnosisMaster.dx_date ASC'
            ),
            'recursive' => 0
        ));
        return array(
            'header' => $header,
            'data' => $res,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function countNumberOfElementsPerParticipants($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        
        $header = null;
        $conditions = array();
        
        // Get studied model
        
        $modelsList = array(
            'MiscIdentifier' => array(
                'id',
                array(
                    'misc_identifiers'
                ),
                'misc identifiers'
            ),
            'ConsentMaster' => array(
                'id',
                array(
                    'consent_masters'
                ),
                'consents'
            ),
            'DiagnosisMaster' => array(
                'id',
                array(
                    'diagnosis_masters'
                ),
                'diagnosis'
            ),
            'TreatmentMaster' => array(
                'id',
                array(
                    'treatment_masters'
                ),
                'treatments'
            ),
            'EventMaster' => array(
                'id',
                array(
                    'event_masters'
                ),
                'events'
            ),
            'ReproductiveHistory' => array(
                'id',
                array(
                    'consent_masters'
                ),
                'reproductive histories'
            ),
            'FamilyHistory' => array(
                'id',
                array(
                    'family_histories'
                ),
                'family histories'
            ),
            'ParticipantMessage' => array(
                'id',
                array(
                    'participant_messages'
                ),
                'messages'
            ),
            'ParticipantContact' => array(
                'id',
                array(
                    'participant_contacts'
                ),
                'contacts'
            ),
            'ViewCollection' => array(
                'collection_id',
                array(
                    'collections'
                ),
                'collections'
            ),
            'TreatmentExtendMaster' => array(
                'id',
                array(
                    'treatment_masters'
                ),
                'xxxx'
            ),
            
            'ViewAliquot' => array(
                'aliquot_master_id',
                array(
                    'aliquot_masters',
                    'collections'
                ),
                'aliquots'
            ),
            'ViewSample' => array(
                'sample_master_id',
                array(
                    'sample_masters',
                    'collections'
                ),
                'samples'
            ),
            'QualityCtrl' => array(
                'id',
                array(
                    'quality_ctrls',
                    'sample_masters',
                    'collections'
                ),
                'quality controls'
            ),
            'SpecimenReviewMaster' => array(
                'id',
                array(
                    'specimen_review_masters',
                    'sample_masters',
                    'collections'
                ),
                'specimen review'
            ),
            'ViewAliquotUse' => array(
                'id',
                array(
                    'view_aliquot_uses',
                    'aliquot_masters',
                    'collections'
                ),
                'aliquot uses and events'
            ),
            'AliquotReviewMaster' => array(
                'id',
                array(
                    'aliquot_review_masters',
                    'aliquot_masters',
                    'sample_masters',
                    'collections'
                ),
                'aliquot review'
            )
        );
        $modelName = null;
        foreach (array_keys($modelsList) as $tmModelName) {
            if (isset($parameters[$tmModelName])) {
                $modelName = $tmModelName;
                break;
            }
        }
        
        // Get data
        
        if ($modelName) {
            list ($modelIdKey, $orderedLinkedTableNames, $headerDetail) = $modelsList[$modelName];
            $ids = array_filter($parameters[$modelName][$modelIdKey]);
            $ids = empty($ids) ? '-1' : implode(',', $ids);
            $joins = array();
            $deleteConstraints = array();
            $modelLevels = 0;
            $foreignKeyToPreviousModel = null;
            foreach (array_reverse($orderedLinkedTableNames) as $newTableName) {
                $modelLevels ++;
                if ($modelLevels == 1) {
                    $joins[] = "INNER JOIN $newTableName ModelLevel1 ON ModelLevel1.participant_id = Participant.id";
                    $foreignKeyToPreviousModel = preg_replace('/s$/', '_id', $newTableName);
                } else {
                    $joins[] = "INNER JOIN $newTableName ModelLevel$modelLevels ON ModelLevel$modelLevels." . $foreignKeyToPreviousModel . " = ModelLevel" . ($modelLevels - 1) . ".id";
                    $foreignKeyToPreviousModel = preg_replace('/s$/', '_id', $newTableName);
                }
                if ($newTableName != 'view_aliquot_uses')
                    $deleteConstraints[] = "ModelLevel$modelLevels.deleted <> 1";
            }
            $query = "SELECT count(*) AS nbr_of_elements, Participant.*
				FROM participants AS Participant " . implode(' ', $joins) . " WHERE Participant.deleted <> 1 AND " . implode(' AND ', $deleteConstraints) . " AND ModelLevel$modelLevels.id IN ($ids)
				GROUP BY Participant.id;";
            // Set header
            $header = str_replace('%s', __($headerDetail), __('number of %s per participant'));
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $data = $participantModel->tryCatchQuery($query);
        // *** NOTE: It's user choice to display report in csv whatever the number of records ***
        // if(sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
        // return array(
        // 'header' => null,
        // 'data' => null,
        // 'columns_names' => null,
        // 'error_msg' => 'the report contains too many results - please redefine search criteria');
        // }
        foreach ($data as &$newRow)
            $newRow['Generated'] = $newRow['0'];
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    /**
     *
     * @param $parameters
     * @return array
     */
    public function atimDemoReportParticipantClinicalData($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page') . 'xxx', 'javascript:history.back()');
        }
        
        $displayExactSearchWarning = false;
        $conditions = array();
        if (isset($parameters['Participant']['id']) && ! empty($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions[] = "Participant.id IN ('" . implode("','", $participantIds) . "')";
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart) {
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            } elseif ($participantIdentifierEnd) {
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
            }
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        
        // Get Controls Data
        
        $query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
        $eventControls = array();
        foreach ($participantModel->query($query) as $res) {
            $eventControls[$res['event_controls']['event_type']] = array(
                'id' => $res['event_controls']['id'],
                'detail_tablename' => $res['event_controls']['detail_tablename']
            );
        }
        $query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
        $txControls = array();
        foreach ($participantModel->query($query) as $res) {
            $txControls[$res['treatment_controls']['tx_method']] = array(
                'id' => $res['treatment_controls']['id'],
                'detail_tablename' => $res['treatment_controls']['detail_tablename']
            );
        }
        $query = "SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1;";
        $dxControls = array();
        foreach ($participantModel->query($query) as $res) {
            $dxControls[$res['diagnosis_controls']['category'] . '-' . $res['diagnosis_controls']['controls_type']] = array(
                'id' => $res['diagnosis_controls']['id'],
                'detail_tablename' => $res['diagnosis_controls']['detail_tablename']
            );
        }
        
        // Get Participant
        
        $participantsData = $participantModel->find('all', array(
            'conditions' => $conditions
        ));
        if (! $participantsData) {
            return array(
                'header' => '',
                'data' => array(),
                'columns_names' => null,
                'error_msg' => null
            );
        }
        $participantidToData = array();
        foreach ($participantsData as $newParticipant) {
            $participantidToData[$newParticipant['Participant']['id']] = array_merge($newParticipant, array(
                'DiagnosisControl' => array(
                    'controls_type' => null,
                    'category' => null
                ),
                'DiagnosisMaster' => array(
                    'id' => null,
                    'dx_date' => null,
                    'dx_date_accuracy' => null,
                    'icd10_code' => null,
                    'icd_0_3_topography_category' => null,
                    'clinical_tstage' => null,
                    'clinical_nstage' => null,
                    'clinical_mstage' => null,
                    'clinical_stage_summary' => null,
                    'path_tstage' => null,
                    'path_nstage' => null,
                    'path_mstage' => null,
                    'path_stage_summary' => null
                ),
                'TreatmentMaster' => array(
                    'target_site_icdo' => null,
                    'start_date' => null,
                    'start_date_accuracy' => null
                ),
                'TreatmentControl' => array(
                    'tx_method' => null,
                    'disease_site' => null
                ),
                'TreatmentDetail' => array(
                    'path_num' => null
                ),
                'Generated' => array(
                    'chemo_pre_surgery_start_date' => null,
                    'chemo_post_surgery_start_date' => null
                )
            ));
        }
        $participantIds = $participantModel->find('list', array(
            'fields' => array(
                'Participant.id'
            ),
            'conditions' => $conditions
        ));
        
        // Get first primary diagnosis + first surgery + pre-post chemo
        
        $diagnosisModel = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
        
        $treatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $txJoin = array(
            'table' => 'txd_surgeries',
            'alias' => 'TreatmentDetail',
            'type' => 'INNER',
            'conditions' => array(
                'TreatmentDetail.treatment_master_id = TreatmentMaster.id'
            )
        );
        
        $participantIdToFirstDiagnosis = array();
        $conditions = array(
            'DiagnosisMaster.participant_id' => $participantIds,
            'DiagnosisMaster.diagnosis_control_id' => array(
                $dxControls['primary-breast']['id'],
                $dxControls['primary-blood']['id'],
                $dxControls['primary-other tissue']['id']
            )
        );
        $diagnosisData = $diagnosisModel->find('all', array(
            'conditions' => $conditions,
            'order' => array(
                'DiagnosisMaster.participant_id, DiagnosisMaster.dx_date ASC'
            )
        ));
        foreach ($diagnosisData as $newDiagnosis) {
            if (! $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['DiagnosisMaster']['id']) {
                $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['DiagnosisMaster'] = $newDiagnosis['DiagnosisMaster'];
                $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['DiagnosisControl'] = $newDiagnosis['DiagnosisControl'];
                
                // Get first treatment (demo does not take care about accuracy)
                if ($newDiagnosis['DiagnosisMaster']['dx_date']) {
                    $conditions = array(
                        'TreatmentMaster.participant_id' => $newDiagnosis['DiagnosisMaster']['participant_id'],
                        'TreatmentMaster.start_date IS NOT NULL',
                        'TreatmentMaster.start_date >= ' => $newDiagnosis['DiagnosisMaster']['dx_date']
                    );
                    $participantSurgery = $treatmentModel->find('first', array(
                        'conditions' => $conditions,
                        'joins' => array(
                            $txJoin
                        ),
                        'order' => array(
                            'TreatmentMaster.start_date ASC'
                        )
                    ));
                    if ($participantSurgery) {
                        $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']] = array_merge($participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']], $participantSurgery);
                        // Chemo Pre-Post surgery (demo does not take care about accuracy)
                        $conditions = array(
                            'TreatmentMaster.participant_id' => $newDiagnosis['DiagnosisMaster']['participant_id'],
                            'TreatmentMaster.start_date IS NOT NULL',
                            'TreatmentMaster.start_date <= ' => $participantSurgery['TreatmentMaster']['start_date'],
                            'TreatmentMaster.treatment_control_id' => $txControls['chemotherapy']['id']
                        );
                        $participantChemo = $treatmentModel->find('first', array(
                            'conditions' => $conditions,
                            'order' => array(
                                'TreatmentMaster.start_date DESC'
                            )
                        ));
                        if ($participantChemo) {
                            $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['Generated']['chemo_pre_surgery_start_date'] = $participantChemo['TreatmentMaster']['start_date'];
                            $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['Generated']['chemo_pre_surgery_start_date_accuracy'] = $participantChemo['TreatmentMaster']['start_date_accuracy'];
                        }
                        $conditions = array(
                            'TreatmentMaster.participant_id' => $newDiagnosis['DiagnosisMaster']['participant_id'],
                            'TreatmentMaster.start_date IS NOT NULL',
                            'TreatmentMaster.start_date >= ' => $participantSurgery['TreatmentMaster']['start_date'],
                            'TreatmentMaster.treatment_control_id' => $txControls['chemotherapy']['id']
                        );
                        $participantChemo = $treatmentModel->find('first', array(
                            'conditions' => $conditions,
                            'order' => array(
                                'TreatmentMaster.start_date ASC'
                            )
                        ));
                        if ($participantChemo) {
                            $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['Generated']['chemo_post_surgery_start_date'] = $participantChemo['TreatmentMaster']['start_date'];
                            $participantidToData[$newDiagnosis['DiagnosisMaster']['participant_id']]['Generated']['chemo_post_surgery_start_date_accuracy'] = $participantChemo['TreatmentMaster']['start_date_accuracy'];
                        }
                    }
                }
            }
        }
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => '',
            'data' => $participantidToData,
            'columns_names' => null,
            'error_msg' => null,
            'structure_accuracy' => array(
                'Generated' => array(
                    'chemo_pre_surgery_start_date' => 'chemo_pre_surgery_start_date_accuracy',
                    'chemo_post_surgery_start_date' => 'chemo_post_surgery_start_date_accuracy'
                )
            )
        );
    }
}