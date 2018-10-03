<?php

/**
 * Class BrowserController
 */
class BrowserController extends DatamartAppController
{

    public $uses = array(
        'Datamart.Browser',
        'Datamart.DatamartStructure',
        'Datamart.BrowsingResult',
        'Datamart.BrowsingControl',
        'Datamart.BrowsingIndex',
        'Datamart.BatchSet',
        'Datamart.SavedBrowsingIndex',
        'ExternalLink'
    );

    public function index()
    {
        $this->Structures->set("datamart_browsing_indexes");
        $tmpBrowsing = $this->BrowsingIndex->find('all', array(
            'conditions' => array(
                "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'),
                'BrowsingIndex.temporary' => true
            ),
            'order' => array(
                'BrowsingResult.created DESC'
            )
        ));
        
        while (count($tmpBrowsing) > $this->BrowsingIndex->tmpBrowsingLimit) {
            $unit = array_pop($tmpBrowsing);
            $this->BrowsingIndex->checkWritableFields = false;
            $this->BrowsingResult->checkWritableFields = false;
            $this->BrowsingIndex->delete($unit['BrowsingIndex']['id']);
            $this->BrowsingResult->delete($unit['BrowsingResult']['id'], true);
        }
        
        $this->set('tmpBrowsing', $tmpBrowsing);
        $this->set('tmpBrowsingLimit', $this->BrowsingIndex->tmpBrowsingLimit);
        
        $this->request->data = $this->paginate($this->BrowsingIndex, array(
            "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'),
            'BrowsingIndex.temporary' => false
        ));
    }

    /**
     *
     * @param $indexId
     */
    public function edit($indexId)
    {
        $this->set("indexId", $indexId);
        $this->Structures->set("datamart_browsing_indexes");
        if (empty($this->request->data)) {
            $this->request->data = $this->BrowsingIndex->find('first', array(
                'conditions' => array(
                    'BrowsingIndex.id' => $indexId,
                    "BrowsingResult.user_id" => $this->Session->read('Auth.User.id')
                )
            ));
            if ($this->request->data['BrowsingIndex']['temporary']) {
                AppController::addWarningMsg(__('adding notes to a temporary browsing automatically moves it towards the saved browsing list'));
            }
        } else {
            $this->BrowsingIndex->id = $indexId;
            unset($this->request->data['BrowsingIndex']['created']);
            $this->request->data['BrowsingIndex']['temporary'] = false;
            $this->BrowsingIndex->addWritableField(array(
                'temporary'
            ));
            $this->BrowsingIndex->save($this->request->data);
            $this->atimFlash(__('your data has been updated'), "/Datamart/Browser/index");
        }
    }

    /**
     *
     * @param $indexId
     */
    public function delete($indexId)
    {
        $this->BrowsingResult; // lazy load
        $this->request->data = $this->BrowsingIndex->find('first', array(
            'conditions' => array(
                'BrowsingIndex.id' => $indexId,
                "BrowsingResult.user_id" => $this->Session->read('Auth.User.id')
            )
        ));
        if (! empty($this->request->data)) {
            $this->BrowsingIndex->atimDelete($indexId);
            $this->BrowsingResult->atimDelete($this->request->data['BrowsingIndex']['root_node_id']);
            $this->atimFlash(__('your data has been deleted'), '/Datamart/Browser/index/');
        } else {
            $this->atimFlashError(__('error deleting data - contact administrator'), '/Datamart/Browser/index/');
        }
    }

    /**
     *
     * @param $controlId
     * @return array
     */
    private function getIdsAndParentChild($controlId)
    {
        $subStructureId = null;
        $parentChild = null;
        if (strpos($controlId, Browser::$subModelSeparatorStr) !== false) {
            list ($controlId, $subStructureId) = explode(Browser::$subModelSeparatorStr, $controlId);
        }
        if (in_array(substr($controlId, - 1), array(
            'c',
            'p'
        ))) {
            $parentChild = substr($controlId, - 1);
            $controlId = substr($controlId, 0, - 1);
        }
        return array(
            $controlId,
            $subStructureId,
            $parentChild
        );
    }

