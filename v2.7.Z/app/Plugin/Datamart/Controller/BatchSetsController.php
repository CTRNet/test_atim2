<?php

/**
 * Class BatchSetsController
 */
class BatchSetsController extends DatamartAppController
{

    public static $tmpBatchSetLimit = 5;

    public $uses = array(
        'Datamart.BatchSet',
        'Datamart.BatchId',
        'Datamart.BrowsingResult',
        'Datamart.DatamartStructure',
        
        'InventoryManagement.RealiquotingControl'
    );

    public $paginate = array(
        'BatchSet' => array(
            'limit' => 5,
            'order' => 'BatchSet.created DESC'
        )
    );

    /**
     *
     * @param null $typeOfList
     */
    public function index($typeOfList = null)
    {
        if ($typeOfList && in_array($typeOfList, array(
            'temporary',
            'saved',
            'all'
        ))) {
            $userBankId = AppController::getInstance()->Session->read('Auth.User.Group.bank_id');
            $userBankGroupIds = array(
                '-1'
            );
            if ($userBankId) {
                $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
                $tmpBankGroupIds = $bankModel->getBankGroupIds($userBankId);
                if ($tmpBankGroupIds) {
                    $userBankGroupIds = $tmpBankGroupIds;
                }
            }
            
            $conditions = array();
            switch ($typeOfList) {
                case 'temporary':
                    $conditions = array(
                        'BatchSet.user_id' => $_SESSION['Auth']['User']['id'],
                        'BatchSet.flag_tmp' => true
                    );
                    break;
                case 'saved':
                    $conditions = array(
                        'BatchSet.user_id' => $_SESSION['Auth']['User']['id'],
                        'BatchSet.flag_tmp <> 1'
                    );
                    break;
                case 'all':
                    $conditions = array(
                        array(
                            'BatchSet.user_id <> ' . $_SESSION['Auth']['User']['id'],
                            'BatchSet.flag_tmp <> 1'
                        ),
                        array(
                            'OR' => array(
                                // Bank owner condition added if group of the user is not linked to a bank
                                array(
                                    'BatchSet.sharing_status' => array(
                                        'group',
                                        'bank'
                                    ),
                                    'BatchSet.group_id' => AppController::getInstance()->Session->read('Auth.User.group_id')
                                ),
                                array(
                                    'BatchSet.sharing_status' => 'bank',
                                    'BatchSet.group_id' => $userBankGroupIds
                                ),
                                array(
                                    'BatchSet.sharing_status' => 'all'
                                )
                            )
                        )
                    );
            }
            
            $this->Structures->set('querytool_batch_set');
            $this->request->data = $this->paginate($this->BatchSet, $conditions);
            $this->BatchSet->completeData($this->request->data);
        } else {
            
            $typeOfList = null;
            
            // CUSTOM CODE: FORMAT DISPLAY DATA
            $hookLink = $this->hook('format');
            if ($hookLink) {
                require ($hookLink);
            }
        }
        
        $this->set('typeOfList', $typeOfList);
    }

