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
        'parent aliquot detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
        'edit link' => '/InventoryManagement/AliquotMasters/editRealiquoting/%%Realiquoting.id%%/',
        'delete link' => '/InventoryManagement/AliquotMasters/deleteRealiquotingData/%%AliquotMaster.id%%/%%AliquotMasterChildren.id%%/child/'
    )
);

if ($displayLabBookUrl) {
    $structureLinks['index']['see lab book'] = array(
        'link' => '/labbook/LabBookMasters/detail/%%Realiquoting.generated_lab_book_master_id%%',
        'icon' => 'lab_book'
    );
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false,
        'pagination' => false
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);