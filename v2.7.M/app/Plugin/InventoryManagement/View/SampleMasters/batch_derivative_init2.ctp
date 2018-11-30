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
$extras = '<input type="hidden" name="data[SampleMaster][ids]" value="' . $sampleMasterIds . '"/>
				<input type="hidden" name="data[AliquotMaster][ids]" value="' . (isset($aliquotMasterIds) ? $aliquotMasterIds : "") . '"/>
				<input type="hidden" name="data[SampleMaster][sample_control_id]" value="' . $sampleMasterControlId . '"/>
				<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="' . $parentSampleControlId . '"/>
				<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';

$bottom = array();
if (isset($labBookControlId))
    $bottom['add lab book (pop-up)'] = '/labbook/LabBookMasters/add/' . $labBookControlId . '/1/';
$bottom['cancel'] = $urlToCancel;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'header' => __('derivative creation process') . ' - ' . __('lab book selection')
    ),
    'links' => array(
        'top' => '/InventoryManagement/SampleMasters/batchDerivative/' . $aliquotMasterId,
        'bottom' => $bottom
    ),
    'extras' => $extras
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
?>

<script>
var labBookPopup = true;
</script>