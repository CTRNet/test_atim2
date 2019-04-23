<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class AliquotMastersController
 */
class AliquotMastersController extends InventoryManagementAppController
{

    public $components = array();

    public $uses = array(
        'InventoryManagement.Collection',
        
        'InventoryManagement.SampleMaster',
        'InventoryManagement.ViewSample',
        'InventoryManagement.DerivativeDetail',
        
        'InventoryManagement.SampleControl',
        
        'InventoryManagement.AliquotControl',
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.AliquotMastersRev',
        'InventoryManagement.ViewAliquot',
        'InventoryManagement.AliquotDetail',
        
        'InventoryManagement.RealiquotingControl',
        
        'InventoryManagement.ViewAliquotUse',
        'InventoryManagement.AliquotInternalUse',
        'InventoryManagement.Realiquoting',
        'InventoryManagement.SourceAliquot',
        'InventoryManagement.AliquotReviewMaster',
        'Order.OrderItem',
        
        'StorageLayout.StorageMaster',
        'StorageLayout.StorageCoordinate',
        
        'Study.StudySummary',
        
        'ExternalLink'
    );

    public $paginate = array(
        'AliquotMaster' => array(
            'order' => 'AliquotMaster.barcode DESC'
        ),
        'ViewAliquot' => array(
            'order' => 'ViewAliquot.barcode DESC'
        )
    );

    /*
     * --------------------------------------------------------------------------
     * DISPLAY FUNCTIONS
     * --------------------------------------------------------------------------
     */
    
    /* ----------------------------- ALIQUOT MASTER ----------------------------- */
    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/Collections/search'));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->ViewAliquot, 'view_aliquot_joined_to_sample_and_collection', '/InventoryManagement/AliquotMasters/search');
        
