<?php

class TemplateController extends AppController
{

    public $uses = array(
        'Tools.Template',
        'Tools.TemplateNode',
        'Group'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->Auth->actionPath = 'controllers/';
    }

    public function index()
    {
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/index'));
        $this->Structures->set('template');
        
        $this->request->data = $this->Template->getTemplates('template edition');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /*
     * Create the Collection Template setting properties
     */
    public function add()
    {
        $this->Structures->set('template');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $submittedDataValidates = true;
            
            $this->Template->setOwnerAndVisibility($this->request->data);
            
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

    /*
     * Build The Collection Template
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
        $tmpTemplate = $this->Template->getTemplates('template edition', $templateId);
        if (empty($tmpTemplate)) {
            $this->atimFlashWarning(__('you do not own that template'), '/Tools/Template/index/');
            return;
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
                // TODO validate this section is usefull or not
                Configure::write('debug', 0);
                $this->request->data['Template']['id'] = $templateId;
                $this->set('isAjax', true);
            } else {
                // non ajax is made to save the tree
                $tree = json_decode('[' . $this->request->data['tree'] . ']');
                array_shift($tree); // remove root
                $nodesMapping = array(); // for new nodes, key is the received node id, value is the db node
                $foundNodes = array(); // already in db found nodes
                
                $this->TemplateNode->checkWritableFields = false;
                foreach ($tree as $node) {
                    if ($node->nodeId <= 0) {
                        // create the node in Db
                        $parentId = null;
                        if (isset ($node->parentId) && !is_string($node->parentId)){
                            if ($node->parentId <= 0) {
                                $parentId = $nodesMapping[$node->parentId];
                            }elseif ($node->parentId > 0) {
                                $parentId = $node->parentId;
                            }
                        }
                        $this->TemplateNode->data = array();
                        $this->TemplateNode->id = null;
                        
                        $this->TemplateNode->save(array(
                            'TemplateNode' => array(
                                'template_id' => $templateId,
                                'parent_id' => $parentId,
                                'datamart_structure_id' => $node->datamartStructureId,
                                'control_id' => abs($node->controlId),
                                'quantity' => $node->quantity
                            )
                        ));
                        $nodesMapping[$node->nodeId] = $this->TemplateNode->id;
                        $foundNodes[] = $this->TemplateNode->id;
                    } else {
                        $foundNodes[] = $node->nodeId;
                        $this->TemplateNode->id = $node->nodeId;
                        $this->TemplateNode->save(array(
                            'TemplateNode' => array(
                                'quantity' => $node->quantity
                            )
                        ));
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
        $this->request->data = $tmpTemplate;
        $this->set('editProperties', $tmpTemplate['Template']['allow_properties_edition']);
        
        $tree = $this->Template->init();
        $this->set('treeData', $tree['']);
        $this->set('templateId', $templateId);
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/index'));
        $jsData = array(
            'sample_controls' => $sampleControls,
            'samples_relations' => $samplesRelations,
            'aliquot_controls' => AppController::defineArrayKey($aliquotControls, "AliquotControl", "id", true),
            'aliquot_relations' => AppController::defineArrayKey($aliquotControls, "AliquotControl", "sample_control_id")
        );
        $this->set('jsData', $jsData);
        $this->set('templateId', $templateId);
        $this->set('controls', 1);
        $this->set('collectionId', 0);
        
        $this->render('tree');
    }

    public function editProperties($templateId)
    {
        $templateData = $this->Template->getTemplates('template edition', $templateId);
        if (empty($templateData))
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! $templateData['Template']['allow_properties_edition']) {
            $this->atimFlashWarning(__('you do not own that template'), '/Tools/Template/index/');
            return;
        }
        
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
            
            $this->Template->setOwnerAndVisibility($this->request->data, $templateData['Template']['created_by']);
            
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

    public function delete($templateId)
    {
        $templateData = $this->Template->getTemplates('template edition', $templateId);
        if (empty($templateData))
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! $templateData['Template']['allow_properties_edition']) {
            $this->atimFlashWarning(__('you do not own that template'), '/Tools/Template/index/');
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
        foreach ($nodesToDelete as $nodeToDelete) {
            $this->TemplateNode->delete($nodeToDelete);
        }
        $this->Template->delete($templateId);
        
        $this->atimFlash(__('your data has been deleted'), '/Tools/Template/index/');
    }
}