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
 * Class OrderItemsController
 */
class OrderItemsController extends OrderAppController
{

    public $components = array();

    public $uses = array(
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.ViewAliquot',
        
        'StorageLayout.TmaSlide',
        
        'Order.Order',
        'Order.OrderLine',
        'Order.OrderItem',
        
        'Order.Shipment'
    );

    public $paginate = array(
        'OrderItem' => array(
            'order' => 'AliquotMaster.barcode'
        ),
        'ViewAliquot' => array(
            'order' => 'ViewAliquot.barcode DESC'
        ),
        'AliquotMaster' => array(
            'order' => 'AliquotMaster.barcode DESC'
        ),
        'TmaSlide' => array(
            'order' => 'TmaSlide.barcode DESC'
        )
    );

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/Order/Orders/search'));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->OrderItem, 'orderitems', '/InventoryManagement/OrderItems/search');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }

    /**
     *
     * @param $orderId
     * @param string $status
     * @param null $orderLineId
     * @param null $shipmentId
     * @param null $mainFormModel
     */
    public function listall($orderId, $status = 'all', $orderLineId = null, $shipmentId = null, $mainFormModel = null)
    {
        // MANAGE DATA
        if ($orderLineId && $shipmentId)
            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        if ($orderLineId) {
            // List all items of an order line
            $orderLineData = $this->OrderLine->find('first', array(
                'conditions' => array(
                    'OrderLine.id' => $orderLineId,
                    'OrderLine.order_id' => $orderId
                ),
                'recursive' => - 1
            ));
            if (empty($orderLineData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } elseif ($shipmentId) {
            // List all items linked to a shipment
            $shipmentData = $this->Shipment->find('first', array(
                'conditions' => array(
                    'Shipment.id' => $shipmentId,
                    'Shipment.order_id' => $orderId
                ),
                'recursive' => - 1
            ));
            if (empty($shipmentData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } else {
            // List all items of an order
            $orderData = $this->Order->find('first', array(
                'conditions' => array(
                    'Order.id' => $orderId
                ),
                'recursive' => - 1
            ));
            if (empty($orderData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        
        // Set data
        $conditions = array(
            'OrderItem.order_id' => $orderId
        );
        if ($orderLineId) {
            $conditions['OrderItem.order_line_id'] = $orderLineId;
        } elseif ($shipmentId) {
            $conditions['OrderItem.shipment_id'] = $shipmentId;
        }
        if (in_array($status, array(
            'pending',
            'shipped',
            'shipped & returned'
        ))) {
            $conditions['OrderItem.status'] = $status;
        }
        $this->request->data = $this->paginate($this->OrderItem, $conditions);
        
        foreach ($this->request->data as &$newItem) {
            if ($newItem['AliquotMaster']['id']) {
                $newItem['Generated']['item_detail_link'] = '/InventoryManagement/AliquotMasters/detail/' . $newItem['AliquotMaster']['collection_id'] . '/' . $newItem['AliquotMaster']['sample_master_id'] . '/' . $newItem['AliquotMaster']['id'];
            } else {
                $newItem['Generated']['item_detail_link'] = '/StorageLayout/TmaSlides/detail/' . $newItem['TmaSlide']['tma_block_storage_master_id'] . '/' . $newItem['TmaSlide']['id'];
            }
        }
        
        $this->set('status', $status);
        $this->set('orderLineId', $orderLineId);
        $this->set('shipmentId', $shipmentId);
        $this->set('mainFormModel', $mainFormModel);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->Structures->set('orderitems,orderitems_plus' . (($orderLineId || Configure::read('order_item_to_order_objetcs_link_setting') == 3) ? '' : ',orderitems_and_lines'));
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'OrderLine.id' => $orderLineId
        ));
        
        $this->set('atimMenu', $this->Menus->get('/Order/Orders/search'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * Liste all order items linked to the same object (AliquotMaster or TmaSlide)
     *
     * @param unknown $objectModelName Name of the model of the studied object (AliquotMaster, TmaSlide)
     * @param unknown $objectId Id of the boject
     */
    public function listAllOrderItemsLinkedToOneObject($objectModelName, $objectId)
    {
        if (! in_array($objectModelName, array(
            'AliquotMaster',
            'TmaSlide'
        )))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $foreignKeyField = str_replace(array(
            'AliquotMaster',
            'TmaSlide'
        ), array(
            'aliquot_master_id',
            'tma_slide_id'
        ), $objectModelName);
        
        // MANAGE DATA
        
        $this->OrderItem->bindModel(array(
            'belongsTo' => array(
                'Order' => array(
                    'className' => 'StorageLayout.Order',
                    'foreignKey' => 'order_id'
                )
            )
        ));
        $this->request->data = $this->paginate($this->OrderItem, array(
            "OrderItem.$foreignKeyField" => $objectId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Order/Orders/search'));
        $this->set('atimMenuVariables', array());
        
        // Set structure
        $this->Structures->set('orders_short,orderitems' . (Configure::read('order_item_to_order_objetcs_link_setting') == 3 ? '' : ',orderitems_and_lines'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $orderId
     * @param int $orderLineId
     * @param string $objectModelName
     */
    public function add($orderId, $orderLineId = 0, $objectModelName = 'AliquotMaster')
    {
        if ((! $orderId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (Configure::read('order_item_to_order_objetcs_link_setting') == 2 && ! $orderLineId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! in_array($objectModelName, array(
            'AliquotMaster',
            'TmaSlide'
        )))
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (Configure::read('order_item_type_config') == 2 && $objectModelName == 'TmaSlide') {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (Configure::read('order_item_type_config') == 3 && $objectModelName == 'AliquotMaster') {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        $orderData = array();
        $orderLineData = array();
        if (! $orderLineId) {
            $orderData = $this->Order->getOrRedirect($orderId);
        } else {
            $orderLineData = $this->OrderLine->getOrRedirect($orderLineId);
            $orderData = array(
                'Order' => $orderLineData['Order']
            );
        }
        
        $this->set('objectModelName', $objectModelName);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get($orderLineId ? '/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/' : '/Order/Orders/detail/%%Order.id%%/'));
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'OrderLine.id' => $orderLineId
        ));
        
        $this->Structures->set('orderitems,' . (($objectModelName == 'AliquotMaster') ? 'addaliquotorderitems' : 'addtmaslideorderitems'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = array(
                array()
            );
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $errorsTracking = array();
            
            // Validation
            
            $displayLimit = Configure::read('AddToOrder_processed_items_limit');
            if (sizeof($this->request->data) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", ($orderLineId ? '/Order/OrderLines/detail/' . $orderId . '/' . $orderLineId . '/' : '/Order/Orders/detail/' . $orderId));
                return;
            }
            
            $rowCounter = 0;
            $barcodesRecorded = array();
            foreach ($this->request->data as &$dataUnit) {
                $rowCounter ++;
                $this->OrderItem->id = null;
                $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->OrderItem->set($dataUnit);
                if (! $this->OrderItem->validates()) {
                    foreach ($this->OrderItem->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errorsTracking[$field][$msg][] = $rowCounter;
                    }
                }
                if ($objectModelName == 'AliquotMaster') {
                    // Check aliquot exists
                    $aliquotData = $this->AliquotMaster->find('first', array(
                        'conditions' => array(
                            'AliquotMaster.barcode' => $dataUnit['AliquotMaster']['barcode']
                        ),
                        'recursive' => - 1
                    ));
                    if (! $aliquotData) {
                        $errorsTracking['barcode']['barcode is required and should exist'][] = $rowCounter;
                    } else {
                        $this->OrderItem->data['OrderItem']['aliquot_master_id'] = $aliquotData['AliquotMaster']['id'];
                    }
                    // Check aliquot is not already assigned to an order with a 'pending' or 'shipped' status
                    if ($aliquotData && ! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $aliquotData['AliquotMaster']['id'])) {
                        $errorsTracking['barcode']["an aliquot cannot be added twice to orders as long as this one has not been first returned"][] = $rowCounter;
                    }
                    // Check aliquot has not be enterred twice
                    if (in_array($dataUnit['AliquotMaster']['barcode'], $barcodesRecorded))
                        $errorsTracking['barcode']['an aliquot can only be added once to an order'][] = $rowCounter;
                    $barcodesRecorded[] = $dataUnit['AliquotMaster']['barcode'];
                } else {
                    // Check tma slide exists
                    $slideData = $this->TmaSlide->find('first', array(
                        'conditions' => array(
                            'TmaSlide.barcode' => $dataUnit['TmaSlide']['barcode']
                        ),
                        'recursive' => - 1
                    ));
                    if (! $slideData) {
                        $errorsTracking['barcode']['a tma slide barcode is required and should exist'][] = $rowCounter;
                    } else {
                        $this->OrderItem->data['OrderItem']['tma_slide_id'] = $slideData['TmaSlide']['id'];
                    }
                    // Check tma slide is not already assigned to an order with a 'pending' or 'shipped' status
                    if ($slideData && ! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $slideData['TmaSlide']['id'])) {
                        $errorsTracking['barcode']["a tma slide cannot be added twice to orders as long as this one has not been first returned"][] = $rowCounter;
                    }
                    // Check tma slide has not be enterred twice
                    if (in_array($dataUnit['TmaSlide']['barcode'], $barcodesRecorded))
                        $errorsTracking['barcode']['a tma slide can only be added once to an order'][] = $rowCounter;
                    $barcodesRecorded[] = $dataUnit['TmaSlide']['barcode'];
                }
                // Reset data
                $dataUnit = $this->OrderItem->data;
            }
            unset($dataUnit);
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // Launch Save Process
            
            if (empty($errorsTracking)) {
                $this->OrderItem->addWritableField(array(
                    'status',
                    'order_id',
                    'order_line_id',
                    'aliquot_master_id',
                    'tma_slide_id'
                ));
                if ($objectModelName == 'AliquotMaster') {
                    $this->AliquotMaster->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                } else {
                    $this->TmaSlide->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                }
                AppModel::acquireBatchViewsUpdateLock();
                // save all
                foreach ($this->request->data as $newDataToSave) {
                    // Order Item Data to save
                    $newDataToSave['OrderItem']['status'] = 'pending';
                    $newDataToSave['OrderItem']['order_id'] = $orderId;
                    if ($orderLineId)
                        $newDataToSave['OrderItem']['order_line_id'] = $orderLineId;
                        // Save new recrod
                    $this->OrderItem->id = null;
                    $this->OrderItem->data = array();
                    if (! $this->OrderItem->save($newDataToSave, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    if ($objectModelName == 'AliquotMaster') {
                        // Update aliquot master status
                        $newAliquotMasterData = array();
                        $newAliquotMasterData['AliquotMaster']['in_stock'] = 'yes - not available';
                        $newAliquotMasterData['AliquotMaster']['in_stock_detail'] = 'reserved for order';
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->AliquotMaster->id = $newDataToSave['OrderItem']['aliquot_master_id'];
                        if (! $this->AliquotMaster->save($newAliquotMasterData))
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    } else {
                        // Update tma slide status
                        $newTmaSlideData = array();
                        $newTmaSlideData['TmaSlide']['in_stock'] = 'yes - not available';
                        $newTmaSlideData['TmaSlide']['in_stock_detail'] = 'reserved for order';
                        $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->TmaSlide->id = $newDataToSave['OrderItem']['tma_slide_id'];
                        if (! $this->TmaSlide->save($newTmaSlideData))
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                if ($orderLineId) {
                    // Update Order Line status
                    $newOrderLineData = array();
                    $newOrderLineData['OrderLine']['status'] = 'pending';
                    $this->OrderLine->addWritableField(array(
                        'status'
                    ));
                    $this->OrderLine->id = $orderLineData['OrderLine']['id'];
                    if (! $this->OrderLine->save($newOrderLineData))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                $this->atimFlash(__('your data has been saved'), $orderLineId ? '/Order/OrderLines/detail/' . $orderId . '/' . $orderLineId . '/' : '/Order/Orders/detail/' . $orderId);
            } else {
                $this->OrderItem->validationErrors = array();
                foreach ($errorsTracking as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->OrderItem->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                    }
                }
            }
        }
    }

    /**
     *
     * @deprecated Replaced by addOrderItemsInBatch()
     * @param null $aliquotMasterId
     */
    public function addAliquotsInBatch($aliquotMasterId = null)
    {
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }

    /**
     *
     * @param $objectModelName
     * @param null $objectId
     */
    public function addOrderItemsInBatch($objectModelName, $objectId = null)
    {
        // MANAGE DATA
        if (! in_array($objectModelName, array(
            'AliquotMaster',
            'TmaSlide'
        ))) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (Configure::read('order_item_type_config') == 2 && $objectModelName == 'TmaSlide') {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (Configure::read('order_item_type_config') == 3 && $objectModelName == 'AliquotMaster') {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        $objectIdsToAdd = null;
        $initialDisplay = false;
        
        if (! empty($objectId)) {
            // Just clicked on 'add to order' button of the aliquot or tma slide form
            $objectIdsToAdd[] = $objectId;
            $initialDisplay = true;
        } elseif (isset($this->request->data[$objectModelName]) || isset($this->request->data['ViewAliquot'])) {
            // Just launched process from batchset
            if (isset($this->request->data[$objectModelName])) {
                $objectIdsToAdd = $this->request->data[$objectModelName]['id'];
            } else {
                $objectIdsToAdd = $this->request->data['ViewAliquot']['aliquot_master_id'];
            }
            if ($objectIdsToAdd == 'all' && isset($this->request->data['node'])) {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $objectIdsToAdd = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $objectIdsToAdd = array_filter($objectIdsToAdd);
            $initialDisplay = true;
        } elseif (isset($this->request->data['object_ids_to_add'])) {
            // User just clicked on submit button
            $objectIdsToAdd = explode(',', $this->request->data['object_ids_to_add']);
            unset($this->request->data['object_ids_to_add']);
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        
        // Get Aliquot or TMA Slide data
        $newItemsData = $this->{$objectModelName}->find('all', array(
            'conditions' => array(
                "$objectModelName.id" => $objectIdsToAdd
            )
        ));
        $displayLimit = Configure::read('AddToOrder_processed_items_limit');
        if (empty($newItemsData)) {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        } elseif (sizeof($newItemsData) > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        if (sizeof($newItemsData) != sizeof($objectIdsToAdd)) {
            // In case an order item has just been deleted by another user before we submitted updated data
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Check new item is not already assigned to an order with a 'pending' or 'shipped' status
        foreach ($newItemsData as $newItem) {
            if ($objectModelName == 'AliquotMaster') {
                if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $newItem['AliquotMaster']['id'])) {
                    $this->atimFlashWarning(__("an aliquot cannot be added twice to orders as long as this one has not been first returned"), $urlToCancel);
                    return;
                }
            } else {
                if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $newItem['TmaSlide']['id'])) {
                    $this->atimFlashWarning(__("a tma slide cannot be added twice to orders as long as this one has not been first returned"), $urlToCancel);
                    return;
                }
            }
        }
        // Sort new items
        $this->{$objectModelName}->sortForDisplay($newItemsData, $objectIdsToAdd);
        
        $this->set('newItemsData', $newItemsData);
        $this->set('objectModelName', $objectModelName);
        $this->set('objectIdsToAdd', implode(',', $objectIdsToAdd));
        $this->set('urlToCancel', $urlToCancel);
        
        // warn unconsented aliquots
        if ($objectModelName == 'AliquotMaster') {
            $unconsentedAliquots = $this->AliquotMaster->getUnconsentedAliquots(array(
                'id' => $objectIdsToAdd
            ));
            if (! empty($unconsentedAliquots)) {
                AppController::addWarningMsg(__('this list contains aliquot(s) without a proper consent') . " (" . count($unconsentedAliquots) . ")");
            }
        }
        
        // Build data for order and order line selection
        $orderAndOrderLineData = array();
        $this->Order->unbindModel(array(
            'hasMany' => array(
                'OrderLine',
                'Shipment'
            )
        ));
        $orderDataTmp = $this->Order->find('all', array(
            'conditions' => array(
                'NOT' => array(
                    'Order.processing_status' => array(
                        'completed'
                    )
                )
            ),
            'order' => 'Order.order_number ASC'
        ));
        if (! $orderDataTmp) {
            $this->atimFlashWarning(__('no order to complete is actually defined'), $urlToCancel);
            return;
        }
        foreach ($orderDataTmp as $newOrder) {
            $orderId = $newOrder['Order']['id'];
            $newOrder['Generated']['order_and_order_line_ids'] = "$orderId|";
            if (isset($this->request->data['FunctionManagement']['selected_order_and_order_line_ids']) && ($this->request->data['FunctionManagement']['selected_order_and_order_line_ids'] == $newOrder['Generated']['order_and_order_line_ids'])) {
                $newOrder['FunctionManagement']['selected_order_and_order_line_ids'] = $this->request->data['FunctionManagement']['selected_order_and_order_line_ids'];
            }
            $orderAndOrderLineData[$orderId] = array(
                'order' => array(
                    $newOrder
                ),
                'lines' => array()
            );
        }
        $this->OrderLine->unbindModel(array(
            'belongsTo' => array(
                'Order'
            )
        ));
        $orderLineDataTmp = $this->OrderLine->find('all', array(
            'conditions' => array(
                'OrderLine.order_id' => array_keys($orderAndOrderLineData)
            ),
            'order' => 'OrderLine.date_required ASC'
        ));
        if (! $orderLineDataTmp && (Configure::read('order_item_to_order_objetcs_link_setting') == 2)) {
            $this->atimFlashWarning(__('no order to complete is actually defined'), $urlToCancel);
            return;
        }
        foreach ($orderLineDataTmp as $newLine) {
            $newLine['Generated']['order_and_order_line_ids'] = $newLine['OrderLine']['order_id'] . '|' . $newLine['OrderLine']['id'];
            unset($newLine['OrderItem']);
            if (isset($this->request->data['FunctionManagement']['selected_order_and_order_line_ids']) && ($this->request->data['FunctionManagement']['selected_order_and_order_line_ids'] == $newLine['Generated']['order_and_order_line_ids'])) {
                $newLine['FunctionManagement']['selected_order_and_order_line_ids'] = $this->request->data['FunctionManagement']['selected_order_and_order_line_ids'];
            }
            $orderAndOrderLineData[$newLine['OrderLine']['order_id']]['lines'][] = $newLine;
        }
        $this->set('orderAndOrderLineData', $orderAndOrderLineData);
        $this->set('itemToOrderDirectLinkAllowed', true);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Structures
        $this->Structures->set(($objectModelName == 'AliquotMaster' ? 'view_aliquot_joined_to_sample_and_collection' : 'tma_blocks_for_slide_creation,tma_slides'), 'atim_structure_for_new_items_list');
        $this->Structures->set('orderitems_to_addAliquotsInBatch', 'atim_structure_orderitems_data');
        $this->Structures->set('orderlines', 'atim_structure_order_line');
        $this->Structures->set('orders', 'atim_structure_order');
        
        // Menu
        $this->set('atimMenu', $this->Menus->get("/Order/Orders/search/"));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE DATA
        
        if ($initialDisplay) {
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // SAVE
            
            // Launch validations
            $submittedDataValidates = true;
            
            // Launch validation on order or order line selected data
            $orderId = null;
            $orderLineId = null;
            if (empty($this->request->data['FunctionManagement']['selected_order_and_order_line_ids'])) {
                $submittedDataValidates = false;
                $this->OrderItem->validationErrors[][] = __("a valid order or order line has to be selected");
            } elseif (preg_match('/^([0-9]+)\|([0-9]*)$/', $this->request->data['FunctionManagement']['selected_order_and_order_line_ids'], $orderAndOrderLineIds)) {
                $orderId = $orderAndOrderLineIds[1];
                $orderLineId = $orderAndOrderLineIds[2];
                if ($orderLineId) {
                    if (! $this->OrderLine->find('count', array(
                        'conditions' => array(
                            'OrderLine.order_id' => $orderId,
                            'OrderLine.id' => $orderLineId
                        ),
                        'recursive' => - 1
                    ))) {
                        $submittedDataValidates = false;
                        $this->OrderItem->validationErrors[][] = __("a valid order or order line has to be selected");
                    }
                } else {
                    if (! $this->Order->find('count', array(
                        'conditions' => array(
                            'Order.id' => $orderId
                        ),
                        'recursive' => - 1
                    ))) {
                        $submittedDataValidates = false;
                        $this->OrderItem->validationErrors[][] = __("a valid order or order line has to be selected");
                    }
                }
                $this->request->data['OrderItem']['order_id'] = $orderId;
                $this->request->data['OrderItem']['order_line_id'] = $orderLineId;
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            // Launch validation on order item data
            $this->OrderItem->set($this->request->data);
            $submittedDataValidates = ($this->OrderItem->validates()) ? $submittedDataValidates : false;
            $this->request->data = $this->OrderItem->data;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->OrderItem->addWritableField(array(
                    'order_id',
                    'order_line_id',
                    'status',
                    'aliquot_master_id',
                    'tma_slide_id'
                ));
                foreach ($objectIdsToAdd as $addedId) {
                    // Add order item
                    $newOrderItemData = array();
                    $newOrderItemData['OrderItem']['status'] = 'pending';
                    $newOrderItemData['OrderItem'][($objectModelName == 'AliquotMaster') ? 'aliquot_master_id' : 'tma_slide_id'] = $addedId;
                    $newOrderItemData['OrderItem'] = array_merge($newOrderItemData['OrderItem'], $this->request->data['OrderItem']);
                    $this->OrderItem->data = null;
                    $this->OrderItem->id = null;
                    if (! $this->OrderItem->save($newOrderItemData, false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    if ($objectModelName == 'AliquotMaster') {
                        // Update aliquot master status
                        $newAliquotMasterData = array();
                        $newAliquotMasterData['AliquotMaster']['in_stock'] = 'yes - not available';
                        $newAliquotMasterData['AliquotMaster']['in_stock_detail'] = 'reserved for order';
                        $this->AliquotMaster->addWritableField(array(
                            'in_stock',
                            'in_stock_detail'
                        ));
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->AliquotMaster->id = $addedId;
                        if (! $this->AliquotMaster->save($newAliquotMasterData)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    } else {
                        // Update tma slide status
                        $newTmaSlideData = array();
                        $newTmaSlideData['TmaSlide']['in_stock'] = 'yes - not available';
                        $newTmaSlideData['TmaSlide']['in_stock_detail'] = 'reserved for order';
                        $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->TmaSlide->id = $addedId;
                        if (! $this->TmaSlide->save($newTmaSlideData))
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                // Update Order Line status
                if ($orderLineId) {
                    $newOrderLineData = array();
                    $newOrderLineData['OrderLine']['status'] = 'pending';
                    $this->OrderLine->addWritableField(array(
                        'status'
                    ));
                    $this->OrderLine->id = $orderLineId;
                    if (! $this->OrderLine->save($newOrderLineData)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // Redirect
                $this->atimFlash(__('your data has been saved'), (! $orderLineId) ? "/Order/Orders/detail/$orderId/" : "/Order/OrderLines/detail/$orderId/$orderLineId/");
            }
        }
    }

    /**
     *
     * @param $orderId
     * @param $orderItemId
     * @param null $mainFormModel
     *
     * @deprecated Replaced by editInBatch function on 2018-07-09
     */
    public function edit($orderId, $orderItemId, $mainFormModel = null)
    {
        if ((! $orderId) || (! $orderItemId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        $orderItemData = $this->OrderItem->find('first', array(
            'conditions' => array(
                'OrderItem.id' => $orderItemId,
                'OrderItem.order_id' => $orderId
            )
        ));
        if (empty($orderItemData))
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $urlToRedirect = '/Order/OrderItems/editInBatch/' . $orderItemData['OrderItem']['order_id'] . '/0/0/' . $orderItemId;
        switch ($mainFormModel) {
            case 'OrderLine':
                $urlToRedirect = '/Order/OrderItems/editInBatch/' . $orderItemData['OrderItem']['order_id'] . '/' . $orderItemData['OrderItem']['order_line_id'] . '/0/' . $orderItemId;
                break;
            case 'Shipment':
                $urlToRedirect = '/Order/OrderItems/editInBatch/' . $orderItemData['OrderItem']['order_id'] . '/0/' . $orderItemData['OrderItem']['shipment_id'] . '/' . $orderItemId;
                break;
        }
        $this->redirect($urlToRedirect, null, true);
    }

    public function editInBatch($orderId = 0, $orderLineId = 0, $shipmentId = 0, $orderItemId = 0, $orderItemStatus = '')
    {
        // MANAGE DATA
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        $initialDisplay = false;
        $criteria = array(
            'OrderItem.id' => '-1'
        );
        $orderItemIds = array();
        $intialOrderItemsData = array();
        if (isset($this->request->data['OrderItem']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['OrderItem']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['OrderItem']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $orderItemIds = array_filter($this->request->data['OrderItem']['id']);
            $criteria = array(
                'OrderItem.id' => $orderItemIds
            );
            $initialDisplay = true;
        } elseif (! empty($this->request->data)) {
            // User submit data of the OrderItem.editInBatch() form
            $orderItemIds = explode(',', $this->request->data['order_item_ids']);
            $criteria = array(
                'OrderItem.id' => $orderItemIds
            );
        } elseif ($orderId) {
            // User is working on an order
            $this->Order->getOrRedirect($orderId);
            $criteria = array(
                'OrderItem.order_id' => $orderId
            );
            if ($orderItemStatus) {
                $criteria[] = array(
                    'OrderItem.status' => $orderItemStatus
                );
            }
            $urlToCancel = '/Order/Orders/detail/' . $orderId;
            if ($orderLineId) {
                $criteria['OrderItem.order_line_id'] = $orderLineId;
                $urlToCancel = '/Order/OrderLines/detail/' . $orderId . '/' . $orderLineId;
            }
            if ($shipmentId) {
                $criteria['OrderItem.shipment_id'] = $shipmentId;
                $urlToCancel = '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId;
            }
            if ($orderItemId) {
                $criteria['OrderItem.id'] = $orderItemId;
            }
            if (empty($this->request->data))
                $initialDisplay = true;
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        unset($this->request->data['order_item_ids']);
        
        if ($initialDisplay) {
            $intialOrderItemsData = $this->OrderItem->find('all', array(
                'conditions' => $criteria,
                'recursive' => 0
            ));
            if (empty($intialOrderItemsData)) {
                $this->atimFlashWarning(__('no item to update'), $urlToCancel);
                return;
            }
            if ($orderItemIds)
                $this->OrderItem->sortForDisplay($intialOrderItemsData, $orderItemIds);
            $displayLimit = Configure::read('edit_processed_items_limit');
            if (sizeof($intialOrderItemsData) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
                return;
            }
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('orderId', $orderId);
        $this->set('orderLineId', $orderLineId);
        $this->set('shipmentId', $shipmentId);
        $this->set('orderItemIds', implode(',', $orderItemIds));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->Structures->set('orderitems');
        
        if ($shipmentId) {
            // Get the current menu object
            $this->set('atimMenu', $this->Menus->get('/Order/Shipments/detail/%%Shipment.id%%/'));
            // Variables
            $this->set('atimMenuVariables', array(
                'Order.id' => $orderId,
                'Shipment.id' => $shipmentId
            ));
        } elseif ($orderLineId) {
            // Get the current menu object
            $this->set('atimMenu', $this->Menus->get('/Order/OrderLines/detail/%%OrderLine.id%%/'));
            // Variables
            $this->set('atimMenuVariables', array(
                'Order.id' => $orderId,
                'OrderLine.id' => $orderLineId
            ));
        } elseif ($orderId) {
            // Get the current menu object
            $this->set('atimMenu', $this->Menus->get('/Order/Orders/detail/%%Order.id%%/'));
            // Variables
            $this->set('atimMenuVariables', array(
                'Order.id' => $orderId
            ));
        } else {
            $this->set('atimMenu', $this->Menus->get('/Order/Orders/search/'));
            $this->set('atimMenuVariables', array());
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE DATA
        
        if ($initialDisplay) {
            $this->request->data = $intialOrderItemsData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Launch validation
            $submittedDataValidates = true;
            
            $fieldsReservedForReturnedItems = array(
                'OrderItem.date_returned',
                'OrderItem.reason_returned',
                'OrderItem.reception_by'
            );
            
            $errors = array();
            $recordCounter = 0;
            $updatedItemIds = array();
            foreach ($this->request->data as $key => &$newStudiedItem) {
                $recordCounter ++;
                // Get id
                if (! isset($newStudiedItem['OrderItem']['id']))
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $updatedItemIds[] = $newStudiedItem['OrderItem']['id'];
                // Launch Order Item validation
                $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->OrderItem->set($newStudiedItem);
                $submittedDataValidates = ($this->OrderItem->validates()) ? $submittedDataValidates : false;
                foreach ($this->OrderItem->validationErrors as $field => $msgs) {
                    $msgs = is_array($msgs) ? $msgs : array(
                        $msgs
                    );
                    foreach ($msgs as $msg)
                        $errors['OrderItem'][$field][$msg][] = $recordCounter;
                }
                // Reset data
                $newStudiedItem = $this->OrderItem->data;
                // Check returned fields
                if (! $newStudiedItem['OrderItem']['status']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if ($newStudiedItem['OrderItem']['status'] != 'shipped & returned') {
                    foreach ($fieldsReservedForReturnedItems as $returnedItemModelField) {
                        list ($returnedItemModel, $returnedItemField) = explode('.', $returnedItemModelField);
                        if (isset($newStudiedItem[$returnedItemModel][$returnedItemField]) && strlen($newStudiedItem[$returnedItemModel][$returnedItemField])) {
                            $errors['OrderItem'][$returnedItemField][__('fields defined for returned items can not be completed for items with status different than shipped & returned')][] = $recordCounter;
                            $submittedDataValidates = false;
                        }
                    }
                }
            }
            
            if ($this->OrderItem->find('count', array(
                'conditions' => array(
                    'OrderItem.id' => $updatedItemIds
                ),
                'recursive' => - 1
            )) != sizeof($updatedItemIds)) {
                // In case an order item has just been deleted by another user before we submitted updated data
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // Launch save process
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->OrderItem->writableFieldsMode = 'editgrid';
                
                foreach ($this->request->data as $orderItem) {
                    // Save data
                    $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->OrderItem->id = $orderItem['OrderItem']['id'];
                    if (! $this->OrderItem->save($orderItem['OrderItem'], false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // Redirect
                
                if ($shipmentId) {
                    $this->atimFlash(__('your data has been saved'), '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId);
                } elseif ($orderLineId) {
                    $this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/' . $orderId . '/' . $orderLineId);
                } elseif ($orderId) {
                    $this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/' . $orderId);
                } else {
                    // Creat Batchset then redirect
                    $batchIds = $orderItemIds;
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('OrderItem'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                }
            } else {
                // Set error message
                foreach ($errors as $model => $fieldMessages) {
                    $this->{$model}->validationErrors = array();
                    foreach ($fieldMessages as $field => $messages) {
                        foreach ($messages as $message => $linesNbr) {
                            $lineNbrMessage = ($linesNbr) ? ' - ' . str_replace('%s', implode(',', $linesNbr), __('see line %s')) : '';
                            if (! array_key_exists($field, $this->{$model}->validationErrors)) {
                                $this->{$model}->validationErrors[$field][] = $message . $lineNbrMessage;
                            } else {
                                $this->{$model}->validationErrors[][] = $message . $lineNbrMessage;
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * @param $orderId
     * @param $orderItemId
     * @param null $mainFormModel
     */
    public function delete($orderId, $orderItemId, $mainFormModel = null)
    {
        
        // MANAGE DATA
        
        // Get data
        $orderItemData = $this->OrderItem->find('first', array(
            'conditions' => array(
                'OrderItem.id' => $orderItemId,
                'OrderItem.order_id' => $orderId
            )
        ));
        if (empty($orderItemData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Build URL
        $redirectUrl = 'javascript:history.go(-1)';
        switch ($mainFormModel) {
            case 'Order':
                $redirectUrl = '/Order/Orders/detail/' . $orderItemData['OrderItem']['order_id'] . '/';
                break;
            case 'OrderLine':
                $redirectUrl = '/Order/OrderLines/detail/' . $orderItemData['OrderItem']['order_id'] . '/' . $orderItemData['OrderItem']['order_line_id'] . '/';
                break;
            case 'Shipment':
                $redirectUrl = '/Order/Shipments/detail/' . $orderItemData['OrderItem']['order_id'] . '/' . $orderItemData['OrderItem']['shipment_id'] . '/';
                break;
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->OrderItem->allowDeletion($orderItemData);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // Launch deletion
            
            if ($this->OrderItem->atimDelete($orderItemId)) {
                
                if ($orderItemData['OrderItem']['aliquot_master_id']) {
                    // Update AliquotMaster data
                    $newAliquotMasterData = array();
                    $newAliquotMasterData['AliquotMaster']['in_stock'] = 'yes - available';
                    $newAliquotMasterData['AliquotMaster']['in_stock_detail'] = '';
                    
                    $this->AliquotMaster->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                    
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $orderItemData['OrderItem']['aliquot_master_id'];
                    if (! $this->AliquotMaster->save($newAliquotMasterData)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                } else {
                    // Update Tma Slide data
                    $newTmaSlideData = array();
                    $newTmaSlideData['TmaSlide']['in_stock'] = 'yes - available';
                    $newTmaSlideData['TmaSlide']['in_stock_detail'] = '';
                    
                    $this->TmaSlide->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                    
                    $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->TmaSlide->id = $orderItemData['OrderItem']['tma_slide_id'];
                    if (! $this->TmaSlide->save($newTmaSlideData)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $orderLineId = $orderItemData['OrderItem']['order_line_id'];
                if ($orderLineId) {
                    // Update order line status
                    $newStatus = 'pending';
                    $orderItemCount = $this->OrderItem->find('count', array(
                        'conditions' => array(
                            'OrderItem.order_line_id' => $orderLineId
                        ),
                        'recursive' => - 1
                    ));
                    if ($orderItemCount != 0) {
                        $orderItemNotShippedCount = $this->OrderItem->find('count', array(
                            'conditions' => array(
                                'OrderItem.status = "pending"',
                                'OrderItem.order_line_id' => $orderLineId,
                                'OrderItem.deleted != 1'
                            ),
                            'recursive' => - 1
                        ));
                        if ($orderItemNotShippedCount == 0) {
                            $newStatus = 'shipped';
                        }
                    }
                    $orderLineData = array();
                    $orderLineData['OrderLine']['status'] = $newStatus;
                    $this->OrderLine->addWritableField(array(
                        'status'
                    ));
                    $this->OrderLine->id = $orderLineId;
                    if (! $this->OrderLine->save($orderLineData)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                // Redirect
                $this->atimFlash(__('your data has been deleted - update the aliquot in stock data'), $redirectUrl);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $redirectUrl);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), $redirectUrl);
        }
    }

    /**
     *
     * @param int $orderId
     * @param int $orderLineId
     * @param int $shipmentId
     * @param int $orderItemId
     */
    public function defineOrderItemsReturned($orderId = 0, $orderLineId = 0, $shipmentId = 0, $orderItemId = 0)
    {
        // MANAGE DATA
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        $initialDisplay = false;
        
        $criteria = array(
            'OrderItem.id' => '-1'
        );
        $orderItemIds = array();
        $initialOrderItemsData = array();
        if (isset($this->request->data['OrderItem']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['OrderItem']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['OrderItem']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $orderItemIds = array_filter($this->request->data['OrderItem']['id']);
            $criteria = array(
                'OrderItem.id' => $orderItemIds
            );
            $initialDisplay = true;
        } elseif (! empty($this->request->data)) {
            // User submit data of the OrderItem.defineOrderItemsReturned() form
            $orderItemIds = explode(',', $this->request->data['order_item_ids']);
            $criteria = array(
                'OrderItem.id' => $orderItemIds
            );
        } elseif ($orderId) {
            // User is working on an order
            $this->Order->getOrRedirect($orderId);
            $criteria = array(
                'OrderItem.order_id' => $orderId
            );
            $criteria[] = array(
                'OrderItem.status' => 'shipped'
            );
            if ($orderLineId)
                $criteria['OrderItem.order_line_id'] = $orderLineId;
            if ($shipmentId)
                $criteria['OrderItem.shipment_id'] = $shipmentId;
            if ($orderItemId)
                $criteria['OrderItem.id'] = $orderItemId;
            if (empty($this->request->data))
                $initialDisplay = true;
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        unset($this->request->data['order_item_ids']);
        
        if ($initialDisplay) {
            $initialOrderItemsData = $this->OrderItem->find('all', array(
                'conditions' => $criteria,
                'order' => array(
                    'AliquotMaster.barcode ASC',
                    'TmaSlide.barcode ASC'
                )
            ));
            if (empty($initialOrderItemsData)) {
                $this->atimFlashWarning(__('no order items can be defined as returned'), $urlToCancel);
                return;
            }
            $displayLimit = Configure::read('defineOrderItemsReturned_processed_items_limit');
            if (sizeof($initialOrderItemsData) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit). " . __('use databrowser to submit a sub set of data'), $urlToCancel);
                return;
            }
            if ($orderItemIds) {
                $this->OrderItem->sortForDisplay($initialOrderItemsData, $orderItemIds);
            } else {
                foreach ($initialOrderItemsData as $newOrderItem)
                    $orderItemIds[] = $newOrderItem['OrderItem']['id'];
            }
        }
        
        if ($this->OrderItem->find('count', array(
            'conditions' => array(
                'OrderItem.id' => $orderItemIds,
                "OrderItem.status != 'shipped'"
            )
        ))) {
            $this->atimFlashWarning(__('only shipped items can be defined as returned'), $urlToCancel);
            return;
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('orderId', $orderId);
        $this->set('orderLineId', $orderLineId);
        $this->set('shipmentId', $shipmentId);
        $this->set('orderItemIds', implode(',', $orderItemIds));
        
        // Set menu
        
        if ($shipmentId) {
            // Get the current menu object
            $this->set('atimMenu', $this->Menus->get('/Order/Shipments/detail/%%Shipment.id%%/'));
            // Variables
            $this->set('atimMenuVariables', array(
                'Order.id' => $orderId,
                'Shipment.id' => $shipmentId
            ));
        } elseif ($orderLineId) {
            // Get the current menu object
            $this->set('atimMenu', $this->Menus->get('/Order/OrderLines/detail/%%OrderLine.id%%/'));
            // Variables
            $this->set('atimMenuVariables', array(
                'Order.id' => $orderId,
                'OrderLine.id' => $orderLineId
            ));
        } elseif ($orderId) {
            // Get the current menu object
            $this->set('atimMenu', $this->Menus->get('/Order/Orders/detail/%%Order.id%%/'));
            // Variables
            $this->set('atimMenuVariables', array(
                'Order.id' => $orderId
            ));
        } else {
            $this->set('atimMenu', $this->Menus->get('/Order/Orders/search/'));
            $this->set('atimMenuVariables', array());
        }
        
        // Set structure
        $this->Structures->set('orderitems,orderitems_returned_flag');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE DATA
        
        if ($initialDisplay) {
            
            AppController::addWarningMsg(__('order items data update will be limited to the item defined as returned'));
            
            $this->request->data = $initialOrderItemsData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Launch validation
            $submittedDataValidates = true;
            
            $errors = array();
            $recordCounter = 0;
            $atLeastOneItemDefinedAsReturned = false;
            foreach ($this->request->data as &$newStudiedItem) {
                $recordCounter ++;
                $orderItemId = $newStudiedItem['OrderItem']['id'];
                if (! isset($newStudiedItem['OrderItem']['id']))
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                if (! isset($newStudiedItem['OrderItem']['aliquot_master_id']) || ! isset($newStudiedItem['OrderItem']['tma_slide_id']))
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                if ($newStudiedItem['FunctionManagement']['defined_as_returned']) {
                    // Launch Item validation
                    $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->OrderItem->set($newStudiedItem);
                    $submittedDataValidates = ($this->OrderItem->validates()) ? $submittedDataValidates : false;
                    foreach ($this->OrderItem->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors['OrderItem'][$field][$msg][] = $recordCounter;
                    }
                    // Reset data
                    $newStudiedItem = $this->OrderItem->data;
                    // At least one item is defined as returned
                    $atLeastOneItemDefinedAsReturned = true;
                }
            }
            
            if (! $atLeastOneItemDefinedAsReturned) {
                $errors['OrderItem']['defined_as_returned']['at least one item should be defined as returned'] = array();
                $submittedDataValidates = false;
            }
            
            if ($this->OrderItem->find('count', array(
                'conditions' => array(
                    'OrderItem.id' => $orderItemIds
                ),
                'recursive' => - 1
            )) != sizeof($orderItemIds)) {
                // In case an order item has just been deleted by another user before we submitted updated data
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // Launch save process
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->AliquotMaster->addWritableField(array(
                    'in_stock',
                    'in_stock_detail'
                ));
                $this->TmaSlide->addWritableField(array(
                    'in_stock',
                    'in_stock_detail'
                ));
                
                $this->OrderItem->writableFieldsMode = 'editgrid';
                $this->OrderItem->addWritableField(array(
                    'status'
                ));
                
                foreach ($this->request->data as $newStudiedItemToUpdate) {
                    if ($newStudiedItemToUpdate['FunctionManagement']['defined_as_returned']) {
                        $orderItemId = $newStudiedItemToUpdate['OrderItem']['id'];
                        
                        // 1- Record Order Item Update
                        $orderItemData = $newStudiedItemToUpdate;
                        $orderItemData['OrderItem']['status'] = 'shipped & returned';
                        
                        $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->OrderItem->id = $orderItemId;
                        if (! $this->OrderItem->save($orderItemData, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                        
                        if ($newStudiedItemToUpdate['OrderItem']['aliquot_master_id']) {
                            // 2- Update Aliquot Master Data
                            $aliquotMaster = array();
                            $aliquotMaster['AliquotMaster']['in_stock'] = 'yes - available';
                            $aliquotMaster['AliquotMaster']['in_stock_detail'] = 'shipped & returned';
                            $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                            $this->AliquotMaster->id = $newStudiedItemToUpdate['OrderItem']['aliquot_master_id'];
                            if (! $this->AliquotMaster->save($aliquotMaster, false)) {
                                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                        } else {
                            // 2- Update Tma Slide Data
                            $tmaSlideMaster = array();
                            $tmaSlideMaster['TmaSlide']['in_stock'] = 'yes - available';
                            $tmaSlideMaster['TmaSlide']['in_stock_detail'] = 'shipped & returned';
                            $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                            $this->TmaSlide->id = $newStudiedItemToUpdate['OrderItem']['tma_slide_id'];
                            if (! $this->TmaSlide->save($tmaSlideMaster, false)) {
                                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                        }
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // Redirect
                
                if ($shipmentId) {
                    $this->atimFlash(__('your data has been saved'), '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId);
                } elseif ($orderLineId) {
                    $this->atimFlash(__('your data has been saved'), '/Order/OrderLines/detail/' . $orderId . '/' . $orderLineId);
                } elseif ($orderId) {
                    $this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/' . $orderId);
                } else {
                    // batch
                    $batchIds = $orderItemIds;
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('OrderItem'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                }
            } else {
                
                AppController::addWarningMsg(__('order items data update will be limited to the item defined as returned'));
                
                // Set error message
                foreach ($errors as $model => $fieldMessages) {
                    $this->{$model}->validationErrors = array();
                    foreach ($fieldMessages as $field => $messages) {
                        foreach ($messages as $message => $linesNbr) {
                            $linesNbr = $linesNbr ? ' - ' . str_replace('%s', implode(',', $linesNbr), __('see line %s')) : '';
                            if (! array_key_exists($field, $this->{$model}->validationErrors)) {
                                $this->{$model}->validationErrors[$field][] = __($message) . $linesNbr;
                            } else {
                                $this->{$model}->validationErrors[][] = __($message) . $linesNbr;
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * @param $orderId
     * @param $orderItemId
     * @param null $mainFormModel
     */
    public function removeFlagReturned($orderId, $orderItemId, $mainFormModel = null)
    {
        
        // MANAGE DATA
        
        // Get data
        $orderItemData = $this->OrderItem->find('first', array(
            'conditions' => array(
                'OrderItem.id' => $orderItemId,
                'OrderItem.order_id' => $orderId
            )
        ));
        if (empty($orderItemData) || $orderItemData['OrderItem']['status'] != 'shipped & returned') {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! isset($orderItemData['OrderItem']['aliquot_master_id']) && ! isset($orderItemData['OrderItem']['tma_slide_id'])) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check the status of the order item can be changed to shipped
        $error = null;
        if ($orderItemData['OrderItem']['aliquot_master_id']) {
            if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $orderItemData['OrderItem']['aliquot_master_id'], $orderItemData['OrderItem']['id'])) {
                $error = "the status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses";
            }
        } else {
            if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $orderItemData['OrderItem']['tma_slide_id'], $orderItemData['OrderItem']['id'])) {
                $error = "the status of a tma slide flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses";
            }
        }
        
        // Build URL
        $redirectUrl = 'javascript:history.go(-1)';
        switch ($mainFormModel) {
            case 'Order':
                $redirectUrl = '/Order/Orders/detail/' . $orderItemData['OrderItem']['order_id'] . '/';
                break;
            case 'OrderLine':
                $redirectUrl = '/Order/OrderLines/detail/' . $orderItemData['OrderItem']['order_id'] . '/' . $orderItemData['OrderItem']['order_line_id'] . '/';
                break;
            case 'Shipment':
                $redirectUrl = '/Order/Shipments/detail/' . $orderItemData['OrderItem']['order_id'] . '/' . $orderItemData['OrderItem']['shipment_id'] . '/';
                break;
        }
        
        $hookLink = $this->hook();
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! $error) {
            // Launch status change
            $orderItem = array();
            $orderItem['OrderItem']['status'] = 'shipped';
            $orderItem['OrderItem']['date_returned'] = null;
            $orderItem['OrderItem']['date_returned_accuracy'] = '';
            $orderItem['OrderItem']['reason_returned'] = null;
            $orderItem['OrderItem']['reception_by'] = null;
            $this->OrderItem->addWritableField(array(
                'status',
                'date_returned',
                'date_returned_accuracy',
                'reason_returned',
                'reception_by'
            ));
            $this->OrderItem->id = $orderItemId;
            if (! $this->OrderItem->save($orderItem)) {
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            if ($orderItemData['OrderItem']['aliquot_master_id']) {
                // Update Aliquot Master Data
                $aliquotMaster = array();
                $aliquotMaster['AliquotMaster']['in_stock'] = 'no';
                $aliquotMaster['AliquotMaster']['in_stock_detail'] = 'shipped';
                $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->AliquotMaster->id = $orderItemData['OrderItem']['aliquot_master_id'];
                $this->AliquotMaster->addWritableField(array(
                    'in_stock',
                    'in_stock_detail'
                ));
                if (! $this->AliquotMaster->save($aliquotMaster, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            } else {
                // Update Tma Slide Data
                $tmaSlide = array();
                $tmaSlide['TmaSlide']['in_stock'] = 'no';
                $tmaSlide['TmaSlide']['in_stock_detail'] = 'shipped';
                $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->TmaSlide->id = $orderItemData['OrderItem']['tma_slide_id'];
                $this->TmaSlide->addWritableField(array(
                    'in_stock',
                    'in_stock_detail'
                ));
                if (! $this->TmaSlide->save($tmaSlide, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
            
            AppController::addWarningMsg(__('the return information was deleted'));
            
            $hookLink = $this->hook('postsave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // Redirect
            $this->atimFlash(__('your data has been saved'), $redirectUrl);
        } else {
            $this->atimFlashWarning(__($error), $redirectUrl);
        }
    }
}