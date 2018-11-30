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
$canDelete = AppController::checkLinkPermission('/Order/Shipments/deleteContact/');
$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => array(
        'index' => array(
            'detail' => 'javascript:',
            'delete' => $canDelete ? 'javascript:deleteContact(%%ShipmentContact.id%%);' : '/cannot/'
        )
    ),
    'settings' => array(
        'header' => __('manage contacts'),
        'pagination' => false
    )
));