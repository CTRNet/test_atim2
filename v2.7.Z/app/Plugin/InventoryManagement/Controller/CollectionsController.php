<?php

/**
 * Class CollectionsController
 */
class CollectionsController extends InventoryManagementAppController
{

    public $components = array();

    public $uses = array(
        'InventoryManagement.Collection',
        'InventoryManagement.ViewCollection',
        'InventoryManagement.SampleMaster',
        'InventoryManagement.SampleControl',
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.SpecimenReviewMaster',
        'InventoryManagement.ParentToDerivativeSampleControl',
        'InventoryManagement.SpecimenDetail', // here for collection template validation
        'InventoryManagement.DerivativeDetail', // here for collection template validation
        
        'ExternalLink'
    );

    public $paginate = array(
        'Collection' => array(
            'order' => 'Collection.acquisition_label ASC'
        ),
        'ViewCollection' => array(
            'order' => 'ViewCollection.acquisition_label ASC'
        )
    );

    /**
     * @param int $searchId
     * @param bool $isCclAjax
     */
    public function search($searchId = 0, $isCclAjax = false)
    {
        if ($isCclAjax && $this->request->data) {
            // custom result handling for ccl
            $viewCollection = $this->Structures->get('form', 'view_collection');
            $this->set('atimStructure', $viewCollection);
            $this->Structures->set('empty', 'emptyStructure');
            $conditions = $this->Structures->parseSearchConditions($viewCollection);
            $limit = 20;
            $conditions[] = "ViewCollection.participant_id IS NULL";
            $this->request->data = $this->ViewCollection->find('all', array(
                'conditions' => $conditions,
                'limit' => $limit + 1
            ));
            foreach ($this->request->data as &$d) {
                unset($d['Collection']['id']); // to avoid auto selection
            }
            if (count($this->request->data) > $limit) {
                unset($this->request->data[$limit]);
                $this->set("overflow", true);
            }
        } elseif (isset($this->passedArgs['unlinkedParticipants'])) {
            $groupModel = AppModel::getInstance('', 'Group');
            $group = $groupModel->find('first', array(
                'conditions' => array(
                    'Group.id' => $this->Session->read('Auth.User.group_id')
                )
            ));
            $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection');
            $conditions = array(
                'ViewCollection.collection_property' => 'participant collection',
                'ViewCollection.participant_id' => null
            );
            if ($group['Group']['bank_id']) {
                $this->set('bankFilter', true);
                $conditions['ViewCollection.bank_id'] = $group['Group']['bank_id'];
            }
            $this->Structures->set('view_collection');
            $this->request->data = $this->paginate($this->ViewCollection, $conditions);
        } else {
            $this->searchHandler($searchId, $this->ViewCollection, 'view_collection', '/InventoryManagement/Collections/search');
        }
        
        $helpUrl = $this->ExternalLink->find('first', array(
            'conditions' => array(
                'name' => 'inventory_elements_defintions'
            )
        ));
        $this->set("helpUrl", $helpUrl['ExternalLink']['link']);
        if ($isCclAjax) {
            $this->set('isCclAjax', $isCclAjax);
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            if (! isset($this->request->query['nolatest'])) {
                $this->request->data = $this->ViewCollection->find('all', array(
                    'conditions' => array(
                        'Collection.created_by' => $this->Session->read('Auth.User.id')
                    ),
                    'order' => array(
                        'Collection.created DESC'
                    ),
                    'limit' => 5
                ));
            }
            $this->render('index');
        }
    }

