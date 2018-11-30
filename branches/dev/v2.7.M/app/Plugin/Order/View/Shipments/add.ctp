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
$structureLinks = array(
    'top' => '/Order/Shipments/add/' . $atimMenuVariables['Order.id'] . '/0/' . $orderLineId . '/',
    'bottom' => array(
        'cancel' => '/Order/Orders/detail/' . $atimMenuVariables['Order.id'] . '/',
        'manage recipients' => array(
            'select recipient' => array(
                'icon' => 'detail',
                'link' => AppController::checkLinkPermission('/Order/Shipments/manageContact') ? 'javascript:manageContacts();' : '/notallowed/'
            ),
            'save recipient' => array(
                'icon' => 'disk',
                'link' => AppController::checkLinkPermission('/Order/Shipments/saveContact/') ? 'javascript:saveContact();' : '/notallowed/'
            )
        )
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

require ("contacts_functions.php");