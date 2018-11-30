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
        'header' => __('realiquoting process') . ' - ' . __('aliquot type selection'),
        'stretch' => false
    ),
    'links' => array(
        'top' => ($skipLabBookSelectionStep ? '/InventoryManagement/AliquotMasters/' . $realiquotingFunction . '/' . $aliquotId : '/InventoryManagement/AliquotMasters/realiquotInit2/' . $processType . '/' . $aliquotId),
        'bottom' => array(
            'cancel' => $urlToCancel
        )
    ),
    'extras' => '<input type="hidden" name="data[sample_ctrl_id]" value="' . $sampleCtrlId . '"/>
			<input type="hidden" name="data[realiquot_from]" value="' . $realiquotFrom . '"/>
			<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>',
    'override' => array(
        '0.aliquots_nbr_per_parent' => '1'
    )
);
if ($defaultChildrenAliquotControlId) {
    $finalOptions['override']['0.realiquot_into'] = $defaultChildrenAliquotControlId;
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);