    /**
     *
     * @param $batchSetId
     */
    public function listall($batchSetId)
    {
        $error = false;
        $totalMemory = getTotalMemoryCapacity($error);
        if ($error){
            AppController::forceMsgDisplayInPopup();
            AppController::addWarningMsg(__("the memory allocated to your query is low or undefined."));
        }
        ini_set("memory_limit", $totalMemory / 4 . "M");
        
        $this->Structures->set('querytool_batch_set', 'atim_structure_for_detail');
        $lookupIds = array();
        $atimMenuVariables = array(
            'BatchSet.id' => $batchSetId
        );
        
        $batchSet = $this->BatchSet->getOrRedirect($batchSetId);
        
        // check permissions
        $datamartStructureData = $this->DatamartStructure->findById($batchSet['BatchSet']['datamart_structure_id']);
        if (! AppController::checkLinkPermission($datamartStructureData['DatamartStructure']['index_link'])) {
            $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
            return;
        }
        
        if ($batchSet['BatchSet']['flag_tmp']) {
            $batchSet['BatchSet']['title'] = '<span class="red">' . strtoupper(__('temporary batch set')) . '</span>';
            $atimMenuVariables['BatchSet.temporary_batchset'] = true;
        }
        
        if (! $this->BatchSet->isUserAuthorizedToRw($batchSet, false)) {
            return;
        }
        foreach ($batchSet['BatchId'] as $fields) {
            $lookupIds[] = $fields['lookup_id'];
        }
        
        $this->set('atimMenuVariables', $atimMenuVariables);
        
        // add COUNT of IDS to array results, for form list
        $batchSet['BatchSet']['count_of_BatchId'] = count($lookupIds);
        $lookupIds[] = 0;
        
        // set VAR to determine if this BATCHSET belongs to USER or to other user in GROUP
        $belongToThisUser = $batchSet['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id'];
        $this->set('belongToThisUser', $belongToThisUser);
        
        $this->Structures->set('empty', 'atim_structure_for_process');
        
        // do search for RESULTS, using THIS->DATA if any
        $this->ModelToSearch = null;
        $atimStructureForResults = null;
        $criteria = "";
        $datamartStructure = $this->DatamartStructure->findById($batchSet['BatchSet']['datamart_structure_id']);
        $batchSet['BatchSet']['plugin'] = $datamartStructure['DatamartStructure']['plugin'];
        $batchSet['BatchSet']['model'] = $datamartStructure['DatamartStructure']['model'];
        $atimStructureForResults = $this->Structures->getFormById($datamartStructure['DatamartStructure']['structure_id']);
        $batchSet['BatchSet']['form_links_for_results'] = $datamartStructure['DatamartStructure']['index_link'];
        
        $batchSet['DatamartStructure'] = $datamartStructure['DatamartStructure'];
        $this->ModelToSearch = AppModel::getInstance($batchSet['BatchSet']['plugin'], $batchSet['BatchSet']['model'], true);
        $batchSet['BatchSet']['lookup_key_name'] = $this->ModelToSearch->primaryKey;
        
        $lookupModelName = $batchSet['BatchSet']['model'];
        $lookupKeyName = $batchSet['BatchSet']['lookup_key_name'];
        $this->set('lookupModelName', $lookupModelName);
        $this->set('lookupKeyName', $lookupKeyName);
        
        if (count($lookupIds) > 0) {
            $criteria = array($batchSet['BatchSet']['model'] . '.' . $batchSet['BatchSet']['lookup_key_name'] => array_values($lookupIds));
        }
        
        // set FORM variable, for HELPER call on VIEW
        $this->set('batchSetId', $batchSetId);
        
        // make list of SEARCH RESULTS
        
        $batchSet['0']['query_type'] = __('generic');
        if ($batchSet['DatamartStructure']['control_master_model']) {
            $datamartStructure = $batchSet['DatamartStructure'];
            $results = $this->ModelToSearch->find('all', array(
                'fields' => array(
                    $this->ModelToSearch->getControlForeign()
                ),
                'conditions' => $criteria,
                'recursive' => 0,
                'group' => $this->ModelToSearch->getControlForeign()
            ));
            if (count($results) == 1) {
                // unique control, load detailed version
                AppModel::getInstance("Datamart", "Browser", true);
                $alternateInfo = Browser::getAlternateStructureInfo($datamartStructure['plugin'], $this->ModelToSearch->getControlName(), $results[0][$datamartStructure['model']][$this->ModelToSearch->getControlForeign()]);
                
                $criteria = array(
                    $datamartStructure['control_master_model'] . ".id"=> array_values($lookupIds)
                );
                // add the control_id to the search conditions to benefit from direct inner join on detail
                $criteria[$datamartStructure['control_master_model'] . "." . $this->ModelToSearch->getControlForeign()] = $results[0][$datamartStructure['model']][$this->ModelToSearch->getControlForeign()];
                
                $batchSet['BatchSet']['model'] = $datamartStructure['control_master_model'];
                $prevPkey = $this->ModelToSearch->primaryKey;
                $this->ModelToSearch = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['control_master_model'], true);
                $atimStructureForResults = $this->Structures->get('form', $alternateInfo['form_alias']);
                $batchSet['BatchSet']['form_links_for_results'] = Browser::updateIndexLink($batchSet['BatchSet']['form_links_for_results'], $datamartStructure['model'], $datamartStructure['control_master_model'], $prevPkey, $this->ModelToSearch->primaryKey);
                $batchSet['BatchSet']['form_links_for_results'] = substr($batchSet['BatchSet']['form_links_for_results'], strpos($batchSet['BatchSet']['form_links_for_results'], '/'));
                $batchSet['BatchSet']['lookup_key_name'] = 'id';
            }
            $batchSet['BatchSet']['form_links_for_results'];
        }
        $results = $this->ModelToSearch->find('all', array(
            'conditions' => $criteria,
            'recursive' => 0
        ));
        
