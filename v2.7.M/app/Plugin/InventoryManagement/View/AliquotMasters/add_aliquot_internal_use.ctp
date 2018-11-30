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
    'top' => '/InventoryManagement/AliquotMasters/addAliquotInternalUse/' . $aliquotMasterId,
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$parentSettings = array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false,
        'form_top' => false,
        'form_bottom' => false,
        'header' => __('aliquot use/event'),
        'stretch' => false,
        "language_heading" => __('used aliquot (for update)'),
        'section_start' => true
    )
);

$childrenSettings = array(
    'type' => 'addgrid',
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false,
        'form_top' => false,
        'form_bottom' => false,
        "add_fields" => true,
        "del_fields" => true,
        "language_heading" => __('use/event creation'),
        'section_end' => true
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243 : Derivative in batch: control id not posted when last record is hidden
$emptyStructureOptions = $parentSettings;
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['settings']['language_heading'] = '';
$emptyStructureOptions['settings']['header'] = '';
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';
$this->Structures->build(array(), $emptyStructureOptions);

if ($displayBatchProcessAliqStorageAndInStockDetails) {
    // Form to aplly data to all parents
    $structureOptions = $parentSettings;
    $structureOptions['settings']['header'] = array(
        'title' => __('aliquot use/event') . ' : ' . __('data to apply to all'),
        'description' => __('fields values of the section below will be applied to all other sections if entered and will replace sections fields values')
    );
    $structureOptions['settings']['section_start'] = false;
    $hookLink = $this->Structures->hook('apply_to_all');
    $this->Structures->build($batchProcessAliqStorageAndInStockDetails, $structureOptions);
}

// BUILD FORM

$hookLink = $this->Structures->hook('loop');

$first = true;
$creation = 0;

$manyStudiedAliquots = (sizeof($this->request->data) == 1) ? false : true;
while ($dataUnit = array_shift($this->request->data)) {
    $finalOptionsParent = $parentSettings;
    $finalOptionsChildren = $childrenSettings;
    
    $finalOptionsParent['settings']['header'] .= $manyStudiedAliquots ? " #" . (++ $creation) : '';
    $finalOptionsParent['data'] = $dataUnit['parent'];
    $finalOptionsParent['settings']['name_prefix'] = $dataUnit['parent']['AliquotMaster']['id'];
    $finalOptionsChildren['settings']['name_prefix'] = $dataUnit['parent']['AliquotMaster']['id'];
    
    $finalOptionsParent['data'] = $dataUnit['parent'];
    $finalOptionsChildren['data'] = $dataUnit['children'];
    
    if ($first) {
        $first = false;
        $finalOptionsParent['settings']['form_top'] = true;
    }
    if (empty($this->request->data)) {
        $finalOptionsChildren['settings']['actions'] = true;
        $finalOptionsChildren['settings']['form_bottom'] = true;
        if ($manyStudiedAliquots)
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    
    if (empty($dataUnit['parent']['AliquotControl']['volume_unit'])) {
        $finalStructureParent = $aliquotsStructure;
        $finalStructureChildren = $aliquotinternalusesStructure;
    } else {
        $finalStructureParent = $aliquotsVolumeStructure;
        $finalStructureChildren = $aliquotinternalusesVolumeStructure;
        $finalOptionsChildren['override']['AliquotControl.volume_unit'] = $dataUnit['parent']['AliquotControl']['volume_unit'];
    }
    
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalStructureParent, $finalOptionsParent);
    $this->Structures->build($finalStructureChildren, $finalOptionsChildren);
}
?>
<script>
var copyControl = true;
</script>