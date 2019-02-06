<?php

/**
 * Class Browser
 */
class Browser extends DatamartAppModel
{

    public $useTable = false;

    public $checklistHeader = array();

    public $checklistModel = null;

    public $checklistUseKey = null;

    public $checklistSubModelsIdFilter = null;

    public $resultStructure = null;

    public $count = null;

    public $mergedIds = null;

    public $validPermission = null;
    
    // set when initDataLoad is called.
    private static $browsingControlModel = null;

    private static $browsingResultModel = null;

    private $browsingCache = array();

    private $mergeData = array();

    private $nodes = array();

    private $nodeCurrentIndex = 0;

    private $rowsBuffer = array();

    private $modelsBuffer = array();

    private $searchParameters = null;

    private $offset = 0;

    const NODE_ID = 0;

    const MODEL = 1;

    const IDS = 2;

    const USE_KEY = 3;

    const ANCESTOR_IS_CHILD = 4;

    const JOIN_FIELD = 5;

    const SUB_MODEL_ID = 6;

    public static $cache = array();

    /**
     * The action dropdown under browse will be hierarchical or not
     *
     * @var boolean
     */
    public static $hierarchicalDropdown = false;

    /**
     * The character used to separate model ids in the url
     *
     * @var string
     */
    public static $modelSeparatorStr = "_";

    /**
     * The character used to separate sub model id in the url
     *
     * @var string
     */
    public static $subModelSeparatorStr = "-";

    /**
     *
     * @param int $startingCtrlId The control id to base the dropdown on. If zero, all will be displayed without export options
     * @param int $nodeId The current node id.
     * @param string $pluginName The name of the plugin to use in export to csv link
     * @param string $modelName The name of the model to use in export to csv link
     * @param string $dataModel
     * @param string $modelPkey
     * @param string $dataPkey
     * @param array $subModelsIdFilter An array with ControlModel => array(ids) to filter the sub models id
     * @return Returns an array representing the options to display in the action drop down
     */
    public function getBrowserDropdownOptions($startingCtrlId, $nodeId, $pluginName, $modelName, $dataModel, $modelPkey, $dataPkey, array $subModelsIdFilter = null)
    {
        $prevSetting = AppController::$highlightMissingTranslations;
        AppController::$highlightMissingTranslations = false;
        $appController = AppController::getInstance();
        $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
        if ($startingCtrlId != 0) {
            if ($pluginName == null || $modelName == null || $dataModel == null || $modelPkey == null || $dataPkey == null) {
                $appController->redirect('/Pages/err_internal?p[]=missing parameter for getBrowserDropdownOptions', null, true);
            }
            // the query contains a useless CONCAT to counter a cakephp behavior
            $data = $this->tryCatchQuery("SELECT CONCAT(main_id, '') AS main_id, GROUP_CONCAT(to_id SEPARATOR ',') AS to_id FROM( " . "SELECT id1 AS main_id, id2 AS to_id FROM `datamart_browsing_controls` AS dbc " . "WHERE dbc.flag_active_1_to_2=1 " . "UNION " . "SELECT id2 AS main_id, id1 AS to_id FROM `datamart_browsing_controls` AS dbc " . "WHERE dbc.flag_active_2_to_1=1 " . ") AS data GROUP BY main_id ");
            $options = array();
            foreach ($data as $dataUnit) {
                $options[$dataUnit[0]['main_id']] = explode(",", $dataUnit[0]['to_id']);
            }
            $activeStructuresIds = $this->getActiveStructuresIds();
            $browsingStructures = $datamartStructure->find('all', array(
                'conditions' => array(
                    'DatamartStructure.id IN (0, ' . implode(", ", $activeStructuresIds) . ')'
                )
            ));
            $tmpArr = array();
            foreach ($browsingStructures as $unit) {
                if (AppController::checkLinkPermission($unit['DatamartStructure']['index_link'])) {
                    // keep links with permission
                    $tmpArr[$unit['DatamartStructure']['id']] = $unit['DatamartStructure'];
                }
            }
            $browsingStructures = $tmpArr;
            $rez = Browser::buildBrowsableOptions($options, $startingCtrlId, $browsingStructures, $subModelsIdFilter);
            $sortedRez = array();
            if ($rez != null) {
                foreach ($rez['children'] as $k => $v) {
                    // prepending a '_' to avoid chrome parseJSON ordering bug
                    // http://code.google.com/p/chromium/issues/detail?id=883
                    $sortedRez['_' . $k] = $v['label'];
                }
                asort($sortedRez, SORT_STRING);
                foreach ($rez['children'] as $k => $foo) {
                    $sortedRez['_' . $k] = $rez['children'][$k];
                }
            } else {
                $sortedRez[] = array(
                    'label' => __('nothing to browse to'),
                    'style' => 'disabled',
                    'value' => ''
                );
            }
            
            $result[] = array(
                'value' => '',
                'label' => __('browse'),
                'children' => $sortedRez
            );
            
            $result = array_merge($result, parent::getDropdownOptions($pluginName, $modelName, $modelPkey, null, $dataModel, $dataPkey));
            
            if (AppController::checkLinkPermission('/Datamart/Browser/applyBrowsingSteps/')) {
                $savedBrowsingIndexModel = AppModel::getInstance('Datamart', 'SavedBrowsingIndex');
                $data = $savedBrowsingIndexModel->find('all', array(
                    'conditions' => array_merge($savedBrowsingIndexModel->getOwnershipConditions(), array(
                        'SavedBrowsingIndex.starting_datamart_structure_id' => $startingCtrlId
                    )),
                    'order' => 'SavedBrowsingIndex.name'
                ));
                if ($data) {
                    $subMenu = array();
                    foreach ($data as $dataUnit) {
                        $firstBrowsingStep = $dataUnit['SavedBrowsingStep'][0];
                        $firstStepDatamartStructure = $browsingStructures[$firstBrowsingStep['datamart_structure_id']];
                        $firstStepModel = AppModel::getInstance($firstStepDatamartStructure['plugin'], $firstStepDatamartStructure['model'], true);
                        $firstStepTitle = __($firstStepDatamartStructure['display_name']);
                        if ($firstBrowsingStep['parent_children'] == 'c') {
                            $firstStepTitle .= ' ' . __('children');
                        } elseif ($firstBrowsingStep['parent_children'] == 'p') {
                            $firstStepTitle .= ' ' . __('parent');
                        }
                        $lastBrowsingStep = $dataUnit['SavedBrowsingStep'][(sizeof($dataUnit['SavedBrowsingStep']) - 1)];
                        $lastStepDatamartStructure = $browsingStructures[$lastBrowsingStep['datamart_structure_id']];
                        $lastStepModel = AppModel::getInstance($lastStepDatamartStructure['plugin'], $lastStepDatamartStructure['model'], true);
                        $lastStepTitle = __($lastStepDatamartStructure['display_name']);
                        if ($lastBrowsingStep['parent_children'] == 'c') {
                            $lastStepTitle .= ' ' . __('children');
                        } elseif ($lastBrowsingStep['parent_children'] == 'p') {
                            $lastStepTitle .= ' ' . __('parent');
                        }
                        $subMenu[] = array(
                            'value' => 'Datamart/Browser/applyBrowsingSteps/' . $nodeId . '/' . $dataUnit['SavedBrowsingIndex']['id'],
                            'label' => $dataUnit['SavedBrowsingIndex']['name'] . " [$firstStepTitle => $lastStepTitle]"
                        );
                    }
                    $result[] = array(
                        'value' => '',
                        'label' => __('apply saved browsing steps'),
                        'children' => $subMenu
                    );
                }
            }
        } else {
            
            $activeStructuresIds = $this->getActiveStructuresIds();
            $data = $datamartStructure->find('all', array(
                'conditions' => array(
                    'DatamartStructure.id IN (0, ' . implode(", ", $activeStructuresIds) . ')'
                )
            ));
            $this->getActiveStructuresIds();
            $toSort = array();
            foreach ($data as $k => $v) {
                $toSort[$k] = __($v['DatamartStructure']['display_name']);
            }
            asort($toSort, SORT_STRING);
            foreach ($toSort as $k => $foo) {
                $dataUnit = $data[$k];
                $tmpResult = array(
                    'value' => $dataUnit['DatamartStructure']['id'],
                    'label' => __($dataUnit['DatamartStructure']['display_name']),
                    'style' => $dataUnit['DatamartStructure']['display_name']
                );
                $tmpModel = AppModel::getInstance($dataUnit['DatamartStructure']['plugin'], $dataUnit['DatamartStructure']['model'], true);
                if ($ctrlName = $tmpModel->getControlName()) {
                    $ids = isset($subModelsIdFilter[$ctrlName]) ? $subModelsIdFilter[$ctrlName] : array();
                    $children = self::getSubModels($dataUnit, $dataUnit['DatamartStructure']['id'], $ids);
                    if (! empty($children)) {
                        array_unshift($children, array(
                            'label' => __('all'),
                            'value' => $dataUnit['DatamartStructure']['id']
                        ));
                        $tmpResult['children'] = $children;
                    }
                }
                
                $result[] = $tmpResult;
            }
        }
        AppController::$highlightMissingTranslations = $prevSetting;
        return $result;
    }

    /**
     *
     * @param array $fromTo
     * @param $currentId
     * @param array $browsingStructures
     * @param array|null $subModelsIdFilter
     * @param array $stack
     * @return array|null
     */
    public function buildBrowsableOptionsRecur(array $fromTo, $currentId, array $browsingStructures, array $subModelsIdFilter = null, array $stack)
    {
        $result = null;
        if (isset($fromTo[$currentId]) && isset($browsingStructures[$currentId])) {
            $result = array();
            array_push($stack, $currentId);
            $toArr = array_diff($fromTo[$currentId], $stack);
            $result['label'] = __($browsingStructures[$currentId]['display_name']);
            $result['style'] = $browsingStructures[$currentId]['display_name'];
            $tmp = array_shift($stack);
            $result['value'] = implode(self::$modelSeparatorStr, $stack);
            array_unshift($stack, $tmp);
            if (count($stack) > 1) {
                $this->buildItemOptions($result, $browsingStructures, $currentId, $subModelsIdFilter);
            }
            if (Browser::$hierarchicalDropdown) {
                foreach ($toArr as $to) {
                    $tmpResult = $this->buildBrowsableOptions($fromTo, $to, $browsingStructures, $subModelsIdFilter, $stack);
                    if ($tmpResult != null) {
                        $result['children'][] = $tmpResult;
                    }
                }
                array_pop($stack);
            }
        }
        return $result;
    }

