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
    'index' => array(
        'detail' => '/Protocol/ProtocolExtendMasters/detail/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/',
        'edit' => '/Protocol/ProtocolExtendMasters/edit/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/',
        'delete' => '/Protocol/ProtocolExtendMasters/delete/' . $atimMenuVariables['ProtocolMaster.id'] . '/%%ProtocolExtendMaster.id%%/'
    ),
    'bottom' => array(
        'add' => '/Protocol/ProtocolExtendMasters/add/' . $atimMenuVariables['ProtocolMaster.id']
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);