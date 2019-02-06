<?php

/**
 * Class BrowsingResult
 */
class BrowsingResult extends DatamartAppModel
{

    public $useTable = 'datamart_browsing_results';

    public $belongsTo = array(
        'DatamartStructure' => array(
            'className' => 'Datamart.DatamartStructure',
            'foreignKey' => 'browsing_structures_id'
        )
    );

    public $actsAs = array(
        'Tree'
    );

    /**
     *
     * @param $startId
     * @param $browsingCache
     * @return array|null
     */
    public function cacheAndGet($startId, &$browsingCache)
    {
        $browsing = $this->find('first', array(
            "conditions" => array(
                'BrowsingResult.id' => $startId
            )
        ));
        
        assert(! empty($browsing)) or die();
        
        $browsingCache[$startId] = $browsing;
        
        return $browsing;
    }

    /**
     * Return a model associated to a node (takes the detail model if the result set allows it)
     *
     * @param $browsingResult
     * @return array
     * @internal param mixed $node Either a browsing result id or the data array related to it* Either a browsing result id or the data array related to it
     */
    public function getModelAndStructureForNode($browsingResult)
    {
        if (is_integer($browsingResult)) {
            $browsingResult = $this->getOrRedirect($browsingResult);
        }
        assert(is_array($browsingResult));
        
        $structuresComponent = AppController::getInstance()->Structures;
        $model = AppModel::getInstance($browsingResult['DatamartStructure']['plugin'], $browsingResult['DatamartStructure']['model']);
        $structure = $structuresComponent->getFormById($browsingResult['DatamartStructure']['structure_id']);
        $headerSubType = null;
        $controlId = null;
        if ($browsingResult['BrowsingResult']['browsing_structures_sub_id']) {
            // specific
            $controlId = $browsingResult['BrowsingResult']['browsing_structures_sub_id'];
        } elseif ($browsingResult['DatamartStructure']['control_master_model']) {
            $controlForeign = $model->getControlForeign();
            $data = array_unique(array_filter($model->find('list', array(
                'fields' => array(
                    $model->name . '.' . $controlForeign
                ),
                'conditions' => array(
                    $model->name . '.' . $model->primaryKey . ' IN(' . $browsingResult['BrowsingResult']['id_csv'] . ')'
                )
            ))));
            if (count($data) == 1) {
                $controlId = array_shift($data);
            }
        }
        
        if ($controlId) {
            $model = AppModel::getInstance($browsingResult['DatamartStructure']['plugin'], $browsingResult['DatamartStructure']['control_master_model']);
            $controlModel = AppModel::getInstance($browsingResult['DatamartStructure']['plugin'], $model->getControlName());
            $controlModelData = $controlModel->find('first', array(
                'fields' => array(
                    $controlModel->name . '.form_alias',
                    $controlModel->name . '.databrowser_label'
                ),
                'conditions' => array(
                    $controlModel->name . ".id" => $controlId
                )
            ));
            
            $headerSubType = $controlModelData[$controlModel->name]['databrowser_label'];
            
            // init base model
            $structureAlias = $structure['Structure']['alias'];
            
            AppController::buildDetailBinding($model, array(
                $model->name . '.' . $model->getControlForeign() => $controlId
            ), $structureAlias);
            
            $structure = $structuresComponent->get('form', $structureAlias);
        }
        
        return array(
            'specific' => $controlId != null,
            'model' => $model,
            'structure' => $structure,
            'header_sub_type' => $headerSubType,
            'control_id' => $controlId
        );
    }