    /**
     * Builds the browsable part of the array for action menu
     *
     * @param array $fromTo An array containing the possible destinations for each keys
     * @param Int $currentId The current not control id
     * @param array $browsingStructures An array containing data about all available browsing structures. Used to get the displayed value
     * @param array $subModelsIdFilter An array with ControlModel => array(ids) to filter the sub models id
     * @return An array representing the browsable portion of the action menu
     */
    public function buildBrowsableOptions(array $fromTo, $currentId, array $browsingStructures, array $subModelsIdFilter = null)
    {
        if (Browser::$hierarchicalDropdown) {
            return $this->buildBrowsableOptionsRecur($fromTo, $currentId, $browsingStructures, $subModelsIdFilter, array());
        }
        
        if (in_array($currentId, $fromTo[$currentId])) {
            // make sure the reentrant option is the very first to pass by
            // the count($stack) > 1 condition
            array_unshift($fromTo[$currentId], $currentId);
        }
        
        $result = null;
        if (isset($fromTo[$currentId]) && isset($browsingStructures[$currentId])) {
            $toArr = $fromTo[$currentId];
            foreach ($toArr as &$to) {
                $to = array(
                    'path' => array(),
                    'val' => $to
                );
            }
            unset($to);
            $stack = array();
            $stack[$currentId] = null;
            $studySatamartStructureId = null;
            while ($toArr) {
                $nextToArr = array();
                foreach ($toArr as $to) {
                    $toVal = $to['val'];
                    $toPath = $to['path'];
                    $toPath[] = $toVal;
                    if ($browsingStructures[$toVal]['model'] == 'StudySummary') {
                        $studySatamartStructureId = $browsingStructures[$toVal]['id'];
                    }
                    if (array_key_exists($toVal, $stack) && count($stack) > 1) {
                        // already treated that, the count is there to allow reentrant
                        // mode to pass by
                        continue;
                    } elseif (! isset($browsingStructures[$toVal])) {
                        // permissions denied
                        continue;
                    } elseif ($studySatamartStructureId && $studySatamartStructureId != $browsingStructures[$toVal]['id'] && in_array($studySatamartStructureId, $toPath)) {
                        // study can not be a 'bridge' between two datamart structures (see issue #3374: Databrowser: From misc identifiers to orders, the system go through Study)
                        continue;
                    }
                    $stack[$toVal] = null;
                    $tmpResult = array(
                        'label' => __($browsingStructures[$toVal]['display_name']),
                        'style' => $browsingStructures[$toVal]['display_name'],
                        'value' => implode(self::$modelSeparatorStr, $toPath)
                    );
                    
                    if ($currentId === $toVal) {
                        // reentrant
                        $tmpResult['label'] .= ' ' . __('child');
                        $tmpResult['value'] .= 'c';
                        $this->buildItemOptions($tmpResult, $browsingStructures, $toVal, $subModelsIdFilter);
                        $result[] = $tmpResult;
                        
                        $tmpResult = array(
                            'label' => __($browsingStructures[$toVal]['display_name']) . ' ' . __('parent'),
                            'style' => $browsingStructures[$toVal]['display_name'],
                            'value' => implode(self::$modelSeparatorStr, $toPath) . 'p'
                        );
                    }
                    $this->buildItemOptions($tmpResult, $browsingStructures, $toVal, $subModelsIdFilter);
                    $result[] = $tmpResult;
                    
                    foreach ($fromTo[$toVal] as $next) {
                        $nextToArr[] = array(
                            'path' => $toPath,
                            'val' => $next
                        );
                    }
                }
                $toArr = $nextToArr;
            }
            $result['children'] = $result;
        }
        return $result;
    }

    /**
     *
     * @param array $result
     * @param array $browsingStructures
     * @param $currentId
     * @param array $subModelsIdFilter
     */
    public function buildItemOptions(array &$result, array &$browsingStructures, &$currentId, array &$subModelsIdFilter)
    {
        $result['children'] = array(
            array(
                'value' => $result['value'] . "/true/",
                'label' => __('no filter'),
                'style' => 'no_filter'
            ),
            array(
                'value' => $result['value'],
                'label' => __('all with filter'),
                'style' => 'filter'
            )
        );
        $browsingModel = AppModel::getInstance($browsingStructures[$currentId]['plugin'], $browsingStructures[$currentId]['model'], true);
        if ($controlName = $browsingModel->getControlName()) {
            $idFilter = isset($subModelsIdFilter[$controlName]) ? $subModelsIdFilter[$controlName] : null;
            $result['children'] = array_merge($result['children'], self::getSubModels(array(
                "DatamartStructure" => $browsingStructures[$currentId]
            ), $result['value'], $idFilter));
        }
    }

    /**
     *
     * @param array $mainModelInfo A DatamartStructure model data array of the node to fetch the submodels of
     * @param string $prependValue A string to prepend to the value
     * @param array|null $idsFilter
     * @return array The data about the submodels of the given model
     * @internal param $ array ids_filter An array to filter the controls ids of the current sub model* array ids_filter An array to filter the controls ids of the current sub model
     */
    public static function getSubModels(array $mainModelInfo, $prependValue, array $idsFilter = null)
    {
        // we need to fetch the controls
        $mainModel = AppModel::getInstance($mainModelInfo['DatamartStructure']['plugin'], $mainModelInfo['DatamartStructure']['model'], true);
        $controlModel = AppModel::getInstance($mainModelInfo['DatamartStructure']['plugin'], $mainModel->getControlName(), true);
        $conditions = array();
        if ($mainModel->getControlName() == "SampleControl") {
            // hardcoded SampleControl filtering
            $parentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
            $tmpIds = $parentToDerivativeSampleControl->getActiveSamples();
            if ($idsFilter == null) {
                $idsFilter = $tmpIds;
            } else {
                array_intersect($idsFilter, $tmpIds);
            }
        }
        
        if ($idsFilter != null) {
            $idsFilter[] = 0;
            $conditions[] = $controlModel->name . '.id IN(' . implode(", ", $idsFilter) . ')';
        }
        if (isset($controlModel->_schema['flag_active'])) {
            $conditions[$controlModel->name . '.flag_active'] = 1;
        }
        $childrenData = $controlModel->find('all', array(
            'order' => $controlModel->name . '.databrowser_label',
            'conditions' => $conditions,
            'recursive' => 0
        ));
        $tmpChildrenArr = array();
        foreach ($childrenData as $childData) {
            $label = self::getTranslatedDatabrowserLabel($childData[$controlModel->name]['databrowser_label']);
            $tmpChildrenArr[$label] = array(
                'value' => $prependValue . self::$subModelSeparatorStr . $childData[$controlModel->name]['id'],
                'label' => $label
            );
        }
        $sortedLabels = array_keys($tmpChildrenArr);
        natcasesort($sortedLabels);
        $childrenArr = array();
        foreach ($sortedLabels as $nextLabel) {
            $childrenArr[] = $tmpChildrenArr[$nextLabel];
        }
        return $childrenArr;
    }

    /**
     * Recursively builds a tree node by node.
     *
     * @param Int $nodeId The node id to fetch
     * @param Int $activeNode The node to hihglight in the graph
     * @param Array $mergedIds The merged nodes ids
     * @param Array $linkedTypesDown Should be left blank when calling the function. Internally used to know when to stop to display the "merge" button
     * @param Array $linkedTypesUp Should be left blank when calling the function. Internally used to know when to stop to display the "merge" button
     * @return An array representing the search tree
     */
    public static function getTree($nodeId, $activeNode, $mergedIds, array &$linkedTypesDown = array(), array &$linkedTypesUp = array())
    {
        $browsingResult = new BrowsingResult();
        $result = $browsingResult->find('all', array(
            'conditions' => 'BrowsingResult.id=' . $nodeId . ' OR BrowsingResult.parent_id=' . $nodeId,
            'order' => array(
                'BrowsingResult.id'
            ),
            'recursive' => 1
        ));
        $treeNode = null;
        if ($treeNode = array_shift($result)) {
            $treeNode['active'] = $nodeId == $activeNode;
            $treeNode['children'] = array();
            $children = array();
            while ($node = array_shift($result)) {
                $children[] = $node['BrowsingResult']['id'];
            }
            
            // going down the tree
            $drilldownAllowMerge = ! $treeNode['BrowsingResult']['raw'] && in_array($treeNode['BrowsingResult']['browsing_structures_id'], $linkedTypesDown);
            if ($drilldownAllowMerge) {
                // drilldown, remove the last entry to allow the current one to be flag as mergeable
                array_pop($linkedTypesDown);
            }
            $merge = (count($linkedTypesDown) > 0 || $treeNode['active'] || $drilldownAllowMerge) && ! in_array($treeNode['BrowsingResult']['browsing_structures_id'], $linkedTypesDown);
            if ($merge) {
                array_push($linkedTypesDown, $treeNode['BrowsingResult']['browsing_structures_id']);
                if ($nodeId != $activeNode) {
                    $treeNode['merge'] = true; // for children
                }
            }
            foreach ($children as $child) {
                if ($merge) {
                    $childNode = Browser::getTree($child, $activeNode, $mergedIds, $linkedTypesDown, $linkedTypesUp);
                } else {
                    $foo = array();
                    $childNode = Browser::getTree($child, $activeNode, $mergedIds, $foo, $linkedTypesUp);
                }
                $treeNode['children'][] = $childNode;
                $treeNode['active'] = $childNode['active'] || $treeNode['active'];
                if (! isset($treeNode['merge']) && (($childNode['merge'] && $nodeId != $activeNode) || $childNode['BrowsingResult']['id'] == $activeNode)) {
                    array_push($linkedTypesUp, $childNode['BrowsingResult']['browsing_structures_id']);
                    if (! in_array($treeNode['BrowsingResult']['browsing_structures_id'], $linkedTypesUp) || ! $childNode['BrowsingResult']['raw']) {
                        $treeNode['merge'] = true; // for parent
                        if (! $childNode['BrowsingResult']['raw'] && $childNode['BrowsingResult']['id'] == $activeNode) {
                            $treeNode['hide_merge_icon'] = true;
                        }
                    }
                }
            }
            if ($merge && ! $treeNode['active'] && ! $drilldownAllowMerge) {
                // moving back up to active node, we pop
                array_pop($linkedTypesDown);
            }
        }
        if (! isset($treeNode['merge'])) {
            $treeNode['merge'] = false;
        }
        if (! empty($mergedIds) && (in_array($nodeId, $mergedIds) || $nodeId == $activeNode)) {
            $treeNode['paint_merged'] = true;
        }
        if ($nodeId == $activeNode) {
            // remove the merge icon on the drilldown of the current node
            foreach ($treeNode['children'] as &$childNode) {
                if ($childNode['DatamartStructure']['id'] == $treeNode['DatamartStructure']['id']) {
                    $childNode['merge'] = false;
                }
            }
        }
        return $treeNode;
    }

