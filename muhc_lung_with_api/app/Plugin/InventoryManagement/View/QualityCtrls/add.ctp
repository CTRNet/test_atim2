<?php

function updateHeading(array &$sfsArray, $heading)
{
    foreach ($sfsArray as &$sfs) {
        if ($sfs['flag_edit']) {
            $sfs['language_heading'] = $heading;
            break;
        }
    }
}

// preparing structures
$parentStructure = $samplesStructure;
$parentStructureWVol = null;
$childrenStructure = $qcStructure;
$childrenStructureWVol = $qcVolumeStructure;

if (isset($this->request->data[0]['parent']['AliquotMaster'])) {
    // we've got aliquots, prep parent with and w/o vol
    foreach ($parentStructure['Sfs'] as &$sfs) {
        $sfs['display_column'] -= 10;
    }
    
    // updating headings
    updateHeading($parentStructure['Sfs'], 'sample');
    updateHeading($aliquotsStructure['Sfs'], 'used aliquot');
    updateHeading($aliquotsVolumeStructure['Sfs'], 'used aliquot');
    
    $parentStructureWVol['Structure'] = array_merge(array(
        $parentStructure['Structure']
    ), $aliquotsVolumeStructure['Structure']);
    $parentStructureWVol['Sfs'] = array_merge($parentStructure['Sfs'], $aliquotsVolumeStructure['Sfs']);
    
    $parentStructure['Structure'] = array(
        $parentStructure['Structure'],
        $aliquotsStructure['Structure']
    );
    $parentStructure['Sfs'] = array_merge($parentStructure['Sfs'], $aliquotsStructure['Sfs']);
}

$links = array(
    'top' => '/InventoryManagement/QualityCtrls/add/' . $sampleMasterIdParameter,
    'bottom' => array(
        'cancel' => $cancelButton
    )
);

$optionsParent = array(
    'type' => 'edit',
    'links' => $links,
    'settings' => array(
        'header' => __('quality control creation process') . ' - ' . __('creation'),
        'form_top' => false,
        'actions' => false,
        'form_bottom' => false,
        'stretch' => false,
        'section_start' => true
    )
);

$optionsChildren = array(
    'type' => 'addgrid',
    'links' => $links,
    'settings' => array(
        'form_top' => false,
        'actions' => false,
        'form_bottom' => false,
        "add_fields" => true,
        "del_fields" => true,
        "language_heading" => __('quality controls'),
        'section_end' => true
    )
);

$first = true;
$counter = 0;

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243 : Derivative in batch: control id not posted when last record is hidden
$emptyStructureOptions = $optionsParent;
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['settings']['header'] = '';
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="' . $cancelButton . '"/>';

$this->Structures->build(array(), $emptyStructureOptions);

if ($displayBatchProcessAliqStorageAndInStockDetails) {
    // Form to aplly data to all parents
    $structureOptions = $optionsParent;
    $structureOptions['settings']['header'] = array(
        'title' => __('quality control creation process') . ' : ' . __('data to apply to all'),
        'description' => __('fields values of the section below will be applied to all other sections if entered and will replace sections fields values')
    );
    $structureOptions['settings']['language_heading'] = __('used aliquot');
    $structureOptions['settings']['section_start'] = false;
    $hookLink = $this->Structures->hook('apply_to_all');
    $this->Structures->build($batchProcessAliqStorageAndInStockDetails, $structureOptions);
}

// print the layout

$hookLink = $this->Structures->hook('loop');

$finalStructureParent = null;
$finalStructureChildren = null;

$oneParent = (sizeof($this->request->data) == 1) ? true : false;

while ($data = array_shift($this->request->data)) {
    $parent = $data['parent'];
    $prefix = isset($parent['AliquotMaster']) ? $parent['AliquotMaster']['id'] : $parent['ViewSample']['sample_master_id'];
    $finalOptionsParent = $optionsParent;
    $finalOptionsChildren = $optionsChildren;
    
    if (empty($this->request->data)) {
        // last row
        $finalOptionsChildren['settings']['actions'] = true;
        $finalOptionsChildren['settings']['form_bottom'] = true;
        if (! $oneParent)
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    
    $finalOptionsParent['data'] = $parent;
    
    $finalOptionsParent['settings']['header'] .= $oneParent ? '' : " #" . (++ $counter);
    $finalOptionsParent['settings']['name_prefix'] = $prefix;
    
    $finalOptionsChildren['settings']['name_prefix'] = $prefix;
    $finalOptionsChildren['data'] = $data['children'];
    
    if (isset($parent['AliquotControl']['volume_unit']) && strlen($parent['AliquotControl']['volume_unit']) > 0) {
        $finalStructureParent = $parentStructureWVol;
        $finalStructureChildren = $childrenStructureWVol;
        $finalOptionsChildren['override']['AliquotControl.volume_unit'] = $parent['AliquotControl']['volume_unit'];
    } else {
        $finalStructureParent = $parentStructure;
        $finalStructureChildren = $childrenStructure;
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