    /**
     * @param $collectionId
     * @param bool $hideHeader
     */
    public function detail($collectionId, $hideHeader = false)
    {
        unset($_SESSION['InventoryManagement']['TemplateInit']);
        
        // MANAGE DATA
        $this->request->data = $this->ViewCollection->getOrRedirect($collectionId);
        
        // Set participant id
        $this->set('participantId', $this->request->data['ViewCollection']['participant_id']);
        
        // Get all sample control types to build the add to selected button
        $controls = $this->SampleControl->getPermissibleSamplesArray(null);
        $this->set('specimenSampleControlsList', $controls);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $collectionId
        ));
        $this->Structures->set('view_collection');
        
        // Define if this detail form is displayed into the collection content tree view
        $this->set('isAjax', $this->request->is('ajax'));
        $this->set('hideHeader', $hideHeader);
        
        $templateModel = AppModel::getInstance("Tools", "Template", true);
        $templates = $templateModel->getAddFromTemplateMenu($collectionId);
        $this->set('templates', $templates);
        
        if (! $this->request->is('ajax')) {
            $this->Structures->set('sample_masters_for_collection_tree_view', 'sample_masters_for_collection_tree_view');
            $sampleData = $this->SampleMaster->find('all', array(
                'conditions' => array(
                    'SampleMaster.collection_id' => $collectionId,
                    'SampleMaster.parent_id' => null
                ),
                'recursive' => 0
            ));
            $ids = array();
            foreach ($sampleData as $unit) {
                $ids[] = $unit['SampleMaster']['id'];
            }
            $ids = array_flip($this->SampleMaster->hasChild($ids)); // array_key_exists is faster than in_array
            foreach ($sampleData as &$unit) {
                $unit['children'] = array_key_exists($unit['SampleMaster']['id'], $ids);
            }
            $this->set('sampleData', $sampleData);
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * @param int $collectionId
     * @param int $copySource
     */
    public function add($collectionId = 0, $copySource = 0)
    {
        $collectionData = null;
        if ($collectionId > 0) {
            $collectionData = $this->Collection->find('first', array(
                'conditions' => array(
                    'Collection.id' => $collectionId,
                    'Collection.deleted' => 1
                ),
                'recursive' => 1
            ));
        }
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        if (! empty($collectionData)) {
            $this->Structures->set('linked_collections');
        }
        
        $this->set('atimVariables', array(
            'Collection.id' => $collectionId
        ));
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/Collections/search'));
        $this->set('copySource', $copySource);
        
        // Manage collection_property
        if (! empty($this->request->data) && ! array_key_exists('collection_property', $this->request->data['Collection'])) {
            // Set collection property to 'participant collection' if field collection property is hidden in add form (default value)
            $this->request->data['Collection']['collection_property'] = 'participant collection';
        }
        $this->Collection->addWritableField('collection_property'); // Force collection_property record in case field display flag is set to read only in collections form (see issue#3312)
        
        $needToSave = ! empty($this->request->data);
        if (empty($this->request->data) || isset($this->request->data['FunctionManagement']['col_copy_binding_opt'])) {
            if (! empty($copySource)) {
                if (empty($this->request->data)) {
                    $this->request->data = $this->Collection->getOrRedirect($copySource);
                }
                if ($this->request->data['Collection']['collection_property'] == 'participant collection') {
                    $this->Structures->set('collections,col_copy_binding_opt');
                }
            }
            $this->request->data['Generated']['field1'] = (! empty($collectionData)) ? $collectionData['Participant']['participant_identifier'] : __('n/a');
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($needToSave) {
            
            // Manage Copy
            
            $copySrcData = null;
            if ($copySource) {
                $copySrcData = $this->Collection->getOrRedirect($copySource);
            }
            
            $copyLinksOption = isset($this->request->data['FunctionManagement']['col_copy_binding_opt']) ? (int) $this->request->data['FunctionManagement']['col_copy_binding_opt'] : 0;
            if ($copySource) {
                if ($copyLinksOption > 0 && $this->request->data['Collection']['collection_property'] == 'independent collection') {
                    AppController::addWarningMsg(__('links were not copied since the destination is an independant collection'));
                } elseif ($copyLinksOption > 1) {
                    $classicCclInsert = false;
                    $this->request->data['Collection']['participant_id'] = $copySrcData['Collection']['participant_id'];
                    $this->Collection->addWritableField('participant_id');
                    if ($copyLinksOption == 6) {
                        $this->Collection->addWritableField(array(
                            'consent_master_id',
                            'diagnosis_master_id',
                            'treatment_master_id',
                            'event_master_id'
                        ));
                        $this->request->data['Collection'] = array_merge($this->request->data['Collection'], array(
                            'consent_master_id' => $copySrcData['Collection']['consent_master_id'],
                            'diagnosis_master_id' => $copySrcData['Collection']['diagnosis_master_id'],
                            'treatment_master_id' => $copySrcData['Collection']['treatment_master_id'],
                            'event_master_id' => $copySrcData['Collection']['event_master_id']
                        ));
                    }
                }
            }
            
            $this->request->data['Collection']['deleted'] = 0;
            $this->Collection->addWritableField('deleted');
            
            // LAUNCH SAVE PROCESS
            $submittedDataValidates = true;
            
            // HOOK AND VALIDATION
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // SAVE
                if ($collectionData) {
                    $this->Collection->id = $collectionId;
                } else {
                    $this->Collection->id = 0;
                    $this->Collection->data = null;
                }
                
                if ($this->Collection->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $collectionId = $collectionId ?: $this->Collection->getLastInsertId();
                    $this->atimFlash(__('your data has been saved'), '/InventoryManagement/Collections/detail/' . $collectionId);
                }
            }
        }
    }

    /**
     * @param $collectionId
     */
    public function edit($collectionId)
    {
        $this->Collection->unbindModel(array(
            'hasMany' => array(
                'SampleMaster'
            )
        ));
        $collectionData = $this->Collection->getOrRedirect($collectionId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Collection.id' => $collectionId
        ));
        
        if ($collectionData['Collection']['participant_id']) {
            // Linked collection: Set specific structure
            $this->Structures->set('linked_collections');
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $collectionData;
        } else {
            
            $submittedDataValidates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // 4- SAVE
                $this->Collection->id = $collectionId;
                $this->Collection->data = array();
                if ($this->Collection->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/InventoryManagement/Collections/detail/' . $collectionId);
                }
            }
        }
    }

    /**
     * @param $collectionId
     */
    public function delete($collectionId)
    {
        // Get collection data
        $collectionData = $this->Collection->getOrRedirect($collectionId);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->Collection->allowDeletion($collectionId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // Delete collection
            if ($this->Collection->atimDelete($collectionId, true)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/InventoryManagement/Collections/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/InventoryManagement/Collections/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/InventoryManagement/Collections/detail/' . $collectionId);
        }
    }

    /**
     * @param $collectionId
     * @param $templateId
     */
    public function template($collectionId, $templateId)
    {
        $this->set('atimMenuVariables', array(
            'Collection.id' => $collectionId
        ));
        $templateModel = AppModel::getInstance("Tools", "Template", true);
        $templateModel->id = $templateId;
        $template = $templateModel->read();
        $tree = $templateModel->init();
        $this->set('treeData', $tree['']);
        
        $sampleControls = $this->SampleControl->find('all');
        $sampleControls = AppController::defineArrayKey($sampleControls, 'SampleControl', 'id', true);
        AppController::applyTranslation($sampleControls, 'SampleControl', 'sample_type');
        
        $aliquotControlModel = AppModel::getInstance('InventoryManagement', 'AliquotControl', true);
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
        $aliquotControls = AppController::defineArrayKey($aliquotControls, 'AliquotControl', 'id', true);
        AppController::applyTranslation($aliquotControls, 'AliquotControl', 'aliquot_type');
        
        $parentToDerivativeSampleControlModel = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
        $samplesRelations = $parentToDerivativeSampleControlModel->find('all', array(
            'conditions' => array(
                'flag_active' => 1
            ),
            'recusrive' => - 1
        ));
        foreach ($samplesRelations as &$sampleRelation) {
            unset($sampleRelation['ParentSampleControl']);
            unset($sampleRelation['DerivativeControl']);
        }
        unset($sampleRelation);
        $samplesRelations = AppController::defineArrayKey($samplesRelations, 'ParentToDerivativeSampleControl', 'parent_sample_control_id');
        
        $templateNodeModel = AppModel::getInstance("Tools", "TemplateNode", true);
        $jsData = array(
            'sample_controls' => $sampleControls,
            'samples_relations' => $samplesRelations,
            'aliquot_controls' => AppController::defineArrayKey($aliquotControls, 'AliquotControl', 'id', true),
            'aliquot_relations' => AppController::defineArrayKey($aliquotControls, "AliquotControl", "sample_control_id"),
            'fomated_nodes_default_values' => $templateNodeModel->formatTemplateNodeDefaultValuesForDisplay($templateId)
        );
        
        $this->set('jsData', $jsData);
        $this->set('templateId', empty($template) ? null : $template['Template']['id']);
        $this->set('controls', 0);
        $this->set('collectionId', $collectionId);
        $this->set('flagSystem', empty($template) ? null : $template['Template']['flag_system']);
        $this->set('structureHeader', array(
            'title' => __('samples and aliquots creation from template'),
            'description' => empty($template) ? null : __('collection template') . ': ' . __($template['Template']['name'])
        ));
        $this->Structures->set('template');
        $this->request->data = empty($template) ? null : $template;
        $this->render('/../../Tools/View/Template/tree');
    }

    /**
     * @param $collectionId
     * @param $templateId
     */
    public function templateInit($collectionId, $templateId)
    {
        $template = null;
        if ($templateId != 0) {
            $templateModel = AppModel::getInstance("Tools", "Template", true);
            $template = $templateModel->findById($templateId);
            $templateModel->init($templateId);
        }
        $this->set('template', $template);
        $this->set('templateId', $templateId);
        
        $this->TemplateInit = AppModel::getInstance('InventoryManagement', 'TemplateInit');
        $toBeginMsg = true; // can be overriden in hooks
        $this->Structures->set('template_init_structure', 'template_init_structure');
        
        $this->set('collectionId', $collectionId);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $templateInitId = null;
        if (empty($this->request->data)) {
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // validate and stuff
            $dataValidates = true;
            
            if (isset($this->request->data['template_init_id'])) {
                $templateInitId = $this->request->data['template_init_id'];
            }
            
            $this->TemplateInit->set($this->request->data);
            if (! $this->TemplateInit->validates()) {
                $dataValidates = false;
            } else {
                $this->request->data = $this->TemplateInit->data['TemplateInit'];
            }
            
            // hook
            $hookLink = $this->hook('validate_and_set');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($dataValidates && $templateInitId) {
                $this->Session->write('Template.init_data.' . $templateInitId, $this->request->data);
                $this->set('goToNext', true);
            }
        }
        
        if ($templateInitId == null) {
            if ($templateInitId = $this->Session->read('Template.init_id')) {
                ++ $templateInitId;
            } else {
                $templateInitId = 1;
            }
            $this->Session->write('Template.init_id', $templateInitId);
        }
        $this->set('templateInitId', $templateInitId);
        
        if ($toBeginMsg) {
            AppController::addInfoMsg(__('to begin, click submit'));
        }
    }
}