    /**
     * Builds a representation of the tree within an array
     *
     * @param array $treeNode A node and its informations
     * @param array $tree
     * @param Int $x The current x location
     * @param Int $y The current y location
     * @internal param $ array &$tree An array with the current tree representation* array &$tree An array with the current tree representation
     */
    public static function buildTree(array $treeNode, &$tree = array(), $x = 0, &$y = 0)
    {
        if ($treeNode['active'] && $tree != null) {
            self::drawActiveLine($tree, $x, $y);
        }
        
        $tree[$y][$x] = $treeNode;
        if (count($treeNode['children'])) {
            $looped = false;
            $lastArrowX = null;
            $lastArrowY = null;
            foreach ($treeNode['children'] as $pos => $child) {
                $merge = isset($treeNode['paint_merged']) && isset($child['paint_merged']) ? " merged" : "";
                $tree[$y][$x + 1] = "h-line" . $merge;
                if ($looped) {
                    $tree[$y][$x] = "arrow" . $merge;
                    $lastArrowX = $x;
                    $lastArrowY = $y;
                    $currY = $y - 1;
                    while (! isset($tree[$currY][$x])) {
                        $tree[$currY][$x] = "v-line" . $merge;
                        $currY --;
                    }
                }
                $activeX = null;
                $activeY = null;
                if (! $child['BrowsingResult']['raw'] || ! $treeNode['BrowsingResult']['raw']) {
                    Browser::buildTree($child, $tree, $x + 2, $y);
                } else {
                    $tree[$y][$x + 2] = "h-line" . $merge;
                    $tree[$y][$x + 3] = "h-line" . $merge;
                    Browser::buildTree($child, $tree, $x + 4, $y);
                }
                
                $y ++;
                $looped = true;
            }
            
            $y --;
            if ($lastArrowX !== null) {
                $checkUpMerge = false;
                $applyMerge = false;
                if ($tree[$lastArrowY][$lastArrowX] == "arrow") {
                    $tree[$lastArrowY][$lastArrowX] = "corner";
                    $checkUpMerge = true;
                } elseif ($tree[$lastArrowY][$lastArrowX] == "arrow merged") {
                    $tree[$lastArrowY][$lastArrowX] = "corner merged";
                    $checkUpMerge = true;
                    $applyMerge = true;
                } elseif ($tree[$lastArrowY][$lastArrowX] == "arrow active") {
                    $tree[$lastArrowY][$lastArrowX] = "corner active";
                } elseif ($tree[$lastArrowY][$lastArrowX] == "arrow merged active") {
                    $tree[$lastArrowY][$lastArrowX] = "corner merged active";
                    $checkUpMerge = true;
                    $applyMerge = true;
                }
                
                if ($checkUpMerge) {
                    -- $lastArrowY;
                    while (is_string($tree[$lastArrowY][$lastArrowX])) {
                        if ($applyMerge) {
                            if ($tree[$lastArrowY][$lastArrowX] == "arrow") {
                                $tree[$lastArrowY][$lastArrowX] .= " merged_straight";
                            } elseif ($tree[$lastArrowY][$lastArrowX] == "v-line" || $tree[$lastArrowY][$lastArrowX] == "v-line active") {
                                $tree[$lastArrowY][$lastArrowX] .= " merged";
                            } elseif ($tree[$lastArrowY][$lastArrowX] == "arrow active_straight") {
                                $tree[$lastArrowY][$lastArrowX] = "arrow active_straight merged";
                            }
                        } elseif ($tree[$lastArrowY][$lastArrowX] == "arrow merged" || $tree[$lastArrowY][$lastArrowX] == "arrow merged active") {
                            $applyMerge = true;
                        }
                        -- $lastArrowY;
                    }
                }
            }
        }
    }

    /**
     * Update the line to print it in blue between the given position and the parent node
     *
     * @param array $tree
     * @param int $activeX The current active node x position
     * @param int $activeY The current active node y position
     */
    private static function drawActiveLine(array &$tree, $activeX, $activeY)
    {
        // draw the active line
        $leftArr = array(
            "h-line",
            "arrow",
            "corner",
            "h-line merged",
            "arrow merged",
            "corner merged"
        );
        $counter = 0;
        while ($activeX >= 0 && $activeY >= 0) {
            // try left
            if (isset($tree[$activeY][$activeX - 1])) {
                if (in_array($tree[$activeY][$activeX - 1], $leftArr)) {
                    $tree[$activeY][$activeX - 1] .= " active";
                    -- $activeX;
                } else {
                    // else it's a node
                    break;
                }
            } elseif (isset($tree[$activeY - 1][$activeX])) {
                if ($tree[$activeY - 1][$activeX] == "v-line" || $tree[$activeY - 1][$activeX] == "v-line merged") {
                    $tree[$activeY - 1][$activeX] .= " active";
                } elseif ($tree[$activeY - 1][$activeX] == "arrow") {
                    $tree[$activeY - 1][$activeX] .= " active_straight";
                } elseif ($tree[$activeY - 1][$activeX] == "arrow merged_straight") {
                    $tree[$activeY - 1][$activeX] = "arrow active_straight merged";
                } else {
                    // it's a node
                    break;
                }
                -- $activeY;
            } else {
                break;
            }
            ++ $counter;
            assert($counter < 100) or die("invalid loop");
        }
    }

    /**
     *
     * @param $cell
     * @return mixed|string
     */
    private static function getBaseTitle($cell)
    {
        $title = __($cell['DatamartStructure']['display_name']);
        $word = null;
        if ($cell['BrowsingResult']['parent_children'] == 'c') {
            $word = __('children');
        } elseif ($cell['BrowsingResult']['parent_children'] == 'p') {
            $word = __('parent');
        }
        if ($word) {
            $title .= ' ' . $word;
        }
        return $title;
    }

