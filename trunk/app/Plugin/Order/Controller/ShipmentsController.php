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
 * Class ShipmentsController
 */
class ShipmentsController extends OrderAppController
{

    public $components = array();

    public $uses = array(
        'Order.Shipment',
        'Order.Order',
        'Order.OrderItem',
        'Order.OrderLine',
        
        'InventoryManagement.AliquotMaster',
        'StorageLayout.TmaSlide'
    );

    public $paginate = array(
        'Shipment' => array(
            'order' => 'Shipment.datetime_shipped DESC'
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
        
        $this->searchHandler($searchId, $this->Shipment, 'shipments', '/InventoryManagement/Shipments/search');
        
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
     * @param null $orderId
     */
    public function listall($orderId = null)
    {
        if (! $orderId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Check order
        $orderData = $this->Order->getOrRedirect($orderId);
        
        // Get shipments
        $shipmentsData = $this->paginate($this->Shipment, array(
            'Shipment.order_id' => $orderId
        ));
        $this->request->data = $shipmentsData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Order/Shipments/detail/%%Order.id%%/'));
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $orderId
     * @param null $copiedShipmentId
     */
    public function add($orderId, $copiedShipmentId = null, $orderLineId = null)
    {
        
        // MANAGE DATA
        
        // Check order
        $orderData = $this->Order->getOrRedirect($orderId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Order/Shipments/detail/%%Order.id%%/'));
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId
        ));
        
        $this->set('orderLineId', $orderLineId);
        
        // SAVE PROCESS
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            if ($copiedShipmentId) {
                $this->request->data = $this->Shipment->find('first', array(
                    'conditions' => array(
                        'Shipment.id' => $copiedShipmentId
                    ),
                    'recursive' => - 1
                ));
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Set order id
            $this->request->data['Shipment']['order_id'] = $orderId;
            
            // Launch validation
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            $this->Shipment->addWritableField('order_id');
            if ($submittedDataValidates && $this->Shipment->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved'), '/Order/Shipments/addToShipment/' . $orderId . '/' . $this->Shipment->getLastInsertId() . '/' . $orderLineId);
            }
        }
    }

    /**
     *
     * @param null $orderId
     * @param null $shipmentId
     */
    public function edit($orderId = null, $shipmentId = null)
    {
        if ((! $orderId) || (! $shipmentId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get shipment data
        $shipmentData = $this->Shipment->find('first', array(
            'conditions' => array(
                'Shipment.id' => $shipmentId,
                'Shipment.order_id' => $orderId
            )
        ));
        if (empty($shipmentData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'Shipment.id' => $shipmentId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $shipmentData;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->Shipment->id = $shipmentId;
            if ($submittedDataValidates && $this->Shipment->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId);
            }
        }
    }

    /**
     *
     * @param null $orderId
     * @param null $shipmentId
     * @param bool $isFromTreeView
     */
    public function detail($orderId = null, $shipmentId = null, $isFromTreeView = false)
    {
        
        // MANAGE DATA
        
        // Shipment data
        $shipmentData = $this->Shipment->getOrRedirect($shipmentId);
        $this->request->data = $shipmentData;
        
        // Manage the add to shipment option (in case we reach the AddAliquotToShipment_processed_items_limit)
        $conditions = array(
            'OrderItem.order_id' => $orderId,
            'OrderItem.shipment_id IS NULL'
        );
        $availableOrderItems = $this->OrderItem->find('count', array(
            'conditions' => $conditions
        ));
        $orderItemsLimit = Configure::read('AddToShipment_processed_items_limit');
        $addToShipmentsSubsetLimits = array();
        if ($availableOrderItems > $orderItemsLimit) {
            $nbrOfSubSets = round(($availableOrderItems / $orderItemsLimit), 0, PHP_ROUND_HALF_EVEN);
            for ($start = 0; $start < $orderItemsLimit; $start ++) {
                if (($start * $orderItemsLimit) < $availableOrderItems)
                    $addToShipmentsSubsetLimits[($start + 1)] = array(
                        ($start * $orderItemsLimit),
                        $orderItemsLimit
                    );
            }
        }
        $this->set('addToShipmentsSubsetLimits', $addToShipmentsSubsetLimits);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'Shipment.id' => $shipmentId
        ));
        
        $this->set('isFromTreeView', $isFromTreeView);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $orderId
     * @param null $shipmentId
     */
    public function delete($orderId = null, $shipmentId = null)
    {
        if ((! $orderId) || (! $shipmentId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $shipmentData = $this->Shipment->getOrRedirect($shipmentId);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->Shipment->allowDeletion($shipmentId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->Shipment->atimDelete($shipmentId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Order/Orders/detail/' . $orderId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Order/Orders/detail/' . $orderId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), 'javascript:history.go(-1)');
        }
    }

    /* ----------------------------- SHIPPED ITEMS ---------------------------- */
    /**
     *
     * @param $orderId
     * @param $shipmentId
     * @param null $orderLineId
     * @param null $offset
     * @param null $limit
     */
    public function addToShipment($orderId, $shipmentId, $orderLineId = null)
    {
        // Server-side verification (If by JS user send larg amount of batch data)
        $orderItemsLimit = Configure::read('AddToShipment_processed_items_limit');
        $data = array();
        if (! empty($this->request->data) && isset($this->request->data['OrderItem']['id'])) {
            $data = array_filter($this->request->data['OrderItem']['id']);
        }
        if (! empty($this->request->data) && count($data) > $orderItemsLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$orderItemsLimit). " . __('launch process on order items sub set') . '.', '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId);
            return;
        }
        // MANAGE DATA
        
        // Check shipment
        $shipmentData = $this->Shipment->getOrRedirect($shipmentId);
        
        // Get available order items
        
        $conditions = array(
            'OrderItem.order_id' => $orderId,
            'OrderItem.shipment_id IS NULL'
        );
        if ($orderLineId) {
            $conditions['OrderItem.order_line_id'] = $orderLineId;
        }
        $availableOrderItems = $this->paginate($this->OrderItem, $conditions);
        
        if (empty($availableOrderItems)) {
            $this->atimFlashWarning(__('no new item could be actually added to the shipment'), '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId);
        }
        
        if ($orderLineId) {
            $sampleControlModel = AppModel::getInstance('InventoryManagement', 'SampleControl');
            $aliquotControlModel = AppModel::getInstance('InventoryManagement', 'AliquotControl');
            $languageHeading = '';
            if ($availableOrderItems[0]['OrderLine']['sample_control_id']) {
                $sampleCtrl = $sampleControlModel->findById($availableOrderItems[0]['OrderLine']['sample_control_id']);
                $languageHeading = __($sampleCtrl['SampleControl']['sample_type']);
                if ($availableOrderItems[0]['OrderLine']['aliquot_control_id']) {
                    $aliquotCtrl = $aliquotControlModel->findById($availableOrderItems[0]['OrderLine']['aliquot_control_id']);
                    $languageHeading .= ' - ' . $aliquotCtrl['AliquotControl']['aliquot_type'];
                }
            } elseif ($availableOrderItems[0]['OrderLine']['is_tma_slide']) {
                $languageHeading = __('tma slide');
            }
            if ($availableOrderItems[0]['OrderLine']['product_type_precision']) {
                $languageHeading .= ' - ' . $availableOrderItems[0]['OrderLine']['product_type_precision'];
            }
            $this->set('languageHeading', __('order line') . ' : ' . $languageHeading);
        }
        
        $this->set("dataLimit", $orderItemsLimit);
        $this->set('orderLineId', $orderLineId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'Shipment.id' => $shipmentId
        ));
        
        $this->Structures->set('shippeditems' . ($orderLineId ? '' : ',orderitems_and_lines'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        if (empty($this->request->data)) {
            $this->request->data = $availableOrderItems;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Launch validation
            $submittedDataValidates = true;
            $dataToSave = array_filter($this->request->data['OrderItem']['id']);
            
            if (empty($dataToSave)) {
                $this->OrderItem->validationErrors[] = 'no item has been defined as shipped';
                $submittedDataValidates = false;
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // Launch Save Process
                $orderLineToUpdate = array();
                
                // Take all available items instead to just work on the items returned by the paginate function
                $availableOrderItems = $this->OrderItem->find('all', array(
                    'conditions' => $conditions
                ));
                $availableOrderItems = AppController::defineArrayKey($availableOrderItems, 'OrderItem', 'id', true);
                
                $this->AliquotMaster->addWritableField(array(
                    'in_stock',
                    'in_stock_detail',
                    'storage_master_id',
                    'storage_coord_x',
                    'storage_coord_y'
                ));
                $this->TmaSlide->addWritableField(array(
                    'in_stock',
                    'in_stock_detail',
                    'storage_master_id',
                    'storage_coord_x',
                    'storage_coord_y'
                ));
                
                foreach ($dataToSave as $orderItemId) {
                    $orderItem = isset($availableOrderItems[$orderItemId]) ? $availableOrderItems[$orderItemId] : null;
                    if ($orderItem == null) {
                        // hack attempt
                        continue;
                    }
                    
                    if ($orderItem['AliquotMaster']['id']) {
                        // Get id
                        $aliquotMasterId = $orderItem['AliquotMaster']['id'];
                        
                        // 1- Update Aliquot Master Data
                        $aliquotMaster = array();
                        $aliquotMaster['AliquotMaster']['in_stock'] = 'no';
                        $aliquotMaster['AliquotMaster']['in_stock_detail'] = 'shipped';
                        $aliquotMaster['AliquotMaster']['storage_master_id'] = null;
                        $aliquotMaster['AliquotMaster']['storage_coord_x'] = '';
                        $aliquotMaster['AliquotMaster']['storage_coord_y'] = '';
                        
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->AliquotMaster->id = $aliquotMasterId;
                        if (! $this->AliquotMaster->save($aliquotMaster, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    } else {
                        // Get id
                        $tmaSlideId = $orderItem['TmaSlide']['id'];
                        
                        // 1- Update slide Data
                        $tmaSlide = array();
                        $tmaSlide['TmaSlide']['in_stock'] = 'no';
                        $tmaSlide['TmaSlide']['in_stock_detail'] = 'shipped';
                        $tmaSlide['TmaSlide']['storage_master_id'] = null;
                        $tmaSlide['TmaSlide']['storage_coord_x'] = '';
                        $tmaSlide['TmaSlide']['storage_coord_y'] = '';
                        
                        $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->TmaSlide->id = $tmaSlideId;
                        if (! $this->TmaSlide->save($tmaSlide, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                    
                    // 2- Record Order Item Update
                    $orderItemData = array();
                    $orderItemData['OrderItem']['shipment_id'] = $shipmentData['Shipment']['id'];
                    $orderItemData['OrderItem']['status'] = 'shipped';
                    
                    $this->OrderItem->addWritableField(array(
                        'shipment_id',
                        'status'
                    ));
                    
                    $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->OrderItem->id = $orderItemId;
                    if (! $this->OrderItem->save($orderItemData, false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    // 3- Set order line to update
                    $orderLineId = $orderItem['OrderLine']['id'];
                    if ($orderLineId)
                        $orderLineToUpdate[$orderLineId] = $orderLineId;
                }
                
                foreach ($orderLineToUpdate as $orderLineId) {
                    $itemsCounts = $this->OrderItem->find('count', array(
                        'conditions' => array(
                            'OrderItem.order_line_id' => $orderLineId,
                            'OrderItem.status = "pending"'
                        )
                    ));
                    if ($itemsCounts == 0) {
                        // update if everything is shipped
                        $orderLine = array();
                        $orderLine['OrderLine']['status'] = "shipped";
                        $this->OrderLine->addWritableField(array(
                            'status'
                        ));
                        $this->OrderLine->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->OrderLine->id = $orderLineId;
                        if (! $this->OrderLine->save($orderLine, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $this->atimFlash(__('your data has been saved') . '<br>' . __('item storage data were deleted (if required)'), '/Order/Shipments/detail/' . $orderId . '/' . $shipmentId . '/');
            } else {
                $this->request->data = $availableOrderItems;
            }
        }
    }

    /**
     *
     * @param $orderItems
     * @return array
     */
    public function formatDataForShippedItemsSelection($orderItems)
    {
        $sampleControlModel = AppModel::getInstance('InventoryManagement', 'SampleControl');
        $aliquotControlModel = AppModel::getInstance('InventoryManagement', 'AliquotControl');
        $data = array();
        $nameToId = array();
        foreach ($orderItems as $orderItem) {
            if (! isset($data[$orderItem['OrderLine']['id']])) {
                $name = '';
                if ($orderItem['OrderLine']['id']) {
                    if ($orderItem['OrderLine']['sample_control_id']) {
                        $sampleCtrl = $sampleControlModel->findById($orderItem['OrderLine']['sample_control_id']);
                        $name = __($sampleCtrl['SampleControl']['sample_type']);
                        if ($orderItem['OrderLine']['aliquot_control_id']) {
                            $aliquotCtrl = $aliquotControlModel->findById($orderItem['OrderLine']['aliquot_control_id']);
                            $name .= ' - ' . $aliquotCtrl['AliquotControl']['aliquot_type'];
                        }
                        if ($orderItem['OrderLine']['product_type_precision']) {
                            $name .= ' - ' . $orderItem['OrderLine']['product_type_precision'];
                        }
                    } elseif ($orderItem['OrderLine']['is_tma_slide']) {
                        $name = __('tma slide');
                    }
                }
                $data[$orderItem['OrderLine']['id']] = array(
                    'name' => $name,
                    'order_line_id' => $orderItem['OrderLine']['id'],
                    'data' => array()
                );
                $nameToId[$name][] = $orderItem['OrderLine']['id'];
            }
            $data[$orderItem['OrderLine']['id']]['data'][] = $orderItem;
        }
        // Sort array
        $tmpData = $data;
        $data = array();
        ksort($nameToId);
        foreach ($nameToId as $ids)
            foreach ($ids as $id)
                $data[$id] = $tmpData[$id];
        return $data;
    }

    /**
     *
     * @param $orderId
     * @param $orderItemId
     * @param $shipmentId
     * @param null $mainFormModel
     */
    public function deleteFromShipment($orderId, $orderItemId, $shipmentId, $mainFormModel = null)
    {
        // MANAGE DATA
        
        // Check item
        $orderItemData = $this->OrderItem->find('first', array(
            'conditions' => array(
                'OrderItem.id' => $orderItemId,
                'OrderItem.shipment_id' => $shipmentId
            ),
            'recursive' => - 1
        ));
        if (empty($orderItemData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! isset($orderItemData['OrderItem']['aliquot_master_id']) && ! isset($orderItemData['OrderItem']['tma_slide_id'])) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->Shipment->allowItemRemoveFromShipment($orderItemId, $shipmentId);
        
        // Check the status of the order item can be changed to pending
        if ($arrAllowDeletion['allow_deletion']) {
            if ($orderItemData['OrderItem']['aliquot_master_id']) {
                if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $orderItemData['OrderItem']['aliquot_master_id'], $orderItemData['OrderItem']['id'])) {
                    $arrAllowDeletion = array(
                        'allow_deletion' => false,
                        'msg' => "the status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses"
                    );
                }
            } else {
                if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $orderItemData['OrderItem']['tma_slide_id'], $orderItemData['OrderItem']['id'])) {
                    $arrAllowDeletion = array(
                        'allow_deletion' => false,
                        'msg' => "the status of a tma slide flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses"
                    );
                }
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
        
        $hookLink = $this->hook('delete_from_shipment');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // LAUNCH DELETION
        
        if ($arrAllowDeletion['allow_deletion']) {
            $removeDone = true;
            
            // -> Remove order item from shipment
            $orderItem = array();
            $orderItem['OrderItem']['shipment_id'] = null;
            $orderItem['OrderItem']['status'] = 'pending';
            if ($orderItemData['OrderItem']['status'] == 'shipped & returned')
                AppController::addWarningMsg(__('the return information was deleted'));
            $orderItem['OrderItem']['date_returned'] = null;
            $orderItem['OrderItem']['date_returned_accuracy'] = '';
            $orderItem['OrderItem']['reason_returned'] = null;
            $orderItem['OrderItem']['reception_by'] = null;
            $this->OrderItem->addWritableField(array(
                'shipment_id',
                'status',
                'date_returned',
                'date_returned_accuracy',
                'reason_returned',
                'reception_by'
            ));
            $this->OrderItem->id = $orderItemId;
            if (! $this->OrderItem->save($orderItem, false)) {
                $removeDone = false;
            }
            
            // -> Update aliquot master
            if ($removeDone) {
                if ($orderItemData['OrderItem']['aliquot_master_id']) {
                    $newAliquotMasterData = array();
                    $newAliquotMasterData['AliquotMaster']['in_stock'] = 'yes - not available';
                    $newAliquotMasterData['AliquotMaster']['in_stock_detail'] = 'reserved for order';
                    $this->AliquotMaster->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $orderItemData['OrderItem']['aliquot_master_id'];
                    if (! $this->AliquotMaster->save($newAliquotMasterData, false)) {
                        $removeDone = false;
                    }
                } else {
                    $newSlideData = array();
                    $newSlideData['TmaSlide']['in_stock'] = 'yes - not available';
                    $newSlideData['TmaSlide']['in_stock_detail'] = 'reserved for order';
                    $this->TmaSlide->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                    $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->TmaSlide->id = $orderItemData['OrderItem']['tma_slide_id'];
                    if (! $this->TmaSlide->save($newSlideData, false)) {
                        $removeDone = false;
                    }
                }
            }
            
            // -> Update order line
            if ($removeDone && $orderItemData['OrderItem']['order_line_id']) {
                $orderLine = array();
                $orderLine['OrderLine']['status'] = "pending";
                $this->OrderLine->addWritableField(array(
                    'status'
                ));
                $this->OrderLine->id = $orderItemData['OrderItem']['order_line_id'];
                if (! $this->OrderLine->save($orderLine, false)) {
                    $removeDone = false;
                }
            }
            
            $hookLink = $this->hook('postsave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // Redirect
            if ($removeDone) {
                $this->atimFlash(__('your data has been removed - update the aliquot in stock data'), $redirectUrl);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $redirectUrl);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), $redirectUrl);
        }
    }

    public function manageContact($searchId = false)
    {
        $this->Structures->set('shipment_recipients');
        $contactsModel = AppModel::getInstance("Order", "ShipmentContact", true);

        $this->set('searchId', $searchId);
        $this->searchHandler($searchId, $contactsModel, 'shipment_recipients', '/InventoryManagement/Shipments/manageContact');
    }

    public function saveContact()
    {
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        if (! empty($this->request->data) && isset($this->request->data['Shipment'])) {
            $contactsModel = AppModel::getInstance("Order", "ShipmentContact", true);
            $shipmentContactKeys = array_fill_keys(array(
                "recipient",
                "facility",
                "delivery_street_address",
                "delivery_city",
                "delivery_province",
                "delivery_postal_code",
                "delivery_country",
                "delivery_phone_number",
                "delivery_notes",
                "delivery_department_or_door"
            ), null);
            $shipmentData = array_intersect_key($this->request->data['Shipment'], $shipmentContactKeys);
            
            $contactsModel->save($shipmentData);
            
            echo __('your data has been saved');
            $this->render(false);
            // exit();
        }
    }

    /**
     *
     * @param $contactId
     */
    public function deleteContact($contactId)
    {
        $contactsModel = AppModel::getInstance("Order", "ShipmentContact", true);
        $contactsModel->atimDelete($contactId);
        $this->render(false);
        // exit();
    }
}