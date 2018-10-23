<?php
/** **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */

$finalOptions = array(
    'settings' => array(
        'actions' => (Configure::read('order_item_type_config') == '2'),
        'header' => null
    )
);