    /**
     * Core of the databrowser, handles all browsing requests.
     * Searches, normal display, merged display and overflow display.
     *
     * @param int $nodeId 0 if it's a new browsing, the node id to display or the parent node id when in a search form
     * @param int|string $controlId The datamart structure control id. If there is a substructure,
     *        the string will separate the structure id from the substructure id with an underscore. It will be of the form id_sub-id
     * @param int $mergeTo If a merged display is required, the node id to merge to. The merge direction is always from node_id to merge_to
     */
    public function browse($nodeId = 0, $controlId = 0, $mergeTo = 0)
    {
        $totalMemory = getTotalMemoryCapacity();
        ini_set("memory_limit", $totalMemory / 4 . "M");
        
        if ($controlId != 0) {
            $browsing = $this->DatamartStructure->findById($controlId);
            if (isset($browsing['DatamartStructure']['index_link']) && ! AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])) {
                $url = Router::url(null, true);
                $plugin = $this->request->params['plugin'];
                $controller = $this->request->params['controller'];
                $action = $this->request->params['action'];
                $pca = '/' . $plugin . '/' . $controller . '/' . $action . '/';
                $index = strpos($url, $pca);
                $url = substr($url, 0, $index + strlen($pca));
                $this->atimFlashError(__("You are not authorized to access that location."), $url);
            }
        }
        if ($controlId != 0 && isset($_SESSION['post_data'])) {
            $plugin = $this->request->params['plugin'];
            $controller = $this->request->params['controller'];
            $action = $this->request->params['action'];
            $param = $controlId . "";
            if (isset($_SESSION['post_data'][$plugin][$controller][$action][$param])) {
                convertArrayToJavaScript($_SESSION['post_data'][$plugin][$controller][$action][$param], 'jsPostData');
            }
        }
        $this->BrowsingResult->checkWritableFields = false;
        $this->BrowsingIndex->checkWritableFields = false;
        $this->Structures->set("empty", "empty");
        $browsing = null;
        $checkList = false;
        $lastControlId = 0;
        $parentChild = false;
        $this->set('controlId', (int) $controlId); // cast as it might end with c(child) or p(parent)
        $this->set('mergeTo', $mergeTo);
        $this->Browser; // lazy laod
        $helpUrl = $this->ExternalLink->find('first', array(
            'conditions' => array(
                'name' => 'databrowser_help'
            )
        ));
        $this->set("helpUrl", $helpUrl['ExternalLink']['link']);
        
        // data handling will redirect to a straight page
        if ($this->request->data) {
            // ->browsing access<- (search form or checklist)
            if (isset($this->request->data['Browser']['search_for'])) {
                // search_for is taken from the dropdown
                if (strpos($this->request->data['Browser']['search_for'], "/") > 0) {
                    list ($controlId, $checkList) = explode("/", $this->request->data['Browser']['search_for']);
                } else {
                    $controlId = $this->request->data['Browser']['search_for'];
                    $checkList = false;
                }
            } elseif ($controlId == 0) {
                // error, the control_id should't be 0
                $this->redirect('/Pages/err_internal?p[]=control_id', null, true);
            } else {
                $checkList = true;
            }
            list ($controlId, $subStructureId, $parentChild) = $this->getIdsAndParentChild($controlId);
            // direct access array (if the user goes from 1 to 4 by going throuhg 2 and 3, the direct access are 2 and 3
            $directIdArr = explode(Browser::$modelSeparatorStr, $controlId);
            
            $this->Browser->buildDrillDownIfNeeded($this->request->data, $nodeId);
            
            $lastControlId = $directIdArr[count($directIdArr) - 1];
            if (! $checkList) {
                // going to a search screen, remove the last direct_id to avoid saving it as direct access
                array_pop($directIdArr);
            }
            
            $createdNode = null;
            // save nodes (direct and indirect)
            foreach ($directIdArr as $controlId) {
                $subStructCtrlId = null;
                if (isset($subStructureId) /* there is a sub id */ && $directIdArr[count($directIdArr) - 1] == $controlId /* this is the last element */ &&  $checkList)/* this is a checklist */{
                    $subStructCtrlId = $subStructureId;
                }
                
                $params = array(
                    'struct_ctrl_id' => $controlId,
                    'sub_struct_ctrl_id' => $subStructCtrlId,
                    'node_id' => $nodeId,
                    'last' => $lastControlId == $controlId,
                    'parent_child' => $parentChild
                );
                if (! $createdNode = $this->Browser->createNode($params)) {
                    // something went wrong. A flash screen has been called.
                    return;
                }
                
                $nodeId = $createdNode['browsing']['BrowsingResult']['id'];
            }
            
            if ($createdNode) {
                $resultStructure = $createdNode['result_struct'];
                $browsing = $createdNode['browsing'];
                unset($createdNode);
            }
            
            // all nodes saved, now load the proper form
            if ($checkList) {
                $this->redirect('/Datamart/Browser/browse/' . $nodeId . '/');
            }
            
            if ($subStructureId) {
                $this->redirect('/Datamart/Browser/browse/' . $nodeId . '/' . $lastControlId . $parentChild . Browser::$subModelSeparatorStr . $subStructureId);
            }
            $this->redirect('/Datamart/Browser/browse/' . $nodeId . '/' . $lastControlId . $parentChild);
        } else {
            if ($nodeId == 0) {
                if ($controlId) {
                    // search screen
                    list ($controlId, $subStructureId, $parentChild) = $this->getIdsAndParentChild($controlId);
                    $browsing = $this->DatamartStructure->findById($controlId);
                    $lastControlId = $controlId;
                } else {
                    // new access
                    $this->set("dropdownOptions", $this->Browser->getBrowserDropdownOptions(0, $nodeId, null, null, null, null, null, null));
                    $this->Structures->set("empty");
                    $this->set('type', "add");
                    $this->set('top', "/Datamart/Browser/browse/0/");
                }
            } else {
                if ($controlId) {
                    // search screen
                    list ($controlId, $subStructureId, $parentChild) = $this->getIdsAndParentChild($controlId);
                    $browsing = $this->DatamartStructure->findById($controlId);
                    $lastControlId = $controlId . $parentChild;
                } else {
                    // direct node access
                    $this->set('nodeId', $nodeId);
                    $browsing = $this->BrowsingResult->getOrRedirect($nodeId);
                    if ($browsing['BrowsingResult']['user_id'] != CakeSession::read('Auth.User.id')) {
                        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $checkList = true;
                }
            }
        }
        
        // handle display data
        $render = 'browse_checklist';
        if ($checkList) {
            $order = null;
            if (isset($this->passedArgs["sort"])) {
                $order = $this->passedArgs["sort"] . " " . $this->passedArgs["direction"];
            }
            $this->Browser->initDataLoad($browsing, $mergeTo, explode(",", $browsing['BrowsingResult']['id_csv']), $order);
            
            if (! $this->Browser->validPermission) {
                // $this->atimFlashError(__("You are not authorized to access that location."), Router::url( $this->here, true));
                $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
                return;
            }
            
            $browsingModel = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
            
            $this->set('top', "/Datamart/Browser/browse/" . $nodeId . "/");
            $this->set('nodeId', $nodeId);
            $this->set('type', "checklist");
            $this->set('checklistKey', $this->Browser->checklistModel->name . "." . $this->Browser->checklistUseKey);
            $this->set('checklistKeyName', $browsing['DatamartStructure']['model'] . "." . $browsingModel->primaryKey);
            $this->set('isRoot', $browsing['BrowsingResult']['parent_id'] == 0);
            
            $dropdownOptions = $this->Browser->getBrowserDropdownOptions($browsing['DatamartStructure']['id'], $nodeId, $browsing['DatamartStructure']['plugin'], $this->Browser->checklistModel->name, $browsing['DatamartStructure']['model'], $this->Browser->checklistUseKey, $browsingModel->primaryKey, $this->Browser->checklistSubModelsIdFilter);
            foreach ($dropdownOptions as $key => $option) {
                if (isset($option['value']) && strpos($option['value'], 'javascript:setCsvPopup(\'Datamart/Csv/csv') === 0) {
                    unset($dropdownOptions[$key]);
                }
            }
            $action = 'javascript:setCsvPopup("Datamart/Browser/csv/%d/' . $nodeId . '/' . $mergeTo . '/");';
            $dropdownOptions[] = array(
                'value' => '0',
                'label' => __('export as CSV file (comma-separated values)'),
                'value' => sprintf($action, 0)
            );
            
            $this->set("dropdownOptions", $dropdownOptions);
            $this->Structures->set("empty");
            
            if ($this->Browser->checklistModel->name != $browsing['DatamartStructure']['model']) {
                $browsing['DatamartStructure']['index_link'] = str_replace($browsing['DatamartStructure']['model'], $this->Browser->checklistModel->name, str_replace($browsing['DatamartStructure']['model'] . "." . $browsingModel->primaryKey, $this->Browser->checklistModel->name . "." . $this->Browser->checklistUseKey, $browsing['DatamartStructure']['index_link']));
            }
            $this->set('index', $browsing['DatamartStructure']['index_link']);
            if ($this->Browser->count <= Configure::read('databrowser_and_report_results_display_limit')) {
                $this->set("resultStructure", $this->Browser->resultStructure);
                $this->request->data = $this->Browser->getDataChunk(Configure::read('databrowser_and_report_results_display_limit'));
                $this->set("header", array(
                    'title' => __('result'),
                    'description' => $this->Browser->checklistHeader
                ));
            } else {
                // overflow
                $this->request->data = 'all';
            }
            $this->set('mergedIds', $this->Browser->mergedIds);
            $this->set('unusedParent', $browsing['BrowsingResult']['parent_id'] && $browsing['BrowsingResult']['raw']);
            
            $csvMergeData = $this->BrowsingResult->getSingleLineMergeableNodes($nodeId);
            $this->set('csvMergeData', $csvMergeData);
        } elseif ($browsing) {
            if (! AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])) {
                // $this->atimFlashError(__("You are not authorized to access that location."), Router::url( $this->here, true));
                $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
                return;
            }
            // search screen
            $tmpModel = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
            if (isset($subStructureId) && $ctrlName = $tmpModel->getControlName()) {
                $alternateInfo = Browser::getAlternateStructureInfo($browsing['DatamartStructure']['plugin'], $ctrlName, $subStructureId);
                $alternateAlias = $alternateInfo['form_alias'];
                
                // get the structure and remove fields from the control table
                $structure = $this->Structures->get('form', $alternateAlias);
                foreach ($structure['Sfs'] as $key => $field) {
                    if ($field['model'] == $ctrlName) {
                        unset($structure['Sfs'][$key]);
                    }
                }
                $this->set('atimStructure', $structure);
                $lastControlId .= "-" . $subStructureId;
                $this->set("header", array(
                    "title" => __("search"),
                    "description" => __($browsing['DatamartStructure']['display_name']) . " > " . Browser::getTranslatedDatabrowserLabel($alternateInfo['databrowser_label'])
                ));
            } else {
                $this->set('atimStructure', $this->Structures->getFormById($browsing['DatamartStructure']['structure_id']));
                $this->set("header", array(
                    "title" => __("search"),
                    "description" => __($browsing['DatamartStructure']['display_name'])
                ));
            }
            $this->set('top', "/Datamart/Browser/browse/" . $nodeId . "/" . $lastControlId . "/");
            $this->set('nodeId', $nodeId);
            if ($browsing['DatamartStructure']['adv_search_structure_alias']) {
                Browser::$cache['current_node_id'] = $nodeId;
                $advancedStructure = $this->Structures->get('form', $browsing['DatamartStructure']['adv_search_structure_alias']);
                $this->set('advancedStructure', $advancedStructure);
            }
            
            // determine which search counter to display
            $path = $this->BrowsingResult->getPath($nodeId);
            $currentStructureId = $browsing['DatamartStructure']['id'];
            $countersStructureFields = array();
            if ($path) {
                while ($parentNode = array_pop($path)) {
                    if ($this->BrowsingControl->find1ToN($currentStructureId, $parentNode['BrowsingResult']['browsing_structures_id'])) {
                        // valid parent
                        $browsingResult = $this->BrowsingResult->findById($parentNode['BrowsingResult']['id']);
                        if (false) {
                            // Disabled: Adds a counter field to search forms when going from
                            // 1 to N. Unclear if useful.
                            $countersStructureFields[] = array(
                                'model' => '0',
                                'field' => 'counter_' . $parentNode['BrowsingResult']['id'],
                                'type' => 'integer_positive',
                                'flag_search' => 1,
                                'flag_search_readonly' => 0,
                                'display_column' => 1,
                                'display_order' => 1,
                                'language_label' => $browsingResult['DatamartStructure']['display_name'],
                                'language_heading' => '',
                                'tablename' => '',
                                'language_tag' => '',
                                'language_help' => '',
                                'setting' => '',
                                'default' => '',
                                'flag_confidential' => '',
                                'flag_float' => '',
                                'margin' => '',
                                'StructureValidation' => array()
                            );
                        }
                        $currentStructureId = $parentNode['BrowsingResult']['browsing_structures_id'];
                    } else {
                        break;
                    }
                }
            }
            
            if ($countersStructureFields) {
                $this->set('countersStructureFields', array(
                    'Structure' => array(
                        'alias' => 'custom'
                    ),
                    'Sfs' => $countersStructureFields
                ));
            }
            
            $render = 'browse_search';
        }
        $this->render($render);
    }

    /**
     * Used to generate the databrowser csv
     *
     * @param $allFields
     * @param $nodeId
     * @param int $mergeTo
     * @internal param int $parentId
     */
    public function csv($allFields, $nodeId, $mergeTo)
    {
        $totalMemory = getTotalMemoryCapacity();
        ini_set("memory_limit", $totalMemory / 4 . "M");
        ini_set("max_execution_time", - 1);
        
        $config = array_merge($this->request->data['Config'], $this->request->data[0]);
        
        unset($this->request->data[0]);
        unset($this->request->data['Config']);
        $this->configureCsv($config);
        
        $browsing = $this->BrowsingResult->findById($nodeId);
        
        if (! AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])) {
            // $this->atimFlashError(__("You are not authorized to access that location."), Router::url(null, true));
            $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
            return;
        }
        
        $ids = null;
        if ($this->request->data) {
            $ids = current(current($this->request->data));
        } else {
            $ids = explode(",", $browsing['BrowsingResult']['id_csv']);
        }
        
        $this->layout = false;
        Configure::write('debug', 0);
        AppController::atimSetCookie(false);
        if ($config['redundancy'] == 'same' && isset($config['singleLineNodes']) && ! empty($config['singleLineNodes'])) {
            // check selected nodes
            $mergeableNodes = $this->BrowsingResult->getSingleLineMergeableNodes($nodeId);
            $validIds = array_merge(array_keys($mergeableNodes['parents']), array_keys($mergeableNodes['flat_children']));
            foreach ($config['singleLineNodes'] as $k => $receivedId) {
                if (! in_array($receivedId, $validIds)) {
                    unset($config['singleLineNodes'][$k]);
                }
            }
            
            // for each added nodes, count the max width
            $nodesInfo = array(
                $nodeId => array(
                    'max_length' => 1
                )
            );
            $totalMaxLength = 1;
            foreach ($config['singleLineNodes'] as $receivedId) {
                $nodesInfo[$receivedId] = array(
                    'max_length' => $this->BrowsingResult->countMaxDuplicates($nodeId, $receivedId)
                );
                $totalMaxLength += $nodesInfo[$receivedId]['max_length'];
            }
            
            $baseFetchLimit = (int) (500 / $totalMaxLength);
            $offset = 0;
            
            // get all nodes structures
            $browsingResults = $this->BrowsingResult->find('all', array(
                'conditions' => array(
                    'BrowsingResult.id' => array_merge(array(
                        $nodeId
                    ), $config['singleLineNodes'])
                )
            ));
            $browsingResults = AppController::defineArrayKey($browsingResults, 'BrowsingResult', 'id', true);
            $structuresArray = array(); // structures[node_id] = structure to use
            $models = array(); // models[node_id] = model
            $joins = array(); // joins[node_id] = joins array
            AppModel::getInstance('Datamart', 'Browser'); // for a static call
            foreach ($browsingResults as $browsingResult) {
                // permissions
                if (! AppController::checkLinkPermission($browsingResult['DatamartStructure']['index_link'])) {
                    // $this->atimFlashError(__("You are not authorized to access that location."), Router::url( $this->here, true));
                    $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
                    return;
                }
                
                $info = $this->BrowsingResult->getModelAndStructureForNode($browsingResult);
                $structuresArray[$browsingResult['BrowsingResult']['id']] = $info['structure'];
                $nodesInfo[$browsingResult['BrowsingResult']['id']]['display_name'] = __($browsingResult['DatamartStructure']['display_name']) . ($info['header_sub_type'] ? ' - ' . Browser::getTranslatedDatabrowserLabel($info['header_sub_type']) : '');
                $models[$browsingResult['BrowsingResult']['id']] = $info['model'];
                if ($browsingResult['BrowsingResult']['id'] != $nodeId) {
                    $joins[$browsingResult['BrowsingResult']['id']] = $this->BrowsingResult->getJoins($browsingResult['BrowsingResult']['id'], $nodeId);
                }
            }
            
            $this->set('nodesInfo', $nodesInfo);
            $this->set('structuresArray', $structuresArray);
            $this->set('csvHeader', true);
            
            while ($primaryData = $models[$nodeId]->find('all', array(
                'conditions' => array(
                    $models[$nodeId]->name . '.' . $models[$nodeId]->primaryKey => $ids
                ),
                'limit' => $baseFetchLimit,
                'offset' => $offset
            ))) {
                $primaryData = AppController::defineArrayKey($primaryData, $models[$nodeId]->name, $models[$nodeId]->primaryKey, true);
                $this->request->data = array();
                $this->request->data[$nodeId] = AppController::defineArrayKey($primaryData, $models[$nodeId]->name, $models[$nodeId]->primaryKey);
                $baseModelCondition = array(
                    $models[$nodeId]->name . '.' . $models[$nodeId]->primaryKey => array_keys($primaryData)
                );
                foreach ($nodesInfo as $key => $nodeInfo) {
                    if ($key == $nodeId) {
                        continue; // skip primary node
                    }
                    foreach ($joins[$key] as $join) {
                        unset($models[$key]->belongsTo[$join['alias']]);
                    }
                    $models[$key]->find('first');
                    $data = $models[$key]->find('all', array(
                        'fields' => array(
                            '*'
                        ),
                        'joins' => $joins[$key],
                        'conditions' => array_merge($baseModelCondition, array(
                            $models[$key]->name . '.' . $models[$key]->primaryKey . ' IN (' . $browsingResults[$key]['BrowsingResult']['id_csv'] . ')'
                        ))
                    ));
                    $this->request->data[$key] = AppController::defineArrayKey($data, $models[$nodeId]->name, $models[$nodeId]->primaryKey);
                }
                $offset += $baseFetchLimit;
                $this->render('../Csv/csv_same_line');
                $this->set('csvHeader', false);
            }
        } else {
            $this->Browser->InitDataLoad($browsing, $config['redundancy'] == 'same' ? 0 : $mergeTo, $ids);
            
            if (! $this->Browser->validPermission) {
                // $this->atimFlashError(__("You are not authorized to access that location."), Router::url( $this->here, true));
                $this->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
                return;
            }
            
            $this->set("resultStructure", $this->Browser->resultStructure);
            
            $this->set('csvHeader', true);
            while ($this->request->data = $this->Browser->getDataChunk(300)) {
                $this->render('../Csv/csv');
                $this->set('csvHeader', false);
            }
        }
        
        $this->render(false);
        $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
    }

    /**
     * If the model is found, creates a batchset based based on it and displays the first node.
     * The ids must be in
     * $this->request->data[$model][id]
     *
     * @param String $model
     * @param string $source
     */
    public function batchToDatabrowser($model, $source = 'batchset')
    {
        $dmStructure = $this->DatamartStructure->find('first', array(
            'conditions' => array(
                'OR' => array(
                    'DatamartStructure.model' => $model,
                    'DatamartStructure.control_master_model' => $model
                )
            ),
            'recursive' => - 1
        ));
        
        if ($dmStructure == null) {
            $this->redirect('/Pages/err_internal?p[]=model+not+found', null, true);
        }
        
        $model = null;
        if (array_key_exists($dmStructure['DatamartStructure']['model'], $this->request->data)) {
            $model = AppModel::getInstance($dmStructure['DatamartStructure']['plugin'], $dmStructure['DatamartStructure']['model'], true);
        } elseif (array_key_exists($dmStructure['DatamartStructure']['control_master_model'], $this->request->data)) {
            $model = AppModel::getInstance($dmStructure['DatamartStructure']['plugin'], $dmStructure['DatamartStructure']['control_master_model'], true);
        } else {
            $this->redirect('/Pages/err_internal?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $ids = $this->request->data[$model->name][$model->primaryKey];
        $ids = array_filter($ids);
        
        if (empty($ids)) {
            $this->redirect('/Pages/err_internal?p[]=no+ids', null, true);
        }
        
        sort($ids);
        
        $save = array(
            'BrowsingResult' => array(
                "user_id" => $this->Session->read('Auth.User.id'),
                "parent_id" => 0,
                "browsing_structures_id" => $dmStructure['DatamartStructure']['id'],
                "browsing_structures_sub_id" => 0,
                "id_csv" => implode(",", $ids),
                'raw' => 1,
                "browsing_type" => 'initiated from ' . $source
            )
        );
        
        $tmp = $this->BrowsingResult->find('first', array(
            'conditions' => Set::flatten($save)
        ));
        $nodeId = null;
        if (empty($tmp)) {
            $this->BrowsingResult->checkWritableFields = false;
            $this->BrowsingResult->save($save);
            $nodeId = $this->BrowsingResult->id;
            $this->BrowsingIndex->checkWritableFields = false;
            $this->BrowsingIndex->save(array(
                "BrowsingIndex" => array(
                    'root_node_id' => $nodeId
                )
            ));
        } else {
            // current set already exists, use it
            $nodeId = $tmp['BrowsingResult']['id'];
        }
        $this->redirect('/Datamart/Browser/browse/' . $nodeId);
    }

    /**
     *
     * @param $indexId
     */
    public function save($indexId)
    {
        $this->BrowsingResult; // lazy load
        $this->request->data = $this->BrowsingIndex->find('first', array(
            'conditions' => array(
                'BrowsingIndex.id' => $indexId,
                "BrowsingResult.user_id" => $this->Session->read('Auth.User.id')
            )
        ));
        if (empty($this->request->data)) {
            $this->redirect('/Pages/err_internal?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } else {
            $this->request->data['BrowsingIndex']['temporary'] = false;
            $this->BrowsingIndex->pkeySafeguard = false;
            $this->BrowsingIndex->checkWritableFields = false;
            $this->BrowsingIndex->save($this->request->data);
            $this->atimFlash(__('your data has been updated'), "/Datamart/Browser/index");
        }
    }

    /**
     * Creates a drilldown of the parent node based on the non matched parent
     * row of the current set.
     * Echoes the new node id, if any.
     *
     * @param int $nodeId
     */
    public function unusedParent($nodeId)
    {
        Configure::write('debug', 0);
        $childData = $this->BrowsingResult->findById($nodeId);
        if (! $childData['BrowsingResult']['parent_id']) {
            echo json_encode(array(
                'redirect' => '/Pages/err_internal?p[]=no+parent',
                'msg' => ''
            ));
        }
        $parentData = $this->BrowsingResult->findById($childData['BrowsingResult']['parent_id']);
        $control = $this->BrowsingControl->find('first', array(
            'conditions' => array(
                'BrowsingControl.id1' => $childData['DatamartStructure']['id'],
                'BrowsingControl.id2' => $parentData['DatamartStructure']['id']
            )
        ));
        $parentKeyUsedData = null;
        if (empty($control)) {
            $control = $this->BrowsingControl->find('first', array(
                'conditions' => array(
                    'BrowsingControl.id2' => $childData['DatamartStructure']['id'],
                    'BrowsingControl.id1' => $parentData['DatamartStructure']['id']
                )
            ));
            assert(! empty($control));
            
            // load the child model
            $datamartStructure = $this->DatamartStructure->findById($control['BrowsingControl']['id1']);
            $datamartStructure = $datamartStructure['DatamartStructure'];
            $parentModel = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
            
            // fetch the used parent keys
            $parentKeyUsedData = $parentModel->find('all', array(
                'fields' => array(
                    $parentModel->name . '.' . $parentModel->primaryKey
                ),
                'conditions' => array(
                    $parentModel->name . '.' . $control['BrowsingControl']['use_field'] => explode(',', $childData['BrowsingResult']['id_csv'])
                )
            ));
        } else {
            // load the child model
            $datamartStructure = $this->DatamartStructure->findById($control['BrowsingControl']['id1']);
            $datamartStructure = $datamartStructure['DatamartStructure'];
            $childModel = AppModel::getInstance($datamartStructure['plugin'], $datamartStructure['model'], true);
            
            // fetch the used parent keys
            $parentKeyUsedData = $childModel->find('all', array(
                'fields' => array(
                    $childModel->name . '.' . $control['BrowsingControl']['use_field']
                ),
                'conditions' => array(
                    $childModel->name . '.' . $childModel->primaryKey => explode(',', $childData['BrowsingResult']['id_csv'])
                )
            ));
        }
        
        $parentKeyUsed = array();
        foreach ($parentKeyUsedData as $data) {
            $parentKeyUsed[] = current(current($data));
        }
        $parentKeyUsed = array_unique($parentKeyUsed);
        sort($parentKeyUsed);
        $parentKeyUsed = array_diff(explode(',', $parentData['BrowsingResult']['id_csv']), $parentKeyUsed);
        $idCsv = implode(",", $parentKeyUsed);
        
        // build the save array
        $parentId = null;
        $browsingResult = $this->BrowsingResult->findById($childData['BrowsingResult']['parent_id']);
        if ($browsingResult['BrowsingResult']['raw']) {
            $parentId = $childData['BrowsingResult']['parent_id'];
        } else {
            $parentId = $browsingResult['BrowsingResult']['parent_id'];
        }
        $save = array(
            'BrowsingResult' => array(
                "user_id" => $this->Session->read('Auth.User.id'),
                "parent_id" => $parentId,
                "browsing_structures_id" => $parentData['DatamartStructure']['id'],
                "browsing_structures_sub_id" => $parentData['BrowsingResult']['browsing_structures_sub_id'],
                "id_csv" => $idCsv,
                'raw' => 0,
                "browsing_type" => 'unused parents'
            )
        );
        
        $returnId = null;
        if (! empty($save['BrowsingResult']['id_csv'])) {
            $tmp = $this->BrowsingResult->find('first', array(
                'conditions' => Set::flatten($save)
            ));
            if (! empty($tmp)) {
                // current set already exists, use it
                $returnId = $tmp['BrowsingResult']['id'];
            } else {
                $this->BrowsingResult->id = null;
                $this->BrowsingResult->checkWritableFields = false;
                if (! $this->BrowsingResult->save($save)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $returnId = $this->BrowsingResult->id;
            }
        }
        
        if ($returnId) {
            $this->redirect('/Datamart/Browser/browse/' . $returnId);
        } else {
            AppController::addWarningMsg(__('there are no unused parent items'));
            $this->redirect('/Datamart/Browser/browse/' . $nodeId);
        }
        exit();
    }

    /**
     *
     * @param $startingNodeId
     * @param $browsingStepIndexId
     */
    public function applyBrowsingSteps($startingNodeId, $browsingStepIndexId)
    {
        $this->BrowsingResult->checkWritableFields = false;
        $browsingSteps = $this->SavedBrowsingIndex->find('first', array(
            'conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array(
                'SavedBrowsingIndex.id' => $browsingStepIndexId
            ))
        ));
        if (! $browsingSteps) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->Browser->buildDrillDownIfNeeded($this->request->data, $startingNodeId);
        
        $nodeId = $startingNodeId;
        foreach ($browsingSteps['SavedBrowsingStep'] as $step) {
            $searchParams = unserialize($step['serialized_search_params']);
            $params = array(
                'struct_ctrl_id' => $step['datamart_structure_id'],
                'sub_struct_ctrl_id' => $step['datamart_sub_structure_id'],
                'node_id' => $nodeId,
                'last' => false,
                'search_conditions' => $searchParams['search_conditions'],
                'exact_search' => $searchParams['exact_search'],
                'adv_search_conditions' => isset($searchParams['adv_search_conditions']) ? $searchParams['adv_search_conditions'] : array(),
                'parent_child' => $step['parent_children']
            );
            if (! $createdNode = $this->Browser->createNode($params)) {
                // something went wrong. A flash screen has been called.
                return;
            }
            
            $nodeId = $createdNode['browsing']['BrowsingResult']['id'];
        }
        
        // done, render the proper node.
        $this->redirect('/Datamart/Browser/browse/' . $nodeId . '/');
    }
}