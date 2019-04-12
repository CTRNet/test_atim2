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
    'bottom' => array(
        'edit' => '/Tools/CollectionProtocol/edit/' . $atimMenuVariables['CollectionProtocol.id'] . '/',
        'delete' => '/Tools/CollectionProtocol/delete/' . $atimMenuVariables['CollectionProtocol.id'] . '/'
    )
);

// 1- PROTOCOL

$structureSettings = array(
    'actions' => false,
    'header' => __('protocol', null),
    'form_bottom' => false
);

$finalAtimStructure = $collectionProtocolStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'data' => $collectionProtocolData
);

$hookLink = $this->Structures->hook('protocol');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- SEPARATOR

$structureSettings = array(
    'actions' => false,
    'header' => __('visits', null),
    'form_top' => false,
    'form_bottom' => false
);

$this->Structures->build($emptyStructure, array(
    'settings' => $structureSettings
));

// 3- VISIT

$structureSettings = array(
    'pagination' => false,
    'add_fields' => true,
    'del_fields' => true,
    'form_top' => false
);

$dropdownOptions = array();

$finalAtimStructure = $collectionProtocolVisitStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'data' => $collectionProtocolVisitData,
    'type' => 'index',
    'settings' => $structureSettings
);

$hookLink = $this->Structures->hook('visit');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);