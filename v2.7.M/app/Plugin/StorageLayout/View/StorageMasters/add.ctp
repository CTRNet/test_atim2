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
    'top' => '/StorageLayout/StorageMasters/add/' . $atimMenuVariables['StorageControl.id'],
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$structureOverride = array();

$structureOverride['StorageMaster.storage_control_id'] = $storageControlId;
$structureOverride['StorageMaster.layout_description'] = $layoutDescription;
unset($this->request->data['StorageMaster']['layout_description']);

if (isset($predefinedParentStorageSelectionLabel)) {
    $structureOverride['FunctionManagement.recorded_storage_selection_label'] = $predefinedParentStorageSelectionLabel;
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);
$finalOptions['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);