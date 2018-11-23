<?php

/**
 * Class OrderLinesController
 */
class OrderLinesController extends OrderAppController
{

    public $uses = array(
        'Order.Order',
        'Order.OrderLine',
        'Order.OrderItem',
        'Order.Shipment',
        
        'Study.StudySummary'
    );

    public $paginate = array(
        'OrderLine' => array(
            'order' => 'OrderLine.date_required DESC'
        )
    );

    /**
     *
     * @param $orderId
     */
    public function listall($orderId)
    {
        // MANAGE DATA
        $orderData = $this->Order->getOrRedirect($orderId);
        
        // Set data
        $this->request->data = $this->paginate($this->OrderLine, array(
            'OrderLine.order_id' => $orderId,
            'OrderLine.deleted' => 0
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Order/OrderLines/detail/%%Order.id%%/'));
        
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
     */
    public function add($orderId)
    {
        if (! $orderId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } elseif (Configure::read('order_item_to_order_objetcs_link_setting') == 3) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Check order
        $orderData = $this->Order->getOrRedirect($orderId);
        $this->set('structureOverride', array(
            'FunctionManagement.autocomplete_order_line_study_summary_id' => $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $orderData['Order']['default_study_summary_id']
                )
            )),
            'OrderLine.date_required' => $orderData['Order']['default_required_date'],
            'OrderLine.date_required_accuracy' => $orderData['Order']['default_required_date_accuracy']
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Order/OrderLines/detail/%%Order.id%%/'));
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId
        ));
        
        // SAVE PROCESS
        
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
            
            $rowCounter = 0;
            foreach ($this->request->data as &$dataUnit) {
                $rowCounter ++;
                $this->OrderLine->id = null;
                $this->OrderLine->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->OrderLine->set($dataUnit);
                if (! $this->OrderLine->validates()) {
                    foreach ($this->OrderLine->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errorsTracking[$field][$msg][] = $rowCounter;
                    }
                }
                $dataUnit = $this->OrderLine->data;
            }
            unset($dataUnit);
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // Launch Save Process
            
            if (empty($errorsTracking)) {
                $this->OrderLine->addWritableField(array(
                    'order_id',
                    'status'
                ));
                AppModel::acquireBatchViewsUpdateLock();
                // save all
                foreach ($this->request->data as $newDataToSave) {
                    // Set order id
                    $newDataToSave['OrderLine']['order_id'] = $orderId;
                    $newDataToSave['OrderLine']['status'] = 'pending';
                    // Save new recrod
                    $this->OrderLine->id = null;
                    $this->OrderLine->data = array();
                    if (! $this->OrderLine->save($newDataToSave, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                AppModel::releaseBatchViewsUpdateLock();
                $this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/' . $orderId);
            } else {
                $this->OrderLine->validationErrors = array();
                foreach ($errorsTracking as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->OrderLine->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                    }
                }
            }
        }
    }

    /**
     *
     * @param $orderId
     * @param $orderLineId
     */
    public function edit($orderId, $orderLineId)
    {
        if ((! $orderId) || (! $orderLineId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        $orderLineData = $this->OrderLine->find('first', array(
            'conditions' => array(
                'OrderLine.id' => $orderLineId,
                'OrderLine.order_id' => $orderId
            )
        ));
        if (empty($orderLineData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'OrderLine.id' => $orderLineId
        ));
        
        // SAVE PROCESS
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $orderLineData['FunctionManagement']['autocomplete_order_line_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $orderLineData['OrderLine']['study_summary_id']
                )
            ));
            $this->request->data = $orderLineData;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->OrderLine->id = $orderLineId;
                if ($this->OrderLine->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Order/OrderLines/detail/' . $orderId . '/' . $orderLineId);
                }
            }
        }
    }

    /**
     *
     * @param $orderId
     * @param $orderLineId
     */
    public function detail($orderId, $orderLineId)
    {
        if ((! $orderId) || (! $orderLineId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        $orderLineData = $this->OrderLine->find('first', array(
            'conditions' => array(
                'OrderLine.id' => $orderLineId,
                'OrderLine.order_id' => $orderId
            )
        ));
        if (empty($orderLineData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $orderLineData;
        
        $shipmentsList = $this->Shipment->find('all', array(
            'conditions' => array(
                'Shipment.order_id' => $orderId
            ),
            'recursive' => - 1
        ));
        $this->set('shipmentsList', $shipmentsList);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Order.id' => $orderId,
            'OrderLine.id' => $orderLineId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $orderId
     * @param $orderLineId
     */
    public function delete($orderId, $orderLineId)
    {
        // MANAGE DATA
        $orderLineData = $this->OrderLine->find('first', array(
            'conditions' => array(
                'OrderLine.id' => $orderLineId,
                'OrderLine.order_id' => $orderId
            )
        ));
        if (empty($orderLineData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->OrderLine->allowDeletion($orderLineId);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->OrderLine->atimDelete($orderLineId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Order/Orders/detail/' . $orderId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), 'javascript:history.go(-1)');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), 'javascript:history.go(-1)');
        }
    }
}