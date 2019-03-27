<?php

/**
 * Class BrowsingStepsController
 */
class BrowsingStepsController extends DatamartAppController
{

    public $uses = array(
        'Datamart.SavedBrowsingIndex',
        'Datamart.DatamartStructure',
        'Datamart.Browser'
    );

    public function listall()
    {
        // Load datamart structure
        $tmpDatamartStructures = $this->DatamartStructure->find('all', array(
            'conditions' => array()
        ));
        $datamartStructures = array();
        foreach ($tmpDatamartStructures as $newDatamartStructure)
            $datamartStructures[$newDatamartStructure['DatamartStructure']['id']] = $newDatamartStructure['DatamartStructure'];
        
        $this->request->data = $this->SavedBrowsingIndex->find('all', array(
            'conditions' => $this->SavedBrowsingIndex->getOwnershipConditions(),
            'order' => 'SavedBrowsingIndex.name'
        ));
        foreach ($this->request->data as &$data) {
            // Translate display name
            $data['DatamartStructure']['display_name'] = __($data['DatamartStructure']['display_name']);
            // Get formatted step data
            $result = '';
            $stepCounter = 0;
            foreach ($data['SavedBrowsingStep'] as $newStep) {
                $stepCounter ++;
                $newStepDatamartStructure = $datamartStructures[$newStep['datamart_structure_id']];
                $newStepModel = AppModel::getInstance($newStepDatamartStructure['plugin'], $newStepDatamartStructure['model'], true);
                $stepTitle = "** $stepCounter ** " . __($newStepDatamartStructure['display_name']);
                if ($newStep['parent_children'] == 'c') {
                    $stepTitle .= ' ' . __('children');
                } elseif ($newStep['parent_children'] == 'p') {
                    $stepTitle .= ' ' . __('parent');
                }
                $stepSearchDetails = '';
                $search = $newStep['serialized_search_params'] ? unserialize($newStep['serialized_search_params']) : array();
                $advSearch = isset($search['adv_search_conditions']) ? $search['adv_search_conditions'] : array();
                if ((isset($search['search_conditions']) && count($search['search_conditions'])) || $advSearch || isset($search['counters'])) {
                    $structure = null;
                    if ($newStepModel->getControlName() && $newStep['datamart_sub_structure_id'] > 0) {
                        // alternate structure required
                        $tmpModel = AppModel::getInstance($newStepDatamartStructure['plugin'], $newStepDatamartStructure['model'], true);
                        AppModel::getInstance("Datamart", "Browser", true);
                        $alternateAlias = Browser::getAlternateStructureInfo($newStepDatamartStructure['plugin'], $tmpModel->getControlName(), $newStep['datamart_sub_structure_id']);
                        $alternateAlias = $alternateAlias['form_alias'];
                        $structure = StructuresComponent::$singleton->get('form', $alternateAlias);
                        // unset the serialization on the sub model since it's already in the title
                        unset($search['search_conditions'][$newStepDatamartStructure['control_master_model'] . "." . $tmpModel->getControlForeign()]);
                        $tmpModel = AppModel::getInstance($newStepDatamartStructure['plugin'], $newStepDatamartStructure['control_master_model'], true);
                        $tmpData = $tmpModel->find('first', array(
                            'conditions' => array(
                                $tmpModel->getControlName() . ".id" => $newStep['datamart_sub_structure_id']
                            ),
                            'recursive' => 0
                        ));
                        $stepTitle .= " > " . Browser::getTranslatedDatabrowserLabel($tmpData[$tmpModel->getControlName()]['databrowser_label']);
                    } else {
                        $structure = StructuresComponent::$singleton->getFormById($newStepDatamartStructure['structure_id']);
                    }
                    
                    $addonParams = array();
                    if (isset($search['counters'])) {
                        foreach ($search['counters'] as $counter) {
                            $browsingStructure = $datamartStructures[$counter['browsing_structures_id']];
                            $addonParams[] = array(
                                'field' => __('counter') . ': ' . __($browsingStructure['display_name']),
                                'condition' => $counter['condition']
                            );
                        }
                    }
                    if (count($search['search_conditions']) || $advSearch || $addonParams) { // count might be zero if the only condition was the sub type
                        $advStructure = array();
                        if ($newStepDatamartStructure['adv_search_structure_alias']) {
                            $advStructure = StructuresComponent::$singleton->get('form', $newStepDatamartStructure['adv_search_structure_alias']);
                        }
                        
                        $stepSearchDetails .= $this->Browser->formatSearchToPrint(array(
                            'search' => $search,
                            'adv_search' => $advSearch,
                            'structure' => $structure,
                            'adv_structure' => $advStructure,
                            'model' => $newStepModel,
                            'addon_params' => $addonParams
                        ), false);
                    }
                }
                $result .= $stepTitle . "&#013;\n" . (empty($stepSearchDetails) ? __('no search criteria') . "&#013;\n" : $stepSearchDetails) . "&#013;\n";
            }
            $data['Generated']['description'] = "$result";
        }
        $this->Structures->set('datamart_saved_browsing');
    }