        $this->set('results', AppModel::sortWithUrl($results, $this->passedArgs)); // set for display purposes...
        $this->set('dataForDetail', $batchSet);
        $this->set('atimStructureForResults', $atimStructureForResults);
        $tmp = array();
        if (isset($atimStructureForResults['Structure']['alias'])) {
            $batchSet['BatchSet']['structure_alias'] = $atimStructureForResults['Structure']['alias'];
        } else {
            foreach ($atimStructureForResults['Structure'] as $struct) {
                $tmp[] = $struct['alias'];
            }
            $batchSet['BatchSet']['structure_alias'] = implode(",", $tmp);
        }
        $actions = array();
        if (count($results)) {
            $actions = $this->BatchSet->getDropdownOptions($batchSet['BatchSet']['plugin'], $batchSet['BatchSet']['model'], $batchSet['BatchSet']['lookup_key_name'], $batchSet['BatchSet']['structure_alias'], $lookupModelName, $lookupKeyName, $batchSetId);
            
            $tmp = array(
                0 => array(
                    'label' => __('remove from batch set'),
                    'value' => 'Datamart/BatchSets/remove/' . $batchSetId . '/'
                )
            );
            if (! is_numeric($batchSet['BatchSet']['datamart_structure_id'])) {
                $tmp[1] = array(
                    'label' => __('create generic batch set'),
                    'value' => 'Datamart/BatchSets/add/-1'
                );
            }
            $actions[0]['children'] = array_merge($tmp, $actions[0]['children']);
            
            if ($this->DatamartStructure->getIdByModelName($batchSet['BatchSet']['model']) != null) {
                $actions[] = array(
                    'label' => __("initiate browsing"),
                    'value' => "Datamart/Browser/batchToDatabrowser/" . $batchSet['BatchSet']['model'] . "/"
                );
            }
        }
        
        $this->set('actions', $actions);
        
        $ctrappFormLinks = array();
        $ctrappFormLinks = $batchSet['BatchSet']['form_links_for_results'];
        $this->set('ctrappFormLinks', $ctrappFormLinks); // set for display purposes...
        
