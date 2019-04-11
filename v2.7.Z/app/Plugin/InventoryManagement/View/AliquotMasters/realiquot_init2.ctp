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
$bottom = array();
if (isset($labBookCtrlId))
    $bottom['add lab book (pop-up)'] = '/labbook/LabBookMasters/add/' . $labBookCtrlId . '/1/';
$bottom['cancel'] = $urlToCancel;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'header' => __('realiquoting process') . ' - ' . __('lab book selection')
    ),
    'links' => array(
        'top' => '/InventoryManagement/AliquotMasters/' . $realiquotingFunction . '/' . $aliquotId,
        'bottom' => $bottom
    ),
    'extras' => '<input type="hidden" name="data[sample_ctrl_id]" value="' . $sampleCtrlId . '"/>
					<input type="hidden" name="data[realiquot_from]" value="' . $realiquotFrom . '"/>
					<input type="hidden" name="data[0][realiquot_into]" value="' . $realiquotInto . '"/>
					<input type="hidden" name="data[0][ids]" value="' . $ids . '"/>
					<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>'
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