    /**
     *
     * @param $nodeId
     */
    public function save($nodeId)
    {
        Configure::write('debug', 0);
        $this->set('nodeId', $nodeId);
        $this->Structures->set('datamart_saved_browsing');
        
        if (! empty($this->request->data)) {
            $browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult');
            $path = $browsingResultModel->getPath($nodeId, null, 0);
            if (count($path) < 2) {
                return; // error, shouldn't be called
            }
            $savedBrowsingStepModel = AppModel::getInstance('Datamart', 'SavedBrowsingStep');
            $this->SavedBrowsingIndex->addWritableField(array(
                'starting_datamart_structure_id',
                'user_id',
                'group_id'
            ));
            $topNode = array_shift($path);
            $this->request->data['SavedBrowsingIndex']['starting_datamart_structure_id'] = $topNode['BrowsingResult']['browsing_structures_id'];
            $this->request->data['SavedBrowsingIndex']['user_id'] = $this->Session->read('Auth.User.id');
            $this->request->data['SavedBrowsingIndex']['group_id'] = $this->Session->read('Auth.User.group_id');
            $dataSource = $this->SavedBrowsingIndex->getDataSource();
            $dataSource->begin();
            if ($this->SavedBrowsingIndex->save($this->request->data)) {
                $indexId = $this->SavedBrowsingIndex->getInsertID();
                $browsingSteps = array();
                foreach ($path as $pathNode) {
                    if ($pathNode['BrowsingResult']['raw']) {
                        $browsingSteps[] = array(
                            'datamart_saved_browsing_index_id' => $indexId,
                            'datamart_structure_id' => $pathNode['BrowsingResult']['browsing_structures_id'],
                            'datamart_sub_structure_id' => $pathNode['BrowsingResult']['browsing_structures_sub_id'],
                            'serialized_search_params' => $pathNode['BrowsingResult']['serialized_search_params'],
                            'parent_children' => $pathNode['BrowsingResult']['parent_children']
                        );
                    }
                }
                $savedBrowsingStepModel->checkWritableFields = false;
                $savedBrowsingStepModel->saveAll($browsingSteps);
                $dataSource->commit();
                echo json_encode(array(
                    'type' => 'message',
                    'message' => __('data saved')
                ));
                $this->render(false);
            }
        }
    }

    /**
     *
     * @param $id
     */
    public function edit($id)
    {
        $this->Structures->set('datamart_saved_browsing');
        $browsingIndex = $this->SavedBrowsingIndex->find('first', array(
            'conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array(
                'SavedBrowsingIndex.id' => $id
            ))
        ));
        if (! $browsingIndex) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (! empty($this->request->data)) {
            $this->SavedBrowsingIndex->id = $id;
            if ($this->SavedBrowsingIndex->save($this->request->data)) {
                $this->atimFlash(__('your data has been saved'), '/Datamart/BrowsingSteps/listall/');
            }
        } else {
            $this->request->data = $browsingIndex;
            $this->request->data['DatamartStructure']['display_name'] = __($this->request->data['DatamartStructure']['display_name']);
        }
        $this->set('atimMenuVariables', array(
            'SavedBrowsingIndex.id' => $id
        ));
    }

    /**
     *
     * @param $id
     */
    public function delete($id)
    {
        $browsingIndex = $this->SavedBrowsingIndex->find('first', array(
            'conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array(
                'SavedBrowsingIndex.id' => $id
            ))
        ));
        if (! $browsingIndex) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->SavedBrowsingIndex->atimDelete($id);
        $this->atimFlash(__('your data has been deleted'), '/Datamart/BrowsingSteps/listall/');
    }
}