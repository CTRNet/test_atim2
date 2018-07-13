<?php

/**
 * Class TemplateController
 */
class TemplateController extends ToolsAppController
{

    public $uses = array(
        'Tools.Template',
        'Tools.TemplateNode',
        'Tools.CollectionProtocol',
        'Tools.CollectionProtocolVisit',
        'Group'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->Auth->actionPath = 'controllers/';
    }

    /**
     * List user collection templates and protocols.
     */
    public function listProtocolsAndTemplates()
    {
        // Nothing to do
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * List user collection templates.
     */
    public function index()
    {
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        $this->Structures->set('template');
        
        $templates = $this->Template->getTools('list all');
        $templateIds = array();
        foreach ($templates as $newTemplate) {
            $templateIds[] = $newTemplate['Template']['id'];
        }
        $conditions = array(
            'Template.id' => $templateIds
        );
        $this->request->data = $this->paginate($this->Template, $conditions);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * Create a new Collection Template
     */
    public function add()
    {
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        $this->Structures->set('template');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $submittedDataValidates = true;
            
            $this->Template->setOwner($this->request->data);
            $this->request->data['Template']['user_id'] = AppController::getInstance()->Session->read('Auth.User.id');
            $this->request->data['Template']['group_id'] = AppController::getInstance()->Session->read('Auth.User.group_id');
            $this->Template->addWritableField(array(
                'user_id',
                'group_id'
            ));
            if ($this->request->data['Template']['flag_active']) {
                $this->request->data['Template']['last_activation_date'] = date('Y-m-d');
                $this->Template->addWritableField(array(
                    'last_activation_date'
                ));
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates && $this->Template->save($this->request->data)) {
                $templateId = $this->Template->getLastInsertId();
                $this->atimFlash(__('your data has been saved'), '/Tools/Template/edit/' . $templateId);
            }
        }
    }

    /**
     * Modify a Collection Template
     *
     * @param integer $templateId Id of the template
     */
    public function edit($templateId)
    {
        // the following business rules apply to received data
        // controlId = 0 -> collection root
        // > 0 -> sample
        // < 0 -> aliquot
        //
        // nodeId = 0 -> collection root node
        // < 0 -> node not in database
        // > 0 -> node in database
        
        // validate access
        $templateData = $this->Template->getOrRedirect($templateId);
        
        $tmpTemplate = $this->Template->getTools('edition', $templateId);
        if (! $tmpTemplate['Template']['allow_properties_edition']) {
            AppController::addWarningMsg(__('you do not own that template'));
        }
        
        // js menus required data-------
        $sampleControlModel = AppModel::getInstance("InventoryManagement", "SampleControl", true);
        $parentToDerivativeSampleControlModel = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
        $sampleControls = $sampleControlModel->find('all', array(
            'fields' => array(
                'id',
                'sample_type'
            ),
            'recursive' => - 1
        ));
        $samplesRelations = $parentToDerivativeSampleControlModel->find('all', array(
            'conditions' => array(
                'flag_active' => 1
            ),
            'recusrive' => - 1
        ));
        AppController::applyTranslation($sampleControls, 'SampleControl', 'sample_type');
        
        foreach ($samplesRelations as &$sampleRelation) {
            unset($sampleRelation['ParentSampleControl']);
            unset($sampleRelation['DerivativeControl']);
        }
        unset($sampleRelation);
        
        $sampleControls = AppController::defineArrayKey($sampleControls, 'SampleControl', 'id', true);
        $samplesRelations = AppController::defineArrayKey($samplesRelations, 'ParentToDerivativeSampleControl', 'parent_sample_control_id');
        
        $aliquotControlModel = AppModel::getInstance("InventoryManagement", "AliquotControl", 1);
        $aliquotControls = $aliquotControlModel->find('all', array(
            'fields' => array(
                'id',
                'sample_control_id',
                'aliquot_type'
            ),
            'conditions' => array(
                'flag_active' => 1
            ),
            'recursive' => - 1
        ));
        AppController::applyTranslation($aliquotControls, 'AliquotControl', 'aliquot_type');
        // -----------------------------
        
        $this->Structures->set('template_disabled');
        
        if (! empty($this->request->data)) {
            // correct owner/visibility if needed
            
            // record the tree
            if ($this->request->is('ajax')) {
                // ajax request are made to save the template info
                Configure::write('debug', 0);
                $this->request->data['Template']['id'] = $templateId;
                $this->set('isAjax', true);
            } elseif (! $tmpTemplate['Template']['allow_properties_edition']) {
                AppController::addWarningMsg(__('data can not be changed'));
            } else {
                // non ajax is made to save the tree
                $tree = json_decode('[' . $this->request->data['tree'] . ']');
                array_shift($tree); // remove root
                $nodesMapping = array(); // for new nodes, key is the received node id, value is the db node
                $foundNodes = array(); // already in db found nodes
                
                $this->TemplateNode->checkWritableFields = false;
                foreach ($tree as $node) {
                    if (! empty($node->defaultValues)) {
                        $node->defaultValues = $this->TemplateNode->fromateNodeDefaultValuesToSave($node->defaultValues);
                    }
                    if ($node->nodeId <= 0) {
                        // create the node in Db
                        $parentId = null;
                        if (is_numeric($node->parentId) && is_string($node->parentId)) {
                            $node->parentId = (int) $node->parentId;
                        }
                        if (isset($node->parentId) && ! is_string($node->parentId)) {
                            if ($node->parentId <= 0) {
                                $parentId = $nodesMapping[$node->parentId];
                            } elseif ($node->parentId > 0) {
                                $parentId = $node->parentId;
                            }
                        }
                        $this->TemplateNode->data = array();
                        $this->TemplateNode->id = null;
                        
                        $templateNode = array(
                            'TemplateNode' => array(
                                'template_id' => $templateId,
                                'parent_id' => $parentId,
                                'datamart_structure_id' => $node->datamartStructureId,
                                'control_id' => abs($node->controlId),
                                'quantity' => $node->quantity
                            )
                        );
                        
                        if (! empty($node->defaultValues)) {
                            $templateNode['TemplateNode']['default_values'] = $node->defaultValues;
                        }
                        $this->TemplateNode->save($templateNode);
                        $nodesMapping[$node->nodeId] = $this->TemplateNode->id;
                        $foundNodes[] = $this->TemplateNode->id;
                    } else {
                        $foundNodes[] = $node->nodeId;
                        $this->TemplateNode->id = $node->nodeId;
                        
                        $templateNode = array(
                            'TemplateNode' => array(
                                'quantity' => $node->quantity
                            )
                        );
                        if (! empty($node->defaultValues)) {
                            $templateNode['TemplateNode']['default_values'] = $node->defaultValues;
                        }
                        $this->TemplateNode->save($templateNode);
                    }
                }
                
                $nodesToDelete = $this->TemplateNode->find('list', array(
                    'fields' => array(
                        'TemplateNode.id'
                    ),
                    'conditions' => array(
                        'TemplateNode.template_id' => $templateId,
                        'NOT' => array(
                            'TemplateNode.id' => $foundNodes
                        )
                    )
                ));
                $nodesToDelete = array_reverse($nodesToDelete);
                foreach ($nodesToDelete as $nodeToDelete) {
                    $this->TemplateNode->delete($nodeToDelete);
                }
                
                $this->atimFlash(__('your data has been saved'), '/Tools/Template/edit/' . $templateId);
                return;
            }
        }
        
        // loading tree and setting variables
        $this->Template->id = $templateId;
        $this->request->data = $templateData;
        $this->set('editProperties', $tmpTemplate['Template']['allow_properties_edition']);
        $tree = $this->Template->init($this->Structures);
        $this->set('treeData', $tree['']);
        $this->set('templateId', $templateId);
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        $jsData = array(
            'sample_controls' => $sampleControls,
            'samples_relations' => $samplesRelations,
            'aliquot_controls' => AppController::defineArrayKey($aliquotControls, "AliquotControl", "id", true),
            'aliquot_relations' => AppController::defineArrayKey($aliquotControls, "AliquotControl", "sample_control_id"),
            'fomated_nodes_default_values' => $this->TemplateNode->formatTemplateNodeDefaultValuesForDisplay($templateId),
            'default_values_json' => $this->TemplateNode->getDefaultValues($templateId),
            'template_id' => $templateId
        );
        $this->set('jsData', $jsData);
        $this->set('templateId', $templateId);
        $this->set('controls', 1);
        $this->set('collectionId', 0);
        
        $this->render('tree');
    }

    /**
     * Modify properties of a Collection Template
     *
     * @param integer $templateId Id of the template
     */
    public function editProperties($templateId)
    {
        $templateData = $this->Template->getTools('edition', $templateId);
        if (empty($templateData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $templateData['Template']['allow_properties_edition']) {
            $this->atimFlashWarning(__('data can not be changed'), '/Tools/Template/edit/' . $templateId);
            return;
        }
        
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        $this->set('atimMenuVariables', array(
            'Template.id' => $templateId
        ));
        $this->Structures->set('template');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $templateData;
        } else {
            $submittedDataValidates = true;
            
            $this->Template->setOwner($this->request->data);
            
            if (! $templateData['Template']['flag_active'] && $this->request->data['Template']['flag_active']) {
                $this->request->data['Template']['last_activation_date'] = date('Y-m-d');
                $this->Template->addWritableField(array(
                    'last_activation_date'
                ));
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->Template->id = $templateId;
                if ($this->Template->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Tools/Template/edit/' . $templateId);
                }
            }
        }
    }

    /**
     * Delete a Collection Template
     *
     * @param integer $templateId Id of the template
     */
    public function delete($templateId)
    {
        $templateData = $this->Template->getOrRedirect($templateId);
        
        $templateData = $this->Template->getTools('edition', $templateId);
        if (empty($templateData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $templateData['Template']['allow_properties_edition']) {
            $this->atimFlashWarning(__('data can not be changed'), '/Tools/Template/edit/' . $templateId);
            return;
        }
        
        $nodesToDelete = $this->TemplateNode->find('list', array(
            'fields' => array(
                'TemplateNode.id'
            ),
            'conditions' => array(
                'TemplateNode.template_id' => $templateId
            )
        ));
        $nodesToDelete = array_reverse($nodesToDelete);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->Template->allowDeletion($templateId);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            foreach ($nodesToDelete as $nodeToDelete) {
                $this->TemplateNode->delete($nodeToDelete);
            }
            $this->Template->delete($templateId);
            
            $hookLink = $this->hook('postsave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->atimFlash(__('your data has been deleted'), '/Tools/Template/listProtocolsAndTemplates/');
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Tools/Template/edit/' . $templateId);
        }
    }

    /**
     * Form to record template node default values.
     *
     * @param integer $nodeId Id of the template node
     * @param integer $datamartStructureId Datamart structure id recorded for the template node.
     * @param integer $controlId Control ID of the inventory data (collection, sample, aliquot) that will be created from the node.
     */
    public function defaultValue($nodeId, $datamartStructureId, $controlId)
    {
        AppController::addWarningMsg(__('click on submit button of the main form to record the default values'));
        AppController::forceMsgDisplayInPopup();
        $structure = $this->TemplateNode->getStructuresForNodeDefaultValuesEntry($datamartStructureId, $controlId);
        $this->set("structure", $structure);
        $this->set("nodeId", $nodeId);
    }

    public function formatedDefaultValue($nodeDatamartStructureId, $nodeControlId)
    {
        $defaultValue = $this->request->data;
        $formatedDefaultValue = $this->TemplateNode->formatTemplateNodeDefaultValuesForDisplayByControlAndDatamartStructureIdId($nodeDatamartStructureId, $nodeControlId, $defaultValue);
        $this->set("formatedDefaultValue", $formatedDefaultValue);
    }
}