    /**
     *
     * @param $startingNodeId
     * @return array
     */
    public function getSingleLineMergeableNodes($startingNodeId)
    {
        $startingNode = $this->getOrRedirect($startingNodeId);
        $requiredFields = array(
            'BrowsingResult.id',
            'BrowsingResult.parent_id',
            'BrowsingResult.browsing_structures_id',
            'BrowsingResult.browsing_type'
        );
        $parentsNodes = $this->getPath($startingNodeId, $requiredFields);
        $startingNode = array_pop($parentsNodes); // the last element is the starting node
        if ($startingNode['BrowsingResult']['browsing_type'] == 'drilldown') {
            // starting node is a drilldown, flush the direct parent
            array_pop($parentsNodes);
        }
        
        $filteredParents = array();
        
        $datamartControlsModel = AppModel::getInstance('Datamart', 'BrowsingControl');
        
        // filter parents
        $currentCtrlId = $startingNode['BrowsingResult']['browsing_structures_id'];
        $encounteredCtrls = array();
        // drilldowns are automatically stop conditions caused by encountered_ctrls
        while ($parent = array_pop($parentsNodes)) {
            if (in_array($parent['BrowsingResult']['browsing_structures_id'], $encounteredCtrls)) {
                // already encoutered type, don't go futher up
                break;
            }
            if ($datamartControlsModel->findNTo1($currentCtrlId, $parent['BrowsingResult']['browsing_structures_id'])) {
                // compatible node found
                $filteredParents[] = $parent;
                $currentCtrlId = $parent['BrowsingResult']['browsing_structures_id'];
                $encounteredCtrls[] = $currentCtrlId;
            } elseif ($datamartControlsModel->find1ToN($currentCtrlId, $parent['BrowsingResult']['browsing_structures_id'])) {
                // compatible node found on a terminating node
                $filteredParents[] = $parent;
                break;
            } else {
                // incompatible node found, no need to go further up the tree
                break;
            }
        }
        unset($parentsNodes);
        
        $filteredParents = array_reverse($filteredParents);
        $filteredParents = AppController::defineArrayKey($filteredParents, 'BrowsingResult', 'id', true);
        
        // filter children
        $childrenNodes = $this->children($startingNodeId, false, $requiredFields);
        $flatChildrenNodes = array();
        $this->makeTree($childrenNodes);
        $nextLevelChildren = array(
            array(
                'current_ctrl_id' => $currentCtrlId = $startingNode['BrowsingResult']['browsing_structures_id'],
                'nodes' => &$childrenNodes,
                'encountered_ctrls' => array()
            )
        );
        while (! empty($nextLevelChildren)) {
            $currentNodes = $nextLevelChildren;
            $nextLevelChildren = array();
            foreach ($currentNodes as &$childNode) {
                // check all current level nodes. Put all curent level nodes' children into tmp_children
                // within the same line, no same ctrl id allowed
                $currentCtrlId = $childNode['current_ctrl_id'];
                $encounteredCtrls = $childNode['encountered_ctrls'];
                foreach ($childNode['nodes'] as $k => &$node) {
                    if ($node['BrowsingResult']['browsing_type'] == 'drilldown') {
                        // drilldown are automatically rejected
                        unset($childNode['nodes'][$k]);
                    } elseif (! in_array($node['BrowsingResult']['browsing_structures_id'], $encounteredCtrls)) {
                        if ($datamartControlsModel->findNTo1($currentCtrlId, $node['BrowsingResult']['browsing_structures_id'])) {
                            // compatible node found, leave it in the tree
                            $flatChildrenNodes[$node['BrowsingResult']['id']] = $node;
                            // add children to the next level to check
                            if (isset($node['BrowsingResult']['children'])) {
                                $nextLevelChildren[] = array(
                                    'current_ctrl_id' => $node['BrowsingResult']['browsing_structures_id'],
                                    'nodes' => &$node['BrowsingResult']['children'],
                                    'encountered_ctrls' => array_merge($encounteredCtrls, array(
                                        $currentCtrlId
                                    ))
                                );
                            }
                        } elseif ($datamartControlsModel->find1ToN($currentCtrlId, $node['BrowsingResult']['browsing_structures_id'])) {
                            // compatible node found, leave it in the tree
                            $flatChildrenNodes[$node['BrowsingResult']['id']] = $node;
                            // terminating 1 - n relationship
                            unset($node['BrowsingResult']['children']);
                        } else {
                            // incompatible node found, remove it from the tree
                            unset($childNode['nodes'][$k]);
                        }
                    } else {
                        // incompatible node found, remove it from the tree
                        unset($childNode['nodes'][$k]);
                    }
                }
            }
        }
        return array(
            'parents' => $filteredParents,
            'children' => $childrenNodes,
            'flat_children' => $flatChildrenNodes,
            'current_id' => $startingNodeId
        );
    }

    /**
     *
     * @param $baseNodeId
     * @param $targetNodeId
     * @return array
     */
    public function getJoins($baseNodeId, $targetNodeId)
    {
        $mergeOn = array();
        $baseBrowsingResult = null;
        if ($baseNodeId < $targetNodeId) {
            $path = $this->getPath($targetNodeId, null, 0);
            while ($browsingResult = array_pop($path)) {
                if ($browsingResult['BrowsingResult']['id'] == $baseNodeId) {
                    $baseBrowsingResult = $browsingResult;
                    break;
                }
                $mergeOn[$browsingResult['BrowsingResult']['id']] = $browsingResult;
            }
            $mergeOn = array_reverse($mergeOn);
        } else {
            $path = $this->getPath($baseNodeId, null, 0);
            $baseBrowsingResult = array_pop($path);
            while ($browsingResult = array_pop($path)) {
                $mergeOn[$browsingResult['BrowsingResult']['id']] = $browsingResult;
                if ($browsingResult['BrowsingResult']['id'] == $targetNodeId) {
                    break;
                }
            }
        }
        
        $browsingControlModel = AppModel::getInstance('Datamart', 'BrowsingControl', true);
        $currentModel = $this->getModelAndStructureForNode($baseBrowsingResult);
        $currentModel = $currentModel['model']->name;
        $joins = array();
        foreach ($mergeOn as $mergeUnit) {
            $toModel = $this->getModelAndStructureForNode($mergeUnit);
            $toModel = $toModel['model']->name;
            $joins[] = $browsingControlModel->getInnerJoinArray($currentModel, $toModel, explode(',', $mergeUnit['BrowsingResult']['id_csv']));
            $currentModel = $toModel;
        }
        return $joins;
    }

    /**
     *
     * @param $baseNodeId
     * @param $targetNodeId
     * @return mixed
     */
    public function countMaxDuplicates($baseNodeId, $targetNodeId)
    {
        $joins = $this->getJoins($baseNodeId, $targetNodeId);
        
        $baseModel = $this->getModelAndStructureForNode((int) $baseNodeId);
        $baseModel = $baseModel['model'];
        $finalModel = $this->getModelAndStructureForNode((int) $targetNodeId);
        $finalModel = $finalModel['model'];
        $data = $baseModel->find('first', array(
            'fields' => array(
                'COUNT(' . $finalModel->name . '.' . $finalModel->primaryKey . ') AS c'
            ),
            'conditions' => array(),
            'joins' => $joins,
            'group' => $baseModel->name . '.' . $baseModel->primaryKey,
            'order' => 'c DESC',
            'recursive' => - 1
        ));
        return $data[0]['c'];
    }
}