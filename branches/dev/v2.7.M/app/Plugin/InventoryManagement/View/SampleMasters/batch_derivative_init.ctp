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
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'header' => __('derivative creation process') . ' - ' . __('derivative type selection'),
        'stretch' => false
    ),
    'links' => array(
        'top' => ($skipLabBookSelectionStep ? '/InventoryManagement/SampleMasters/batchDerivative/' . $aliquotMasterId : '/InventoryManagement/SampleMasters/batchDerivativeInit2/' . $aliquotMasterId),
        'bottom' => array(
            'cancel' => $urlToCancel
        )
    ),
    'extras' => '<input type="hidden" name="data[SampleMaster][ids]" value="' . $ids . '"/>
					<input type="hidden" name="data[AliquotMaster][ids]" value="' . (isset($aliquotIds) ? $aliquotIds : "") . '"/>
					<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="' . $parentSampleControlId . '"/>
					<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);