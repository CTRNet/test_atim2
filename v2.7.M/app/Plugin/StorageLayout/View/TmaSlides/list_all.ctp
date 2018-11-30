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
        'detail' => '/StorageLayout/TmaSlides/detail/' . $atimMenuVariables['StorageMaster.id'] . '/%%TmaSlide.id%%',
        'edit' => '/StorageLayout/TmaSlides/edit/' . $atimMenuVariables['StorageMaster.id'] . '/%%TmaSlide.id%%',
        'delete' => '/StorageLayout/TmaSlides/delete/' . $atimMenuVariables['StorageMaster.id'] . '/%%TmaSlide.id%%',
        'add to order' => array(
            "link" => '/Order/OrderItems/addOrderItemsInBatch/TmaSlide/%%TmaSlide.id%%/',
            "icon" => "add_to_order"
        )
    ),
    'bottom' => array(
        'add' => '/StorageLayout/TmaSlides/add/' . $atimMenuVariables['StorageMaster.id'] . '/'
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