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
    'top' => '/StorageLayout/TmaSlides/edit/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'] . "/$fromSlidePage",
    'bottom' => array(
        'cancel' => ($fromSlidePage ? '/StorageLayout/TmaSlides/detail/' . $atimMenuVariables['StorageMaster.id'] . '/' . $atimMenuVariables['TmaSlide.id'] : '/StorageLayout/StorageMasters/detail/' . $atimMenuVariables['StorageMaster.id'])
    )
);

$structureOverride = array();
$settings = array(
    'header' => __('tma slide')
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);