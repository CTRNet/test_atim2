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
 * Class OrderItem
 */
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

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'OrderItem.id'
        )
    );

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        foreach ($results as &$newItem) {
            if (array_key_exists('OrderItem', $newItem) && array_key_exists('aliquot_master_id', $newItem['OrderItem']) && array_key_exists('tma_slide_id', $newItem['OrderItem'])) {
                if (($newItem['OrderItem']['aliquot_master_id'] && $newItem['OrderItem']['tma_slide_id']) || (! $newItem['OrderItem']['aliquot_master_id'] && ! $newItem['OrderItem']['tma_slide_id'])) {
                    AppController::addWarningMsg(__('error on order item type - contact your administartor'));
                }
            }
            // Set generated data
            $newItem['Generated']['type'] = '';
            $newItem['Generated']['barcode'] = '';
            if (array_key_exists('AliquotMaster', $newItem) && $newItem['AliquotMaster']['id']) {
                $newItem['Generated']['type'] = 'aliquot';
                if (isset($newItem['AliquotMaster']['barcode']))
                    $newItem['Generated']['barcode'] = $newItem['AliquotMaster']['barcode'];
            }
            if (array_key_exists('TmaSlide', $newItem) && $newItem['TmaSlide']['id']) {
                $newItem['Generated']['type'] = 'tma slide';
                if (isset($newItem['TmaSlide']['barcode']))
                    $newItem['Generated']['barcode'] = $newItem['TmaSlide']['barcode'];
            }
            // Set the order line product type value
            if (isset($newItem['OrderLine']) && array_key_exists('sample_control_id', $newItem['OrderLine']) && array_key_exists('aliquot_control_id', $newItem['OrderLine']) && array_key_exists('is_tma_slide', $newItem['OrderLine'])) {
                $newItem['FunctionManagement']['product_type'] = $newItem['OrderLine']['sample_control_id'] . '|' . $newItem['OrderLine']['aliquot_control_id'] . '|' . $newItem['OrderLine']['is_tma_slide'];
                if ('||' == $newItem['FunctionManagement']['product_type'])
                    $newItem['FunctionManagement']['product_type'] = '';
            }
        }
        return $results;
    }

    /**
     * Check if an item can be deleted.
     *
     * @param $orderLineData Data of the studied order item.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($orderLineData)
    {
        // Check aliquot is not gel matrix used to create either core
        if (! empty($orderLineData['Shipment']['id'])) {
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
     * @param $foreignKeyField (aliquot_master_id or tma_slide_id) OrderItem foreign key field to check
     * @param $objectId
     * @param Id|string $orderItemId Id
     *        of the order item
     * @return bool
     * @internal param $id (aliquot_master_id
     *           or tma_slide_id value) Id of the object (AliquotMaster or TmaSlide) linked to the order item (that will be created or that will be updated)
     * @author N. Luc
     * @since 2016-05-16
     */
    public function checkOrderItemStatusCanBeSetToPendingOrShipped($foreignKeyField, $objectId, $orderItemId = '-1')
    {
        $res = $this->find('count', array(
            'conditions' => array(
                "OrderItem.id != '$orderItemId'",
                "OrderItem.$foreignKeyField" => $objectId,
                'OrderItem.status' => array(
                    'pending',
                    'shipped'
                )
            ),
            'recursive' => - 1
        ));
        if ($res) {
            return false;
        }
        return true;
    }
}