        $helpUrl = $this->ExternalLink->find('first', array(
            'conditions' => array(
                'name' => 'inventory_elements_defintions'
            )
        ));
        $this->set("helpUrl", $helpUrl['ExternalLink']['link']);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }

    public function addInit()
    {
        $urlToCancel = 'javascript:history.go(-1)';
        
        // Get Data
        $model = null;
        $key = null;
        if (isset($this->request->data['BatchSet']) || isset($this->request->data['node'])) {
            if (isset($this->request->data['SampleMaster'])) {
                $model = 'SampleMaster';
                $key = 'id';
            } elseif (isset($this->request->data['ViewSample'])) {
                $model = 'ViewSample';
                $key = 'sample_master_id';
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            if (isset($this->request->data['node']) && $this->request->data[$model][$key] == 'all') {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data[$model][$key] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        
        // Set url to redirect
        if (isset($this->request->data['BatchSet']['id'])) {
            $urlToCancel = '/Datamart/BatchSets/listall/' . $this->request->data['BatchSet']['id'];
        } elseif (isset($this->request->data['node']['id'])) {
            $urlToCancel = '/Datamart/Browser/browse/' . $this->request->data['node']['id'];
        }
        $this->set('urlToCancel', $urlToCancel);
        
        // Manage data
        
        $initData = $this->batchInit($this->SampleMaster, $model, $key, 'sample_control_id', $this->AliquotControl, 'sample_control_id', 'you cannot create aliquots with this sample type');
        if (array_key_exists('error', $initData)) {
            $this->atimFlashWarning(__($initData['error']), $urlToCancel);
            return;
        }
        
        // Manage structure and menus
        $this->AliquotMaster; // lazy load
        $defaultAliquotControlId = null;
        foreach ($initData['possibilities'] as $possibility) {
            AliquotMaster::$aliquotTypeDropdown[$possibility['AliquotControl']['id']] = __($possibility['AliquotControl']['aliquot_type']);
            $defaultAliquotControlId = $possibility['AliquotControl']['id'];
        }
        $this->set('defaultAliquotControlId', $defaultAliquotControlId);
        
        $this->set('ids', $initData['ids']);
        
        $this->Structures->set('aliquot_type_selection,aliquot_nb_definition');
        $this->setBatchMenu(array(
            'SampleMaster' => $initData['ids']
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $sampleMasterId
     * @param null $aliquotControlId
     * @param int $quantity
     */
    public function add($sampleMasterId = null, $aliquotControlId = null, $quantity = 1)
    {
        if ($this->request->is('ajax')) {
            $this->layout = 'ajax';
            ob_start();
        }
        
        $urlToCancel = isset($this->request->data['url_to_cancel']) ? $this->request->data['url_to_cancel'] : 'javascript:history.go(-1)';
        unset($this->request->data['url_to_cancel']);
        
        // CHECK PARAMETERS
        if (! empty($sampleMasterId) && ! empty($aliquotControlId)) {
            // User just click on add aliquot button from sample detail form
            $this->request->data = array();
            $this->request->data[0]['ids'] = $sampleMasterId;
            $this->request->data[0]['realiquot_into'] = $aliquotControlId;
        } elseif (empty($this->request->data)) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        
        $isIntialDisplay = isset($this->request->data[0]['ids']) ? true : false;
        $isBatchProcess = empty($sampleMasterId);
        $this->set('isBatchProcess', $isBatchProcess);
        
        // GET ALIQUOT CONTROL DATA
        
        if ($this->request->data[0]['realiquot_into'] == "") {
            $this->atimFlashWarning(__('you need to select an aliquot type'), $urlToCancel);
            return;
        }
        
        $aliquotControl = $this->AliquotControl->findById($this->request->data[0]['realiquot_into']);
        if (empty($aliquotControl)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('aliquotControlId', $aliquotControl['AliquotControl']['id']);
        
        // GET DEFAULT VALUES
        
        $templateInitId = null;
        if (isset($this->request->data['template_init_id'])) {
            $templateInitId = $this->request->data['template_init_id'];
            unset($this->request->data['template_init_id']);
        }
        
        // Set default field values defined into the collection template
        if (isset(AppController::getInstance()->passedArgs['nodeIdWithDefaultValues'])) {
            $templateNodeModel = AppModel::getInstance("Tools", "TemplateNode", true);
            $templateNode = $templateNodeModel->find('first', array(
                'conditions' => array(
                    'TemplateNode.id' => AppController::getInstance()->passedArgs['nodeIdWithDefaultValues']
                )
            ));
            $templateNodeDefaultValues = array();
            foreach (json_decode($templateNode['TemplateNode']['default_values'], true) as $model => $fieldsValues) {
                foreach ($fieldsValues as $field => $Value) {
                    if (is_array($Value)) {
                        $tmpDateTimeArray = array(
                            'year' => '',
                            'month' => '',
                            'day' => '',
                            'hour' => '',
                            'min' => '',
                            'sec' => ''
                        );
                        $tmpDateTimeArray = array_merge($tmpDateTimeArray, $Value);
                        $templateNodeDefaultValues["$model.$field"] = sprintf("%s-%s-%s %s:%s:%s", $tmpDateTimeArray['year'], $tmpDateTimeArray['month'], $tmpDateTimeArray['day'], $tmpDateTimeArray['hour'], $tmpDateTimeArray['min'], $tmpDateTimeArray['sec']);
                    } else {
                        $templateNodeDefaultValues["$model.$field"] = $Value;
                    }
                }
            }
            $this->set('templateNodeDefaultValues', $templateNodeDefaultValues);
        }
        
        // GET SAMPLES DATA
        
        $sampleMasterIds = array();
        if ($isIntialDisplay) {
            $sampleMasterIds = explode(",", $this->request->data[0]['ids']);
            $quantity = isset($this->request->data[0]['aliquots_nbr_per_parent']) ? $this->request->data[0]['aliquots_nbr_per_parent'] : $quantity;
            unset($this->request->data[0]);
        } else {
            unset($this->request->data[0]);
            if (! empty($this->request->data)) {
                $sampleMasterIds = array_keys($this->request->data);
            } else {
                // User don't work in batch mode and deleted all aliquot rows
                if (empty($sampleMasterId)) {
                    $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
                    return;
                }
                $sampleMasterIds = array(
                    $sampleMasterId
                );
            }
        }
        $samples = $this->ViewSample->find('all', array(
            'conditions' => array(
                'sample_master_id' => $sampleMasterIds
            ),
            'recursive' => - 1
        ));
        $displayLimit = Configure::read('AliquotCreation_processed_items_limit');
        if (sizeof($samples) > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        $this->ViewSample->sortForDisplay($samples, $sampleMasterIds);
        $samplesFromId = array();
        
        $isSpecimen = (strcmp($samples[0]['ViewSample']['sample_category'], 'specimen') == 0) ? true : false;
        
        // Sample checks
        if (sizeof($samples) != sizeof($sampleMasterIds)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $sampleControlId = null;
        foreach ($samples as $sampleMasterData) {
            if (is_null($sampleControlId)) {
                $sampleControlId = $sampleMasterData['ViewSample']['sample_control_id'];
            } else {
                if ($sampleMasterData['ViewSample']['sample_control_id'] != $sampleControlId)
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $samplesFromId[$sampleMasterData['ViewSample']['sample_master_id']] = $sampleMasterData;
        }
        
        $criteria = array(
            'AliquotControl.sample_control_id' => $sampleControlId,
            'AliquotControl.flag_active' => '1',
            'AliquotControl.id' => $aliquotControl['AliquotControl']['id']
        );
        if (! $this->AliquotControl->find('count', array(
            'conditions' => $criteria
        ))) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('sampleMasterId', $sampleMasterId);
        
        // Set menu
        $atimMenuLink = '/InventoryManagement/';
        if ($isBatchProcess) {
            $this->setBatchMenu(array(
                'SampleMaster' => $sampleMasterIds
            ));
        } else {
            $atimMenuLink = '/InventoryManagement/SampleMasters/detail/%%Collection.id%%/' . ($isSpecimen ? '%%SampleMaster.initial_specimen_sample_id%%' : '%%SampleMaster.id%%');
            $this->set('atimMenu', $this->Menus->get($atimMenuLink));
            $this->set('atimMenuVariables', array(
                'Collection.id' => $samples[0]['ViewSample']['collection_id'],
                'SampleMaster.id' => $sampleMasterId,
                'SampleMaster.initial_specimen_sample_id' => $samples[0]['ViewSample']['initial_specimen_sample_id']
            ));
        }
        
        // set structure
        $this->Structures->set($aliquotControl['AliquotControl']['form_alias'], 'atim_structure', array(
            'model_table_assoc' => array(
                'AliquotDetail' => $aliquotControl['AliquotControl']['detail_tablename']
            )
        ));
        if ($isBatchProcess) {
            $this->Structures->set('view_sample_joined_to_collection', 'sample_info');
        }
        $this->Structures->set('empty', 'emptyStructure');
        
        // set data for initial data to allow bank to override data
        $structureOverride = array(
            'AliquotControl.aliquot_type' => $aliquotControl['AliquotControl']['aliquot_type'],
            'AliquotMaster.in_stock' => 'yes - available'
        );
        list ($structureOverride['AliquotMaster.storage_datetime'], $structureOverride['AliquotMaster.storage_datetime_accuracy']) = $isBatchProcess ? array(
            date('Y-m-d G:i'),
            'c'
        ) : $this->AliquotMaster->getDefaultStorageDateAndAccuracy($this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.id' => $sampleMasterId
            )
        )));
        if (! empty($aliquotControl['AliquotControl']['volume_unit'])) {
            $structureOverride['AliquotControl.volume_unit'] = $aliquotControl['AliquotControl']['volume_unit'];
        }
        $this->set('structureOverride', $structureOverride);
        
        // Set url to cancel
        if (! empty($aliquotControlId)) {
            // User just click on add aliquot button from sample detail form
            $urlToCancel = '/InventoryManagement/SampleMasters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sampleMasterId;
        }
        $this->set('urlToCancel', $urlToCancel);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($isIntialDisplay) {
            
            // 1- INITIAL DISPLAY
            $this->request->data = array();
            foreach ($samples as $sample) {
                $this->request->data[] = array(
                    'parent' => $sample,
                    'children' => array_fill(0, $quantity, array())
                );
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // 2- VALIDATE PROCESS
            $errors = array();
            $prevData = $this->request->data;
            if (empty($prevData)) {
                $this->atimFlashWarning(__("at least one data has to be created"), "javascript:history.back();");
                return;
            }
            $this->request->data = array();
            $recordCounter = 0;
            foreach ($prevData as $sampleMasterId => $createdAliquots) {
                $recordCounter ++;
                
                unset($createdAliquots['ViewSample']);
                if (! isset($samplesFromId[$sampleMasterId]))
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $sampleMasterData = $samplesFromId[$sampleMasterId];
                
                $newAliquotCreated = false;
                $lineCounter = 0;
                foreach ($createdAliquots as $key => $aliquot) {
                    $lineCounter ++;
                    $newAliquotCreated = true;
                    
                    // Set AliquotMaster.initial_volume
                    if (array_key_exists('initial_volume', $aliquot['AliquotMaster'])) {
                        if (empty($aliquotControl['AliquotControl']['volume_unit'])) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        $aliquot['AliquotMaster']['current_volume'] = $aliquot['AliquotMaster']['initial_volume'];
                    }
                    
                    // Validate and update position data
                    $aliquot['AliquotMaster']['aliquot_control_id'] = $aliquotControl['AliquotControl']['id'];
                    
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->set($aliquot);
                    if (! $this->AliquotMaster->validates()) {
                        foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errors[$field][$msg][] = ($isBatchProcess ? $recordCounter : $lineCounter);
                        }
                    }
                    
                    // Reset data to get position data
                    $createdAliquots[$key] = $this->AliquotMaster->data;
                }
                $this->request->data[] = array(
                    'parent' => $sampleMasterData,
                    'children' => $createdAliquots
                ); // prep data in case validation fails
                if (! $newAliquotCreated) {
                    $errors[]['at least one aliquot has to be created'][] = ($isBatchProcess ? $recordCounter : '');
                }
            }
            
            if (empty($this->request->data)) {
                $errors[]['at least one aliquot has to be created'][] = '';
                $this->request->data[] = array(
                    'parent' => $samples[0],
                    'children' => array()
                );
            }
            
            $this->AliquotMaster->addWritableField(array(
                'collection_id',
                'sample_control_id',
                'sample_master_id',
                'aliquot_control_id',
                'storage_master_id',
                'current_volume',
                'study_summary_id'
            ));
            $this->AliquotMaster->addWritableField(array(
                'aliquot_master_id'
            ), $aliquotControl['AliquotControl']['detail_tablename']);
            $this->AliquotMaster->writableFieldsMode = 'addgrid';
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // 3- SAVE PROCESS
            
            if (empty($errors)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // save
                $batchIds = array();
                foreach ($this->request->data as $createdAliquots) {
                    foreach ($createdAliquots['children'] as $newAliquot) {
                        $this->AliquotMaster->id = null;
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        unset($newAliquot['AliquotMaster']['id']);
                        $newAliquot['AliquotMaster']['collection_id'] = $createdAliquots['parent']['ViewSample']['collection_id'];
                        $newAliquot['AliquotMaster']['sample_master_id'] = $createdAliquots['parent']['ViewSample']['sample_master_id'];
                        if (! $this->AliquotMaster->save($newAliquot, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        
                        $batchIds[] = $this->AliquotMaster->getLastInsertId();
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if ($isBatchProcess) {
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquot'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                } else {
                    if ($this->request->is('ajax')) {
                        ob_end_clean();
                        echo json_encode(array(
                            'goToNext' => true,
                            'display' => '',
                            'id' => - 1
                        ));
                        exit();
                    } else {
                        $this->atimFlash(__('your data has been saved'), '/InventoryManagement/SampleMasters/detail/' . $samples[0]['ViewSample']['collection_id'] . '/' . $sampleMasterId);
                    }
                }
            } else {
                $this->AliquotMaster->validationErrors = array();
                $this->AliquotDetail->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $msg = __($msg);
                        $linesStrg = implode(",", array_unique($lines));
                        if (! empty($linesStrg)) {
                            $pattern = $isBatchProcess ? 'see # %s' : 'see line %s';
                            $msg .= ' - ' . str_replace('%s', $linesStrg, __($pattern));
                        }
                        $this->AliquotMaster->validationErrors[$field][] = $msg;
                    }
                }
            }
        }
        $this->set('isAjax', $this->request->is('ajax'));
    }

    /**
     *
     * @param unknown_type $collectionId
     * @param unknown_type $sampleMasterId
     * @param unknown_type $aliquotMasterId
     * @param int|unknown_type $isFromTreeViewOrLayout 0-Normal, 1-Tree view, 2-Stoarge layout
     */
    public function detail($collectionId, $sampleMasterId, $aliquotMasterId, $isFromTreeViewOrLayout = 0)
    {
        if ($isFromTreeViewOrLayout) {
            Configure::write('debug', 0);
        }
        // MANAGE DATA
        
        // Get the aliquot data
        $joins = array(
            array(
                'table' => 'specimen_details',
                'alias' => 'SpecimenDetail',
                'type' => 'LEFT',
                'conditions' => array(
                    'SpecimenDetail.sample_master_id = AliquotMaster.sample_master_id'
                )
            ),
            array(
                'table' => 'derivative_details',
                'alias' => 'DerivativeDetail',
                'type' => 'LEFT',
                'conditions' => array(
                    'DerivativeDetail.sample_master_id = AliquotMaster.sample_master_id'
                )
            )
        );
        $condtions = array(
            'AliquotMaster.collection_id' => $collectionId,
            'AliquotMaster.sample_master_id' => $sampleMasterId,
            'AliquotMaster.id' => $aliquotMasterId
        );
        $aliquotData = $this->AliquotMaster->find('first', array(
            'conditions' => $condtions,
            'joins' => $joins
        ));
        if (empty($aliquotData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Set aliquot data
        $this->set('aliquotMasterData', $aliquotData);
        $this->request->data = array();
        
        // Set storage data
        $this->set('aliquotStorageData', empty($aliquotData['StorageMaster']['id']) ? array() : array(
            'StorageMaster' => $aliquotData['StorageMaster']
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object.
        $atimMenuLink = ($aliquotData['SampleControl']['sample_category'] == 'specimen') ? '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' : '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
        $this->set('atimMenu', $this->Menus->get($atimMenuLink));
        $this->set('atimMenuVariables', array(
            'Collection.id' => $collectionId,
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $aliquotData['SampleMaster']['initial_specimen_sample_id'],
            'AliquotMaster.id' => $aliquotMasterId
        ));
        
        // Set structure
        $this->Structures->set($aliquotData['AliquotControl']['form_alias']);
        $this->Structures->set('empty', 'emptyStructure');
        
        // Define if this detail form is displayed into the collection content tree view, storage tree view, storage layout
        $this->set('isFromTreeViewOrLayout', $isFromTreeViewOrLayout);
        
        // Define if aliquot is included into an order
        $orderItem = $this->OrderItem->find('first', array(
            'conditions' => array(
                'OrderItem.aliquot_master_id' => $aliquotMasterId
            )
        ));
        if (! empty($orderItem)) {
            $this->set('orderLineId', $orderItem['OrderItem']['order_line_id']);
            $this->set('orderId', $orderItem['OrderItem']['order_id']);
        }
        
        $sampleMaster = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        $ptdscModel = AppModel::getInstance('InventoryManagement', 'ParentToDerivativeSampleControl', true);
        $ptdsc = $ptdscModel->find('first', array(
            'conditions' => array(
                'ParentToDerivativeSampleControl.parent_sample_control_id' => $sampleMaster['SampleMaster']['sample_control_id']
            ),
            'recursive' => - 1
        ));
        $this->set('canCreateDerivative', ! empty($ptdsc));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function edit($collectionId, $sampleMasterId, $aliquotMasterId)
    {
        // MANAGE DATA
        
        // Get the aliquot data
        $aliquotData = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $collectionId,
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                'AliquotMaster.id' => $aliquotMasterId
            )
        ));
        if (empty($aliquotData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object.
        $this->setAliquotMenu($aliquotData);
        
        // Set structure
        $this->Structures->set($aliquotData['AliquotControl']['form_alias'], 'atim_structure', array(
            'model_table_assoc' => array(
                'AliquotDetail' => $aliquotData['AliquotControl']['detail_tablename']
            )
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA RECORD
        
        if (empty($this->request->data)) {
            $aliquotData['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array(
                'StorageMaster' => $aliquotData['StorageMaster']
            ));
            $aliquotData['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $aliquotData['AliquotMaster']['study_summary_id']
                )
            ));
            $this->request->data = $aliquotData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Update data
            if (array_key_exists('initial_volume', $this->request->data['AliquotMaster']) && empty($aliquotData['AliquotControl']['volume_unit'])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Launch validations
            
            $submittedDataValidates = true;
            
            // -> Fields validation
            // --> AliquotMaster
            $this->request->data['AliquotMaster']['id'] = $aliquotMasterId;
            $this->request->data['AliquotMaster']['aliquot_control_id'] = $aliquotData['AliquotMaster']['aliquot_control_id'];
            
            $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
            $this->AliquotMaster->set($this->request->data);
            $this->AliquotMaster->id = $aliquotMasterId;
            $submittedDataValidates = ($this->AliquotMaster->validates()) ? $submittedDataValidates : false;
            $this->request->data = $this->AliquotMaster->data;
            
            // Reste data to get position data
            $this->request->data = $this->AliquotMaster->data;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // Save data
            if ($submittedDataValidates) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->AliquotMaster->id = $aliquotMasterId;
                $this->AliquotMaster->addWritableField(array(
                    'storage_master_id',
                    'study_summary_id'
                ));
                
                if (! $this->AliquotMaster->save($this->request->data, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if (! $this->AliquotMaster->updateAliquotVolume($aliquotMasterId)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $this->atimFlash(__('your data has been updated'), '/InventoryManagement/AliquotMasters/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $aliquotMasterId);
                return;
            }
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function removeAliquotFromStorage($collectionId, $sampleMasterId, $aliquotMasterId)
    {
        if ((! $collectionId) || (! $sampleMasterId) || (! $aliquotMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the aliquot data
        $aliquotData = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $collectionId,
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                'AliquotMaster.id' => $aliquotMasterId
            )
        ));
        if (empty($aliquotData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Delete storage data
        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
        $this->AliquotMaster->id = $aliquotMasterId;
        $aliquotDataToSave = array(
            'AliquotMaster' => array(
                'storage_master_id' => null,
                'storage_coord_x' => '',
                'storage_coord_y' => ''
            )
        );
        $this->AliquotMaster->addWritableField(array(
            'storage_master_id',
            'storage_coord_x',
            'storage_coord_y'
        ));
        if (! $this->AliquotMaster->save($aliquotDataToSave, false)) {
            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->atimFlash(__('your data has been updated'), '/InventoryManagement/AliquotMasters/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $aliquotMasterId);
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function delete($collectionId, $sampleMasterId, $aliquotMasterId)
    {
        if ((! $collectionId) || (! $sampleMasterId) || (! $aliquotMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get the aliquot data
        $aliquotData = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $collectionId,
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                'AliquotMaster.id' => $aliquotMasterId
            )
        ));
        if (empty($aliquotData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->AliquotMaster->allowDeletion($aliquotMasterId);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->AliquotMaster->atimDelete($aliquotMasterId)) {
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been deleted'), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/InventoryManagement/AliquotMasters/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $aliquotMasterId);
        }
    }

    /* ------------------------------ ALIQUOT INTERNAL USES ------------------------------ */
    /**
     *
     * @param null $aliquotMasterId
     */
    public function addAliquotInternalUse($aliquotMasterId = null)
    {
        // GET DATA
        $submitedRequestDataEmpty = empty($this->request->data);
        
        $initialDisplay = false;
        $aliquotIds = array();
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if ($aliquotMasterId != null) {
            // User is workning on a collection
            $aliquotIds = array(
                $aliquotMasterId
            );
            if (empty($this->request->data) && $submitedRequestDataEmpty)
                $initialDisplay = true;
        } elseif (isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
            if ($this->request->data['ViewAliquot']['aliquot_master_id'] == 'all' && isset($this->request->data['node'])) {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $aliquotIds = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
            $initialDisplay = true;
        } else {
            // Remove 'FunctionManagement' and 'AliquotMaster' to get aliquot master ids
            $tmpData = $this->request->data;
            unset($tmpData['FunctionManagement']);
            unset($tmpData['AliquotMaster']);
            $aliquotIds = array_keys($tmpData);
        }
        
        $aliquotData = $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.id' => $aliquotIds
            )
        ));
        $displayLimit = Configure::read('AliquotInternalUseCreation_processed_items_limit');
        if (empty($aliquotData)) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        } elseif (sizeof($aliquotData) > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        $this->AliquotMaster->sortForDisplay($aliquotData, $aliquotIds);
        
        // SET MENU AND STRUCTURE DATA
        
        $atimMenuLink = '/InventoryManagement/';
        if ($aliquotMasterId != null) {
            // User is working on a collection
            $atimMenuLink = ($aliquotData[0]['SampleControl']['sample_category'] == 'specimen') ? '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' : '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
            $this->set('atimMenuVariables', array(
                'Collection.id' => $aliquotData[0]['AliquotMaster']['collection_id'],
                'SampleMaster.id' => $aliquotData[0]['AliquotMaster']['sample_master_id'],
                'SampleMaster.initial_specimen_sample_id' => $aliquotData[0]['SampleMaster']['initial_specimen_sample_id'],
                'AliquotMaster.id' => $aliquotData[0]['AliquotMaster']['id']
            ));
            $urlToCancel = '/InventoryManagement/AliquotMasters/detail/' . $aliquotData[0]['AliquotMaster']['collection_id'] . '/' . $aliquotData[0]['AliquotMaster']['sample_master_id'] . '/' . $aliquotData[0]['AliquotMaster']['id'] . '/';
        } else {
            
            $unconsentedAliquots = $this->AliquotMaster->getUnconsentedAliquots(array(
                'id' => $aliquotIds
            ));
            if (! empty($unconsentedAliquots)) {
                AppController::addWarningMsg(__('aliquot(s) without a proper consent') . ": " . count($unconsentedAliquots));
            }
        }
        
        $this->set('atimMenu', $this->Menus->get($atimMenuLink));
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('aliquotMasterId', $aliquotMasterId);
        
        $this->Structures->set('used_aliq_in_stock_details', "aliquots_structure");
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
        $this->set('displayBatchProcessAliqStorageAndInStockDetails', (sizeof(array_filter($aliquotIds)) > 1));
        $this->Structures->set('batch_process_aliq_storage_and_in_stock_details', 'batch_process_aliq_storage_and_in_stock_details');
        $this->Structures->set('aliquotinternaluses', 'aliquotinternaluses_structure');
        $this->Structures->set('aliquotinternaluses_volume,aliquotinternaluses', 'aliquotinternaluses_volume_structure');
        
        // MANAGE DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            // Force $this->request->data to empty array() to override AliquotMaster.aliquot_volume_unit
            $this->request->data = array();
            
            foreach ($aliquotData as $aliquotDataUnit) {
                $this->request->data[] = array(
                    'parent' => $aliquotDataUnit,
                    'children' => array()
                );
            }
        } else {
            // Parse First Section To Apply To All
            list ($usedAliquotDataToApplyToAll, $errorsOnFirstSectionToApplyToAll) = $this->AliquotMaster->getAliquotDataStorageAndStockToApplyToAll($this->request->data);
            
            unset($this->request->data['FunctionManagement']);
            unset($this->request->data['AliquotMaster']);
            
            $previousData = $this->request->data;
            $this->request->data = array();
            
            if (empty($previousData)) {
                $this->atimFlashWarning(__("at least one data has to be created"), "javascript:history.back();");
                return;
            }
            
            if ($usedAliquotDataToApplyToAll) {
                AppController::addWarningMsg(__('fields values of the first section have been applied to all other sections'));
            }
            
            // validate
            $errors = $errorsOnFirstSectionToApplyToAll;
            $aliquotDataToSave = array();
            $usesToSave = array();
            $line = 0;
            
            $sortedAliquotData = array();
            foreach ($aliquotData as $key => $data) {
                $sortedAliquotData[$data['AliquotMaster']['id']] = $data;
            }
            
            $recordCounter = 0;
            foreach ($previousData as $keyAliquotMasterId => $dataUnit) {
                $recordCounter ++;
                
                if ($usedAliquotDataToApplyToAll)
                    $dataUnit = array_replace_recursive($dataUnit, $usedAliquotDataToApplyToAll);
                
                if (! array_key_exists($keyAliquotMasterId, $sortedAliquotData)) {
                    $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $aliquotData = $sortedAliquotData[$keyAliquotMasterId];
                
                $dataUnit['AliquotMaster']['id'] = $keyAliquotMasterId;
                $aliquotData['AliquotMaster'] = $dataUnit['AliquotMaster'];
                $this->AliquotMaster->data = null;
                unset($aliquotData['AliquotMaster']['storage_coord_x']);
                unset($aliquotData['AliquotMaster']['storage_coord_y']);
                $this->AliquotMaster->set($aliquotData);
                if (! $this->AliquotMaster->validates()) {
                    foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors[$field][$msg][$recordCounter] = $recordCounter;
                    }
                }
                $aliquotDataToSave[] = array(
                    'id' => $keyAliquotMasterId,
                    'aliquot_control_id' => $aliquotData['AliquotControl']['id'],
                    'in_stock' => $dataUnit['AliquotMaster']['in_stock'],
                    'in_stock_detail' => $dataUnit['AliquotMaster']['in_stock_detail'],
                    
                    'tmp_remove_from_storage' => $dataUnit['FunctionManagement']['remove_from_storage']
                );
                
                $parent = array(
                    'AliquotMaster' => $dataUnit['AliquotMaster'],
                    'StorageMaster' => $dataUnit['StorageMaster'],
                    'FunctionManagement' => $dataUnit['FunctionManagement'],
                    'AliquotControl' => isset($dataUnit['AliquotControl']) ? $dataUnit['AliquotControl'] : array()
                );
                
                unset($dataUnit['AliquotMaster']);
                unset($dataUnit['StorageMaster']);
                unset($dataUnit['FunctionManagement']);
                unset($dataUnit['AliquotControl']);
                
                if (empty($dataUnit)) {
                    $errors['']['you must define at least one use for each aliquot'][$recordCounter] = $recordCounter;
                }
                foreach ($dataUnit as &$useDataUnit) {
                    $useDataUnit['AliquotInternalUse']['aliquot_master_id'] = $keyAliquotMasterId;
                    $this->AliquotInternalUse->data = null;
                    $this->AliquotInternalUse->set($useDataUnit);
                    if (! $this->AliquotInternalUse->validates()) {
                        foreach ($this->AliquotInternalUse->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errors[$field][$msg][$recordCounter] = $recordCounter;
                        }
                    }
                    $useDataUnit = $this->AliquotInternalUse->data;
                }
                $usesToSave = array_merge($usesToSave, $dataUnit);
                $this->request->data[] = array(
                    'parent' => $parent,
                    'children' => $dataUnit
                );
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (empty($errors)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // saving
                $this->AliquotInternalUse->addWritableField(array(
                    'aliquot_master_id',
                    'study_summary_id'
                ));
                $this->AliquotInternalUse->writableFieldsMode = 'addgrid';
                $this->AliquotInternalUse->saveAll($usesToSave, array(
                    'validate' => false
                ));
                
                foreach ($aliquotDataToSave as $newAliquotToSave) {
                    if ($newAliquotToSave['tmp_remove_from_storage'] || ($newAliquotToSave['in_stock'] == 'no')) {
                        $newAliquotToSave += array(
                            'storage_master_id' => null,
                            'storage_coord_x' => '',
                            'storage_coord_y' => ''
                        );
                        $this->AliquotMaster->addWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    } else {
                        $this->AliquotMaster->removeWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    }
                    unset($newAliquotToSave['tmp_remove_from_storage']);
                    
                    $this->AliquotMaster->data = array();
                    $this->AliquotMaster->id = $newAliquotToSave['id'];
                    if (! $this->AliquotMaster->save($newAliquotToSave, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                foreach ($aliquotIds as $tmpAliquotMasterId) {
                    $this->AliquotMaster->updateAliquotVolume($tmpAliquotMasterId);
                }
                
                $hookLink = $this->hook('post_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if ($aliquotMasterId != null) {
                    $this->atimFlash(__('your data has been saved'), $urlToCancel);
                } else {
                    // batch
                    $lastId = $this->AliquotInternalUse->getLastInsertId();
                    $batchIds = range($lastId - count($usesToSave) + 1, $lastId);
                    foreach ($batchIds as &$batchId) {
                        // add the "6" suffix to work with the view
                        $batchId = $batchId . "6";
                    }
                    
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquotUse'),
                            'flag_tmp' => true
                        )
                    );
                    
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                }
            } else {
                $this->AliquotMaster->validationErrors = array();
                $this->AliquotInternalUse->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->AliquotMaster->validationErrors[$field][] = __($msg) . (($recordCounter != 1) ? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
                    }
                }
            }
        }
    }

    /**
     *
     * @param $aliquotMasterId
     * @param $aliquotUseId
     */
    public function detailAliquotInternalUse($aliquotMasterId, $aliquotUseId)
    {
        if ((! $aliquotMasterId) || (! $aliquotUseId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the use data
        
        $this->AliquotMaster; // lazy load
        $useData = $this->AliquotInternalUse->find('first', array(
            'fields' => array(
                '*'
            ),
            'conditions' => array(
                'AliquotInternalUse.aliquot_master_id' => $aliquotMasterId,
                'AliquotInternalUse.id' => $aliquotUseId
            ),
            'joins' => array(
                AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'),
                AliquotMaster::$joinAliquotControlOnDup
            )
        ));
        if (empty($useData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $useData;
        
        // Get Sample Data
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $useData['AliquotMaster']['collection_id'],
                'SampleMaster.id' => $useData['AliquotMaster']['sample_master_id']
            ),
            'recursive' => 0
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object.
        $atimMenuLink = ($sampleData['SampleControl']['sample_category'] == 'specimen') ? '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%' : '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
        $this->set('atimMenu', $this->Menus->get($atimMenuLink));
        $this->set('atimMenuVariables', array(
            'Collection.id' => $useData['AliquotMaster']['collection_id'],
            'SampleMaster.id' => $useData['AliquotMaster']['sample_master_id'],
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id'],
            'AliquotMaster.id' => $aliquotMasterId
        ));
        
        // Set structure
        $this->Structures->set(empty($useData['AliquotControl']['volume_unit']) ? 'aliquotinternaluses' : 'aliquotinternaluses,aliquotinternaluses_volume');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $aliquotMasterId
     * @param $aliquotUseId
     */
    public function editAliquotInternalUse($aliquotMasterId, $aliquotUseId)
    {
        if ((! $aliquotMasterId) || (! $aliquotUseId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the use data
        $this->AliquotMaster; // lazy load
        $useData = $this->AliquotInternalUse->find('first', array(
            'fields' => array(
                '*'
            ),
            'conditions' => array(
                'AliquotInternalUse.aliquot_master_id' => $aliquotMasterId,
                'AliquotInternalUse.id' => $aliquotUseId
            ),
            'joins' => array(
                AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'),
                AliquotMaster::$joinAliquotControlOnDup
            )
        ));
        if (empty($useData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get Sample Data
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $useData['AliquotMaster']['collection_id'],
                'SampleMaster.id' => $useData['AliquotMaster']['sample_master_id']
            ),
            'recursive' => 0
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object.
        $this->setAliquotMenu(array_merge($sampleData, $useData));
        
        // Set structure
        $this->Structures->set('aliquotinternaluses');
        $this->Structures->set(empty($useData['AliquotControl']['volume_unit']) ? 'aliquotinternaluses' : 'aliquotinternaluses,aliquotinternaluses_volume');
        
        $this->set('aliquotUseId', $aliquotUseId);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA RECORD
        
        if (empty($this->request->data)) {
            
            $useData['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $useData['AliquotInternalUse']['study_summary_id']
                )
            ));
            $this->request->data = $useData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Launch validations
            $submittedDataValidates = true;
            
            if ((! empty($this->request->data['AliquotInternalUse']['used_volume'])) && empty($useData['AliquotControl']['volume_unit'])) {
                // No volume has to be recored for this aliquot type
                $this->AliquotInternalUse->validationErrors['used_volume'][] = 'no volume has to be recorded for this aliquot type';
                $submittedDataValidates = false;
            } elseif (empty($this->request->data['AliquotInternalUse']['used_volume'])) {
                // Change '0' to null
                $this->request->data['AliquotInternalUse']['used_volume'] = null;
            }
            
            $this->AliquotInternalUse->addWritableField(array(
                'study_summary_id'
            ));
            $this->AliquotInternalUse->writableFieldsMode = 'addgrid';
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // if data VALIDATE, then save data
            if ($submittedDataValidates) {
                $this->AliquotInternalUse->id = $aliquotUseId;
                if ($this->AliquotInternalUse->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    if (! $this->AliquotMaster->updateAliquotVolume($aliquotMasterId)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $this->atimFlash(__('your data has been saved'), '/InventoryManagement/AliquotMasters/detailAliquotInternalUse/' . $aliquotMasterId . '/' . $aliquotUseId . '/');
                }
            }
        }
    }

    /**
     *
     * @param $aliquotMasterId
     * @param $aliquotUseId
     */
    public function deleteAliquotInternalUse($aliquotMasterId, $aliquotUseId)
    {
        if ((! $aliquotMasterId) || (! $aliquotUseId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the use data
        $useData = $this->AliquotInternalUse->find('first', array(
            'conditions' => array(
                'AliquotInternalUse.aliquot_master_id' => $aliquotMasterId,
                'AliquotInternalUse.id' => $aliquotUseId
            )
        ));
        if (empty($useData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $flashUrl = '/InventoryManagement/AliquotMasters/detail/' . $useData['AliquotMaster']['collection_id'] . '/' . $useData['AliquotMaster']['sample_master_id'] . '/' . $aliquotMasterId;
        
        // LAUNCH DELETION
        $deletionDone = true;
        
        // -> Delete use
        if ($deletionDone) {
            if (! $this->AliquotInternalUse->atimDelete($aliquotUseId)) {
                $deletionDone = false;
            }
        }
        
        // -> Delete use
        if ($deletionDone) {
            if (! $this->AliquotMaster->updateAliquotVolume($aliquotMasterId)) {
                $deletionDone = false;
            }
        }
        
        $hookLink = $this->hook('postsave_process');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($deletionDone) {
            $this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), $flashUrl);
        } else {
            $this->atimFlashError(__('error deleting data - contact administrator'), $flashUrl);
        }
    }

    public function addInternalUseToManyAliquots()
    {
        $initialDisplay = false;
        $aliquotIds = array();
        
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        // GET DATA
        
        if (isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
            if ($this->request->data['ViewAliquot']['aliquot_master_id'] == 'all' && isset($this->request->data['node'])) {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $aliquotIds = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
            $initialDisplay = true;
        } elseif (isset($this->request->data['aliquot_ids'])) {
            $aliquotIds = explode(',', $this->request->data['aliquot_ids']);
        }
        $this->set('aliquotIds', implode(',', $aliquotIds));
        
        $studiedAliquotNbrs = $this->AliquotMaster->find('count', array(
            'conditions' => array(
                'AliquotMaster.id' => $aliquotIds
            ),
            'recursive' => - 1
        ));
        
        $displayLimit = Configure::read('AliquotInternalUseCreation_processed_items_limit');
        if (! $studiedAliquotNbrs) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        } elseif ($studiedAliquotNbrs > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        
        $aliquotControlIds = array();
        foreach ($this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.id' => $aliquotIds
            ),
            'fields' => array(
                'DISTINCT AliquotMaster.aliquot_control_id'
            ),
            'recursive' => - 1
        )) as $newCtrl)
            $aliquotControlIds[] = $newCtrl['AliquotMaster']['aliquot_control_id'];
        $allVolumeUnits = $this->AliquotControl->find('all', array(
            'conditions' => array(
                'AliquotControl.id' => $aliquotControlIds
            ),
            'fields' => array(
                'DISTINCT AliquotControl.volume_unit'
            ),
            'recursive' => - 1
        ));
        $aliquotVolumeUnit = null;
        if (sizeof($allVolumeUnits) == 1) {
            if (! empty($allVolumeUnits[0]['AliquotControl']['volume_unit'])) {
                $aliquotVolumeUnit = $allVolumeUnits[0]['AliquotControl']['volume_unit'];
            }
        } else {
            AppController::addWarningMsg(__('aliquot(s) volume units are different - no used volume can be completed'));
        }
        $this->set('aliquotVolumeUnit', $aliquotVolumeUnit);
        
        $unconsentedAliquots = $this->AliquotMaster->getUnconsentedAliquots(array(
            'id' => $aliquotIds
        ));
        if (! empty($unconsentedAliquots)) {
            AppController::addWarningMsg(__('aliquot(s) without a proper consent') . ": " . count($unconsentedAliquots));
        }
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        
        $this->set('urlToCancel', $urlToCancel);
        
        $this->Structures->set(($aliquotVolumeUnit ? 'aliquotinternaluses_volume,' : '') . 'aliquotinternaluses,batch_process_aliq_storage_and_in_stock_details');
        
        // MANAGE DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            
            $this->request->data = array();
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $submittedDataValidates = true;
            
            // Validation : Internal Use
            
            $this->AliquotInternalUse->id = null;
            $this->AliquotInternalUse->data = null;
            $this->AliquotInternalUse->set($this->request->data);
            if (! $this->AliquotInternalUse->validates())
                $submittedDataValidates = false;
            $this->request->data['AliquotInternalUse'] = $this->AliquotInternalUse->data['AliquotInternalUse'];
            
            if (isset($this->request->data['AliquotInternalUse']['used_volume']) && strlen($this->request->data['AliquotInternalUse']['used_volume']) && empty($aliquotVolumeUnit)) {
                $this->SourceAliquot->validationErrors['use'][] = 'no used volume can be recorded';
                $submittedDataValidates = false;
            }
            
            // Validation : AliquotMaster
            
            list ($aliquotMasterDataToUpdate, $validates, $positionDeletionWarningMessage) = $this->AliquotMaster->validateAliquotMasterDataUpdateInBatch($this->request->data['FunctionManagement'], $this->request->data['AliquotMaster'], $aliquotIds);
            if (! $validates)
                $submittedDataValidates = false;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // saving
                $aliquotInternalUseData = array(
                    'AliquotInternalUse' => $this->request->data['AliquotInternalUse']
                );
                $this->AliquotInternalUse->addWritableField(array(
                    'aliquot_master_id',
                    'study_summary_id'
                ));
                $this->AliquotInternalUse->writableFieldsMode = 'add';
                $this->AliquotMaster->addWritableField(array(
                    'in_stock'
                ));
                $this->AliquotMaster->writableFieldsMode = 'add';
                foreach ($aliquotIds as $aliquotMasterId) {
                    
                    // AliquotInternalUse
                    
                    $this->AliquotInternalUse->id = null;
                    $this->AliquotInternalUse->data = null;
                    $aliquotInternalUseData['AliquotInternalUse']['aliquot_master_id'] = $aliquotMasterId;
                    if (! $this->AliquotInternalUse->save($aliquotInternalUseData, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    if (! $this->AliquotMaster->updateAliquotVolume($aliquotMasterId))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        
                        // AliquotMaster
                    
                    $this->AliquotMaster->id = $aliquotMasterId;
                    $this->AliquotMaster->data = null;
                    $this->AliquotMaster->save($aliquotMasterDataToUpdate, false);
                }
                
                $hookLink = $this->hook('post_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                // batch
                $batchIds = $aliquotIds;
                $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                
                $batchSetData = array(
                    'BatchSet' => array(
                        'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquot'),
                        'flag_tmp' => true
                    )
                );
                
                $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                $batchSetModel->saveWithIds($batchSetData, $batchIds);
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if ($positionDeletionWarningMessage)
                    AppController::addWarningMsg(__($positionDeletionWarningMessage));
                $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
            }
        }
    }

    /* ----------------------------- SOURCE ALIQUOTS ---------------------------- */
    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     */
    public function addSourceAliquots($collectionId, $sampleMasterId)
    {
        // MANAGE DATA
        
        // Get Sample data
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => 0
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get aliquot already defined as source
        $existingSourceAliquots = $this->SourceAliquot->find('all', array(
            'conditions' => array(
                'SourceAliquot.sample_master_id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        $existingSourceAliquotIds = array();
        if (! empty($existingSourceAliquots)) {
            foreach ($existingSourceAliquots as $sourceAliquot) {
                $existingSourceAliquotIds[] = $sourceAliquot['SourceAliquot']['aliquot_master_id'];
            }
        }
        
        // Get parent sample aliquot that could be defined as source
        $criteria = array(
            'AliquotMaster.collection_id' => $collectionId,
            'AliquotMaster.sample_master_id' => $sampleData['SampleMaster']['parent_id'],
            'OR' => array(
                array(
                    'AliquotControl.volume_unit' => ''
                ),
                array(
                    'AliquotControl.volume_unit' => null
                )
            ),
            'NOT' => array(
                'AliquotMaster.id' => $existingSourceAliquotIds
            )
        );
        $availableSampleAliquotsWoVolume = $this->AliquotMaster->find('all', array(
            'conditions' => $criteria,
            'order' => 'AliquotMaster.barcode ASC',
            'recursive' => 0
        ));
        unset($criteria['OR']);
        $criteria['NOT']['OR'] = array(
            array(
                'AliquotControl.volume_unit' => ''
            ),
            array(
                'AliquotControl.volume_unit' => null
            )
        );
        $availableSampleAliquotsWVolume = $this->AliquotMaster->find('all', array(
            'conditions' => $criteria,
            'order' => 'AliquotMaster.barcode ASC',
            'recursive' => 0
        ));
        
        if (empty($availableSampleAliquotsWVolume) && empty($availableSampleAliquotsWoVolume)) {
            $this->atimFlashWarning(__('no new sample aliquot could be actually defined as source aliquot'), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
        }
        $availableSampleAliquots = array(
            'vol' => $availableSampleAliquotsWVolume,
            'no_vol' => $availableSampleAliquotsWoVolume
        );
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%'));
        
        // Get the current menu object.
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sampleData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id']
        ));
        
        // Set structure
        $this->Structures->set('sourcealiquots', 'sourcealiquots');
        $this->Structures->set('sourcealiquots,sourcealiquots_volume', 'sourcealiquots_volume');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA RECORD
        
        if (empty($this->request->data)) {
            $this->request->data = $availableSampleAliquots;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Launch validation
            $submittedDataValidates = true;
            
            $aliquotsDefinedAsSourcePointers = array();
            $unifiedDataPointers = array();
            $errors = array();
            $lineCounter = 0;
            foreach ($this->request->data as &$typesArrayPointers) {
                foreach ($typesArrayPointers as &$dataUnitPointer) {
                    $unifiedDataPointers[] = &$dataUnitPointer;
                }
            }
            foreach ($unifiedDataPointers as &$studiedAliquotPointer) {
                $lineCounter ++;
                
                if ($studiedAliquotPointer['FunctionManagement']['use']) {
                    // New aliquot defined as source
                    
                    // Check volume
                    
                    if ((! empty($studiedAliquotPointer['SourceAliquot']['used_volume'])) && empty($studiedAliquotPointer['AliquotControl']['volume_unit'])) {
                        // No volume has to be recored for this aliquot type
                        $errors['SourceAliquot']['used_volume']['no volume has to be recorded for this aliquot type'][] = $lineCounter;
                        $submittedDataValidates = false;
                    } elseif (empty($studiedAliquotPointer['SourceAliquot']['used_volume'])) {
                        // Change '0' to null
                        $studiedAliquotPointer['SourceAliquot']['used_volume'] = null;
                    }
                    
                    // Launch Aliquot Master validation
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    
                    $tmpStorageMaster = $studiedAliquotPointer['StorageMaster'];
                    $tmpStorageCoordX = $studiedAliquotPointer['AliquotMaster']['storage_coord_x'];
                    $tmpStorageCoordY = $studiedAliquotPointer['AliquotMaster']['storage_coord_y'];
                    unset($studiedAliquotPointer['StorageMaster']);
                    unset($studiedAliquotPointer['AliquotMaster']['storage_coord_x']);
                    unset($studiedAliquotPointer['AliquotMaster']['storage_coord_y']);
                    
                    $this->AliquotMaster->set($studiedAliquotPointer);
                    $this->AliquotMaster->id = $studiedAliquotPointer['AliquotMaster']['id'];
                    
                    $submittedDataValidates = ($this->AliquotMaster->validates()) ? $submittedDataValidates : false;
                    foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors['AliquotMaster'][$field][$msg][] = $lineCounter;
                    }
                    
                    // Reset data to get position data (not really required for this function)
                    $studiedAliquotPointer = $this->AliquotMaster->data;
                    
                    $studiedAliquotPointer['StorageMaster'] = $tmpStorageMaster;
                    $studiedAliquotPointer['AliquotMaster']['storage_coord_x'] = $tmpStorageCoordX;
                    $studiedAliquotPointer['AliquotMaster']['storage_coord_y'] = $tmpStorageCoordY;
                    
                    // Launch Aliquot Source validation
                    $this->SourceAliquot->set($studiedAliquotPointer);
                    $submittedDataValidates = ($this->SourceAliquot->validates()) ? $submittedDataValidates : false;
                    foreach ($this->SourceAliquot->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors['SourceAliquot'][$field][$msg][] = $lineCounter;
                    }
                    
                    // Add record to array of tested aliquots
                    $aliquotsDefinedAsSourcePointers[] = $studiedAliquotPointer;
                }
            }
            
            if (empty($aliquotsDefinedAsSourcePointers)) {
                $this->SourceAliquot->validationErrors['use'][] = 'no aliquot has been defined as source aliquot';
                $submittedDataValidates = false;
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (! $submittedDataValidates) {
                // Set error message
                foreach ($errors as $model => $fieldMessages) {
                    $this->{$model}->validationErrors = array();
                    foreach ($fieldMessages as $field => $messages) {
                        foreach ($messages as $message => $lines) {
                            $this->{$model}->validationErrors[$field][] = __($message) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                        }
                    }
                }
            } else {
                // Launch save process
                // Parse records to save
                
                $this->AliquotMaster->writableFieldsMode = 'editgrid';
                
                $this->SourceAliquot->addWritableField(array(
                    'aliquot_master_id',
                    'sample_master_id'
                ));
                $this->SourceAliquot->writableFieldsMode = 'editgrid';
                
                foreach ($aliquotsDefinedAsSourcePointers as $sourceAliquotPointer) {
                    // Get Source Aliquot Master Id
                    $aliquotMasterId = $sourceAliquotPointer['AliquotMaster']['id'];
                    
                    // Set aliquot master data
                    if ($sourceAliquotPointer['FunctionManagement']['remove_from_storage'] || ($sourceAliquotPointer['AliquotMaster']['in_stock'] == 'no')) {
                        // Delete aliquot storage data
                        $sourceAliquotPointer['AliquotMaster']['storage_master_id'] = null;
                        $sourceAliquotPointer['AliquotMaster']['storage_coord_x'] = '';
                        $sourceAliquotPointer['AliquotMaster']['storage_coord_y'] = '';
                        $this->AliquotMaster->addWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    } else {
                        $this->AliquotMaster->removeWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    }
                    
                    // Save data:
                    // - AliquotMaster
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $aliquotMasterId;
                    
                    if (! $this->AliquotMaster->save($sourceAliquotPointer, false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    // - SourceAliquot
                    $this->SourceAliquot->id = null;
                    $this->SourceAliquot->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $sourceAliquotPointer['SourceAliquot']['aliquot_master_id'] = $aliquotMasterId;
                    $sourceAliquotPointer['SourceAliquot']['sample_master_id'] = $sampleMasterId;
                    // barcode,aliquot_label,storage_coord_x,storage_coord_y
                    if (! $this->SourceAliquot->save($sourceAliquotPointer, false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    // - Update aliquot current volume
                    if (! $this->AliquotMaster->updateAliquotVolume($aliquotMasterId)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved') . '<br>' . __('aliquot storage data were deleted (if required)'), '/InventoryManagement/SampleMasters/detail/' . $collectionId . '/' . $sampleMasterId);
            }
        }
    }

    /**
     *
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function editSourceAliquot($sampleMasterId, $aliquotMasterId)
    {
        // Get the realiquoting data
        $sourceData = $this->SourceAliquot->find('first', array(
            'conditions' => array(
                'SourceAliquot.sample_master_id' => $sampleMasterId,
                'SourceAliquot.aliquot_master_id' => $aliquotMasterId
            )
        ));
        if (empty($sourceData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $sourceData['AliquotControl'] = $this->AliquotControl->getOrRedirect($sourceData['AliquotMaster']['aliquot_control_id']);
        $sourceData['AliquotControl'] = $sourceData['AliquotControl']['AliquotControl'];
        
        $flashUrl = '/InventoryManagement/SampleMasters/detail/' . $sourceData['SampleMaster']['collection_id'] . '/' . $sourceData['SampleMaster']['id'];
        
        $showSubmitButton = true;
        if (empty($sourceData['AliquotControl']['volume_unit'])) {
            $this->Structures->set('sourcealiquots');
            $showSubmitButton = false; // To allow custom code to display page
        } else {
            $this->Structures->set('sourcealiquots,sourcealiquots_volume');
        }
        $this->set('showSubmitButton', $showSubmitButton);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! $showSubmitButton)
            AppController::addWarningMsg(__('no source aliquot data has to be updated'));
        
        if ($this->request->data) {
            $this->SourceAliquot->id = $sourceData['SourceAliquot']['id'];
            $this->SourceAliquot->data = array();
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($this->SourceAliquot->save($this->request->data)) {
                $this->AliquotMaster->updateAliquotVolume($sourceData['AliquotMaster']['id']);
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been saved'), '/InventoryManagement/SampleMasters/detail/' . $sourceData['SampleMaster']['collection_id'] . '/' . $sourceData['SampleMaster']['id']);
            }
        } else {
            $this->request->data = $sourceData;
        }
        
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%'));
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sourceData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sourceData['SampleMaster']['id'],
            'SampleMaster.initial_specimen_sample_id' => $sourceData['SampleMaster']['initial_specimen_sample_id'],
            'AliquotMaster.id' => $sourceData['AliquotMaster']['id']
        ));
    }

    /**
     *
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function deleteSourceAliquot($sampleMasterId, $aliquotMasterId)
    {
        if ((! $sampleMasterId) || (! $aliquotMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the realiquoting data
        $sourceData = $this->SourceAliquot->find('first', array(
            'conditions' => array(
                'SourceAliquot.sample_master_id' => $sampleMasterId,
                'SourceAliquot.aliquot_master_id' => $aliquotMasterId
            )
        ));
        if (empty($sourceData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // LAUNCH DELETION
        // -> Delete Realiquoting
        $deletionDone = $this->SourceAliquot->atimDelete($sourceData['SourceAliquot']['id']);
        
        // -> Update volume
        if ($deletionDone) {
            $deletionDone = $this->AliquotMaster->updateAliquotVolume($sourceData['AliquotMaster']['id']);
        }
        
        $flashUrl = '/InventoryManagement/SampleMasters/detail/' . $sourceData['SampleMaster']['collection_id'] . '/' . $sourceData['SampleMaster']['id'];
        
        $hookLink = $this->hook('postsave_process');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($deletionDone) {
            $this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), $flashUrl);
        } else {
            $this->atimFlashError(__('error deleting data - contact administrator'), $flashUrl);
        }
    }

    /* ------------------------------ REALIQUOTING ------------------------------ */
    /**
     *
     * @param $processType
     * @param null $aliquotId
     */
    public function realiquotInit($processType, $aliquotId = null)
    {
        
        // Get ids of the studied aliquots
        $ids = array();
        if (! empty($aliquotId)) {
            $aliquot = $this->AliquotMaster->getOrRedirect($aliquotId);
            $aliquot = $aliquot['AliquotMaster'];
            $this->request->data['url_to_cancel'] = sprintf('/InventoryManagement/AliquotMasters/detail/%d/%d/%d', $aliquot['collection_id'], $aliquot['sample_master_id'], $aliquot['id']);
            $ids = array(
                $aliquotId
            );
        } else {
            if (isset($this->request->data['AliquotMaster'])) {
                $ids = $this->request->data['AliquotMaster']['id'];
            } elseif (isset($this->request->data['ViewAliquot'])) {
                $ids = $this->request->data['ViewAliquot']['aliquot_master_id'];
            } else {
                $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
                return;
            }
            if ($ids == 'all' && isset($this->request->data['node'])) {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $ids = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            if (! is_array($ids) && strpos($ids, ',')) {
                // User launched action from databrowser but the number of items was bigger than databrowser_and_report_results_display_limit
                $this->atimFlashWarning(__("batch init - number of submitted records too big"), "javascript:history.back();");
                return;
            }
            $ids = array_filter($ids);
        }
        $ids[] = 0;
        
        // Find parent(s) aliquot
        $this->AliquotMaster->unbindModel(array(
            'hasOne' => array(
                'SpecimenDetail'
            ),
            'belongsTo' => array(
                'Collection',
                'StorageMaster'
            )
        ));
        $aliquots = $this->AliquotMaster->findAllById($ids);
        if (empty($aliquots)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('aliquotId', $aliquotId);
        $this->setUrlToCancel();
        
        // Check aliquot & sample types of the selected aliquots are identical
        $aliquotCtrlId = $aliquots[0]['AliquotMaster']['aliquot_control_id'];
        $sampleCtrlId = $aliquots[0]['SampleMaster']['sample_control_id'];
        if (count($aliquots) > 1) {
            foreach ($aliquots as $aliquot) {
                if (($aliquot['AliquotMaster']['aliquot_control_id'] != $aliquotCtrlId) || ($aliquot['SampleMaster']['sample_control_id'] != $sampleCtrlId)) {
                    $this->atimFlashWarning(__("you cannot realiquot those elements together because they are of different types"), "javascript:history.back();");
                    return;
                }
            }
        }
        
        // Build list of aliquot type that could be created from the sources for display
        $possibleCtrlIds = $this->RealiquotingControl->getAllowedChildrenCtrlId($sampleCtrlId, $aliquotCtrlId);
        if (empty($possibleCtrlIds)) {
            $this->atimFlashWarning(__("you cannot realiquot those elements"), "javascript:history.back();");
            return;
        }
        
        $aliquotCtrls = $this->AliquotControl->findAllById($possibleCtrlIds);
        assert(! empty($aliquotCtrls));
        $defaultChildrenAliquotControlId = null;
        foreach ($aliquotCtrls as $aliquotCtrl) {
            $dropdown[$aliquotCtrl['AliquotControl']['id']] = __($aliquotCtrl['AliquotControl']['aliquot_type']);
            $defaultChildrenAliquotControlId = $aliquotCtrl['AliquotControl']['id'];
        }
        AliquotMaster::$aliquotTypeDropdown = $dropdown;
        $this->set('defaultChildrenAliquotControlId', sizeof($dropdown) == 1 ? $defaultChildrenAliquotControlId : null);
        
        // Set data
        $this->request->data = array();
        $this->request->data[0]['ids'] = implode(",", $ids);
        
        $this->set('realiquotFrom', $aliquotCtrlId);
        $this->set('sampleCtrlId', $sampleCtrlId);
        
        switch ($processType) {
            case 'creation':
                $this->set('realiquotingFunction', 'realiquot');
                break;
            case 'definition':
                $this->set('realiquotingFunction', 'defineRealiquotedChildren');
                break;
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->set('processType', $processType);
        
        // Set structure and menu
        $this->Structures->set('aliquot_type_selection' . (($processType == 'definition') ? '' : ',aliquot_nb_definition'));
        
        if (empty($aliquotId)) {
            $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        } else {
            $this->setAliquotMenu($aliquots[0]);
        }
        
        $criteria = array(
            'ParentAliquotControl.sample_control_id' => $sampleCtrlId,
            'ParentAliquotControl.id' => $aliquotCtrlId,
            'ParentAliquotControl.flag_active' => '1',
            'RealiquotingControl.flag_active' => '1',
            'RealiquotingControl.lab_book_control_id IS NOT NULL'
        );
        $LabBookDefined = $this->RealiquotingControl->find('count', array(
            'conditions' => $criteria
        ));
        $this->set('skipLabBookSelectionStep', $LabBookDefined ? false : true);
        
        // Hook Call
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $processType
     * @param null $aliquotId
     */
    public function realiquotInit2($processType, $aliquotId = null)
    {
        if (! isset($this->request->data['sample_ctrl_id']) || ! isset($this->request->data['realiquot_from']) || ! isset($this->request->data[0]['realiquot_into']) || ! isset($this->request->data[0]['ids'])) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } elseif ($this->request->data[0]['realiquot_into'] == '') {
            $this->atimFlashWarning(__("you must select an aliquot type"), "javascript:history.back();");
            return;
        }
        
        $this->set('sampleCtrlId', $this->request->data['sample_ctrl_id']);
        $this->set('aliquotId', $aliquotId);
        $this->set('realiquotFrom', $this->request->data['realiquot_from']);
        $this->set('realiquotInto', $this->request->data[0]['realiquot_into']);
        $this->set('ids', $this->request->data[0]['ids']);
        $this->setUrlToCancel();
        
        switch ($processType) {
            case 'creation':
                $this->set('realiquotingFunction', 'realiquot');
                break;
            case 'definition':
                $this->set('realiquotingFunction', 'defineRealiquotedChildren');
                break;
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->AliquotMaster->unbindModel(array(
            'hasOne' => array(
                'SpecimenDetail'
            ),
            'belongsTo' => array(
                'Collection',
                'StorageMaster'
            )
        ));
        $aliquotData = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.id' => $this->request->data[0]['ids']
            )
        ));
        $sampleCtrlId = $aliquotData['SampleMaster']['sample_control_id'];
        if ($sampleCtrlId != $this->request->data['sample_ctrl_id'])
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $labBookCtrlId = $this->RealiquotingControl->getLabBookCtrlId($sampleCtrlId, $this->request->data['realiquot_from'], $this->request->data[0]['realiquot_into']);
        
        if (is_numeric($labBookCtrlId)) {
            $this->set('labBookCtrlId', $labBookCtrlId);
            $this->Structures->set('realiquoting_lab_book');
            AppController::addWarningMsg(__('if no lab book has to be defined for this process, keep fields empty and click submit to continue'));
        } else {
            $this->Structures->set('empty');
            AppController::addWarningMsg(__('no lab book can be defined for that realiquoting') . ' ' . __('click submit to continue'));
        }
        
        if (empty($aliquotId)) {
            $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        } else {
            $this->setAliquotMenu($aliquotData);
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $aliquotId
     */
    public function realiquot($aliquotId = null)
    {
        $initialDisplay = false;
        $parentAliquotsIds = '';
        if (empty($this->request->data)) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
            return;
        } elseif (isset($this->request->data[0]) && isset($this->request->data[0]['ids'])) {
            if ($this->request->data[0]['realiquot_into'] == '') {
                $this->atimFlashWarning(__("you must select an aliquot type"), "javascript:history.back();");
                return;
            }
            $initialDisplay = true;
            $parentAliquotsIds = $this->request->data[0]['ids'];
        } elseif (isset($this->request->data['ids'])) {
            $initialDisplay = false;
            $parentAliquotsIds = $this->request->data['ids'];
        } else {
            $this->redirect("/Pages/err_no_data?method='.__METHOD__.',line='.__LINE__", null, true);
        }
        $this->set('parentAliquotsIds', $parentAliquotsIds);
        
        // Get parent an child control data
        $parentAliquotCtrlId = isset($this->request->data['realiquot_from']) ? $this->request->data['realiquot_from'] : null;
        $childAliquotCtrlId = isset($this->request->data[0]['realiquot_into']) ? $this->request->data[0]['realiquot_into'] : (isset($this->request->data['realiquot_into']) ? $this->request->data['realiquot_into'] : null);
        $childAliquotsNbrPerParentNbr = isset($this->request->data[0]['aliquots_nbr_per_parent']) ? $this->request->data[0]['aliquots_nbr_per_parent'] : null;
        $parentAliquotCtrl = $this->AliquotControl->findById($parentAliquotCtrlId);
        $childAliquotCtrl = ($parentAliquotCtrlId == $childAliquotCtrlId) ? $parentAliquotCtrl : $this->AliquotControl->findById($childAliquotCtrlId);
        if (empty($parentAliquotCtrl) || empty($childAliquotCtrl)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // lab book management
        $labBook = null; // lab book object
        $labBookExpectedCtrlId = null;
        $labBookCode = null;
        $labBookId = null;
        $syncWithLabBook = null;
        $labBookFields = array();
        if (isset($this->request->data['Realiquoting']) && isset($this->request->data['Realiquoting']['lab_book_master_code']) && (strlen($this->request->data['Realiquoting']['lab_book_master_code']) > 0 || $this->request->data['Realiquoting']['sync_with_lab_book'])) {
            $labBook = AppModel::getInstance("LabBook", "LabBookMaster", true);
            $sampleCtrlId = isset($this->request->data['sample_ctrl_id']) ? $this->request->data['sample_ctrl_id'] : null;
            $labBookExpectedCtrlId = $this->RealiquotingControl->getLabBookCtrlId($sampleCtrlId, $parentAliquotCtrlId, $childAliquotCtrlId);
            $syncResponse = $labBook->syncData($this->request->data, array(), $this->request->data['Realiquoting']['lab_book_master_code'], $labBookExpectedCtrlId);
            if (is_numeric($syncResponse)) {
                $labBookId = $syncResponse;
                $labBookFields = $labBook->getFields($labBookExpectedCtrlId);
                $labBookCode = $this->request->data['Realiquoting']['lab_book_master_code'];
                $syncWithLabBook = $this->request->data['Realiquoting']['sync_with_lab_book'];
            } else {
                $this->atimFlashWarning(__($syncResponse), "javascript:history.back()");
                return;
            }
        }
        $this->set('labBookCode', $labBookCode);
        $this->set('syncWithLabBook', $syncWithLabBook);
        $this->set('labBookFields', $labBookFields);
        
        // Structure and menu data
        $this->set('aliquotId', $aliquotId);
        if (empty($aliquotId)) {
            $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        } else {
            $parent = $this->AliquotMaster->find('first', array(
                'conditions' => array(
                    'AliquotMaster.id' => $aliquotId
                ),
                'recursive' => 0
            ));
            if (empty($parent)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->setAliquotMenu($parent);
        }
        
        $this->set('realiquotFrom', $parentAliquotCtrlId);
        $this->set('realiquotInto', $childAliquotCtrlId);
        $this->set('sampleCtrlId', $this->request->data['sample_ctrl_id']);
        
        // AliquotMaster is used for parent save and child save. The parent detail might change from parent to parent.
        // We need to manage writable fields
        $this->Structures->set('used_aliq_in_stock_details', 'in_stock_detail', array(
            'model_table_assoc' => array(
                'AliquotDetail' => 'tmp_detail_table'
            )
        ));
        $this->set('displayBatchProcessAliqStorageAndInStockDetails', (sizeof(array_filter(explode(',', $parentAliquotsIds))) > 1));
        $this->Structures->set('batch_process_aliq_storage_and_in_stock_details', 'batch_process_aliq_storage_and_in_stock_details');
        $parentNoVolWritableFields = AppModel::$writableFields;
        AppModel::$writableFields = array();
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'in_stock_detail_volume', array(
            'model_table_assoc' => array(
                'AliquotDetail' => 'tmp_detail_table'
            )
        ));
        $parentVolWritableFields = AppModel::$writableFields;
        AppModel::$writableFields = array();
        $this->Structures->set($childAliquotCtrl['AliquotControl']['form_alias'] . (empty($parentAliquotCtrl['AliquotControl']['volume_unit']) ? ',realiquot_without_vol' : ',realiquot_with_vol'), 'atim_structure', array(
            'model_table_assoc' => array(
                'AliquotDetail' => $childAliquotCtrl['AliquotControl']['detail_tablename']
            )
        ));
        $childWritableFields = AppModel::$writableFields;
        AppModel::$writableFields = array();
        $this->setUrlToCancel();
        
        $this->Structures->set('empty', 'emptyStructure');
        
        // set data for initial data to allow bank to override data
        $createdAliquotStructureOverride = array(
            'AliquotControl.aliquot_type' => $childAliquotCtrl['AliquotControl']['aliquot_type'],
            'AliquotMaster.storage_datetime' => date('Y-m-d G:i'),
            'AliquotMaster.in_stock' => 'yes - available',
            
            'Realiquoting.realiquoting_datetime' => date('Y-m-d G:i')
        );
        if (! empty($childAliquotCtrl['AliquotControl']['volume_unit'])) {
            $createdAliquotStructureOverride['AliquotControl.volume_unit'] = $childAliquotCtrl['AliquotControl']['volume_unit'];
        }
        if (! empty($parentAliquotCtrl['AliquotControl']['volume_unit'])) {
            $createdAliquotStructureOverride['GeneratedParentAliquot.aliquot_volume_unit'] = $parentAliquotCtrl['AliquotControl']['volume_unit'];
        }
        $this->set('createdAliquotStructureOverride', $createdAliquotStructureOverride);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            
            // 1- INITIAL DISPLAY
            $parentAliquots = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    'AliquotMaster.id' => explode(",", $parentAliquotsIds)
                ),
                'recursive' => 0
            ));
            $displayLimit = Configure::read('RealiquotedAliquotCreation_processed_items_limit');
            if (sizeof($parentAliquots) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $this->request->data['url_to_cancel']);
                return;
            }
            if (empty($parentAliquots)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $this->AliquotMaster->sortForDisplay($parentAliquots, $parentAliquotsIds);
            
            // build data array
            $childAliquotsNbrPerParentNbr = $childAliquotsNbrPerParentNbr ? $childAliquotsNbrPerParentNbr : 1;
            if ($childAliquotsNbrPerParentNbr > 20) {
                $childAliquotsNbrPerParentNbr = 20;
                AppController::addWarningMsg(__('nbr of children by default can not be bigger than 20'));
            }
            $tmpChildArray = array();
            while ($childAliquotsNbrPerParentNbr) {
                $tmpChildArray[] = array();
                $childAliquotsNbrPerParentNbr --;
            }
            
            $this->request->data = array();
            foreach ($parentAliquots as $parentAliquot) {
                if ($parentAliquotCtrlId != $parentAliquot['AliquotMaster']['aliquot_control_id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $this->request->data[] = array(
                    'parent' => $parentAliquot,
                    'children' => $tmpChildArray
                );
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            unset($this->request->data['sample_ctrl_id']);
            unset($this->request->data['realiquot_into']);
            unset($this->request->data['realiquot_from']);
            unset($this->request->data['ids']);
            unset($this->request->data['Realiquoting']);
            unset($this->request->data['url_to_cancel']);
            
            // Parse First Section To Apply To All
            list ($usedAliquotDataToApplyToAll, $errorsOnFirstSectionToApplyToAll) = $this->AliquotMaster->getAliquotDataStorageAndStockToApplyToAll($this->request->data);
            
            unset($this->request->data['FunctionManagement']);
            unset($this->request->data['AliquotMaster']);
            
            if (empty($this->request->data)) {
                $this->atimFlashWarning(__("at least one data has to be created"), "javascript:history.back();");
                return;
            }
            
            if ($usedAliquotDataToApplyToAll) {
                AppController::addWarningMsg(__('fields values of the first section have been applied to all other sections'));
            }
            
            // 2- VALIDATE PROCESS
            
            $errors = $errorsOnFirstSectionToApplyToAll;
            
            $validatedData = array();
            $recordCounter = 0;
            $childGotVolume = false;
            foreach ($this->request->data as $parentId => $parentAndChildren) {
                $recordCounter ++;
                
                // A- Validate parent aliquot data
                
                if ($usedAliquotDataToApplyToAll)
                    $parentAndChildren = array_replace_recursive($parentAndChildren, $usedAliquotDataToApplyToAll);
                
                $this->AliquotMaster->id = null;
                $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                
                $parentAliquotData = $parentAndChildren['AliquotMaster'];
                $parentAliquotData['id'] = $parentId;
                $parentAliquotData['aliquot_control_id'] = $parentAliquotCtrlId;
                unset($parentAliquotData['storage_coord_x']);
                unset($parentAliquotData['storage_coord_y']);
                
                $this->AliquotMaster->set(array(
                    "AliquotMaster" => $parentAliquotData
                ));
                if (! $this->AliquotMaster->validates()) {
                    foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors[$field][$msg][$recordCounter] = $recordCounter;
                    }
                }
                $parentAliquotData = $this->AliquotMaster->data['AliquotMaster'];
                
                // Set parent data to $validatedData
                $validatedData[$parentId]['parent']['AliquotMaster'] = $parentAliquotData;
                $validatedData[$parentId]['parent']['AliquotMaster']['storage_coord_x'] = $parentAndChildren['AliquotMaster']['storage_coord_x'];
                $validatedData[$parentId]['parent']['AliquotMaster']['storage_coord_y'] = $parentAndChildren['AliquotMaster']['storage_coord_y'];
                
                $validatedData[$parentId]['parent']['FunctionManagement'] = $parentAndChildren['FunctionManagement'];
                $validatedData[$parentId]['parent']['AliquotControl'] = $parentAndChildren['AliquotControl'];
                $validatedData[$parentId]['parent']['StorageMaster'] = $parentAndChildren['StorageMaster'];
                
                $validatedData[$parentId]['children'] = array();
                
                // B- Validate new aliquot created + realiquoting data
                
                $newAliquotCreated = false;
                foreach ($parentAndChildren as $tmpId => $child) {
                    
                    if (is_numeric($tmpId)) {
                        $newAliquotCreated = true;
                        
                        // ** Aliquot **
                        
                        // Set AliquotMaster.initial_volume
                        if (array_key_exists('initial_volume', $child['AliquotMaster'])) {
                            if (empty($childAliquotCtrl['AliquotControl']['volume_unit'])) {
                                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                            $child['AliquotMaster']['current_volume'] = $child['AliquotMaster']['initial_volume'];
                            $childGotVolume = true;
                        }
                        
                        // Validate and update position data
                        $this->AliquotMaster->id = null;
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        
                        $child['AliquotMaster']['id'] = null;
                        $child['AliquotMaster']['aliquot_control_id'] = $childAliquotCtrlId;
                        $child['AliquotMaster']['sample_master_id'] = $validatedData[$parentId]['parent']['AliquotMaster']['sample_master_id'];
                        $child['AliquotMaster']['collection_id'] = $validatedData[$parentId]['parent']['AliquotMaster']['collection_id'];
                        
                        $this->AliquotMaster->set($child);
                        if (! $this->AliquotMaster->validates()) {
                            foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                                $msgs = is_array($msgs) ? $msgs : array(
                                    $msgs
                                );
                                foreach ($msgs as $msg)
                                    $errors[$field][$msg][$recordCounter] = $recordCounter;
                            }
                        }
                        // Reset data to get position data
                        $child = $this->AliquotMaster->data;
                        
                        // ** Realiquoting **
                        $this->Realiquoting->set(array(
                            'Realiquoting' => $child['Realiquoting']
                        ));
                        if (! $this->Realiquoting->validates()) {
                            foreach ($this->Realiquoting->validationErrors as $field => $msgs) {
                                $msgs = is_array($msgs) ? $msgs : array(
                                    $msgs
                                );
                                foreach ($msgs as $msg)
                                    $errors[$field][$msg][$recordCounter] = $recordCounter;
                            }
                        }
                        $child['Realiquoting'] = $this->Realiquoting->data['Realiquoting'];
                        
                        // Check volume can be completed
                        if ((! empty($child['Realiquoting']['parent_used_volume'])) && empty($child['GeneratedParentAliquot']['aliquot_volume_unit'])) {
                            // No volume has to be recored for this aliquot type
                            $errors['parent_used_volume']['no volume has to be recorded when the volume unit field is empty'][$recordCounter] = $recordCounter;
                        }
                        
                        // Set child data to $validatedData
                        $validatedData[$parentId]['children'][$tmpId] = $child;
                    }
                }
                
                if (! $newAliquotCreated) {
                    $errors[]['at least one child has to be created'][$recordCounter] = $recordCounter;
                }
            }
            
            $this->request->data = $validatedData;
            
            if (empty($errors) && ! empty($labBookCode)) {
                // this time we do synchronize with the lab book
                foreach ($this->request->data as $key => &$newDataSet) {
                    $labBook->syncData($newDataSet['children'], array(
                        'Realiquoting'
                    ), $labBookCode);
                }
            }
            
            $childWritableFields['aliquot_masters']['addgrid'] = array_merge($childWritableFields['aliquot_masters']['addgrid'], array(
                'collection_id',
                'sample_master_id',
                'aliquot_control_id',
                'storage_coord_x',
                'storage_coord_y',
                'storage_master_id',
                'study_summary_id'
            ));
            $this->Realiquoting->writableFieldsMode = 'addgrid';
            $childWritableFields['realiquotings']['addgrid'] = array_merge($childWritableFields['realiquotings']['addgrid'], array(
                'parent_aliquot_master_id',
                'child_aliquot_master_id',
                'lab_book_master_id',
                'sync_with_lab_book'
            ));
            if ($childGotVolume) {
                $childWritableFields['aliquot_masters']['addgrid'][] = 'current_volume';
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // 3- SAVE PROCESS
            
            if (empty($errors)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $newAliquotIds = array();
                foreach ($this->request->data as $parentId => $parentAndChildren) {
                    
                    // A- Save parent aliquot data
                    
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $parentId;
                    
                    $parentData = $parentAndChildren['parent'];
                    $storageWritableFields = array();
                    if ($parentData['FunctionManagement']['remove_from_storage'] || ($parentData['AliquotMaster']['in_stock'] == 'no')) {
                        // Delete storage data
                        $parentData['AliquotMaster']['storage_master_id'] = null;
                        $parentData['AliquotMaster']['storage_coord_x'] = '';
                        $parentData['AliquotMaster']['storage_coord_y'] = '';
                        $storageWritableFields = array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        );
                    }
                    
                    $parentData['AliquotMaster']['id'] = $parentId;
                    $orgParentData = $this->AliquotMaster->getOrRedirect($parentId);
                    AppModel::$writableFields = $orgParentData['AliquotControl']['volume_unit'] ? $parentVolWritableFields : $parentNoVolWritableFields;
                    
                    foreach ($storageWritableFields as $newWritableField)
                        AppModel::$writableFields['aliquot_masters']['edit'][] = $newWritableField;
                    
                    if (isset(AppModel::$writableFields['tmp_detail_table'])) {
                        AppModel::$writableFields[$orgParentData['AliquotControl']['detail_tablename']] = AppModel::$writableFields['tmp_detail_table'];
                    }
                    $this->AliquotMaster->data = array();
                    
                    $this->AliquotMaster->writableFieldsMode = 'edit';
                    
                    // clean data to prevent warnings
                    $toSave = array();
                    foreach (AppModel::$writableFields['aliquot_masters']['edit'] as $field) {
                        $toSave[$field] = $parentData['AliquotMaster'][$field];
                    }
                    if (! $this->AliquotMaster->save(array(
                        'AliquotMaster' => $toSave
                    ), false)) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    $this->AliquotMaster->writableFieldsMode = 'addgrid';
                    AppModel::$writableFields = $childWritableFields;
                    foreach ($parentAndChildren['children'] as $children) {
                        
                        $realiquotingData = array(
                            'Realiquoting' => $children['Realiquoting']
                        );
                        unset($children['Realiquoting']);
                        unset($children['FunctionManagement']);
                        unset($children['GeneratedParentAliquot']);
                        
                        // B- Save children aliquot data
                        $this->AliquotMaster->id = null;
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        
                        unset($children['AliquotMaster']['id']);
                        if (! $this->AliquotMaster->save($children, false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        
                        $childId = $this->AliquotMaster->getLastInsertId();
                        $newAliquotIds[] = $childId;
                        
                        // C- Save realiquoting data
                        
                        $realiquotingData['Realiquoting']['parent_aliquot_master_id'] = $parentId;
                        $realiquotingData['Realiquoting']['child_aliquot_master_id'] = $childId;
                        $realiquotingData['Realiquoting']['lab_book_master_id'] = $labBookId;
                        $realiquotingData['Realiquoting']['sync_with_lab_book'] = $syncWithLabBook;
                        
                        $this->Realiquoting->id = null;
                        $this->Realiquoting->data = array(); // *** To guaranty no merge will be done with previous data ***
                        if (! $this->Realiquoting->save($realiquotingData, false)) {
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                    
                    // D- Update parent aliquot current volume
                    $this->AliquotMaster->updateAliquotVolume($parentId);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if (empty($aliquotId)) {
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquot'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $newAliquotIds);
                    $this->atimFlash(__('your data has been saved') . '<br>' . __('aliquot storage data were deleted (if required)'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                } else {
                    $aliquot = $this->AliquotMaster->findById($aliquotId);
                    $aliquot = $aliquot['AliquotMaster'];
                    $this->atimFlash(__('your data has been saved') . '<br>' . __('aliquot storage data were deleted (if required)'), '/InventoryManagement/AliquotMasters/detail/' . $aliquot['collection_id'] . '/' . $aliquot['sample_master_id'] . '/' . $aliquot['id']);
                }
            } else {
                $this->AliquotMaster->validationErrors = array();
                $this->AliquotDetail->validationErrors = array();
                $this->Realiquoting->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        // Counter cake2 issue and use AliquotDetail model for validationErrors
                        $this->AliquotMaster->validationErrors[$field][] = __($msg) . (empty($aliquotId) ? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
                    }
                }
            }
        }
    }

    /**
     *
     * @param null $aliquotMasterId
     */
    public function defineRealiquotedChildren($aliquotMasterId = null)
    {
        $usedAliquotDataToApplyToAll = array();
        if (isset($this->request->data['FunctionManagement'])) {
            $usedAliquotDataToApplyToAll['FunctionManagement'] = $this->request->data['FunctionManagement'];
            $usedAliquotDataToApplyToAll['AliquotMaster'] = $this->request->data['AliquotMaster'];
            unset($this->request->data['FunctionManagement']);
            unset($this->request->data['AliquotMaster']);
        }
        
        $initialDisplay = false;
        $parentAliquotsIds = array();
        if (empty($this->request->data)) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
            return;
        } elseif (isset($this->request->data[0]) && isset($this->request->data[0]['ids'])) {
            if ($this->request->data[0]['realiquot_into'] == '') {
                $this->atimFlashWarning(__("you must select an aliquot type"), "javascript:history.back();");
                return;
            }
            $initialDisplay = true;
            $parentAliquotsIds = $this->request->data[0]['ids'];
        } elseif (isset($this->request->data['ids'])) {
            $initialDisplay = false;
            $parentAliquotsIds = $this->request->data['ids'];
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
            return;
        }
        $this->set('parentAliquotsIds', $parentAliquotsIds);
        
        // Get parent an child control data
        $parentAliquotCtrlId = isset($this->request->data['realiquot_from']) ? $this->request->data['realiquot_from'] : null;
        $childAliquotCtrlId = isset($this->request->data[0]['realiquot_into']) ? $this->request->data[0]['realiquot_into'] : (isset($this->request->data['realiquot_into']) ? $this->request->data['realiquot_into'] : null);
        $parentAliquotCtrl = $this->AliquotControl->findById($parentAliquotCtrlId);
        $childAliquotCtrl = ($parentAliquotCtrlId == $childAliquotCtrlId) ? $parentAliquotCtrl : $this->AliquotControl->findById($childAliquotCtrlId);
        if (empty($parentAliquotCtrl) || empty($childAliquotCtrl)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // lab book management
        $labBook = null; // lab book object
        $labBookExpectedCtrlId = null;
        $labBookCode = null;
        $labBookId = null;
        $syncWithLabBook = null;
        $labBookFields = array();
        if (isset($this->request->data['Realiquoting']) && isset($this->request->data['Realiquoting']['lab_book_master_code']) && (strlen($this->request->data['Realiquoting']['lab_book_master_code']) > 0 || $this->request->data['Realiquoting']['sync_with_lab_book'])) {
            $labBook = AppModel::getInstance("LabBook", "LabBookMaster", true);
            $sampleCtrlId = isset($this->request->data['sample_ctrl_id']) ? $this->request->data['sample_ctrl_id'] : null;
            $labBookExpectedCtrlId = $this->RealiquotingControl->getLabBookCtrlId($sampleCtrlId, $parentAliquotCtrlId, $childAliquotCtrlId);
            $syncResponse = $labBook->syncData($this->request->data, array(), $this->request->data['Realiquoting']['lab_book_master_code'], $labBookExpectedCtrlId);
            if (is_numeric($syncResponse)) {
                $labBookId = $syncResponse;
                $labBookFields = $labBook->getFields($labBookExpectedCtrlId);
                $labBookCode = $this->request->data['Realiquoting']['lab_book_master_code'];
                $syncWithLabBook = $this->request->data['Realiquoting']['sync_with_lab_book'];
            } else {
                $this->atimFlashWarning(__($syncResponse), "javascript:history.back()");
                return;
            }
        }
        $this->set('labBookCode', $labBookCode);
        $this->set('syncWithLabBook', $syncWithLabBook);
        $this->set('labBookFields', $labBookFields);
        
        // Structure and menu data
        $this->set('aliquotId', $aliquotMasterId);
        if (empty($aliquotMasterId)) {
            $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        } else {
            $parent = $this->AliquotMaster->find('first', array(
                'conditions' => array(
                    'AliquotMaster.id' => $aliquotMasterId
                ),
                'recursive' => 0
            ));
            if (empty($parent)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->setAliquotMenu($parent);
        }
        
        $this->set('realiquotFrom', $parentAliquotCtrlId);
        $this->set('realiquotInto', $childAliquotCtrlId);
        $this->set('sampleCtrlId', $this->request->data['sample_ctrl_id']);
        
        if (empty($parentAliquotCtrl['AliquotControl']['volume_unit'])) {
            $this->Structures->set('used_aliq_in_stock_details', 'in_stock_detail');
            $this->Structures->set('children_aliquots_selection', 'atim_structure_for_children_aliquots_selection');
        } else {
            $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'in_stock_detail');
            $this->Structures->set('children_aliquots_selection,children_aliquots_selection_volume', 'atim_structure_for_children_aliquots_selection');
        }
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('displayBatchProcessAliqStorageAndInStockDetails', (sizeof(array_filter(explode(",", $parentAliquotsIds))) > 1));
        $this->Structures->set('batch_process_aliq_storage_and_in_stock_details', 'batch_process_aliq_storage_and_in_stock_details');
        
        $this->setUrlToCancel();
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            
            // BUILD DATA FOR INTIAL DISPLAY
            
            $this->request->data = array();
            $excludedParentAliquot = array();
            
            // Get parent aliquot data
            $this->AliquotMaster->unbindModel(array(
                'hasOne' => array(
                    'SpecimenDetail',
                    'DerivativeDetail'
                ),
                'belongsTo' => array(
                    'Collection'
                )
            ));
            $hasManyDetails = array(
                'hasMany' => array(
                    'RealiquotingParent' => array(
                        'className' => 'InventoryManagement.Realiquoting',
                        'foreignKey' => 'child_aliquot_master_id'
                    ),
                    'RealiquotingChildren' => array(
                        'className' => 'InventoryManagement.Realiquoting',
                        'foreignKey' => 'parent_aliquot_master_id'
                    )
                )
            );
            $this->AliquotMaster->bindModel($hasManyDetails);
            $parentAliquots = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    'AliquotMaster.id' => explode(",", $parentAliquotsIds)
                )
            ));
            $this->AliquotMaster->sortForDisplay($parentAliquots, $parentAliquotsIds);
            if (empty($parentAliquots)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            foreach ($parentAliquots as $parentAliquotData) {
                // Get aliquots already defined as children
                $aliquotToExclude = array(
                    $parentAliquotData['AliquotMaster']['id']
                );
                foreach ($parentAliquotData['RealiquotingChildren'] as $realiquotingData) {
                    $aliquotToExclude[] = $realiquotingData['child_aliquot_master_id'];
                }
                
                // Get aliquots already defined as parent of the studied parent
                $existingParents = array();
                foreach ($parentAliquotData['RealiquotingParent'] as $realiquotingData) {
                    $aliquotToExclude[] = $realiquotingData['parent_aliquot_master_id'];
                }
                
                // Search Sample Aliquots could be defined as children aliquot
                $criteria = array(
                    'AliquotMaster.sample_master_id' => $parentAliquotData['AliquotMaster']['sample_master_id'],
                    'AliquotMaster.aliquot_control_id' => $childAliquotCtrlId,
                    'NOT' => array(
                        'AliquotMaster.id' => $aliquotToExclude
                    )
                );
                
                $excludeAliquot = false;
                $aliquotDataForSelection = $this->AliquotMaster->find('all', array(
                    'conditions' => $criteria,
                    'order' => array(
                        'AliquotMaster.in_stock_order',
                        'AliquotMaster.storage_datetime DESC'
                    ),
                    'recursive' => 0
                ));
                
                if (empty($aliquotDataForSelection)) {
                    // No aliquot can be defined as child
                    $excludedParentAliquot[] = $parentAliquotData;
                } else {
                    // Set default data
                    $defaultUseDatetime = $this->AliquotMaster->getDefaultRealiquotingDate($parentAliquotData);
                    foreach ($aliquotDataForSelection as &$childrenAliquot) {
                        $childrenAliquot['GeneratedParentAliquot']['aliquot_volume_unit'] = empty($parentAliquotData['AliquotControl']['volume_unit']) ? '' : $parentAliquotData['AliquotControl']['volume_unit'];
                        $childrenAliquot['Realiquoting']['realiquoting_datetime'] = $defaultUseDatetime;
                    }
                    
                    // Set data
                    $this->request->data[] = array(
                        'parent' => $parentAliquotData,
                        'children' => $aliquotDataForSelection
                    );
                }
            }
            
            // Manage exculded parents
            if (! empty($excludedParentAliquot)) {
                $tmpBarcode = array();
                foreach ($excludedParentAliquot as $newAliquot) {
                    $tmpBarcode[] = $newAliquot['AliquotMaster']['barcode'];
                }
                $msg = __('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)') . ': [' . implode(",", $tmpBarcode) . ']';
                
                if (empty($this->request->data)) {
                    $this->atimFlashWarning(__($msg), "javascript:history.back()");
                    return;
                } else {
                    AppController::addWarningMsg($msg);
                }
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // LAUNCH VALIDATE & SAVE PROCESSES
            
            // Parse First Section To Apply To All
            list ($usedAliquotDataToApplyToAll, $errorsOnFirstSectionToApplyToAll) = $this->AliquotMaster->getAliquotDataStorageAndStockToApplyToAll($usedAliquotDataToApplyToAll);
            
            unset($this->request->data['sample_ctrl_id']);
            unset($this->request->data['realiquot_into']);
            unset($this->request->data['realiquot_from']);
            unset($this->request->data['ids']);
            unset($this->request->data['Realiquoting']);
            unset($this->request->data['url_to_cancel']);
            
            if (empty($this->request->data)) {
                $this->atimFlashWarning(__("at least one data has to be created"), "javascript:history.back();");
                return;
            }
            
            if ($usedAliquotDataToApplyToAll) {
                AppController::addWarningMsg(__('fields values of the first section have been applied to all other sections'));
            }
            
            $errors = $errorsOnFirstSectionToApplyToAll;
            $validatedData = array();
            $recordCounter = 0;
            $relations = array();
            
            foreach ($this->request->data as $parentId => $parentAndChildren) {
                $recordCounter ++;
                
                // A- Validate parent aliquot data
                
                if ($usedAliquotDataToApplyToAll)
                    $parentAndChildren = array_replace_recursive($parentAndChildren, $usedAliquotDataToApplyToAll);
                
                $this->AliquotMaster->id = null;
                $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                
                $parentAliquotData = $parentAndChildren['AliquotMaster'];
                $parentAliquotData["id"] = $parentId;
                $parentAliquotData["aliquot_control_id"] = $parentAliquotCtrlId;
                unset($parentAliquotData['storage_coord_x']);
                unset($parentAliquotData['storage_coord_y']);
                
                $this->AliquotMaster->set(array(
                    "AliquotMaster" => $parentAliquotData
                ));
                if (! $this->AliquotMaster->validates()) {
                    foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors[$field][$msg][] = $recordCounter;
                    }
                }
                $parentAliquotData = $this->AliquotMaster->data['AliquotMaster'];
                
                // Set parent data to $validatedData
                $validatedData[$parentId]['parent']['AliquotMaster'] = $parentAliquotData;
                $validatedData[$parentId]['parent']['AliquotMaster']['storage_coord_x'] = $parentAndChildren['AliquotMaster']['storage_coord_x'];
                $validatedData[$parentId]['parent']['AliquotMaster']['storage_coord_y'] = $parentAndChildren['AliquotMaster']['storage_coord_y'];
                
                $validatedData[$parentId]['parent']['FunctionManagement'] = $parentAndChildren['FunctionManagement'];
                $validatedData[$parentId]['parent']['AliquotControl'] = $parentAndChildren['AliquotControl'];
                $validatedData[$parentId]['parent']['StorageMaster'] = $parentAndChildren['StorageMaster'];
                
                $validatedData[$parentId]['children'] = array();
                
                // B- Validate realiquoting data
                
                $childrenHasBeenDefined = false;
                foreach ($parentAndChildren as $tmpId => &$childrenAliquot) {
                    if (is_numeric($tmpId)) {
                        if ($childrenAliquot['FunctionManagement']['use']) {
                            $childrenHasBeenDefined = true;
                            
                            if (isset($relations[$childrenAliquot['AliquotMaster']['id']])) {
                                $errors[][__("circular assignation with [%s]", $childrenAliquot['AliquotMaster']['barcode'])][] = $recordCounter;
                            }
                            $relations[$parentId] = $childrenAliquot['AliquotMaster']['id'];
                            
                            $this->Realiquoting->set(array(
                                'Realiquoting' => $childrenAliquot['Realiquoting']
                            ));
                            if (! $this->Realiquoting->validates()) {
                                foreach ($this->Realiquoting->validationErrors as $field => $msgs) {
                                    $msgs = is_array($msgs) ? $msgs : array(
                                        $msgs
                                    );
                                    foreach ($msgs as $msg)
                                        $errors[$field][$msg][] = $recordCounter;
                                }
                            }
                            $childrenAliquot['Realiquoting'] = $this->Realiquoting->data['Realiquoting'];
                            
                            // Check volume can be completed
                            if ((! empty($childrenAliquot['Realiquoting']['parent_used_volume'])) && empty($childrenAliquot['GeneratedParentAliquot']['aliquot_volume_unit'])) {
                                // No volume has to be recored for this aliquot type
                                $errors['parent_used_volume']['no volume has to be recorded when the volume unit field is empty'][] = $recordCounter;
                            }
                        }
                        $validatedData[$parentId]['children'][$tmpId] = $childrenAliquot;
                    }
                }
                if (! $childrenHasBeenDefined) {
                    $errors[]['at least one child has to be defined'][] = $recordCounter;
                }
            }
            
            $this->request->data = $validatedData;
            
            if (empty($errors) && ! empty($labBookCode)) {
                // this time we do synchronize with the lab book
                foreach ($this->request->data as $key => &$newDataSet) {
                    $labBook->syncData($newDataSet['children'], array(
                        'Realiquoting'
                    ), $labBookCode);
                }
            }
            
            $this->AliquotMaster->addWritableField('current_volume');
            $this->Realiquoting->addWritableField(array(
                'parent_aliquot_master_id',
                'child_aliquot_master_id',
                'lab_book_master_id',
                'sync_with_lab_book'
            ));
            $this->Realiquoting->writableFieldsMode = 'addgrid';
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (empty($errors)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $newAliquotIds = array();
                
                // C- Save Process
                foreach ($this->request->data as $parentId => $parentAndChildren) {
                    
                    // Save parent aliquot data
                    
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $parentId;
                    
                    $parentData = $parentAndChildren['parent'];
                    if ($parentData['FunctionManagement']['remove_from_storage'] || ($parentData['AliquotMaster']['in_stock'] == 'no')) {
                        // Delete storage data
                        $parentData['AliquotMaster']['storage_master_id'] = null;
                        $parentData['AliquotMaster']['storage_coord_x'] = '';
                        $parentData['AliquotMaster']['storage_coord_y'] = '';
                        $this->AliquotMaster->addWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    } else {
                        $this->AliquotMaster->removeWritableField(array(
                            'storage_master_id',
                            'storage_coord_x',
                            'storage_coord_y'
                        ));
                    }
                    $parentData['AliquotMaster']['id'] = $parentId;
                    
                    if (! $this->AliquotMaster->save(array(
                        'AliquotMaster' => $parentData['AliquotMaster']
                    ), false)) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    // Save realiquoting data
                    foreach ($parentAndChildren['children'] as $childrenAliquotToSave) {
                        if ($childrenAliquotToSave['FunctionManagement']['use']) {
                            // save realiquoting
                            $childrenAliquotToSave['Realiquoting']['parent_aliquot_master_id'] = $parentId;
                            $childrenAliquotToSave['Realiquoting']['child_aliquot_master_id'] = $childrenAliquotToSave['AliquotMaster']['id'];
                            $childrenAliquotToSave['Realiquoting']['lab_book_master_id'] = $labBookId;
                            $childrenAliquotToSave['Realiquoting']['sync_with_lab_book'] = $syncWithLabBook;
                            
                            $this->Realiquoting->id = null;
                            $this->Realiquoting->data = null;
                            if (! $this->Realiquoting->save(array(
                                'Realiquoting' => $childrenAliquotToSave['Realiquoting']
                            ), false)) {
                                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                            
                            // Set data for batchset
                            $newAliquotIds[] = $childrenAliquotToSave['AliquotMaster']['id'];
                        }
                    }
                    
                    // Update parent aliquot current volume
                    
                    $this->AliquotMaster->updateAliquotVolume($parentId);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // redirect
                if ($aliquotMasterId == null) {
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquot'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->saveWithIds($batchSetData, $newAliquotIds);
                    $this->atimFlash(__('your data has been saved') . '<br>' . __('aliquot storage data were deleted (if required)'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                } else {
                    $aliquot = $this->AliquotMaster->findById($aliquotMasterId);
                    $aliquot = $aliquot['AliquotMaster'];
                    $this->atimFlash(__('your data has been saved') . '<br>' . __('aliquot storage data were deleted (if required)'), '/InventoryManagement/AliquotMasters/detail/' . $aliquot['collection_id'] . '/' . $aliquot['sample_master_id'] . '/' . $aliquot['id']);
                }
            } else {
                // Errors have been detected => rebuild form data
                $this->AliquotMaster->validationErrors = array();
                $this->AliquotDetail->validationErrors = array();
                $this->Realiquoting->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->AliquotMaster->validationErrors[$field][] = __($msg) . (empty($aliquotId) ? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
                    }
                }
            }
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function listAllRealiquotedParents($collectionId, $sampleMasterId, $aliquotMasterId)
    {
        // MANAGE DATA
        
        // Get the aliquot data
        $currentAliquotData = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $collectionId,
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                'AliquotMaster.id' => $aliquotMasterId
            )
        ));
        if (empty($currentAliquotData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get/Manage Parent Aliquots
        $this->request->data = $this->Realiquoting->find('all', array(
            
            'order' => 'Realiquoting.realiquoting_datetime DESC',
            'fields' => array(
                '*'
            ),
            'joins' => array(
                AliquotMaster::joinOnAliquotDup('Realiquoting.parent_aliquot_master_id'),
                AliquotMaster::$joinAliquotControlOnDup
            ),
            'conditions' => array(
                'Realiquoting.child_aliquot_master_id' => $aliquotMasterId
            )
        ));
        
        // Manage data to build URL to access la book
        $this->set('displayLabBookUrl', false);
        foreach ($this->request->data as &$newRecord) {
            $newRecord['Realiquoting']['generated_lab_book_master_id'] = '-1';
            if (array_key_exists('lab_book_master_id', $newRecord['Realiquoting']) && ! empty($newRecord['Realiquoting']['lab_book_master_id'])) {
                $newRecord['Realiquoting']['generated_lab_book_master_id'] = $newRecord['Realiquoting']['lab_book_master_id'];
            }
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object.
        $this->setAliquotMenu($currentAliquotData, true);
        
        // Set structure
        $this->Structures->set('realiquotedparent,realiquotedparent_vol');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $realiquotingId
     */
    public function editRealiquoting($realiquotingId)
    {
        $data = $this->Realiquoting->getOrRedirect($realiquotingId);
        $data['AliquotControl'] = $this->AliquotControl->getOrRedirect($data['AliquotMaster']['aliquot_control_id']);
        $data['AliquotControl'] = $data['AliquotControl']['AliquotControl'];
        
        $this->Structures->set(empty($data['AliquotControl']['volume_unit']) ? 'realiquotedparent' : 'realiquotedparent,realiquotedparent_vol');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($this->request->data) {
            $this->Realiquoting->id = $realiquotingId;
            $this->Realiquoting->data = array();
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($this->Realiquoting->save($this->request->data)) {
                $this->AliquotMaster->updateAliquotVolume($data['AliquotMaster']['id']);
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been saved'), '/InventoryManagement/AliquotMasters/detail/' . $data['AliquotMasterChildren']['collection_id'] . '/' . $data['AliquotMasterChildren']['sample_master_id'] . '/' . $data['AliquotMasterChildren']['id']);
            }
        } else {
            $this->request->data = $data;
        }
        
        $tmpSampleMasterRecursive = $this->SampleMaster->recursive;
        $this->SampleMaster->recursive = 0;
        $sample = $this->SampleMaster->getOrRedirect($data['AliquotMasterChildren']['sample_master_id']);
        $this->SampleMaster->recursive = $tmpSampleMasterRecursive;
        $this->setAliquotMenu(array(
            'AliquotMaster' => $data['AliquotMasterChildren'],
            'SampleMaster' => $sample['SampleMaster'],
            'SampleControl' => $sample['SampleControl']
        ), false);
        $this->set('realiquotingId', $realiquotingId);
    }

    /**
     *
     * @param $parentId
     * @param $childId
     * @param $source
     */
    public function deleteRealiquotingData($parentId, $childId, $source)
    {
        if ((! $parentId) || (! $childId) || (! $source)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get the realiquoting data
        $realiquotingData = $this->Realiquoting->find('first', array(
            'conditions' => array(
                'Realiquoting.parent_aliquot_master_id' => $parentId,
                'Realiquoting.child_aliquot_master_id' => $childId
            )
        ));
        if (empty($realiquotingData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $flashUrl = '';
        switch ($source) {
            case 'parent':
                $flashUrl = '/InventoryManagement/AliquotMasters/detail/' . $realiquotingData['AliquotMaster']['collection_id'] . '/' . $realiquotingData['AliquotMaster']['sample_master_id'] . '/' . $realiquotingData['AliquotMaster']['id'];
                break;
            case 'child':
                $flashUrl = '/InventoryManagement/AliquotMasters/detail/' . $realiquotingData['AliquotMasterChildren']['collection_id'] . '/' . $realiquotingData['AliquotMasterChildren']['sample_master_id'] . '/' . $realiquotingData['AliquotMasterChildren']['id'];
                break;
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->Realiquoting->allowDeletion($realiquotingData['Realiquoting']['id']);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->Realiquoting->atimDelete($realiquotingData['Realiquoting']['id'])) {
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if ($this->AliquotMaster->updateAliquotVolume($realiquotingData['AliquotMaster']['id'])) {
                    $this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), $flashUrl);
                } else {
                    $this->atimFlashError(__('error deleting data - contact administrator'), $flashUrl);
                }
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $flashUrl);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), $flashUrl);
        }
    }

    public function autocompleteBarcode()
    {
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        // query the database
        $term = str_replace(array(
            "\\",
            '%',
            '_'
        ), array(
            "\\\\",
            '\%',
            '\_'
        ), $_GET['term']);
        $data = $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.barcode LIKE' => '%' . $term . '%'
            ),
            'fields' => array(
                'AliquotMaster.barcode'
            ),
            'limit' => 10,
            'recursive' => - 1
        ));
        
        // build javascript textual array
        $result = "";
        foreach ($data as $dataUnit) {
            $result .= '"' . str_replace(array(
                '\\',
                '"'
            ), array(
                '\\\\',
                '\"'
            ), $dataUnit['AliquotMaster']['barcode']) . '", ';
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        $this->set('result', "[" . $result . "]");
    }

    /**
     *
     * @param $collectionId
     * @param $aliquotMasterId
     * @param bool $isAjax
     */
    public function contentTreeView($collectionId, $aliquotMasterId, $isAjax = false)
    {
        if (! $collectionId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($isAjax) {
            $this->layout = 'ajax';
            Configure::write('debug', 0);
        }
        
        $atimStructure['AliquotMaster'] = $this->Structures->get('form', 'aliquot_masters_for_collection_tree_view,realiquoting_data_for_collection_tree_view');
        $atimStructure['ViewAliquotUse'] = $this->Structures->get('form', 'viewaliquotuses_for_collection_tree_view');
        ;
        $this->set('atimStructure', $atimStructure);
        
        $this->set("collectionId", $collectionId);
        $this->set("isAjax", $isAjax);
        
        // Unbind models
        $this->SampleMaster->unbindModel(array(
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
        ), false);
        $this->AliquotMaster->unbindModel(array(
            'belongsTo' => array(
                'Collection',
                'SampleMaster'
            ),
            'hasOne' => array(
                'SpecimenDetail'
            )
        ), false);
        
        // Get list of children aliquot realiquoted from studied aliquot
        $realiquotingDataFromChildIds = array(
            '-1' => array()
        ); // counters Eventum 1353
        foreach ($this->Realiquoting->find('all', array(
            'conditions' => array(
                'Realiquoting.parent_aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        )) as $newRealiquotingData)
            $realiquotingDataFromChildIds[$newRealiquotingData['Realiquoting']['child_aliquot_master_id']] = $newRealiquotingData;
        $this->request->data = $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.id' => array_keys($realiquotingDataFromChildIds),
                'AliquotMaster.collection_id' => $collectionId
            )
        ));
        foreach ($this->request->data as &$newChildrenAliquotData) {
            $newChildrenAliquotData = array_merge($newChildrenAliquotData, $realiquotingDataFromChildIds[$newChildrenAliquotData['AliquotMaster']['id']]);
        }
        
        // Get list of realiquoted children having been realiquoted too: To disable or not the expand icon
        $aliquotIdsHavingChild = array_flip($this->AliquotMaster->hasChild(array_keys($realiquotingDataFromChildIds)));
        $tmaBlockStorageControlIds = array();
        $storageControlModel = AppModel::getInstance("StorageLayout", "StorageControl", true);
        foreach ($this->request->data as &$aliquot) {
            $aliquot['children'] = array_key_exists($aliquot['AliquotMaster']['id'], $aliquotIdsHavingChild);
            $aliquot['css'][] = $aliquot['AliquotMaster']['in_stock'] == 'no' ? 'disabled' : '';
            // Check aliquot is a TMA core, - To change 'aliquot' icon to 'Tma Block' icon
            if ($aliquot['ViewAliquot']['aliquot_type'] == 'core' && $aliquot['StorageMaster']['id']) {
                if (! array_key_exists($aliquot['StorageMaster']['storage_control_id'], $tmaBlockStorageControlIds)) {
                    $tmaBlockStorageControlIds[$aliquot['StorageMaster']['storage_control_id']] = $storageControlModel->find('count', array(
                        'conditions' => array(
                            'StorageControl.id' => $aliquot['StorageMaster']['storage_control_id'],
                            'StorageControl.is_tma_block' => 1
                        )
                    ));
                }
                if ($tmaBlockStorageControlIds[$aliquot['StorageMaster']['storage_control_id']]) {
                    $aliquot = array_merge(array(
                        'TmaBlock' => $aliquot['StorageMaster']
                    ), $aliquot);
                }
            }
        }
        
        // Get list of aliquot uses
        $tmpAliquotUses = $this->ViewAliquotUse->find('all', array(
            'conditions' => array(
                'ViewAliquotUse.aliquot_master_id' => $aliquotMasterId,
                "ViewAliquotUse.use_definition !='realiquoted to'"
            ),
            'order' => array(
                'ViewAliquotUse.use_datetime ASC'
            )
        ));
        $aliquotUses = array();
        foreach ($tmpAliquotUses as $newAliquotUse) {
            $model = null;
            switch ($newAliquotUse['ViewAliquotUse']['use_definition']) {
                case 'quality control':
                    $model = 'QualityCtrl';
                    break;
                case 'specimen review':
                    $model = 'SpecimenReviewMaster';
                    break;
                case 'order preparation':
                    $model = 'OrderItem';
                    break;
                case 'aliquot shipment':
                    $model = 'Shipment';
                    break;
                case 'shipped aliquot return':
                    $model = 'OrderItemReturn';
                    break;
                default:
                    $model = preg_match('/^sample\ derivative\ creation.+$/', $newAliquotUse['ViewAliquotUse']['use_definition']) ? 'SampleMaster' : 'AliquotInternalUse';
            }
            $newAliquotUse = array_merge(array(
                $model => array()
            ), $newAliquotUse);
            preg_match('/^\/([A-Za-z\_\/]+)\/([0-9\/]+)$/', $newAliquotUse['ViewAliquotUse']['detail_url'], $matches);
            $newAliquotUse['FunctionManagement']['url_ids'] = $matches[2];
            $newAliquotUse['children'] = array();
            $newAliquotUse['css'][] = 'sample_disabled';
            $aliquotUses[] = $newAliquotUse;
        }
        $this->request->data = array_merge($this->request->data, $aliquotUses);
        
        $sortedData = array();
        $counter = 0;
        $padLength = strlen(sizeof($this->request->data));
        foreach ($this->request->data as $newRecord) {
            $counter ++;
            $dateKey = str_pad($counter, $padLength, "0", STR_PAD_LEFT);
            if (isset($newRecord['ViewAliquotUse']['use_datetime'])) {
                $dateKey = $newRecord['ViewAliquotUse']['use_datetime'] . $dateKey;
                $newRecord['ViewAliquotUse']['use_datetime_accuracy'] = str_replace(array(
                    '',
                    'c',
                    'i'
                ), array(
                    'h',
                    'h',
                    'h'
                ), $newRecord['ViewAliquotUse']['use_datetime_accuracy']);
            } elseif (isset($newRecord['Realiquoting']['realiquoting_datetime'])) {
                $dateKey = $newRecord['Realiquoting']['realiquoting_datetime'] . $dateKey;
                $newRecord['Realiquoting']['realiquoting_datetime_accuracy'] = str_replace(array(
                    '',
                    'c',
                    'i'
                ), array(
                    'h',
                    'h',
                    'h'
                ), $newRecord['Realiquoting']['realiquoting_datetime_accuracy']);
            } else {
                $dateKey = '0000-00-00 00:00:00' . $dateKey;
            }
            $sortedData[$dateKey] = $newRecord;
        }
        ksort($sortedData);
        $this->request->data = $sortedData;
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function editInBatch()
    {
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/Collections/search'));
        $this->Structures->set('aliquot_master_edit_in_batchs');
        
        $urlToCancel = AppController::getCancelLink($this->request->data);
        
        // Check limit of processed aliquots
        $displayLimit = Configure::read('AliquotModification_processed_items_limit');
        if (isset($this->request->data['ViewAliquot']['aliquot_master_id']) && sizeof(array_filter($this->request->data['ViewAliquot']['aliquot_master_id'])) > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        
        if (isset($this->request->data['aliquot_ids'])) {
            $aliquotIds = explode(',', $this->request->data['aliquot_ids']);
            list ($aliquotMasterDataToUpdate, $validates, $positionDeletionWarningMessage) = $this->AliquotMaster->validateAliquotMasterDataUpdateInBatch($this->request->data['FunctionManagement'], $this->request->data['AliquotMaster'], $aliquotIds);
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($validates) {
                if ($aliquotMasterDataToUpdate['AliquotMaster']) {
                    
                    AppModel::acquireBatchViewsUpdateLock();
                    
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    
                    $this->AliquotMaster->addWritableField(array(
                        'in_stock'
                    ));
                    
                    foreach ($aliquotIds as $aliquotId) {
                        $this->AliquotMaster->id = $aliquotId;
                        $this->AliquotMaster->data = null;
                        $this->AliquotMaster->save($aliquotMasterDataToUpdate, false);
                    }
                    
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('ViewAliquot'),
                            'flag_tmp' => true
                        )
                    );
                    
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $aliquotIds);
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    AppModel::releaseBatchViewsUpdateLock();
                    
                    if ($positionDeletionWarningMessage)
                        AppController::addWarningMsg(__($positionDeletionWarningMessage));
                    
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                } else {
                    $this->AliquotMaster->validationErrors[][] = 'you need to at least update a value';
                    $this->request->data['ViewAliquot']['aliquot_master_id'] = $aliquotIds;
                    $this->set('cancelLink', $this->request->data['cancel_link']);
                }
            }
        } elseif (! isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
            return;
        } elseif ($this->request->data['ViewAliquot']['aliquot_master_id'] == 'all' && isset($this->request->data['node'])) {
            $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
            $browsingResult = $this->BrowsingResult->find('first', array(
                'conditions' => array(
                    'BrowsingResult.id' => $this->request->data['node']['id']
                )
            ));
            $this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
        }
        
        $this->set('cancelLink', $urlToCancel);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * List all aliquot uses
     *
     * @param int $collectionId
     * @param int $sampleMasterId
     * @param int $aliquotMasterId
     * @param bool $isFromTreeView
     */
    public function listallUses($collectionId, $sampleMasterId, $aliquotMasterId, $isFromTreeView = false)
    {
        $aliquot = $this->AliquotMaster->getOrRedirect($aliquotMasterId);
        if ($aliquot['AliquotMaster']['sample_master_id'] != $sampleMasterId || $aliquot['AliquotMaster']['collection_id'] != $collectionId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $this->ViewAliquotUse->find('all', array(
            'conditions' => array(
                'ViewAliquotUse.aliquot_master_id' => $aliquotMasterId
            )
        ));
        $this->Structures->set('viewaliquotuses');
        $this->set('isFromTreeView', $isFromTreeView);
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        $this->render('listall_uses');
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $aliquotMasterId
     */
    public function storageHistory($collectionId, $sampleMasterId, $aliquotMasterId)
    {
        $aliquot = $this->AliquotMaster->getOrRedirect($aliquotMasterId);
        if ($aliquot['AliquotMaster']['sample_master_id'] != $sampleMasterId || $aliquot['AliquotMaster']['collection_id'] != $collectionId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->AliquotMaster->getStorageHistory($aliquotMasterId);
        $this->Structures->set('custom_aliquot_storage_history');
        $hookLink = $this->hook();
        if ($hookLink) {
            require ($hookLink);
        }
    }

    public function printBarcodes()
    {
        $this->layout = false;
        Configure::write('debug', 0);
        $conditions = array();
        
        switch ($this->passedArgs['model']) {
            case 'Collection':
                $conditions['AliquotMaster.collection_id'] = isset($this->request->data['ViewCollection']['collection_id']) ? $this->request->data['ViewCollection']['collection_id'] : $this->passedArgs['id'];
                if ($conditions['AliquotMaster.collection_id'] == 'all' && isset($this->request->data['node'])) {
                    $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                    $browsingResult = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $this->request->data['node']['id']
                        )
                    ));
                    $conditions['AliquotMaster.collection_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
                }
                break;
            case 'SampleMaster':
                $conditions['AliquotMaster.sample_master_id'] = isset($this->request->data['ViewSample']['sample_master_id']) ? $this->request->data['ViewSample']['sample_master_id'] : $this->passedArgs['id'];
                if ($conditions['AliquotMaster.sample_master_id'] == 'all' && isset($this->request->data['node'])) {
                    $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                    $browsingResult = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $this->request->data['node']['id']
                        )
                    ));
                    $conditions['AliquotMaster.sample_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
                }
                break;
            case 'AliquotMaster':
            default:
                $conditions['AliquotMaster.id'] = isset($this->request->data['ViewAliquot']['aliquot_master_id']) ? $this->request->data['ViewAliquot']['aliquot_master_id'] : $this->passedArgs['id'];
                if ($conditions['AliquotMaster.id'] == 'all' && isset($this->request->data['node'])) {
                    $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                    $browsingResult = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $this->request->data['node']['id']
                        )
                    ));
                    $conditions['AliquotMaster.id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
                }
                break;
        }
        
        $this->Structures->set('aliquot_barcode', 'result_structure');
        $this->set('csvHeader', true);
        $offset = 0;
        AppController::atimSetCookie(false);
        $atLeastOnce = false;
        $aliquotsCount = $this->AliquotMaster->find('count', array(
            'conditions' => $conditions,
            'limit' => 1000,
            'offset' => $offset
        ));
        $displayLimit = Configure::read('AliquotBarcodePrint_processed_items_limit');
        if ($aliquotsCount > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", "javascript:history.back();");
            return;
        }
        while ($this->request->data = $this->AliquotMaster->find('all', array(
            'conditions' => $conditions,
            'limit' => 300,
            'offset' => $offset
        ))) {
            $this->render('../../../Datamart/View/Csv/csv');
            $this->set('csvHeader', false);
            $offset += 300;
            $atLeastOnce = true;
        }
        if ($atLeastOnce) {
            $this->render(false);
        } else {
            $this->atimFlashWarning(__('there are no barcodes to print'), 'javascript:history.back();');
        }
        
        $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
    }
}