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
 * Class Shipment
 */
class Shipment extends OrderAppModel
{

    public $name = 'Shipment';

    public $useTable = 'shipments';

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'Shipment.id'
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Shipment.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Shipment.id' => $variables['Shipment.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $result['Shipment']['shipment_code']
                ),
                'title' => array(
                    null,
                    __('shipment') . ' : ' . $result['Shipment']['shipment_code']
                ),
                'data' => $result,
                'structure alias' => 'shipments'
            );
        }
        
        return $return;
    }

    /**
     * Get array gathering all existing shipments.
     *
     * @param $orderId Id of the order linked to the shipments to return (null for all).
     *       
     * @author N. Luc
     * @since 2009-09-11
     *        @updated N. Luc
     * @return array
     */
    public function getShipmentPermissibleValues($orderId = null)
    {
        $result = array();
        
        $conditions = is_null($orderId) ? array() : array(
            'Shipment.order_id' => $orderId
        );
        foreach ($this->find('all', array(
            'conditions' => $conditions,
            'order' => 'Shipment.datetime_shipped DESC'
        )) as $shipment) {
            $result[$shipment['Shipment']['id']] = $shipment['Shipment']['shipment_code'];
        }
        
        return $result;
    }

    /**
     * Check if a shipment can be deleted.
     *
     * @param $shipmentId Id of the studied shipment.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($shipmentId)
    {
        // Check no item is linked to this shipment
        $orderItemModel = AppModel::getInstance("Order", "OrderItem", true);
        $returnedNbr = $orderItemModel->find('count', array(
            'conditions' => array(
                'OrderItem.shipment_id' => $shipmentId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'order item exists for the deleted shipment'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Check if an item can be removed from a shipment.
     *
     * @param $orderItemId Id of the studied item.
     * @param $shipmentId Id of the studied shipemnt.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowItemRemoveFromShipment($orderItemId, $shipmentId)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}