        $this->set('displayUnlockButton', $this->BatchSet->allowToUnlock($batchSetId));
    }

    /**
     *
     * @param int $targetBatchSetId
     */
    public function add($targetBatchSetId = 0)
    {
        // if not an already existing Batch SET...
        $isGeneric = $targetBatchSetId == - 1;
        if ($isGeneric) {
            $targetBatchSetId = 0;
        }
        $browsingResult = null;
        if (! $targetBatchSetId) {
            // Create new batch set
            if (array_key_exists('node', $this->request->data)) {
                // use databrowser node id to get BATCHSET field values
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $structure = $this->Structures->getFormById($browsingResult['DatamartStructure']['structure_id']);
                if (empty($browsingResult) || empty($structure)) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $this->request->data['BatchSet']['datamart_structure_id'] = $browsingResult['DatamartStructure']['id'];
            } elseif (array_key_exists('BatchSet', $this->request->data) && isset($this->request->data['BatchSet']['datamart_structure_id'])) {
                $this->request->data['BatchSet']['datamart_structure_id'] = $this->request->data['BatchSet']['datamart_structure_id'];
            } elseif (array_key_exists('Report', $this->request->data) && isset($this->request->data['Report']['datamart_structure_id'])) {
                $this->request->data['BatchSet']['datamart_structure_id'] = $this->request->data['Report']['datamart_structure_id'];
            } elseif (array_key_exists('BatchSet', $this->request->data)) {
                $batchSetTmp = $this->BatchSet->find('first', array(
                    'conditions' => array(
                        'BatchSet.id' => $this->request->data['BatchSet']['id']
                    ),
                    'recursive' => 0
                ));
                unset($this->request->data['BatchSet']['id']);
                // create a generic from a generic
                $this->request->data['BatchSet']['datamart_structure_id'] = $batchSetTmp['BatchSet']['datamart_structure_id'];
            } elseif (isset($this->request->params['_data'])) {
                // creation via the "add to tmp batchset button"
                $data = $this->request->params['_data'];
                $modelName = key($data[0]);
                $datamartStructureId = $this->DatamartStructure->getIdByModelName($modelName);
                $model = $this->DatamartStructure->getModel($datamartStructureId, $modelName);
                $data = AppController::defineArrayKey($data, $model->name, $model->primaryKey, true);
                $ids = array_keys($data);
                
                $this->request->data['BatchSet']['flag_tmp'] = true;
                $this->request->data['BatchSet']['datamart_structure_id'] = $datamartStructureId;
                $this->request->data['BatchSet']['user_id'] = $this->Session->read('Auth.User.id');
                $this->request->data['BatchSet']['group_id'] = $this->Session->read('Auth.User.group_id');
                $this->request->data['BatchSet']['sharing_status'] = 'user';
                $this->BatchSet->addWritableField(array(
                    'title',
                    'user_id',
                    'group_id',
                    'sharing_status',
                    'datamart_structure_id',
                    'flag_tmp'
                ));
                $this->BatchSet->save($this->request->data['BatchSet']);
                
                // get new SET id, and save
                $targetBatchSetId = $this->BatchSet->getLastInsertId();
                $ids = array_unique($ids);
                $ids = array_filter($ids);
                
                foreach ($ids as $id) {
                    // setup ARRAY for ADDING/SAVING
                    $saveArray[] = array(
                        'set_id' => $targetBatchSetId,
                        'lookup_id' => $id
                    );
                }
                
                // saving
                $this->BatchId->checkWritableFields = false;
                $this->BatchId->saveAll($saveArray);
                
                // done
                // $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
                $this->redirect('/Datamart/BatchSets/listall/' . $targetBatchSetId);
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // generate TEMP description for this SET
            if (empty($this->request->data['BatchSet']['title'])) {
                $this->request->data['BatchSet']['title'] = date('Y-m-d G:i');
            }
            
            // save hidden MODEL value as new BATCH SET
            $this->request->data['BatchSet']['user_id'] = $this->Session->read('Auth.User.id');
            $this->request->data['BatchSet']['group_id'] = $this->Session->read('Auth.User.group_id');
            $this->request->data['BatchSet']['sharing_status'] = 'user';
            $this->BatchSet->addWritableField(array(
                'title',
                'user_id',
                'group_id',
                'sharing_status',
                'datamart_structure_id'
            ));
            $this->BatchSet->save($this->request->data['BatchSet']);
            
            // get new SET id, and save
            $targetBatchSetId = $this->BatchSet->getLastInsertId();
        }
        
        // get BatchSet for source info
        $this->request->data['BatchSet']['id'] = $targetBatchSetId;
        $this->BatchSet->id = $targetBatchSetId;
        
        $batchSet = $this->BatchSet->read();
        if (! $this->BatchSet->isUserAuthorizedToRw($batchSet, true)) {
            return;
        }
        
        $lookupKeyName = null;
        $model = null;
        $datamartStructure = $this->DatamartStructure->findById($batchSet['BatchSet']['datamart_structure_id']);
        $datamartStructure = $datamartStructure['DatamartStructure'];
        $model = $batchSet['DatamartStructure']['model'];
        if ($datamartStructure['control_master_model']) {
            $batchSet['BatchSet']['model'] = $datamartStructure['control_master_model'];
            if (isset($this->request->data[$datamartStructure['model']])) {
                $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
                $model = $datamartStructure['model'];
                $lookupKeyName = $modelInstance->primaryKey;
            } else {
                $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['control_master_model'], true);
                $model = $datamartStructure['control_master_model'];
                $lookupKeyName = $modelInstance->primaryKey;
            }
        } else {
            $modelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
            $batchSet['BatchSet']['model'] = $datamartStructure['model'];
            $lookupKeyName = $modelInstance->primaryKey;
        }
        $batchSet['BatchSet']['plugin'] = $batchSet['DatamartStructure']['plugin'];
        
        if (isset($this->request->data[$model])) {
            // saving batch_set ids. To avoid dupes, load all existings ids, delete them, merge with the new ones, save.
            $batchSetIds = array();
            
            // load and delete existing ids
            foreach ($batchSet['BatchId'] as $array) {
                $batchSetIds[] = $array['lookup_id'];
                
                // remove from SAVED batch set
                $this->BatchId->delete($array['id']);
            }
            
            // merging with the new ones
            if (is_array($this->request->data[$model][$lookupKeyName])) {
                $batchSetIds = array_merge($this->request->data[$model][$lookupKeyName], $batchSetIds);
            } elseif ($this->request->data[$model][$lookupKeyName] == 'all' && array_key_exists('node', $this->request->data)) {
                if (! $browsingResult) {
                    $browsingResult = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $this->request->data['node']['id']
                        )
                    ));
                }
                $batchSetIds = array_merge(explode(",", $browsingResult['BrowsingResult']['id_csv']), $batchSetIds);
            } else {
                $batchSetIds = array_merge(explode(",", $this->request->data[$model][$lookupKeyName]), $batchSetIds);
            }
            
            // clean up IDS, removing blanks and duplicates...
            $batchSetIds = array_unique($batchSetIds);
            $batchSetIds = array_filter($batchSetIds);
            
            foreach ($batchSetIds as $integer) {
                // setup ARRAY for ADDING/SAVING
                $saveArray[] = array(
                    'set_id' => $this->request->data['BatchSet']['id'],
                    'lookup_id' => $integer
                );
            }
            
            // saving
            $this->BatchId->checkWritableFields = false;
            $this->BatchId->saveAll($saveArray);
        } else {
            AppController::addWarningMsg(__("failed to add data to the batch set"));
        }
        // clear SESSION after done...
        $_SESSION['ctrapp_core']['datamart']['process'] = array();
        // $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
        $this->redirect('/Datamart/BatchSets/listall/' . $this->request->data['BatchSet']['id']);
        
        exit();
    }

    /**
     *
     * @param int $batchSetId
     */
    public function edit($batchSetId = 0)
    {
        $this->set('atimMenuVariables', array(
            'BatchSet.id' => $batchSetId
        ));
        $this->Structures->set('querytool_batch_set');
        
        if (! empty($this->request->data)) {
            $this->BatchSet->id = $batchSetId;
            $this->request->data['BatchSet']['flag_tmp'] = false;
            $this->BatchSet->addWritableField('flag_tmp');
            unset($this->request->data['BatchSet']['created_by']);
            if ($this->BatchSet->save($this->request->data)) {
                $this->atimFlash(__('your data has been updated'), '/Datamart/BatchSets/listall/' . $batchSetId);
            }
        } else {
            $batchSet = $this->BatchSet->find('first', array(
                'conditions' => array(
                    'BatchSet.id' => $batchSetId
                )
            ));
            if (! $this->BatchSet->isUserAuthorizedToRw($batchSet, true)) {
                return;
            }
            if ($batchSet['BatchSet']['datamart_structure_id']) {
                $tmp = $this->DatamartStructure->findById($batchSet['BatchSet']['datamart_structure_id']);
                $batchSet['BatchSet']['model'] = $tmp['DatamartStructure']['model'];
            }
            $this->request->data = $batchSet;
        }
    }

    /**
     *
     * @param int $batchSetId
     */
    public function delete($batchSetId = 0)
    {
        $batchSet = $this->BatchSet->getOrRedirect($batchSetId);
        if (! $this->BatchSet->isUserAuthorizedToRw($batchSet, true)) {
            return;
        }
        $this->BatchSet->delete($batchSetId);
        $this->atimFlash(__('your data has been deleted'), '/Datamart/BatchSets/index');
    }

    public function deleteInBatch()
    {
        // Get all user batchset
        $userBankId = $_SESSION['Auth']['User']['Group']['bank_id'];
        $userBankGroupIds = array(
            '-1'
        );
        if ($userBankId) {
            $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
            $tmpBankGroupIds = $bankModel->getBankGroupIds($userBankId);
            if ($tmpBankGroupIds) {
                $userBankGroupIds = $tmpBankGroupIds;
            }
        }
        
        $availableBatchsetsConditions = array(
            'OR' => array(
                'BatchSet.user_id' => $_SESSION['Auth']['User']['id'],
                array(
                    'BatchSet.group_id' => $_SESSION['Auth']['User']['group_id'],
                    'BatchSet.sharing_status' => array(
                        'group',
                        'bank'
                    )
                ),
                array(
                    'BatchSet.group_id' => $userBankGroupIds,
                    'BatchSet.sharing_status' => 'bank'
                ),
                'BatchSet.sharing_status' => 'all'
            )
        );
        $userBatchsets = $this->BatchSet->find('all', array(
            'conditions' => $availableBatchsetsConditions,
            'order' => 'BatchSet.created DESC'
        ));
        $userBatchsetsFromId = array();
        foreach ($userBatchsets as $key => $tmpData) {
            $userBatchsets[$key]['BatchSet']['count_of_BatchId'] = count($tmpData['BatchId']);
            $userBatchsetsFromId[$tmpData['BatchSet']['id']] = $tmpData;
        }
        $this->BatchSet->completeData($userBatchsets);
        $this->set('userBatchsets', $userBatchsets);
        
        $this->set('atimMenuVariables', array(
            'Param.Type_Of_List' => 'user'
        ));
        $this->set('atimMenu', $this->Menus->get('/Datamart/BatchSets/index/'));
        $this->Structures->set('querytool_batch_set');
        
        if (! empty($this->request->data)) {
            $deletionDone = false;
            $this->request->data['BatchSet']['ids'] = array_filter($this->request->data['BatchSet']['ids']);
            $submittedDataValidates = true;
            foreach ($this->request->data['BatchSet']['ids'] as $batchSetId) {
                if (! array_key_exists($batchSetId, $userBatchsetsFromId)) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if ($userBatchsetsFromId[$batchSetId]['BatchSet']['locked']) {
                    AppController::addWarningMsg(__('at least one batchset is locked'));
                    $submittedDataValidates = false;
                }
            }
            if ($submittedDataValidates) {
                foreach ($this->request->data['BatchSet']['ids'] as $batchSetId) {
                    if (! empty($batchSetId)) {
                        $this->BatchSet->delete($batchSetId);
                    }
                }
                $this->atimFlash(__('your data has been deleted'), '/Datamart/BatchSets/index/user');
            }
        }
    }

    /**
     *
     * @param $batchSetId
     */
    public function remove($batchSetId)
    {
        $batchSet = $this->BatchSet->getOrRedirect($batchSetId);
        if (! $this->BatchSet->isUserAuthorizedToRw($batchSet, true)) {
            return;
        }
        
        // set function variables, makes script readable :)
        $batchSetId = $batchSet['BatchSet']['id'];
        $batchSetModelInstance = null;
        $datamartStructure = $this->DatamartStructure->findById($batchSet['BatchSet']['datamart_structure_id']);
        $datamartStructure = $datamartStructure['DatamartStructure'];
        $batchSetModelInstance = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
        
        if (count($this->request->data[$batchSetModelInstance->name][$batchSetModelInstance->primaryKey])) {
            // START findall criteria
            $criteria = 'set_id="' . $batchSetId . '" ' . 'AND ( lookup_id="' . implode('" OR lookup_id="', $this->request->data[$batchSetModelInstance->name][$batchSetModelInstance->primaryKey]) . '" )';
            
            // get BatchId ROWS and remove from SAVED batch set
            $results = $this->BatchId->find('all', array(
                'conditions' => $criteria
            ));
            foreach ($results as $id) {
                $this->BatchId->delete($id['BatchId']['id']);
            }
        }
        
        // redirect back to list Batch SET
        // $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
        $this->redirect('/Datamart/BatchSets/listall/' . $batchSetId);
        exit();
    }

    /**
     *
     * @param $batchId
     */
    public function save($batchId)
    {
        $batchSet = $this->BatchSet->getOrRedirect($batchId);
        if ($batchSet['BatchSet']['user_id'] == $this->Session->read('Auth.User.id')) {
            $this->BatchSet->checkWritableFields = false;
            $this->BatchSet->id = $batchId;
            $this->BatchSet->save(array(
                'flag_tmp' => 0
            ));
            $this->atimFlash(__('your data has been updated'), "/Datamart/BatchSets/index");
        } else {
            $this->redirect('/Pages/err_internal?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }

    /**
     *
     * @param $batchSetId
     */
    public function unlock($batchSetId)
    {
        $batchSet = $this->BatchSet->getOrRedirect($batchSetId);
        if ($this->BatchSet->allowToUnlock($batchSetId)) {
            $this->BatchSet->checkWritableFields = false;
            $this->BatchSet->id = $batchSetId;
            $this->BatchSet->save(array(
                'locked' => 0
            ));
            $this->atimFlash(__('your data has been updated'), "/Datamart/BatchSets/listall/$batchSetId");
        } else {
            $this->atimFlashError(__('you are not allowed to unlock this batchset'), "/Datamart/BatchSets/index/user");
        }
    }
}