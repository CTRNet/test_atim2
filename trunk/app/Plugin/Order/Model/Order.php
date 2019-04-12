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
 * Class Order
 */
class Order extends OrderAppModel
{

    public $hasMany = array(
        'OrderLine' => array(
            'className' => 'Order.OrderLine',
            'foreignKey' => 'order_id'
        ),
        'Shipment' => array(
            'className' => 'Order.Shipment',
            'foreignKey' => 'order_id'
        )
    );

    public $belongsTo = array(
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'default_study_summary_id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'Order.id'
        )
    );

    public static $studyModel = null;

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Order.id'])) {
            $this->warnUnconsentedAliquots($variables['Order.id']);
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Order.id' => $variables['Order.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    __('order'),
                    ': ' . $result['Order']['order_number']
                ),
                'title' => array(
                    null,
                    __('order') . ': ' . $result['Order']['order_number']
                ),
                'data' => $result,
                'structure alias' => 'orders'
            );
        }
        
        return $return;
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $this->validateAndUpdateOrderStudyData();
        
        return parent::validates($options);
    }

    /**
     * Check order study definition and set error if required.
     */
    public function validateAndUpdateOrderStudyData()
    {
        $orderData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($orderData);
        if ((! is_array($orderData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['Order']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $orderData) && array_key_exists('autocomplete_order_study_summary_id', $orderData['FunctionManagement'])) {
            $orderData['Order']['study_summary_id'] = null;
            $orderData['FunctionManagement']['autocomplete_order_default_study_summary_id'] = trim($orderData['FunctionManagement']['autocomplete_order_study_summary_id']);
            $this->addWritableField(array(
                'default_study_summary_id'
            ));
            if (strlen($orderData['FunctionManagement']['autocomplete_order_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($orderData['FunctionManagement']['autocomplete_order_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $orderData['Order']['default_study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_order_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }

    /**
     * Check if an order can be deleted.
     *
     * @param $orderId Id of the studied order.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($orderId)
    {
        // Check no order line exists
        $orderItemModel = AppModel::getInstance("Order", "OrderItem", true);
        $returnedNbr = $orderItemModel->find('count', array(
            'conditions' => array(
                'OrderItem.order_id' => $orderId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'order item exists for the deleted order'
            );
        }
        
        // Check no order line exists
        $orderLingModel = AppModel::getInstance("Order", "OrderLine", true);
        $returnedNbr = $orderLingModel->find('count', array(
            'conditions' => array(
                'OrderLine.order_id' => $orderId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'order line exists for the deleted order'
            );
        }
        
        // Check no order line exists
        $shipmentModel = AppModel::getInstance("Order", "Shipment", true);
        $returnedNbr = $shipmentModel->find('count', array(
            'conditions' => array(
                'Shipment.order_id' => $orderId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'shipment exists for the deleted order'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     *
     * @param $orderId
     */
    public function warnUnconsentedAliquots($orderId)
    {
        $orderItemModel = AppModel::getInstance("Order", "OrderItem", true);
        $orderItemData = $orderItemModel->find('all', array(
            'conditions' => array(
                'OrderItem.order_id' => $orderId,
                'OrderItem.aliquot_master_id IS NOT NULL'
            ),
            'fields' => array(
                'OrderItem.aliquot_master_id'
            ),
            'recursive' => 0
        ));
        
        if (empty($orderItemData)) {
            return;
        }
        
        $aliquotIds = array();
        foreach ($orderItemData as $orderItemDataUnit) {
            $aliquotIds[] = $orderItemDataUnit['OrderItem']['aliquot_master_id'];
        }
        
        if (! empty($aliquotIds)) {
            $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
            $unconsentedAliquots = $aliquotMasterModel->getUnconsentedAliquots(array(
                'id' => $aliquotIds
            ));
            if (! empty($unconsentedAliquots)) {
                AppController::addWarningMsg(__('aliquot(s) without a proper consent') . ": " . count($unconsentedAliquots));
            }
        }
    }
}