    /**
     *
     * @param Int $currentNode The id of the current node. Its path will be highlighted
     * @param array $mergedIds The id of the merged node
     * @param String $webrootUrl The webroot of ATiM
     * @return the html of the table search tree
     */
    public static function getPrintableTree($currentNode, array $mergedIds, $webrootUrl)
    {
        $result = "";
        $browsingResult = new BrowsingResult();
        $browsingStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure');
        $tmpNode = $currentNode;
        $prevNode = null;
        $currentNodeDatamartStructureId = null;
        do {
            $prevNode = $tmpNode;
            $br = $browsingResult->find('first', array(
                'conditions' => array(
                    'BrowsingResult.id' => $tmpNode
                )
            ));
            if ($currentNode == $br['BrowsingResult']['id'])
                $currentNodeDatamartStructureId = $br['DatamartStructure']['id'];
            assert($br);
            $tmpNode = $br['BrowsingResult']['parent_id'];
        } while ($tmpNode);
        $fm = Browser::getTree($prevNode, $currentNode, $mergedIds);
        Browser::buildTree($fm, $tree);
        $result .= "<table class='structure'><tr><td style='padding-left: 10px;'>" . __("browsing") . "<table class='databrowser'>\n";
        ksort($tree);
        $lang = AppController::getInstance()->Session->read('Config.language');
        
        foreach ($tree as $y => $line) {
            $result .= '<tr><td></td>'; // print a first empty column, css will print an highlighted h-line in the top left cell
            $lastX = - 1;
            ksort($line);
            foreach ($line as $x => $cell) {
                $pad = $x - $lastX - 1;
                $padPos = 0;
                while ($pad > 0) {
                    $result .= '<td></td>';
                    $pad --;
                }
                if (is_array($cell)) {
                    $cellModel = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['model'], true);
                    $class = '';
                    if ($cell['active']) {
                        $class .= " active ";
                    }
                    if (isset($cell['paint_merged'])) {
                        $class .= " merged";
                    }
                    $count = strlen($cell['BrowsingResult']['id_csv']) ? count(explode(",", $cell['BrowsingResult']['id_csv'])) : 0;
                    $title = self::getBaseTitle($cell);
                    $info = __($cell['BrowsingResult']['browsing_type']) . ' - ' . AppController::getFormatedDatetimeString($cell['BrowsingResult']['created']);
                    $cacheKey = 'node_' . $lang . $cell['BrowsingResult']['id'];
                    if (! $content = Cache::read($cacheKey, 'browser')) {
                        if ($cell['BrowsingResult']['raw']) {
                            $search = $cell['BrowsingResult']['serialized_search_params'] ? unserialize($cell['BrowsingResult']['serialized_search_params']) : array();
                            $advSearch = isset($search['adv_search_conditions']) ? $search['adv_search_conditions'] : array();
                            
                            if ((isset($search['search_conditions']) && count($search['search_conditions'])) || $advSearch || isset($search['counters'])) {
                                $structure = null;
                                if ($cellModel->getControlName() && $cell['BrowsingResult']['browsing_structures_sub_id'] > 0) {
                                    // alternate structure required
                                    $tmpModel = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['model'], true);
                                    $alternateAlias = self::getAlternateStructureInfo($cell['DatamartStructure']['plugin'], $tmpModel->getControlName(), $cell['BrowsingResult']['browsing_structures_sub_id']);
                                    $alternateAlias = $alternateAlias['form_alias'];
                                    $structure = StructuresComponent::$singleton->get('form', $alternateAlias);
                                    // unset the serialization on the sub model since it's already in the title
                                    unset($search['search_conditions'][$cell['DatamartStructure']['control_master_model'] . "." . $tmpModel->getControlForeign()]);
                                    $tmpModel = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['control_master_model'], true);
                                    $tmpData = $tmpModel->find('first', array(
                                        'conditions' => array(
                                            $tmpModel->getControlName() . ".id" => $cell['BrowsingResult']['browsing_structures_sub_id']
                                        ),
                                        'recursive' => 0,
                                        'fields' => '*'
                                    )); // fixes a bug on a select on an unexisting undefined field
                                    $title .= " > " . self::getTranslatedDatabrowserLabel($tmpData[$tmpModel->getControlName()]['databrowser_label']);
                                } else {
                                    $structure = StructuresComponent::$singleton->getFormById($cell['DatamartStructure']['structure_id']);
                                }
                                
                                $addonParams = array();
                                if (isset($search['counters'])) {
                                    foreach ($search['counters'] as $counter) {
                                        $browsingStructure = $browsingStructureModel->findById($counter['browsing_structures_id']);
                                        $addonParams[] = array(
                                            'field' => __('counter') . ': ' . __($browsingStructure['DatamartStructure']['display_name']),
                                            'condition' => $counter['condition']
                                        );
                                    }
                                }
                                
                                if (count($search['search_conditions']) || $advSearch || $addonParams) { // count might be zero if the only condition was the sub type
                                    $advStructure = array();
                                    if ($cell['DatamartStructure']['adv_search_structure_alias']) {
                                        $advStructure = StructuresComponent::$singleton->get('form', $cell['DatamartStructure']['adv_search_structure_alias']);
                                    }
                                    $info .= "<br/><br/>" . Browser::formatSearchToPrint(array(
                                        'search' => $search,
                                        'adv_search' => $advSearch,
                                        'structure' => $structure,
                                        'adv_structure' => $advStructure,
                                        'model' => $cellModel,
                                        'addon_params' => $addonParams
                                    ));
                                }
                            }
                        }
                        $content = "<div class='content'><span class='title'>" . $title . "</span><br/>" . __("results") . ": " . $count . "<br/>\n" . $info . "</div>";
                        Cache::Write($cacheKey, $content, 'browser');
                    }
                    $controls = "<div class='controls'>%s</div>";
                    $link = $webrootUrl . "Datamart/Browser/browse/";
                    if (isset($cell['merge']) && $cell['merge'] && ! isset($cell['hide_merge_icon'])) {
                        $controls = sprintf($controls, "<a class='icon16 link' href='" . $link . $currentNode . "/0/" . $cell['BrowsingResult']['id'] . "' title='" . __("link to current view") . "'/>&nbsp;</a>");
                    } elseif ($currentNodeDatamartStructureId == $cell['DatamartStructure']['id'] && $cell['BrowsingResult']['id'] != $currentNode) {
                        $controls = sprintf($controls, "<a class='icon16 data_diff' href='" . $webrootUrl . "Datamart/Reports/compareToBatchSetOrNode/node/" . $cell['BrowsingResult']['id'] . "/0/$currentNode' title='" . __("compare contents") . "'/>&nbsp;</a>");
                    } else {
                        $controls = sprintf($controls, "");
                    }
                    $box = "<div class='info %s'>%s%s</div>";
                    if ($x < 16) {
                        // right
                        $box = sprintf($box, "right", $controls, $content);
                    } else {
                        // left
                        $box = sprintf($box, "left", $content, $controls);
                    }
                    $result .= "<td class='node " . $class . "'><div class='container'><a class='box20x20' href='" . $link . $cell['BrowsingResult']['id'] . "/'><span class='icon16 " . $cell['DatamartStructure']['display_name'] . "'></span></a>" . $box . "</div></td>";
                } else {
                    $result .= "<td class='" . $cell . "'></td>";
                }
                $lastX = $x;
            }
            $result .= "</tr>\n";
        }
        $result .= '</table></td></tr></table>';
        
        return $result;
    }

    /**
     * Formats the search params array and returns it into a table
     *
     * @param array $params Both search parameters with both structures
     * @param boolean $htmlFormat Expect result returned in html format else txt
     * @return An html string of a table containing the search formated params
     */
    public static function formatSearchToPrint(array $params, $htmlFormat = true)
    {
        $searchConditions = $params['search']['search_conditions'];
        
        // Preprocess to clean datetime accuracy.
        // System added additionnal search criteria on date field when user searched on one specific date
        // to consider approcimatice dates too. See example below with initial date criteria >= 1980-01-23 11h :
        // [OR] => Array(
        // [0] => Array([Model.field >=] => 1980-01-23 11:0:0, [Model.field_accuracy] => Array([0] => c, [1] => ))
        // [1] => Array([Model.field >=] => 1980-01-23 11:00:00, [Model.field_accuracy] => i)
        // [2] => Array([Model.field >=] => 1980-01-23 00:00:00, [Model.field_accuracy] => h)
        // [3] => Array([Model.field >=] => 1980-01-01 00:00:00, [Model.field_accuracy] => d)
        // [4] => Array([Model.field >=] => 1980-01-01 00:00:00, Model.field_accuracy] => Array([0] => m, [1] => y))
        // )
        // System will keep only the first one for display
        foreach ($searchConditions as $key => $value) {
            if (is_array($value) && isset($value['OR'][0])) {
                $tmp = current($value['OR'][0]);
                $searchConditions[key($value['OR'][0])] = $tmp;
                unset($searchConditions[$key]);
            }
        }
        
        // Manage the display
        $htmlResult = "<table align='center' width='100%' class='browserBubble'>";
        $txtResult = '';
        // value_element can be a string or an array
        foreach ($searchConditions as $key => $valueElement) {
            $values = array();
            $fieldLabelToDisplay = "";
            $fieldLabelToDisplaySuffix = "";
            if (is_numeric($key)) {
                // it's a textual field ([0] => model.field LIKE %foo1% OR model.field LIKE %foo2%)
                $values = array();
                $parts = explode(" OR ", substr($valueElement, 1, - 1)); // strip first and last parenthesis
                foreach ($parts as $part) {
                    list ($modelField, $operator, $value) = explode(" ", $part);
                    list ($model, $field) = explode(".", $modelField);
                    $values[] = substr($value, 2, - 2);
                }
            } elseif (is_array($valueElement)) {
                // it's coming from a dropdown
                $values = $valueElement;
                list ($model, $field) = explode(".", $key);
            } else {
                // it's a range
                // key = field with possibly a comparison (field >=, field <=), if no comparison, it's =
                // value = value_str
                if (preg_match('/^([0-9]{4}\-[0-9]{1,2}\-[0-9]{1,2})(\ ([0-9:]+)){0,1}$/', $valueElement, $matches)) {
                    list ($year, $month, $day) = explode("-", $matches[1]);
                    $formattedDate = AppController::getFormatedDateString($year, $month, $day);
                    $formattedTime = '';
                    if (isset($matches[3])) {
                        $formattedTime = explode(':', $matches[3]);
                        $formattedTime = ' ' . AppController::getFormatedTimeString($formattedTime['0'], $formattedTime['1'], false);
                    }
                    $values[] = $formattedDate . $formattedTime;
                } else {
                    $values[] = $valueElement;
                }
                if (strpos($key, " ") !== false) {
                    list ($key, $fieldLabelToDisplaySuffix) = explode(" ", $key);
                }
                list ($model, $field) = explode(".", $key);
            }
            $structureValueDomainModel = null;
            $lastLabel = '';
            foreach ($params['structure']['Sfs'] as &$sfUnit) {
                if ($sfUnit['language_label']) {
                    $lastLabel = $sfUnit['language_label'];
                }
                if ($sfUnit['model'] == $model && $sfUnit['field'] == $field) {
                    // Form field used as a search criteria
                    $fieldLabelToDisplay = __($sfUnit['language_label']) ?  : __($lastLabel) . ' ' . __($sfUnit['language_tag']);
                    if (! empty($sfUnit['StructureValueDomain'])) {
                        if (! isset($sfUnit['StructureValueDomain']['StructurePermissibleValue'])) {
                            // Field is a drop down list : Build list of values
                            if (isset($sfUnit['StructureValueDomain']['source']) && strlen($sfUnit['StructureValueDomain']['source']) > 0) {
                                $sfUnit['StructureValueDomain']['StructurePermissibleValue'] = StructuresComponent::getPulldownFromSource($sfUnit['StructureValueDomain']['source']);
                                if (array_key_exists('defined', $sfUnit['StructureValueDomain']['StructurePermissibleValue']) && array_key_exists('previously_defined', $sfUnit['StructureValueDomain']['StructurePermissibleValue'])) {
                                    $sfUnit['StructureValueDomain']['StructurePermissibleValue'] = $sfUnit['StructureValueDomain']['StructurePermissibleValue']['defined'] + $sfUnit['StructureValueDomain']['StructurePermissibleValue']['previously_defined'];
                                }
                            } else {
                                if ($structureValueDomainModel == null) {
                                    App::uses("StructureValueDomain", 'Model');
                                    $structureValueDomainModel = new StructureValueDomain();
                                }
                                $tmpDropdownResult = $structureValueDomainModel->find('first', array(
                                    'recursive' => 2,
                                    'conditions' => array(
                                        'StructureValueDomain.id' => $sfUnit['StructureValueDomain']['id']
                                    )
                                ));
                                $dropdownValues = array();
                                foreach ($tmpDropdownResult['StructurePermissibleValue'] as $valueArray) {
                                    $dropdownValues[$valueArray['value']] = __($valueArray['language_alias']);
                                }
                                $sfUnit['StructureValueDomain']['StructurePermissibleValue'] = $dropdownValues;
                            }
                        }
                    } elseif ($sfUnit['type'] == 'yes_no') {
                        $sfUnit['StructureValueDomain']['StructurePermissibleValue']['y'] = __('yes');
                        $sfUnit['StructureValueDomain']['StructurePermissibleValue']['n'] = __('no');
                    } elseif ($sfUnit['type'] == 'checkbox') {
                        $sfUnit['StructureValueDomain']['StructurePermissibleValue']['1'] = __('yes');
                        $sfUnit['StructureValueDomain']['StructurePermissibleValue']['0'] = __('no');
                    }
                    if (isset($sfUnit['StructureValueDomain']['StructurePermissibleValue'])) {
                        foreach ($values as &$value) { // foreach values
                            if (array_key_exists($value, $sfUnit['StructureValueDomain']['StructurePermissibleValue'])) {
                                $value = $sfUnit['StructureValueDomain']['StructurePermissibleValue'][$value];
                            }
                        }
                        break;
                    }
                }
            }
            $htmlResult .= "<tr><th>" . $fieldLabelToDisplay . " " . $fieldLabelToDisplaySuffix . "</th><td>";
            $txtResult .= $fieldLabelToDisplay . " " . (empty($fieldLabelToDisplaySuffix) ? ': ' : "$fieldLabelToDisplaySuffix ");
            if (count($values) > 6 && $htmlFormat) {
                $htmlResult .= '<span class="databrowserShort">' . stripslashes(implode(", ", array_slice($values, 0, 6))) . '</span>' . '<span class="databrowserAll hidden">, ' . stripslashes(implode(", ", array_slice($values, 6))) . '</span>' . '<br/><a href="#" class="databrowserMore">' . __('and %d more', count($values) - 6) . '</a>';
            } else {
                $htmlResult .= stripslashes(implode(' ' . __('or') . ' ', $values));
                $txtResult .= implode(' ' . __('or') . ' ', $values);
            }
            $htmlResult .= "</td>&#013;\n";
            $txtResult .= "&#013;\n";
        }
        
        foreach ($params['addon_params'] as $addonParam) {
            $htmlResult .= "<tr><th>" . $addonParam['field'] . "</th><td>" . $addonParam['condition'] . "</td>&#013;\n";
            $txtResult .= $addonParam['field'] . " " . $addonParam['condition'] . "&#013;\n";
        }
        
        $htmlResult .= "<tr><th>" . __("exact search") . "</th><td>" . ($params['search']['exact_search'] ? __("yes") : __('no')) . "</td>&#013;\n";
        $txtResult .= __("exact search") . " : " . ($params['search']['exact_search'] ? __("yes") : __('no')) . "&#013;\n";
        
        // advanced search fields
        $sfsModel = AppModel::getInstance('', 'Sfs', true);
        foreach ($params['adv_search'] as $key => $value) {
            if ($key === 'browsing_filter') {
                continue;
            }
            foreach ($params['adv_structure']['Sfs'] as $sfs) {
                if ($sfs['field'] == $key) {
                    $option = $params['model']->getBrowsingAdvSearchArray($key);
                    $option = $option[$value];
                    $dmStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
                    $dmStructure = $dmStructureModel->find('first', array(
                        'conditions' => array(
                            'DatamartStructure.model' => $option['model']
                        )
                    ));
                    $sfs2 = $sfsModel->find('first', array(
                        'conditions' => array(
                            'model' => $option['model'],
                            'field' => $option['field']
                        ),
                        'recursive' => - 1
                    ));
                    $htmlResult .= sprintf("<tr><th>%s %s</th><td>%s %s</td>&#013;\n", __($sfs['language_label']), $option['relation'], __($dmStructure['DatamartStructure']['display_name']), __($sfs2['Sfs']['language_label']));
                    $txtResult .= sprintf("%s %s %s %s&#013;\n", __($sfs['language_label']), $option['relation'], __($dmStructure['DatamartStructure']['display_name']), __($sfs2['Sfs']['language_label']));
                }
            }
        }
        
        // filter
        if (isset($params['adv_search']['browsing_filter'])) {
            $filter = $params['model']->getBrowsingAdvSearchArray('browsing_filter');
            $htmlResult .= "<tr><th>" . __("filter") . "</th><td>" . __($filter[$params['adv_search']['browsing_filter']]['lang']) . "</td>&#013;\n";
            $txtResult .= __("filter") . " : " . __($filter[$params['adv_search']['browsing_filter']]['lang']) . "&#013;\n";
        }
        
        $htmlResult .= "</table>";
        
        return $htmlFormat ? $htmlResult : str_replace('&nbsp;', ' ', $txtResult);
    }

    /**
     *
     * @param string $plugin The name of the plugin to search on
     * @param string $controlModel The name of the control model to search on
     * @param int $id The id of the alternate structure to retrieve
     * @return string The info of the alternate structure
     */
    public static function getAlternateStructureInfo($plugin, $controlModel, $id)
    {
        $modelToUse = AppModel::getInstance($plugin, $controlModel, true);
        $data = $modelToUse->find('first', array(
            'conditions' => array(
                $controlModel . ".id" => $id
            )
        ));
        return $data[$controlModel];
    }

    /**
     * Updates an index link
     *
     * @param string $link
     * @param string $prevModel
     * @param string $newModel
     * @param string $prevPkey
     * @param string $newPkey
     * @return mixed
     */
    public static function updateIndexLink($link, $prevModel, $newModel, $prevPkey, $newPkey)
    {
        return str_replace("%%" . $prevModel . ".", "%%" . $newModel . ".", str_replace("%%" . $prevModel . "." . $prevPkey . "%%", "%%" . $newModel . "." . $newPkey . "%%", $link));
    }

    /**
     * Filters the required sub models controls ids based on the current sub control id.
     * NOTE: This
     * function is hardcoded for Storage and Aliquots using some specific db id.</p>
     *
     * @param array $browsing The DatamartStructure and BrowsingResult data to base the filtering on.
     * @return An array with the ControlModel => array(ids to filter with)
     */
    public static function getDropdownSubFiltering(array $browsing)
    {
        $subModelsIdFilter = array();
        if ($browsing['DatamartStructure']['id'] == 5) {
            // sample->aliquot hardcoded part
            assert($browsing['DatamartStructure']['control_master_model'] == "SampleMaster"); // will print a warning if the id and field dont match anymore
            $sm = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
            $smData = $sm->find('all', array(
                'fields' => array(
                    'SampleMaster.sample_control_id'
                ),
                'conditions' => array(
                    "SampleMaster.id" => explode(",", $browsing['BrowsingResult']['id_csv'])
                ),
                'group' => array(
                    'SampleMaster.sample_control_id'
                ),
                'recursive' => - 1
            ));
            if ($smData) {
                $ac = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
                $data = $ac->find('all', array(
                    'conditions' => array(
                        "AliquotControl.sample_control_id" => array_keys(AppController::defineArrayKey($smData, 'SampleMaster', 'sample_control_id', true)),
                        "AliquotControl.flag_active" => 1
                    ),
                    'fields' => 'AliquotControl.id',
                    'recursive' => - 1
                ));
                if (empty($data)) {
                    $subModelsIdFilter['AliquotControl'][] = 0;
                } else {
                    $ids = array();
                    foreach ($data as $unit) {
                        $ids[] = $unit['AliquotControl']['id'];
                    }
                    $subModelsIdFilter['AliquotControl'] = $ids;
                }
            } else {
                $subModelsIdFilter['AliquotControl'][] = 0;
            }
        } elseif ($browsing['DatamartStructure']['id'] == 1) {
            // aliquot->sample hardcoded part
            assert($browsing['DatamartStructure']['control_master_model'] == "AliquotMaster"); // will print a warning if the id and field doesnt match anymore
            $am = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
            $amData = $am->find('all', array(
                'fields' => array(
                    'AliquotMaster.aliquot_control_id'
                ),
                'conditions' => array(
                    'AliquotMaster.id' => explode(",", $browsing['BrowsingResult']['id_csv'])
                ),
                'group' => array(
                    'AliquotMaster.aliquot_control_id'
                ),
                'recursive' => - 1
            ));
            $ctrlIds = array();
            foreach ($amData as $dataPart) {
                $ctrlIds[] = $dataPart['AliquotMaster']['aliquot_control_id'];
            }
            $ac = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
            $data = $ac->find('all', array(
                'conditions' => array(
                    "AliquotControl.id" => $ctrlIds,
                    "AliquotControl.flag_active" => 1
                ),
                'recursive' => - 1
            ));
            $ids = array();
            foreach ($data as $unit) {
                $ids[] = $unit['AliquotControl']['sample_control_id'];
            }
            $subModelsIdFilter['SampleControl'] = $ids;
        } else {
            /*
             * $sampleControlModel = AppModel::getInstance('InventoryManagement', 'SampleControl');
             * $sampleControls = $sampleControlModel->getPermissibleSamplesArray(null);
             * $sampleControls = AppController::defineArrayKey($sampleControls, 'SampleControl', 'id', true);
             * $aliquotControlModel = AppModel::getInstance('InventoryManagement', 'AliquotControl');
             * $aliquotControls = $aliquotControlModel->find('all', array(
             * 'fields' => array('*'),
             * 'conditions' => array('AliquotControl.flag_active' => 1, 'AliquotControl.sample_control_id' => array_keys($sampleControls)),
             * 'joins' => array(
             * array(
             * 'table' => 'sample_controls',
             * 'alias' => 'SampleControl',
             * 'type' => 'INNER',
             * 'conditions' => 'AliquotControl.sample_control_id = SampleControl.id'
             * )
             * )));
             * $subModelsIdFilter['AliquotControl'] = array_keys(AppController::defineArrayKey($aliquotControls, 'AliquotControl', 'id', true));
             */
        }
        
        return $subModelsIdFilter;
    }

    /**
     * Databrowser lables are string that can be separated by |.
     * Translation will occur on each subsection and replace the pipes by " - "
     *
     * @param string $label The label to translate
     * @return string The translated label
     */
    public static function getTranslatedDatabrowserLabel($label)
    {
        $parts = explode("|", $label);
        $structurePermissibleValuesCustom = null;
        foreach ($parts as &$part) {
            if (preg_match('/^custom\#(.+)\#(.+)$/', $part, $matches)) {
                if (! $structurePermissibleValuesCustom)
                    $structurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
                $translatedValue = $structurePermissibleValuesCustom->getTranslatedCustomDropdownValue($matches[1], $matches[2]);
                $part = ($translatedValue !== false) ? $translatedValue : $matches[2];
            } else {
                $part = __($part);
            }
        }
        return implode(" - ", $parts);
    }

    /**
     *
     * @return array
     */
    private function getActiveStructuresIds()
    {
        $browsingControl = AppModel::getInstance("Datamart", "BrowsingControl", true);
        $data = $browsingControl->find('all');
        $result = array();
        foreach ($data as $unit) {
            if ($unit['BrowsingControl']['flag_active_1_to_2']) {
                $result[$unit['BrowsingControl']['id2']] = null;
            }
            if ($unit['BrowsingControl']['flag_active_2_to_1']) {
                $result[$unit['BrowsingControl']['id1']] = null;
            }
        }
        return array_keys($result);
    }

    /**
     * Builds an ordered array of the nodes to merge
     *
     * @param array $browsing The browsing data of the first node
     * @param int $mergeTo The id of the final node
     * @return An array of the nodes to merge
     */
    private function getNodesToMerge($browsing, $mergeTo)
    {
        $nodesToFetch = array();
        $startId = null;
        $endId = null;
        $descending = null;
        $nodeId = $browsing['BrowsingResult']['id'];
        $previousBrowsing = $browsing;
        if ($mergeTo > $nodeId) {
            $startId = $mergeTo;
            $endId = $nodeId;
            $descending = false;
        } else {
            $startId = $nodeId;
            $endId = $mergeTo;
            $descending = true;
        }
        // fetch from highest id to lowest id
        while ($startId != $endId) {
            $nodesToFetch[] = $startId;
            $browsing = self::$browsingResultModel->cacheAndGet($startId, $this->browsingCache);
            if (! AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])) {
                $this->validPermission = false;
            }
            $startId = $browsing['BrowsingResult']['parent_id'];
        }
        
        if ($descending) {
            array_shift($nodesToFetch);
            $nodesToFetch[] = $endId;
            self::$browsingResultModel->cacheAndGet($endId, $this->browsingCache);
        }
        $this->mergedIds = $nodesToFetch;
        
        if ($descending) {
            // clear drilldown parents
            $remove = $previousBrowsing['BrowsingResult']['raw'] == 0;
            foreach ($nodesToFetch as $index => $nodeToFetch) {
                if ($remove) {
                    unset($nodesToFetch[$index]);
                    $remove = false;
                } else {
                    $remove = $this->browsingCache[$nodeToFetch]['BrowsingResult']['raw'] == 0;
                }
            }
        } else {
            $nodesToFetch = array_reverse($nodesToFetch);
            // clear drilldowns
            foreach ($nodesToFetch as $index => $nodeToFetch) {
                if (! $this->browsingCache[$nodeToFetch]['BrowsingResult']['raw']) {
                    unset($nodesToFetch[$index]);
                }
            }
        }
        
        return $nodesToFetch;
    }

    /**
     *
     * @param $node
     * @return string
     */
    private function getModelAlias($node)
    {
        return $node[self::NODE_ID] . "_" . $node[self::MODEL]->name;
    }

    /**
     * Builds the search parameters array
     * @note: Hardcoded for collections
     *
     * @param $primaryNodeIds
     * @param $order
     */
    private function buildBufferedSearchParameters($primaryNodeIds, $order)
    {
        $joins = array();
        $fields = array();
        for ($i = 1; $i < count($this->nodes); ++ $i) {
            $node = $this->nodes[$i];
            $ancestorNode = $this->nodes[$i - 1];
            $condition = null;
            $alias = $this->getModelAlias($node);
            $ancestorAlias = $i > 1 ? $this->getModelAlias($ancestorNode) : $ancestorNode[self::MODEL]->name;
            if ($node[self::ANCESTOR_IS_CHILD]) {
                $condition = $alias . "." . $node[self::USE_KEY] . " = " . $ancestorAlias . "." . $node[self::JOIN_FIELD];
            } else {
                $condition = $alias . "." . $node[self::JOIN_FIELD] . " = " . $ancestorAlias . "." . $ancestorNode[self::USE_KEY];
            }
            $fields[] = 'CONCAT("", ' . $alias . "." . $node[self::USE_KEY] . ') AS ' . $alias;
            $joins[] = array(
                'table' => $node[self::MODEL]->table,
                'alias' => $alias,
                'type' => 'LEFT',
                'conditions' => array(
                    $condition,
                    $alias . "." . $node[self::USE_KEY] => $node[self::IDS]
                )
            );
            if ($node[self::SUB_MODEL_ID]) {
                $joins[] = $node[self::MODEL]->getDetailJoin($node[self::SUB_MODEL_ID], $alias);
            }
        }
        
        $node = $this->nodes[0];
        $conditions = array();
        $model = $node[self::MODEL];
        if ($node[self::SUB_MODEL_ID]) {
            $conditions[$model->name . "." . $model->getControlForeign()] = $node[self::SUB_MODEL_ID];
        }
        array_unshift($fields, 'CONCAT("", ' . $node[self::MODEL]->name . "." . $node[self::USE_KEY] . ') AS `' . $node[self::MODEL]->name . '`');
        $conditions[$model->name . "." . $node[self::USE_KEY]] = $primaryNodeIds;
        $this->searchParameters = array(
            'fields' => $fields,
            'joins' => $joins,
            'conditions' => $conditions,
            'order' => $order,
            'recursive' => 1
        );
    }

    /**
     * Init the browser model on the current required data display
     *
     * @param array $browsing Browsing data of the first node
     * @param int $mergeTo Node id of the target node to merge with
     * @param array $primaryNodeIds The ids of the primary node to use
     * @param null $order
     */
    public function initDataLoad(array $browsing, $mergeTo, array $primaryNodeIds, $order = null)
    {
        $result = array();
        $startId = null;
        $endId = null;
        $nodeId = $browsing['BrowsingResult']['id'];
        $mainData = array(); // $this->checklistData;
        $descending = null;
        $resultStructure = array(
            'Structure' => array(),
            'Sfs' => array(),
            'Accuracy' => array()
        );
        $header = array();
        self::$browsingControlModel = AppModel::getInstance("Datamart", "BrowsingControl", true);
        self::$browsingResultModel = AppModel::getInstance("Datamart", "BrowsingResult", true);
        $nodesToFetch = array();
        
        if (! AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])) {
            $this->validPermission = false;
        } else {
            $this->validPermission = true;
            if ($mergeTo != 0) {
                $nodesToFetch = $this->getNodesToMerge($browsing, $mergeTo);
            }
        }
        
        // prepare nodes_to_fetch_stack
        array_unshift($nodesToFetch, $nodeId);
        $lastBrowsing = null;
        $iterationCount = 1;
        
        // building the relationship logic between nodes
        foreach ($nodesToFetch as $node) {
            $currentBrowsing = self::$browsingResultModel->findById($node);
            $currentModel = AppModel::getInstance($currentBrowsing['DatamartStructure']['plugin'], $currentBrowsing['DatamartStructure']['model'], true);
            $currentSubModel = null;
            if ($currentBrowsing['BrowsingResult']['browsing_structures_sub_id']) {
                $currentSubModel = $currentBrowsing['BrowsingResult']['browsing_structures_sub_id'];
            }
            $ids = explode(",", $currentBrowsing['BrowsingResult']['id_csv']);
            $ids[] = 0;
            $modelAndStructForNode = self::$browsingResultModel->getModelAndStructureForNode($currentBrowsing);
            if (! $currentSubModel && $modelAndStructForNode['control_id']) {
                $currentSubModel = $modelAndStructForNode['control_id'];
            }
            $structure = $modelAndStructForNode['structure'];
            $headerSubType = ($modelAndStructForNode['header_sub_type'] ? "/" . self::getTranslatedDatabrowserLabel($modelAndStructForNode['header_sub_type']) : '') . ' ';
            if (! $modelAndStructForNode['specific'] && $currentBrowsing['DatamartStructure']['control_master_model']) {
                // must use the generic structure (or its empty...)
                AppController::addInfoMsg(__("the results contain various data types, so the details are not displayed"));
            }
            if ($this->checklistModel == null) {
                $this->checklistSubModelsIdFilter = Browser::getDropdownSubFiltering($currentBrowsing);
                $this->checklistUseKey = $currentModel->primaryKey;
                $this->checklistModel = $currentModel;
            }
            
            $prefix = '';
            if ($iterationCount > 1) {
                // prefix all models with their node id, except for the first node
                $prefix = $node . '_';
            }
            // structure merge, add 100 * iteration count to display column
            foreach ($structure['Sfs'] as $sfs) {
                $sfs['display_column'] += 100 * $iterationCount;
                $sfs['model'] = $prefix . $sfs['model'];
                $sfs['structure_group'] = $iterationCount;
                $sfs['structure_group_name'] = __($currentBrowsing['DatamartStructure']['display_name']);
                $resultStructure['Sfs'][] = $sfs;
            }
            // copy accuracy settings
            foreach ($structure['Accuracy'] as $model => $fields) {
                if (isset($resultStructure['Accuracy'][$model])) {
                    $resultStructure['Accuracy'][$model] = array_merge($fields, $resultStructure['Accuracy'][$model]);
                } else {
                    $resultStructure['Accuracy'][$model] = $fields;
                }
            }
            
            // arrange Structure to be able to print structure alias when in debug mode
            if (! array_key_exists(0, $structure['Structure'])) {
                $structure['Structure'] = array(
                    $structure['Structure']
                );
            }
            $resultStructure['Structure'] = array_merge($resultStructure['Structure'], $structure['Structure']);
            
            $ancestorIsChild = false;
            $joinField = null;
            if ($lastBrowsing != null) {
                // determine wheter the current item is a parent or child of the previous one
                $browsingControl = self::$browsingControlModel->find('first', array(
                    'conditions' => array(
                        'id1' => $lastBrowsing['DatamartStructure']['id'],
                        'id2' => $currentBrowsing['DatamartStructure']['id']
                    )
                ));
                if (empty($browsingControl)) {
                    // direction parent -> child
                    $browsingControl = self::$browsingControlModel->find('first', array(
                        'conditions' => array(
                            'id2' => $lastBrowsing['DatamartStructure']['id'],
                            'id1' => $currentBrowsing['DatamartStructure']['id']
                        )
                    ));
                    assert(! empty($browsingControl));
                } else {
                    // direction child -> parent
                    $ancestorIsChild = true;
                }
                $joinField = $browsingControl['BrowsingControl']['use_field'];
            }
            
            // update header
            $count = $currentModel->find('count', array(
                'conditions' => array(
                    $currentModel->name . "." . $currentModel->primaryKey => $ids
                ),
                'recursive' => - 1
            ));
            $header[] = __($currentBrowsing['DatamartStructure']['display_name']) . $headerSubType . "(" . $count . ")";
            $this->nodes[] = array(
                self::NODE_ID => $node,
                self::IDS => $ids,
                self::MODEL => $currentModel,
                self::USE_KEY => $currentModel->primaryKey,
                self::ANCESTOR_IS_CHILD => $ancestorIsChild,
                self::JOIN_FIELD => $joinField,
                self::SUB_MODEL_ID => $currentSubModel
            );
            $lastBrowsing = $currentBrowsing;
            ++ $iterationCount;
        }
        
        // prepare buffer conditions
        $this->buildBufferedSearchParameters($primaryNodeIds, $order);
        $this->count = $this->nodes[0][self::MODEL]->find('count', array(
            'joins' => $this->searchParameters['joins'],
            'conditions' => $this->searchParameters['conditions'],
            'recursive' => - 1
        ));
        $this->checklistHeader = implode(" - ", $header);
        $this->resultStructure = $resultStructure;
    }

    /**
     *
     * @param $chunkSize
     */
    private function fillBuffer($chunkSize)
    {
        $this->searchParameters['limit'] = $chunkSize;
        $this->searchParameters['offset'] = $this->offset;
        $lines = $this->nodes[0][self::MODEL]->find('all', $this->searchParameters);
        $this->offset += $chunkSize;
        
        $this->rowsBuffer = array();
        $this->modelsBuffer = array();
        foreach ($lines as $line) {
            $this->rowsBuffer[] = array_values($line[0]);
            $i = 0;
            foreach ($line[0] as $modelId) {
                $this->modelsBuffer[$i ++][$modelId] = null;
            }
        }
        
        foreach ($this->modelsBuffer as &$models) {
            $models = array_keys($models);
        }
    }

    /**
     *
     * @param unknown_type $chunkSize
     * @return Returns an array of a portion of the data. Successive calls move the pointer forward.
     */
    public function getDataChunk($chunkSize)
    {
        $this->fillBuffer($chunkSize);
        if (empty($this->rowsBuffer)) {
            $chunk = array();
        } else {
            $chunk = array_fill(0, count($this->rowsBuffer), array());
            $node = null;
            $count = 0;
            foreach ($this->modelsBuffer as $modelIndex => $modelIds) {
                $node = $this->nodes[$modelIndex];
                $prefix = '';
                if ($count) {
                    // set a prefix when model != 0 (the first one cannot be prefixed because of links and checkboxes)
                    $prefix = $node[self::NODE_ID] . '_';
                }
                $modelDataTmp = $node[self::MODEL]->find('all', array(
                    'fields' => '*',
                    'conditions' => array(
                        $node[self::MODEL]->name . "." . $node[self::USE_KEY] => $modelIds
                    ),
                    'recursive' => 0
                ));
                
                if ($prefix) {
                    $modelData = array();
                    while ($models = array_shift($modelDataTmp)) {
                        foreach ($models as $modelName => $data) {
                            $tmpArr[$prefix . $modelName] = $data;
                        }
                        $modelData[] = $tmpArr;
                    }
                    unset($modelDataTmp);
                } else {
                    $modelData = $modelDataTmp;
                }
                $modelData = AppController::defineArrayKey($modelData, $prefix . $node[self::MODEL]->name, $node[self::USE_KEY]);
                foreach ($this->rowsBuffer as $rowIndex => $rowData) {
                    if (! empty($rowData[$modelIndex])) {
                        $chunk[$rowIndex] = array_merge($modelData[$rowData[$modelIndex]][0], $chunk[$rowIndex]);
                    }
                }
                ++ $count;
            }
        }
        return $chunk;
    }

    /**
     * When defining advanced search parameters (parameters based on previous nodes),
     * updates the joins and conditions arrays.
     *
     * @param array $params
     * @return null on success, a model display_name string if a parent node has not a 1:1 relation with it's descendant
     */
    public function buildAdvancedSearchParameters(array &$params)
    {
        $browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult', true);
        $browsingControlModel = AppModel::getInstance('Datamart', 'BrowsingControl', true);
        $joinedModels = array();
        $params['conditions_adv'] = array();
        foreach ($params['joins'] as $join) {
            $joinedModels[$join['alias']] = null;
        }
        foreach ($params['adv_struct']['Sfs'] as $field) {
            if ($field['field'] != 'browsing_filter' && isset($params['data'][$field['model']][$field['field']]) && $params['data'][$field['model']][$field['field']]) {
                $currModel = $params['browsing_model'];
                $advField = $currModel->getBrowsingAdvSearchArray($field['field']);
                $optionKey = $params['data'][$currModel->name][$field['field']];
                if ($advField && isset($advField[$params['data'][$currModel->name][$field['field']]])) {
                    // the needed model is not already joined, join it
                    $path = $browsingResultModel->getPath($params['node_id'], null, 0);
                    $currId = $params['browsing']['DatamartStructure']['id'];
                    $advField = $advField[$optionKey];
                    while ($parentBrowsing = array_pop($path)) {
                        if (! array_key_exists($parentBrowsing['DatamartStructure']['model'], $joinedModels)) {
                            $control = $browsingControlModel->find('first', array(
                                'conditions' => array(
                                    'BrowsingControl.id1' => $currId,
                                    'BrowsingControl.id2' => $parentBrowsing['DatamartStructure']['id']
                                )
                            ));
                            $parentBrowsingModel = AppModel::getInstance($parentBrowsing['DatamartStructure']['plugin'], $parentBrowsing['DatamartStructure']['control_master_model'] ?  : $parentBrowsing['DatamartStructure']['model'], true);
                            
                            if ($parentBrowsingModel->name == $advField['model'] && ! $parentBrowsingModel->schema($advField['field'])) {
                                // error, the field doesn't exist
                                AppController::getInstance()->redirect('/Pages/err_internal?p[]=model+field+not+found', null, true);
                            }
                            
                            $conditions = array();
                            if ($control) {
                                $conditions = array(
                                    $currModel->name . '.' . $control['BrowsingControl']['use_field'] . ' = ' . $parentBrowsingModel->name . '.' . $parentBrowsingModel->primaryKey
                                );
                            } else {
                                $control = $browsingControlModel->find('first', array(
                                    'conditions' => array(
                                        'BrowsingControl.id2' => $currId,
                                        'BrowsingControl.id1' => $parentBrowsing['DatamartStructure']['id']
                                    )
                                ));
                                assert(! empty($control));
                                
                                // make sure parent relation to current node is 1:1
                                $parentRefKey = $parentBrowsingModel->name . '.' . $control['BrowsingControl']['use_field'];
                                $distinctCount = $parentBrowsingModel->find('first', array(
                                    'conditions' => array(
                                        $parentRefKey => explode(',', $parentBrowsing['BrowsingResult']['id_csv'])
                                    ),
                                    'fields' => array(
                                        'COUNT(' . $parentRefKey . ') AS c'
                                    ),
                                    'group' => array(
                                        $parentBrowsingModel->name . '.' . $parentBrowsingModel->primaryKey
                                    ),
                                    'order' => array(
                                        'c DESC'
                                    )
                                ));
                                if ($distinctCount[0]['c'] > 1) {
                                    return $parentBrowsing['DatamartStructure']['display_name'];
                                }
                                
                                $conditions = array(
                                    $parentRefKey . ' = ' . $currModel->name . '.' . $currModel->primaryKey
                                );
                            }
                            
                            $conditions[] = $parentBrowsingModel->name . '.' . $parentBrowsingModel->primaryKey . ' IN(' . $parentBrowsing['BrowsingResult']['id_csv'] . ')';
                            
                            $params['joins'][] = array(
                                'table' => $parentBrowsingModel->table,
                                'alias' => $parentBrowsingModel->name,
                                'type' => 'INNER',
                                'conditions' => $conditions
                            );
                            $joinedModels[$parentBrowsingModel->name] = null;
                            $currId = $parentBrowsing['DatamartStructure']['id'];
                            $currModel = $parentBrowsingModel;
                        }
                    }
                }
                
                $cond = sprintf('%s.%s %s %s.%s', $params['browsing_model']->name, $field['field'], $advField['relation'], $advField['model'], $advField['field']);
                $params['conditions'][] = $cond;
                $params['conditions_adv'][$field['field']] = $optionKey;
            }
        }
        return null;
    }

    /**
     *
     * @param $params
     * @return array
     */
    public function createNode($params)
    {
        $dmStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
        $browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult', true);
        $browsingCtrlModel = AppModel::getInstance('Datamart', 'BrowsingControl', true);
        $browsing = $dmStructureModel->find('first', array(
            'conditions' => array(
                'id' => $params['struct_ctrl_id']
            )
        ));
        assert($browsing);
        $controller = AppController::getInstance();
        $nodeId = $params['node_id'];
        $save = array();
        if (! AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])) {
            echo $browsing['DatamartStructure']['index_link'];
            $controller->atimFlashError(__("You are not authorized to access that location."), Router::url($this->here, true));
            // $controller->atimFlashError(__("You are not authorized to access that location."), 'javascript:history.back()');
            return false;
        }
        $modelToSearch = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
        $useSubModel = null;
        $joins = array();
        
        if ($params['sub_struct_ctrl_id'] && $ctrlModel = $modelToSearch->getControlName()) {
            // sub structure
            $modelToSearch = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['control_master_model'], true);
            $alternateInfo = Browser::getAlternateStructureInfo($browsing['DatamartStructure']['plugin'], $ctrlModel, $params['sub_struct_ctrl_id']);
            $alternateAlias = $alternateInfo['form_alias'];
            $resultStructure = $controller->Structures->get('form', $alternateAlias);
            $modelToImport = $browsing['DatamartStructure']['control_master_model'];
            $useSubModel = true;
            
            // add detail tablename to result_structure (use to parse search parameters) where needed
            $detailModelName = str_replace('Master', 'Detail', $modelToImport);
            if ($detailModelName == $modelToImport) {
                AppController::addWarningMsg('The replacement to get the detail model name failed');
            } else {
                $ctrlModel = AppModel::getInstance($modelToSearch->getPluginName(), $ctrlModel);
                $ctrlData = $ctrlModel->findById($params['sub_struct_ctrl_id']);
                $joins[] = array(
                    'alias' => $detailModelName,
                    'table' => $ctrlData[$ctrlModel->name]['detail_tablename'],
                    'conditions' => array(
                        $modelToSearch->name . '.' . $modelToSearch->primaryKey . ' = ' . $detailModelName . '.' . Inflector::underscore($modelToSearch->name) . '_id'
                    ),
                    'type' => 'INNER'
                );
                foreach ($resultStructure['Sfs'] as &$field) {
                    if ($field['model'] == $detailModelName && $field['tablename'] != $alternateInfo['detail_tablename']) {
                        if (Configure::read('debug') > 0 && ! empty($field['tablename']) && $field['tablename'] != $alternateInfo['detail_tablename']) {
                            AppController::addWarningMsg('A loaded detail field has a different tablename [' . $field['tablename'] . '] than what the control table states [' . $alternateInfo['detail_tablename'] . ']', true);
                        }
                        $field['tablename'] = $alternateInfo['detail_tablename'];
                    }
                }
            }
        } else {
            $resultStructure = $controller->Structures->getFormById($browsing['DatamartStructure']['structure_id']);
            $useSubModel = false;
        }
        
        $advancedData = null;
        $selectKey = $modelToSearch->name . "." . $modelToSearch->primaryKey;
        $searchConditions = null;
        if (isset($params['search_conditions'])) {
            $orgSearchConditions = array(
                'search_conditions' => $params['search_conditions'],
                'exact_search' => $params['exact_search'],
                'adv_search_conditions' => array()
            );
            $advancedData = array(
                $modelToSearch->name => $params['adv_search_conditions']
            );
            $searchConditions = $params['search_conditions'];
        } else {
            $searchConditions = $controller->Structures->parseSearchConditions($resultStructure);
            
            if ($useSubModel) {
                // adding filtering search condition
                $searchConditions[$browsing['DatamartStructure']['control_master_model'] . "." . $modelToSearch->getControlForeign()] = $params['sub_struct_ctrl_id'];
            }
            
            $orgSearchConditions = array(
                'search_conditions' => $searchConditions,
                'exact_search' => isset($controller->request->data['exact_search']),
                'adv_search_conditions' => array()
            );
            $advancedData = $controller->request->data;
        }
        
        if ($params['node_id'] != 0) {
            // this is not the first node, search based on parents
            $parent = $browsingResultModel->find('first', array(
                'conditions' => array(
                    "BrowsingResult.id" => $params['node_id']
                )
            ));
            $controlData = $browsingCtrlModel->find('first', array(
                'conditions' => array(
                    'BrowsingControl.id1' => $parent['DatamartStructure']['id'],
                    'BrowsingControl.id2' => $browsing['DatamartStructure']['id']
                )
            ));
            $parentModel = AppModel::getInstance($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['control_master_model'] ?  : $parent['DatamartStructure']['model'], true);
            if (! empty($controlData)) {
                $toJoin = array(
                    'table' => $parentModel->table,
                    'alias' => $parentModel->name . '_2',
                    'type' => 'INNER',
                    'conditions' => array(
                        $parentModel->name . '_2.' . $controlData['BrowsingControl']['use_field'] . ' = ' . $selectKey,
                        $parentModel->name . '_2.' . $parentModel->primaryKey => explode(',', $parent['BrowsingResult']['id_csv'])
                    )
                );
                if ($params['parent_child'] == 'c') {
                    // reentrant browsing, invert the condition
                    $toJoin['conditions'] = array(
                        // WRONG KEY
                        $parentModel->name . '_2.' . $controlData['BrowsingControl']['use_field'] => explode(',', $parent['BrowsingResult']['id_csv']),
                        $parentModel->name . '_2.' . $parentModel->primaryKey . ' = ' . $selectKey
                    );
                }
                $joins[] = $toJoin;
            } else {
                // ids are already contained in the child
                $controlData = $browsingCtrlModel->find('first', array(
                    'conditions' => array(
                        'BrowsingControl.id1' => $browsing['DatamartStructure']['id'],
                        'BrowsingControl.id2' => $parent['DatamartStructure']['id']
                    )
                ));
                assert($controlData);
                $searchConditions[$modelToSearch->name . '.' . $controlData['BrowsingControl']['use_field']] = explode(',', $parent['BrowsingResult']['id_csv']);
            }
        }
        $browsingFilter = array();
        
        if ($browsing['DatamartStructure']['adv_search_structure_alias']) {
            $advancedStructure = $controller->Structures->get('form', $browsing['DatamartStructure']['adv_search_structure_alias']);
            $advParams = array(
                'adv_struct' => $advancedStructure,
                'data' => $advancedData,
                'joins' => &$joins,
                'conditions' => &$searchConditions,
                'node_id' => $nodeId,
                'browsing' => $browsing,
                'browsing_model' => $modelToSearch
            );
            $errorModelDisplayName = $this->buildAdvancedSearchParameters($advParams);
            if ($errorModelDisplayName != null) {
                // example: If 3 tx are owned by the same participant, this error will be displayed.
                // we do it to make sure the result set is made with 1:1 relationship, thus clear.
                $controller->atimFlashError(__("a special parameter could not be applied because relations between %s and its children node are shared", __($errorModelDisplayName)), Router::url($this->here, true));
                // $controller->atimFlashError(__("a special parameter could not be applied because relations between %s and its children node are shared", __($errorModelDisplayName)), 'javascript:history.back()');
                return false;
            }
            $orgSearchConditions['adv_search_conditions'] = $advParams['conditions_adv'];
            if (isset($advancedData[$modelToSearch->name]['browsing_filter']) && ! empty($advancedData[$modelToSearch->name]['browsing_filter'])) {
                $browsingFilter = $modelToSearch->getBrowsingAdvSearchArray('browsing_filter');
                $browsingFilter = $browsingFilter[$advancedData[$modelToSearch->name]['browsing_filter']];
            }
        }
        
        $data = AppController::getInstance()->request->data;
        
        $having = array();
        if (isset($data[0])) {
            // counters conditions
            // starting from the end, clear empty conditions. Stop at first found condition.
            $possibleCountersConditions = array_reverse($data[0]);
            foreach ($possibleCountersConditions as $name => $val) {
                if ($val) {
                    break;
                } else {
                    unset($possibleCountersConditions[$name]);
                }
            }
            
            if ($possibleCountersConditions) {
                // these are the counters based on browsing. Eg.: I have a result
                // set with 10 samples, I browse towards collection having at
                // least 4 samples. Not to be confused by storage empty spaces.
                // valid conditions
                $browsingControlModel = AppModel::getInstance('Datamart', 'BrowsingControl');
                $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure');
                $lastModelId = $browsing['DatamartStructure']['id'];
                $possibleCountersConditions = array_reverse($possibleCountersConditions);
                foreach ($possibleCountersConditions as $name => $val) {
                    $matches = array();
                    preg_match('#^counter\_([\d]+)\_(start|end)$#', $name, $matches);
                    if (! $matches) {
                        // not a valid counter. (Eg of invalid counter: storage
                        // empty spaces
                        break;
                    }
                    $browsingResult = $browsingResultModel->findById($matches[1]);
                    $found = false; // whether a model is already in the joins array
                    foreach ($joins as $join) {
                        if ($join['alias'] == $browsingResult['DatamartStructure']['model']) {
                            $found = true;
                            break;
                        }
                    }
                    if (! $found) {
                        // join on it
                        $joins[] = $browsingControlModel->getInnerJoinArray($modelToSearch->name, $browsingResult['BrowsingResult']['browsing_structures_id'], explode(',', $browsingResult['BrowsingResult']['id_csv']));
                    }
                    $model = $datamartStructureModel->getModel($browsingResult['BrowsingResult']['browsing_structures_id']);
                    if ($val) {
                        $orgSearchConditions['counters'][] = array(
                            'browsing_structures_id' => $browsingResult['BrowsingResult']['browsing_structures_id'],
                            'condition' => ($matches[2] == 'start' ? '>=' : '<=') . ' ' . $val
                        );
                        $having[] = 'COUNT(DISTINCT(' . $model->name . '.' . $model->primaryKey . ')) ' . ($matches[2] == 'start' ? '>=' : '<=') . ' ' . $val;
                    }
                    $lastModelId = $browsingResult['BrowsingResult']['browsing_structures_id'];
                }
            }
        }
        
        foreach ($joins as $join) {
            unset($modelToSearch->belongsTo[$join['alias']]);
        }
        $group = array(
            $modelToSearch->name . '.' . $modelToSearch->primaryKey
        );
        if ($having) {
            $group[0] .= ' HAVING ' . implode(' AND ', $having);
        }
        if ($params['parent_child'] && isset($joins[1]) && $joins[1]['alias'] == $modelToSearch->name) {
            // reentrant detailed search
            $join = &$joins[1];
            unset($join['conditions'][0]);
            if ($params['parent_child'] == 'c') {
                $searchConditions = array_merge($searchConditions, $join['conditions']);
                unset($joins[1]);
            } else {
                $joins[1] = array(
                    'alias' => $modelToSearch->name . '_2',
                    'table' => $modelToSearch->table,
                    'type' => 'INNER',
                    'conditions' => array(
                        $modelToSearch->name . '_2.parent_id = ' . $modelToSearch->name . '.id',
                        $modelToSearch->name . '_2.id' => $join['conditions'][$modelToSearch->name . '.id']
                    )
                );
            }
        }
        $saveIds = $modelToSearch->find('all', array(
            'conditions' => $searchConditions,
            'fields' => array(
                "CONCAT('', " . $selectKey . ") AS ids"
            ),
            'recursive' => 0,
            'joins' => $joins,
            'order' => array(
                $modelToSearch->name . '.' . $modelToSearch->primaryKey
            ),
            'group' => $group
        ));
        if ($browsingFilter && $saveIds) {
            $temporaryTable = 'browsing_tmp_table';
            $selectField = null;
            if ($modelToSearch->schema($browsingFilter['field'] . '_accuracy')) {
                // construct a field function based on accuracy
                // we have to use \n and \t for accuracy when searching for max
                // because they're the rare entries that go before a space
                $selectField = sprintf(AppModel::ACCURACY_REPLACE_STR, $browsingFilter['field'], $browsingFilter['field'] . '_accuracy', $browsingFilter['attribute'] == 'MAX' ? '"\n"' : '"A"', // non year
$browsingFilter['attribute'] == 'MAX' ? '"\t"' : '"B"', // year
$browsingFilter['attribute']);
            } else {
                $selectField = $browsingFilter['attribute'] . '(' . $browsingFilter['field'] . ')';
            }
            $saveIds = array_unique(array_map(create_function('$val', 'return $val[0]["ids"];'), $saveIds));
            $modelToSearch->tryCatchQuery('DROP TEMPORARY TABLE IF EXISTS ' . $temporaryTable);
            $query = sprintf('CREATE TEMPORARY TABLE %1$s (SELECT %2$s, %3$s AS order_field, " " AS accuracy FROM %4$s WHERE %5$s GROUP BY %2$s)', $temporaryTable, $browsingFilter['group by'], $selectField, $modelToSearch->table, $modelToSearch->primaryKey . ' IN(' . implode(', ', $saveIds) . ')');
            $modelToSearch->tryCatchQuery($query);
            
            if ($modelToSearch->schema($browsingFilter['field'] . '_accuracy')) {
                // update the table to restore values regarding accuracy
                $orgFieldInfo = $modelToSearch->schema($browsingFilter['field']);
                $query = 'UPDATE ' . $temporaryTable . ' SET order_field=CONCAT(SUBSTR(order_field, 1, %1$d), "%2$s"), accuracy="%3$s" WHERE LENGTH(order_field)=%4$d';
                if ($orgFieldInfo['atim_type'] == 'date') {
                    $modelToSearch->tryCatchQuery(sprintf($query, 4, '-01-01', 'y', 5) . ' AND INSTR(order_field, "' . ($browsingFilter['attribute'] == 'MAX' ? '\t' : 'B') . '")!=0');
                    $modelToSearch->tryCatchQuery(sprintf($query, 4, '-01-01', 'm', 5));
                    $modelToSearch->tryCatchQuery(sprintf($query, 7, '-01', 'd', 8));
                } else {
                    // datetime
                    $modelToSearch->tryCatchQuery(sprintf($query, 4, '-01-01 00:00:00', 'y', 5) . ' AND INSTR(order_field, "' . ($browsingFilter['attribute'] == 'MAX' ? '\t' : 'B') . '")!=0');
                    $modelToSearch->tryCatchQuery(sprintf($query, 4, '-01-01 00:00:00', 'm', 5));
                    $modelToSearch->tryCatchQuery(sprintf($query, 7, '-01 00:00:00', 'd', 8));
                    $modelToSearch->tryCatchQuery(sprintf($query, 10, ' 00:00:00', 'h', 11));
                    $modelToSearch->tryCatchQuery(sprintf($query, 13, '00:00', 'i', 14));
                }
                $modelToSearch->tryCatchQuery('UPDATE ' . $temporaryTable . ' SET accuracy="c" WHERE accuracy=" "');
            }
            
            $joins = array(
                array(
                    'table' => $temporaryTable,
                    'alias' => 'TmpTable',
                    'type' => 'INNER',
                    'conditions' => array(
                        sprintf('TmpTable.order_field = %1$s.%2$s', $modelToSearch->name, $browsingFilter['field']),
                        sprintf('TmpTable.%2$s = %1$s.%2$s', $modelToSearch->name, $browsingFilter['group by'])
                    )
                )
            );
            
            if ($modelToSearch->schema($browsingFilter['field'] . '_accuracy')) {
                $joins[0]['conditions'][] = sprintf('TmpTable.accuracy = %1$s.%2$s', $modelToSearch->name, $browsingFilter['field'] . '_accuracy');
            }
            
            $saveIds = $modelToSearch->find('all', array(
                'conditions' => array(
                    $modelToSearch->name . '.' . $modelToSearch->primaryKey => $saveIds
                ),
                'fields' => array(
                    "CONCAT('', " . $selectKey . ") AS ids"
                ),
                'recursive' => 0,
                'joins' => $joins,
                'order' => array(
                    $modelToSearch->name . '.' . $modelToSearch->primaryKey
                )
            ));
            $modelToSearch->tryCatchQuery('DROP TEMPORARY TABLE ' . $temporaryTable);
            
            $orgSearchConditions['adv_search_conditions']['browsing_filter'] = $advancedData[$modelToSearch->name]['browsing_filter'];
        }
        
        $saveIds = implode(",", array_unique(array_map(create_function('$val', 'return $val[0]["ids"];'), $saveIds)));
        if (strlen($saveIds) == 0) {
            // we have an empty set, bail out! (don't save empty result)
            if ($params['last']) {
                // go back 1 page
                $controller->atimFlashError(__("no data matches your search parameters"), Router::url($this->here, true));
                // $controller->atimFlashError(__("no data matches your search parameters"), "javascript:history.back();");
            } else {
                // go to the last node
                $controller->atimFlashWarning(__("you cannot browse to the requested entities because there is no [%s] matching your request", $browsing['DatamartStructure']['display_name']), "/Datamart/Browser/browse/" . $nodeId . "/");
            }
            return false;
        }
        
        $browsingType = null;
        if (! $orgSearchConditions['search_conditions'] || (count($orgSearchConditions['search_conditions']) == 1 && $params['sub_struct_ctrl_id']) && ! $orgSearchConditions['adv_search_conditions'] && ! isset($orgSearchConditions['counters'])) {
            $browsingType = 'direct access';
        } else {
            $browsingType = 'search';
        }
        $save = array(
            'BrowsingResult' => array(
                'user_id' => $controller->Session->read('Auth.User.id'),
                'parent_id' => $nodeId,
                'browsing_structures_id' => $params['struct_ctrl_id'],
                'browsing_structures_sub_id' => $useSubModel ? $params['sub_struct_ctrl_id'] : 0,
                'parent_children' => $params['parent_child'],
                'id_csv' => $saveIds,
                'raw' => 1,
                'browsing_type' => $browsingType,
                'serialized_search_params' => serialize($orgSearchConditions)
            )
        );
        
        if ($params['parent_child']) {
            // to be backward compatible, we need to do it separately otherwise
            // Set::flatten will not work on old identical searches due to
            // new key
            $save['parent_children'] = $params['parent_child'];
        }
        
        $tmp = $nodeId ? $browsingResultModel->find('first', array(
            'conditions' => Set::flatten($save)
        )) : array();
        if (empty($tmp)) {
            if (! isset($save['BrowsingResult']['parent_children'])) {
                $save['BrowsingResult']['parent_children'] = ' ';
            }
            // save fullset
            $save = $browsingResultModel->save($save);
            $save['BrowsingResult']['id'] = $browsingResultModel->id;
            if ($nodeId == 0) {
                // save into index as well
                $browsingIndexModel = AppModel::getInstance('Datamart', 'BrowsingIndex', true);
                $browsingIndexModel->save(array(
                    "BrowsingIndex" => array(
                        "root_node_id" => $save['BrowsingResult']['id']
                    )
                ));
                $browsingIndexModel->id = null;
            }
            $nodeId = $browsingResultModel->id;
            $browsingResultModel->id = null;
        } else {
            $save = $tmp;
        }
        
        $browsing['BrowsingResult'] = $save['BrowsingResult'];
        
        return array(
            'result_struct' => $resultStructure,
            'browsing' => $browsing
        );
    }

    /**
     *
     * @param $data
     * @param $nodeId
     */
    public function buildDrillDownIfNeeded($data, &$nodeId)
    {
        if ($nodeId == 0) {
            return;
        }
        $browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult');
        $parent = $browsingResultModel->find('first', array(
            'conditions' => array(
                "BrowsingResult.id" => $nodeId
            )
        ));
        if (isset($data[$parent['DatamartStructure']['model']]) && isset($data['Browser'])) {
            $parentModel = AppModel::getInstance($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['model'], true);
            // save selected subset if parent model found and from a checklist
            $ids = array();
            if (is_array($data[$parent['DatamartStructure']['model']][$parentModel->primaryKey])) {
                $ids = array_filter($data[$parent['DatamartStructure']['model']][$parentModel->primaryKey]);
                $ids = array_unique($ids);
                sort($ids);
                $idCsv = implode(",", $ids);
            } else {
                // fetch ids from the parent node
                $idCsv = $parent['BrowsingResult']['id_csv'];
                $ids = explode(',', $idCsv);
            }
            
            if (! $parent['BrowsingResult']['raw']) {
                // the parent is a drilldown, seek the next parent
                $parent = $browsingResultModel->find('first', array(
                    'conditions' => array(
                        "BrowsingResult.id" => $parent['BrowsingResult']['parent_id']
                    )
                ));
                $nodeId = $parent['BrowsingResult']['id'];
            }
            
            $save = array(
                'BrowsingResult' => array(
                    "user_id" => AppController::getInstance()->Session->read('Auth.User.id'),
                    "parent_id" => $nodeId,
                    "browsing_structures_id" => $parent['BrowsingResult']['browsing_structures_id'],
                    "browsing_structures_sub_id" => $parent['BrowsingResult']['browsing_structures_sub_id'],
                    "id_csv" => $idCsv,
                    'raw' => 0,
                    "browsing_type" => 'drilldown'
                )
            );
            
            $tmp = $browsingResultModel->find('first', array(
                'conditions' => Set::flatten($save)
            ));
            if (! empty($tmp)) {
                // current set already exists, use it
                $nodeId = $tmp['BrowsingResult']['id'];
            } elseif ($parent['BrowsingResult']['id_csv'] != $idCsv) {
                // current set does not exists and no identical parent exists, save!
                $browsingResultModel->id = null;
                $browsingResultModel->save($save);
                $nodeId = $browsingResultModel->id;
                $browsingResultModel->id = null;
            }
        }
    }
}