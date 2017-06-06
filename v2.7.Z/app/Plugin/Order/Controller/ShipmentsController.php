<?php

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

    function search($search_id = 0)
    {
        $this->set('atim_menu', $this->Menus->get('/Order/Orders/search'));
        $this->searchHandler($search_id, $this->Shipment, 'shipments', '/InventoryManagement/Shipments/search');
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($search_id)) {
            // index
            $this->render('index');
        }
    }

    function listall($order_id = null)
    {
        if (! $order_id) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Check order
        $order_data = $this->Order->getOrRedirect($order_id);
        
        // Get shipments
        $shipments_data = $this->paginate($this->Shipment, array(
            'Shipment.order_id' => $order_id
        ));
        $this->request->data = $shipments_data;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atim_menu', $this->Menus->get('/Order/Shipments/detail/%%Order.id%%/'));
        $this->set('atim_menu_variables', array(
            'Order.id' => $order_id
        ));
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function add($order_id, $copied_shipment_id = null)
    {
        
        // MANAGE DATA
        
        // Check order
        $order_data = $this->Order->getOrRedirect($order_id);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atim_menu', $this->Menus->get('/Order/Shipments/detail/%%Order.id%%/'));
        $this->set('atim_menu_variables', array(
            'Order.id' => $order_id
        ));
        
        // SAVE PROCESS
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            if ($copied_shipment_id) {
                $this->request->data = $this->Shipment->find('first', array(
                    'conditions' => array(
                        'Shipment.id' => $copied_shipment_id
                    ),
                    'recursive' => '-1'
                ));
            }
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            
            // Set order id
            $this->request->data['Shipment']['order_id'] = $order_id;
            
            // Launch validation
            $submitted_data_validates = true;
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            $this->Shipment->addWritableField('order_id');
            if ($submitted_data_validates && $this->Shipment->save($this->request->data)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been saved'), '/Order/Shipments/addToShipment/' . $order_id . '/' . $this->Shipment->getLastInsertId());
            }
        }
    }

    function edit($order_id = null, $shipment_id = null)
    {
        if ((! $order_id) || (! $shipment_id)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get shipment data
        $shipment_data = $this->Shipment->find('first', array(
            'conditions' => array(
                'Shipment.id' => $shipment_id,
                'Shipment.order_id' => $order_id
            )
        ));
        if (empty($shipment_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atim_menu_variables', array(
            'Order.id' => $order_id,
            'Shipment.id' => $shipment_id
        ));
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $shipment_data;
        } else {
            $submitted_data_validates = true;
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            $this->Shipment->id = $shipment_id;
            if ($submitted_data_validates && $this->Shipment->save($this->request->data)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been updated'), '/Order/Shipments/detail/' . $order_id . '/' . $shipment_id);
            }
        }
    }

    function detail($order_id = null, $shipment_id = null, $is_from_tree_view = false)
    {
        
        // MANAGE DATA
        
        // Shipment data
        $shipment_data = $this->Shipment->getOrRedirect($shipment_id);
        $this->request->data = $shipment_data;
        
        // Manage the add to shipment option (in case we reach the AddAliquotToShipment_processed_items_limit)
        $conditions = array(
            'OrderItem.order_id' => $order_id,
            'OrderItem.shipment_id IS NULL'
        );
        $available_order_items = $this->OrderItem->find('count', array(
            'conditions' => $conditions
        ));
        $order_items_limit = Configure::read('AddToShipment_processed_items_limit');
        $add_to_shipments_subset_limits = array();
        if ($available_order_items > $order_items_limit) {
            $nbr_of_sub_sets = round(($available_order_items / $order_items_limit), 0, PHP_ROUND_HALF_EVEN);
            for ($start = 0; $start < $order_items_limit; $start ++) {
                if (($start * $order_items_limit) < $available_order_items)
                    $add_to_shipments_subset_limits[($start + 1)] = array(
                        ($start * $order_items_limit),
                        $order_items_limit
                    );
            }
        }
        $this->set('add_to_shipments_subset_limits', $add_to_shipments_subset_limits);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atim_menu_variables', array(
            'Order.id' => $order_id,
            'Shipment.id' => $shipment_id
        ));
        
        $this->set('is_from_tree_view', $is_from_tree_view);
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function delete($order_id = null, $shipment_id = null)
    {
        if ((! $order_id) || (! $shipment_id)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $shipment_data = $this->Shipment->getOrRedirect($shipment_id);
        
        // Check deletion is allowed
        $arr_allow_deletion = $this->Shipment->allowDeletion($shipment_id);
        
        // CUSTOM CODE
        
        $hook_link = $this->hook('delete');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($arr_allow_deletion['allow_deletion']) {
            if ($this->Shipment->atimDelete($shipment_id)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been deleted'), '/Order/Orders/detail/' . $order_id);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Order/Orders/detail/' . $order_id);
            }
        } else {
            $this->atimFlashWarning(__($arr_allow_deletion['msg']), 'javascript:history.go(-1)');
        }
    }

    /* ----------------------------- SHIPPED ITEMS ---------------------------- */
    function addToShipment($order_id, $shipment_id, $order_line_id = null, $offset = null, $limit = null)
    {
        
        // MANAGE DATA
        
        // Check shipment
        $shipment_data = $this->Shipment->getOrRedirect($shipment_id);
        
        // Get available order items
        
        $conditions = array(
            'OrderItem.order_id' => $order_id,
            'OrderItem.shipment_id IS NULL'
        );
        if ($order_line_id)
            $conditions['OrderItem.order_line_id'] = $order_line_id;
        $available_order_items = $this->OrderItem->find('all', array(
            'conditions' => $conditions,
            'order' => 'OrderLine.id, OrderItem.date_added DESC',
            'offset' => $offset,
            'limit' => $limit
        ));
        if (empty($available_order_items)) {
            $this->atimFlashWarning(__('no new item could be actually added to the shipment'), '/Order/Shipments/detail/' . $order_id . '/' . $shipment_id);
        }
        
        $order_items_limit = Configure::read('AddToShipment_processed_items_limit');
        if (sizeof($available_order_items) > $order_items_limit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$order_items_limit). " . __('launch process on order items sub set') . '.', '/Order/Shipments/detail/' . $order_id . '/' . $shipment_id, 5);
            return;
        }
        
        $this->set('order_line_id', $order_line_id);
        $this->set('offset', $offset);
        $this->set('limit', $limit);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atim_menu_variables', array(
            'Order.id' => $order_id,
            'Shipment.id' => $shipment_id
        ));
        
        $this->Structures->set('shippeditems');
        $this->Structures->set('shippeditems,orderitems_and_lines', 'atim_structure_with_order_lines');
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $this->formatDataForShippedItemsSelection($available_order_items);
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            
            // Launch validation
            $submitted_data_validates = true;
            $data_to_save = array_filter($this->request->data['OrderItem']['id']);
            
            if (empty($data_to_save)) {
                $this->OrderItem->validationErrors[] = 'no item has been defined as shipped';
                $submitted_data_validates = false;
                $this->request->data = $this->formatDataForShippedItemsSelection($available_order_items);
            }
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // Launch Save Process
                $order_line_to_update = array();
                
                $available_order_items = AppController::defineArrayKey($available_order_items, 'OrderItem', 'id', true);
                
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
                
                foreach ($data_to_save as $order_item_id) {
                    $order_item = isset($available_order_items[$order_item_id]) ? $available_order_items[$order_item_id] : null;
                    if ($order_item == null) {
                        // hack attempt
                        continue;
                    }
                    
                    if ($order_item['AliquotMaster']['id']) {
                        // Get id
                        $aliquot_master_id = $order_item['AliquotMaster']['id'];
                        
                        // 1- Update Aliquot Master Data
                        $aliquot_master = array();
                        $aliquot_master['AliquotMaster']['in_stock'] = 'no';
                        $aliquot_master['AliquotMaster']['in_stock_detail'] = 'shipped';
                        $aliquot_master['AliquotMaster']['storage_master_id'] = null;
                        $aliquot_master['AliquotMaster']['storage_coord_x'] = '';
                        $aliquot_master['AliquotMaster']['storage_coord_y'] = '';
                        
                        $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->AliquotMaster->id = $aliquot_master_id;
                        if (! $this->AliquotMaster->save($aliquot_master, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    } else {
                        // Get id
                        $tma_slide_id = $order_item['TmaSlide']['id'];
                        
                        // 1- Update slide Data
                        $tma_slide = array();
                        $tma_slide['TmaSlide']['in_stock'] = 'no';
                        $tma_slide['TmaSlide']['in_stock_detail'] = 'shipped';
                        $tma_slide['TmaSlide']['storage_master_id'] = null;
                        $tma_slide['TmaSlide']['storage_coord_x'] = '';
                        $tma_slide['TmaSlide']['storage_coord_y'] = '';
                        
                        $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->TmaSlide->id = $tma_slide_id;
                        if (! $this->TmaSlide->save($tma_slide, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                    
                    // 2- Record Order Item Update
                    $order_item_data = array();
                    $order_item_data['OrderItem']['shipment_id'] = $shipment_data['Shipment']['id'];
                    $order_item_data['OrderItem']['status'] = 'shipped';
                    
                    $this->OrderItem->addWritableField(array(
                        'shipment_id',
                        'status'
                    ));
                    
                    $this->OrderItem->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->OrderItem->id = $order_item_id;
                    if (! $this->OrderItem->save($order_item_data, false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    // 3- Set order line to update
                    $order_line_id = $order_item['OrderLine']['id'];
                    if ($order_line_id)
                        $order_line_to_update[$order_line_id] = $order_line_id;
                }
                
                foreach ($order_line_to_update as $order_line_id) {
                    $items_counts = $this->OrderItem->find('count', array(
                        'conditions' => array(
                            'OrderItem.order_line_id' => $order_line_id,
                            'OrderItem.status = "pending"'
                        )
                    ));
                    if ($items_counts == 0) {
                        // update if everything is shipped
                        $order_line = array();
                        $order_line['OrderLine']['status'] = "shipped";
                        $this->OrderLine->addWritableField(array(
                            'status'
                        ));
                        $this->OrderLine->data = array(); // *** To guaranty no merge will be done with previous data ***
                        $this->OrderLine->id = $order_line_id;
                        if (! $this->OrderLine->save($order_line, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                }
                
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $this->atimFlash(__('your data has been saved') . '<br>' . __('item storage data were deleted (if required)'), '/Order/Shipments/detail/' . $order_id . '/' . $shipment_id . '/');
            }
        }
    }

    function formatDataForShippedItemsSelection($order_items)
    {
        $sample_control_model = AppModel::getInstance('InventoryManagement', 'SampleControl');
        $aliquot_control_model = AppModel::getInstance('InventoryManagement', 'AliquotControl');
        $data = array();
        $name_to_id = array();
        foreach ($order_items as $order_item) {
            if (! isset($data[$order_item['OrderLine']['id']])) {
                $name = '';
                if ($order_item['OrderLine']['id']) {
                    if ($order_item['OrderLine']['sample_control_id']) {
                        $sample_ctrl = $sample_control_model->findById($order_item['OrderLine']['sample_control_id']);
                        $name = __($sample_ctrl['SampleControl']['sample_type']);
                        if ($order_item['OrderLine']['aliquot_control_id']) {
                            $aliquot_ctrl = $aliquot_control_model->findById($order_item['OrderLine']['aliquot_control_id']);
                            $name .= ' - ' . $aliquot_ctrl['AliquotControl']['aliquot_type'];
                        }
                        if ($order_item['OrderLine']['product_type_precision']) {
                            $name .= ' - ' . $order_item['OrderLine']['product_type_precision'];
                        }
                    } elseif ($order_item['OrderLine']['is_tma_slide']) {
                        $name = __('tma slide');
                    }
                }
                $data[$order_item['OrderLine']['id']] = array(
                    'name' => $name,
                    'order_line_id' => $order_item['OrderLine']['id'],
                    'data' => array()
                );
                $name_to_id[$name][] = $order_item['OrderLine']['id'];
            }
            $data[$order_item['OrderLine']['id']]['data'][] = $order_item;
        }
        // Sort array
        $tmp_data = $data;
        $data = array();
        ksort($name_to_id);
        foreach ($name_to_id as $ids)
            foreach ($ids as $id)
                $data[$id] = $tmp_data[$id];
        return $data;
    }

    function deleteFromShipment($order_id, $order_item_id, $shipment_id, $main_form_model = null)
    {
        // MANAGE DATA
        
        // Check item
        $order_item_data = $this->OrderItem->find('first', array(
            'conditions' => array(
                'OrderItem.id' => $order_item_id,
                'OrderItem.shipment_id' => $shipment_id
            ),
            'recursive' => '-1'
        ));
        if (empty($order_item_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! isset($order_item_data['OrderItem']['aliquot_master_id']) && ! isset($order_item_data['OrderItem']['tma_slide_id'])) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arr_allow_deletion = $this->Shipment->allowItemRemoveFromShipment($order_item_id, $shipment_id);
        
        // Check the status of the order item can be changed to pending
        if ($arr_allow_deletion['allow_deletion']) {
            if ($order_item_data['OrderItem']['aliquot_master_id']) {
                if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('aliquot_master_id', $order_item_data['OrderItem']['aliquot_master_id'], $order_item_data['OrderItem']['id'])) {
                    $arr_allow_deletion = array(
                        'allow_deletion' => false,
                        'msg' => "the status of an aliquot flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses"
                    );
                }
            } else {
                if (! $this->OrderItem->checkOrderItemStatusCanBeSetToPendingOrShipped('tma_slide_id', $order_item_data['OrderItem']['tma_slide_id'], $order_item_data['OrderItem']['id'])) {
                    $arr_allow_deletion = array(
                        'allow_deletion' => false,
                        'msg' => "the status of a tma slide flagged as 'returned' cannot be changed to 'pending' or 'shipped' when this one is already linked to another order with these 2 statuses"
                    );
                }
            }
        }
        
        // Build URL
        $redirect_url = 'javascript:history.go(-1)';
        switch ($main_form_model) {
            case 'Order':
                $redirect_url = '/Order/Orders/detail/' . $order_item_data['OrderItem']['order_id'] . '/';
                break;
            case 'OrderLine':
                $redirect_url = '/Order/OrderLines/detail/' . $order_item_data['OrderItem']['order_id'] . '/' . $order_item_data['OrderItem']['order_line_id'] . '/';
                break;
            case 'Shipment':
                $redirect_url = '/Order/Shipments/detail/' . $order_item_data['OrderItem']['order_id'] . '/' . $order_item_data['OrderItem']['shipment_id'] . '/';
                break;
        }
        
        $hook_link = $this->hook('delete_from_shipment');
        if ($hook_link) {
            require ($hook_link);
        }
        
        // LAUNCH DELETION
        
        if ($arr_allow_deletion['allow_deletion']) {
            $remove_done = true;
            
            // -> Remove order item from shipment
            $order_item = array();
            $order_item['OrderItem']['shipment_id'] = null;
            $order_item['OrderItem']['status'] = 'pending';
            if ($order_item_data['OrderItem']['status'] == 'shipped & returned')
                AppController::addWarningMsg(__('the return information was deleted'));
            $order_item['OrderItem']['date_returned'] = null;
            $order_item['OrderItem']['date_returned_accuracy'] = '';
            $order_item['OrderItem']['reason_returned'] = null;
            $order_item['OrderItem']['reception_by'] = null;
            $this->OrderItem->addWritableField(array(
                'shipment_id',
                'status',
                'date_returned',
                'date_returned_accuracy',
                'reason_returned',
                'reception_by'
            ));
            $this->OrderItem->id = $order_item_id;
            if (! $this->OrderItem->save($order_item, false)) {
                $remove_done = false;
            }
            
            // -> Update aliquot master
            if ($remove_done) {
                if ($order_item_data['OrderItem']['aliquot_master_id']) {
                    $new_aliquot_master_data = array();
                    $new_aliquot_master_data['AliquotMaster']['in_stock'] = 'yes - not available';
                    $new_aliquot_master_data['AliquotMaster']['in_stock_detail'] = 'reserved for order';
                    $this->AliquotMaster->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                    $this->AliquotMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->AliquotMaster->id = $order_item_data['OrderItem']['aliquot_master_id'];
                    if (! $this->AliquotMaster->save($new_aliquot_master_data, false)) {
                        $remove_done = false;
                    }
                } else {
                    $new_slide_data = array();
                    $new_slide_data['TmaSlide']['in_stock'] = 'yes - not available';
                    $new_slide_data['TmaSlide']['in_stock_detail'] = 'reserved for order';
                    $this->TmaSlide->addWritableField(array(
                        'in_stock',
                        'in_stock_detail'
                    ));
                    $this->TmaSlide->data = array(); // *** To guaranty no merge will be done with previous data ***
                    $this->TmaSlide->id = $order_item_data['OrderItem']['tma_slide_id'];
                    if (! $this->TmaSlide->save($new_slide_data, false)) {
                        $remove_done = false;
                    }
                }
            }
            
            // -> Update order line
            if ($remove_done && $order_item_data['OrderItem']['order_line_id']) {
                $order_line = array();
                $order_line['OrderLine']['status'] = "pending";
                $this->OrderLine->addWritableField(array(
                    'status'
                ));
                $this->OrderLine->id = $order_item_data['OrderItem']['order_line_id'];
                if (! $this->OrderLine->save($order_line, false)) {
                    $remove_done = false;
                }
            }
            
            $hook_link = $this->hook('postsave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            // Redirect
            if ($remove_done) {
                $this->atimFlash(__('your data has been removed - update the aliquot in stock data'), $redirect_url);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $redirect_url);
            }
        } else {
            $this->atimFlashWarning(__($arr_allow_deletion['msg']), $redirect_url);
        }
    }

    function manageContact()
    {
        $this->Structures->set('shipment_recipients');
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        $contacts_model = AppModel::getInstance("Order", "ShipmentContact", true);
        $this->request->data = $contacts_model->find('all');
    }

    function saveContact()
    {
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        if (! empty($this->request->data) && isset($this->request->data['Shipment'])) {
            $contacts_model = AppModel::getInstance("Order", "ShipmentContact", true);
            $shipment_contact_keys = array_fill_keys(array(
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
            $shipment_data = array_intersect_key($this->request->data['Shipment'], $shipment_contact_keys);
            
            $contacts_model->save($shipment_data);
            
            echo __('your data has been saved');
            exit();
        }
    }

    function deleteContact($contact_id)
    {
        $contacts_model = AppModel::getInstance("Order", "ShipmentContact", true);
        $contacts_model->atimDelete($contact_id);
        exit();
    }
}