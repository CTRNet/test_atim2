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
 * Class OrderLine
 */
class OrderLine extends OrderAppModel
{

    public $hasMany = array(
        'OrderItem' => array(
            'className' => 'Order.OrderItem',
            'foreignKey' => 'order_line_id'
        )
    );

    public $belongsTo = array(
        'Order' => array(
            'className' => 'Order.Order',
            'foreignKey' => 'order_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'OrderLine.id'
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
        
        if (isset($variables['OrderLine.id']) && isset($variables['Order.id'])) {
            
            $this->bindModel(array(
                'belongsTo' => array(
                    'SampleControl' => array(
                        'className' => 'InventoryManagement.SampleControl',
                        'foreignKey' => 'sample_control_id'
                    ),
                    'AliquotControl' => array(
                        'className' => 'InventoryManagement.AliquotControl',
                        'foreignKey' => 'aliquot_control_id'
                    )
                )
            ));
            $result = $this->find('first', array(
                'conditions' => array(
                    'OrderLine.id' => $variables['OrderLine.id'],
                    'OrderLine.order_id' => $variables['Order.id']
                )
            ));
            $lineTitle = '';
            if ($result['OrderLine']['is_tma_slide']) {
                $lineTitle = __('tma slide');
            } else {
                $lineTitle = __($result['SampleControl']['sample_type']) . (empty($result['AliquotControl']['aliquot_type']) ? '' : ' ' . __($result['AliquotControl']['aliquot_type']));
            }
            $lineTitle .= strlen($result['OrderLine']['product_type_precision']) ? ' : ' . $result['OrderLine']['product_type_precision'] : '';
            $return = array(
                'menu' => array(
                    null,
                    $lineTitle
                ),
                'title' => array(
                    null,
                    __('order line', null) . ' : ' . $lineTitle
                ),
                'data' => $result,
                'structure alias' => 'orderlines'
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
        $this->validateAndUpdateOrderLineStudyData();
        
        $this->addWritableField(array(
            'sample_control_id',
            'aliquot_control_id',
            'is_tma_slide'
        ));
        
        return parent::validates($options);
    }

    /**
     * Check order line study definition and set error if required.
     */
    public function validateAndUpdateOrderLineStudyData()
    {
        $orderLineData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($orderLineData);
        if ((! is_array($orderLineData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['OrderLine']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $orderLineData) && array_key_exists('autocomplete_order_line_study_summary_id', $orderLineData['FunctionManagement'])) {
            $orderLineData['OrderLine']['study_summary_id'] = null;
            $orderLineData['FunctionManagement']['autocomplete_order_line_study_summary_id'] = trim($orderLineData['FunctionManagement']['autocomplete_order_line_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($orderLineData['FunctionManagement']['autocomplete_order_line_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($orderLineData['FunctionManagement']['autocomplete_order_line_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $orderLineData['OrderLine']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_order_line_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function beforeSave($options = array())
    {
        $retVal = parent::beforeSave($options);
        if (isset($this->data['FunctionManagement']['product_type'])) {
            if (preg_match('/^(.*)\|(.*)\|(.*)$/', $this->data['FunctionManagement']['product_type'], $matches)) {
                $this->data['OrderLine']['sample_control_id'] = $matches[1];
                $this->data['OrderLine']['aliquot_control_id'] = $matches[2];
                $this->data['OrderLine']['is_tma_slide'] = $matches[3];
            } else {
                $this->data['OrderLine']['sample_control_id'] = '';
                $this->data['OrderLine']['aliquot_control_id'] = '';
                $this->data['OrderLine']['is_tma_slide'] = '';
            }
            $this->addWritableField(array(
                'sample_control_id',
                'aliquot_control_id',
                'is_tma_slide'
            ));
        }
        return $retVal;
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results, $primary);
        
        if (isset($results['0']['OrderLine'])) {
            $orderItem = null;
            foreach ($results as &$newOrderLine) {
                // Set order_line_completion
                $shippedCounter = 0;
                $itemsCounter = 0;
                if (isset($newOrderLine['OrderItem'])) {
                    foreach ($newOrderLine['OrderItem'] as $newItem) {
                        ++ $itemsCounter;
                        if (in_array($newItem['status'], array(
                            'shipped',
                            'shipped & returned'
                        ))) {
                            ++ $shippedCounter;
                        }
                    }
                } elseif (isset($newOrderLine['OrderLine']['id'])) {
                    if (! $orderItem)
                        $orderItem = AppModel::getInstance('Order', 'OrderItem', true);
                    $itemsCounter = $orderItem->find('count', array(
                        'conditions' => array(
                            'OrderItem.order_line_id' => $newOrderLine['OrderLine']['id']
                        ),
                        'recursive' => - 1
                    ));
                    if ($itemsCounter)
                        $shippedCounter = $orderItem->find('count', array(
                            'conditions' => array(
                                'OrderItem.order_line_id' => $newOrderLine['OrderLine']['id'],
                                'OrderItem.status' => array(
                                    'shipped',
                                    'shipped & returned'
                                )
                            ),
                            'recursive' => - 1
                        ));
                }
                $newOrderLine['Generated']['order_line_completion'] = empty($itemsCounter) ? 'n/a' : $shippedCounter . '/' . $itemsCounter;
                // Set the order line product type value
                if (isset($newOrderLine['OrderLine']) && array_key_exists('sample_control_id', $newOrderLine['OrderLine']) && array_key_exists('aliquot_control_id', $newOrderLine['OrderLine']) && array_key_exists('is_tma_slide', $newOrderLine['OrderLine'])) {
                    $newOrderLine['FunctionManagement']['product_type'] = $newOrderLine['OrderLine']['sample_control_id'] . '|' . $newOrderLine['OrderLine']['aliquot_control_id'] . '|' . $newOrderLine['OrderLine']['is_tma_slide'];
                }
            }
        }
        return $results;
    }

    /**
     * Check if an order line can be deleted.
     *
     * @param $orderLineId Id of the studied order line.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($orderLineId)
    {
        // Check no order item exists
        $orderItemModel = AppModel::getInstance("Order", "OrderItem", true);
        $returnedNbr = $orderItemModel->find('count', array(
            'conditions' => array(
                'OrderItem.order_line_id' => $orderLineId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'item exists for the deleted order line'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     *
     * @return array
     */
    public function getProductTypes()
    {
        $producteTypes = array();
        if (Configure::read('order_item_type_config') != 2)
            $producteTypes = array(
                '||1' => __('tma slide')
            );
        if (Configure::read('order_item_type_config') != 3) {
            $aliquotControlModel = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
            $sampleAliquotAndControlIds = $aliquotControlModel->getSampleAliquotTypesPermissibleValues();
            foreach ($sampleAliquotAndControlIds as $key => $values)
                $producteTypes[$key . '|0'] = $values;
        }
        return $producteTypes;
    }
}