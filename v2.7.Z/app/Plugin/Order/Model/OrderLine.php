<?php

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

    public $registered_view = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'OrderLine.id'
        )
    );

    public static $study_model = null;

    function summary($variables = array())
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
            
            $line_title = __($result['SampleControl']['sample_type']) . (empty($result['AliquotControl']['aliquot_type']) ? '' : ' ' . __($result['AliquotControl']['aliquot_type']));
            $return = array(
                'menu' => array(
                    null,
                    $line_title
                ),
                'title' => array(
                    null,
                    __('order line', null) . ' : ' . $line_title
                ),
                'data' => $result,
                'structure alias' => 'orderlines'
            );
        }
        
        return $return;
    }

    function validates($options = array())
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
    function validateAndUpdateOrderLineStudyData()
    {
        $order_line_data = & $this->data;
        
        // check data structure
        $tmp_arr_to_check = array_values($order_line_data);
        if ((! is_array($order_line_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['OrderLine']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $order_line_data) && array_key_exists('autocomplete_order_line_study_summary_id', $order_line_data['FunctionManagement'])) {
            $order_line_data['OrderLine']['study_summary_id'] = null;
            $order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id'] = trim($order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id'])) {
                // Load model
                if (self::$study_model == null)
                    self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id']);
                
                // Set study summary id
                if (isset($arr_study_selection_results['StudySummary'])) {
                    $order_line_data['OrderLine']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arr_study_selection_results['error'])) {
                    $this->validationErrors['autocomplete_order_line_study_summary_id'][] = $arr_study_selection_results['error'];
                }
            }
        }
    }

    function beforeSave($options = array())
    {
        $ret_val = parent::beforeSave($options);
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
        return $ret_val;
    }

    function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results, $primary);
        
        if (isset($results['0']['OrderLine'])) {
            $OrderItem = null;
            foreach ($results as &$new_order_line) {
                // Set order_line_completion
                $shipped_counter = 0;
                $items_counter = 0;
                if (isset($new_order_line['OrderItem'])) {
                    foreach ($new_order_line['OrderItem'] as $new_item) {
                        ++ $items_counter;
                        if (in_array($new_item['status'], array(
                            'shipped',
                            'shipped & returned'
                        ))) {
                            ++ $shipped_counter;
                        }
                    }
                } elseif (isset($new_order_line['OrderLine']['id'])) {
                    if (! $OrderItem)
                        $OrderItem = AppModel::getInstance('Order', 'OrderItem', true);
                    $items_counter = $OrderItem->find('count', array(
                        'conditions' => array(
                            'OrderItem.order_line_id' => $new_order_line['OrderLine']['id']
                        ),
                        'recursive' => '-1'
                    ));
                    if ($items_counter)
                        $shipped_counter = $OrderItem->find('count', array(
                            'conditions' => array(
                                'OrderItem.order_line_id' => $new_order_line['OrderLine']['id'],
                                'OrderItem.status' => array(
                                    'shipped',
                                    'shipped & returned'
                                )
                            ),
                            'recursive' => '-1'
                        ));
                }
                $new_order_line['Generated']['order_line_completion'] = empty($items_counter) ? 'n/a' : $shipped_counter . '/' . $items_counter;
                // Set the order line product type value
                if (isset($new_order_line['OrderLine']) && array_key_exists('sample_control_id', $new_order_line['OrderLine']) && array_key_exists('aliquot_control_id', $new_order_line['OrderLine']) && array_key_exists('is_tma_slide', $new_order_line['OrderLine'])) {
                    $new_order_line['FunctionManagement']['product_type'] = $new_order_line['OrderLine']['sample_control_id'] . '|' . $new_order_line['OrderLine']['aliquot_control_id'] . '|' . $new_order_line['OrderLine']['is_tma_slide'];
                }
            }
        }
        return $results;
    }

    /**
     * Check if an order line can be deleted.
     *
     * @param $order_line_id Id
     *            of the studied order line.
     *            
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    function allowDeletion($order_line_id)
    {
        // Check no order item exists
        $order_item_model = AppModel::getInstance("Order", "OrderItem", true);
        $returned_nbr = $order_item_model->find('count', array(
            'conditions' => array(
                'OrderItem.order_line_id' => $order_line_id
            ),
            'recursive' => '-1'
        ));
        if ($returned_nbr > 0) {
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

    function getProductTypes()
    {
        $producte_types = array();
        if (Configure::read('order_item_type_config') != 2)
            $producte_types = array(
                '||1' => __('tma slide')
            );
        if (Configure::read('order_item_type_config') != 3) {
            $aliquot_control_model = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
            $sample_aliquot_and_control_ids = $aliquot_control_model->getSampleAliquotTypesPermissibleValues();
            foreach ($sample_aliquot_and_control_ids as $key => $values)
                $producte_types[$key . '|0'] = $values;
        }
        return $producte_types;
    }
}