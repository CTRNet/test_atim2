<?php

class OrderItem extends OrderAppModel
{

    public $belongsTo = array(
        'OrderLine' => array(
            'className' => 'Order.OrderLine',
            'foreignKey' => 'order_line_id'
        ),
        'Shipment' => array(
            'className' => 'Order.Shipment',
            'foreignKey' => 'shipment_id'
        ),
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'aliquot_master_id'
        ),
        'TmaSlide' => array(
            'className' => 'StorageLayout.TmaSlide',
            'foreignKey' => 'tma_slide_id'
        ),
        'ViewAliquot' => array(
            'className' => 'InventoryManagement.ViewAliquot',
            'foreignKey' => 'aliquot_master_id'
        )
    );

    public $registered_view = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'OrderItem.id'
        )
    );

    function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        foreach ($results as &$new_item) {
            if (array_key_exists('OrderItem', $new_item) && array_key_exists('aliquot_master_id', $new_item['OrderItem']) && array_key_exists('tma_slide_id', $new_item['OrderItem'])) {
                if (($new_item['OrderItem']['aliquot_master_id'] && $new_item['OrderItem']['tma_slide_id']) || (! $new_item['OrderItem']['aliquot_master_id'] && ! $new_item['OrderItem']['tma_slide_id'])) {
                    AppController::addWarningMsg(__('error on order item type - contact your administartor'));
                }
            }
            // Set generated data
            $new_item['Generated']['type'] = '';
            $new_item['Generated']['barcode'] = '';
            if (array_key_exists('AliquotMaster', $new_item) && $new_item['AliquotMaster']['id']) {
                $new_item['Generated']['type'] = 'aliquot';
                if (isset($new_item['AliquotMaster']['barcode']))
                    $new_item['Generated']['barcode'] = $new_item['AliquotMaster']['barcode'];
            }
            if (array_key_exists('TmaSlide', $new_item) && $new_item['TmaSlide']['id']) {
                $new_item['Generated']['type'] = 'tma slide';
                if (isset($new_item['TmaSlide']['barcode']))
                    $new_item['Generated']['barcode'] = $new_item['TmaSlide']['barcode'];
            }
            // Set the order line product type value
            if (isset($new_item['OrderLine']) && array_key_exists('sample_control_id', $new_item['OrderLine']) && array_key_exists('aliquot_control_id', $new_item['OrderLine']) && array_key_exists('is_tma_slide', $new_item['OrderLine'])) {
                $new_item['FunctionManagement']['product_type'] = $new_item['OrderLine']['sample_control_id'] . '|' . $new_item['OrderLine']['aliquot_control_id'] . '|' . $new_item['OrderLine']['is_tma_slide'];
                if ('||' == $new_item['FunctionManagement']['product_type'])
                    $new_item['FunctionManagement']['product_type'] = '';
            }
        }
        return $results;
    }

    /**
     * Check if an item can be deleted.
     *
     * @param $order_line_data Data
     *            of the studied order item.
     *            
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    function allowDeletion($order_line_data)
    {
        // Check aliquot is not gel matrix used to create either core
        if (! empty($order_line_data['Shipment']['id'])) {
            return array(
                'allow_deletion' => false,
                'msg' => 'this item cannot be deleted because it was already shipped'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Check if the order item status can be set/changed to 'pending' or 'shipped':
     * - An order item linked to an aliquot (or tma slide) can have a status equal to 'pending' or 'shipped'
     * - when no other order item linked to the same aliquot (or tma slide) has a status equal to 'pending' or 'shipped'
     *
     * @param $foreign_key_field (aliquot_master_id
     *            or tma_slide_id) OrderItem foreign key field to check
     * @param $id (aliquot_master_id
     *            or tma_slide_id value) Id of the object (AliquotMaster or TmaSlide) linked to the order item (that will be created or that will be updated)
     * @param $order_item_id Id
     *            of the order item
     *            
     * @return Boolean
     *
     * @author N. Luc
     * @since 2016-05-16
     */
    function checkOrderItemStatusCanBeSetToPendingOrShipped($foreign_key_field, $object_id, $order_item_id = '-1')
    {
        $res = $this->find('count', array(
            'conditions' => array(
                "OrderItem.id != '$order_item_id'",
                "OrderItem.$foreign_key_field" => $object_id,
                'OrderItem.status' => array(
                    'pending',
                    'shipped'
                )
            ),
            'recursive' => '-1'
        ));
        if ($res) {
            return false;
        }
        return true;
    }
}