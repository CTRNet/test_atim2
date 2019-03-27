<?php
if (isset($this->request->data[0]['parent']['AliquotMaster'])) {
    $childStructureToUse = empty($this->request->data[0]['parent']['AliquotControl']['volume_unit']) ? $sourcealiquots : $aliquotsVolumeStructure;
    // hack structures to add aliquot data
    // start with parent
    foreach ($sampleInfo['Sfs'] as &$sfs) {
        $sfs['display_column'] -= 10;
    }
    
    // updating parent language headings
    foreach ($sampleInfo['Sfs'] as &$sfs) {
        if ($sfs['flag_edit']) {
            $sfs['language_heading'] = 'parent sample';
            break;
        }
    }
    foreach ($childStructureToUse['Sfs'] as &$sfs) {
        if ($sfs['flag_edit']) {
            $sfs['language_heading'] = 'aliquot source (for update)';
            break;
        }
    }
    
    // merging parent structures
    if (! empty($this->request->data[0]['parent']['AliquotControl']['volume_unit'])) {
        // volume structure
        $sampleInfo['Structure'] = array_merge(array(
            $sampleInfo['Structure']
        ), $childStructureToUse['Structure']);
        $derivativeStructure = $derivativeVolumeStructure;
    } else {
        $sampleInfo['Structure'] = array(
            $sampleInfo['Structure'],
            $childStructureToUse['Structure']
        );
    }
    $sampleInfo['Sfs'] = array_merge($sampleInfo['Sfs'], $childStructureToUse['Sfs']);
}

// structure options
$options = array(
    "links" => array(
        "top" => '/InventoryManagement/SampleMasters/batchDerivative/' . $aliquotMasterId,
        'bottom' => array(
            'cancel' => $urlToCancel
        )
    )
);

$optionsParent = array_merge($options, array(
    "type" => "edit",
    "settings" => array(
        "actions" => false,
        "form_top" => false,
        "form_bottom" => false,
        "stretch" => false,
        'section_start' => true
    )
));

$optionsChildren = array_merge($options, array(
    "type" => "addgrid",
    "settings" => array(
        "add_fields" => true,
        "del_fields" => true,
        "actions" => false,
        "form_top" => false,
        "form_bottom" => false,
        'language_heading' => __('derivatives'),
        'section_end' => true
    ),
    "override" => $createdSampleStructureOverride,
    "dropdown_options" => array(
        'DerivativeDetail.lab_book_master_id' => (isset($labBooksList) && (! empty($labBooksList))) ? $labBooksList : array(
            '' => ''
        )
    )
));

$dropdownOptions = array(
    'SampleMaster.parent_id' => (isset($parentSampleDataForDisplay) && (! empty($parentSampleDataForDisplay))) ? $parentSampleDataForDisplay : array(
        '' => ''
    ),
    'DerivativeDetail.lab_book_master_id' => (isset($labBooksList) && (! empty($labBooksList))) ? $labBooksList : array(
        '' => ''
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243 : Derivative in batch: control id not posted when last record is hidden
$emptyStructureOptions = $optionsParent;
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '
	<input type="hidden" name="data[SampleMaster][sample_control_id]" value="' . $childrenSampleControlId . '"/>
	<input type="hidden" name="data[DerivativeDetail][lab_book_master_code]" value="' . $labBookMasterCode . '"/>
	<input type="hidden" name="data[DerivativeDetail][sync_with_lab_book]" value="' . $syncWithLabBook . '"/>
	<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="' . $parentSampleControlId . '"/>
	<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>
	<input type="hidden" name="data[sample_master_ids]" value="' . $sampleMasterIds . '"/>';
$this->Structures->build($emptyStructure, $emptyStructureOptions);

if ($displayBatchProcessAliqStorageAndInStockDetails) {
    // Form to aplly data to all parents
    $structureOptions = $optionsParent;
    $structureOptions['settings']['header'] = array(
        'title' => __('derivative creation process') . ' : ' . __('data to apply to all'),
        'description' => __('fields values of the section below will be applied to all other sections if entered and will replace sections fields values')
    );
    $structureOptions['settings']['language_heading'] = __('aliquot source (for update)');
    $structureOptions['settings']['section_start'] = false;
    $hookLink = $this->Structures->hook('apply_to_all');
    $this->Structures->build($batchProcessAliqStorageAndInStockDetails, $structureOptions);
}

// print the layout
$hookLink = $this->Structures->hook('loop');
$counter = 0;
$oneParent = (sizeof($this->request->data) == 1) ? true : false;
while ($data = array_shift($this->request->data)) {
    $counter ++;
    $parent = $data['parent'];
    $finalOptionsParent = $optionsParent;
    $finalOptionsChildren = $optionsChildren;
    
    if (count($this->request->data) == 0) {
        $finalOptionsChildren['settings']['form_bottom'] = true;
        $finalOptionsChildren['settings']['actions'] = true;
        if (! $oneParent)
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    
    $prefix = isset($parent['AliquotMaster']) ? $parent['AliquotMaster']['id'] : $parent['ViewSample']['sample_master_id'];
    
    $finalOptionsParent['settings']['header'] = __('derivative creation process') . ' - ' . __('creation') . ($oneParent ? '' : " #" . $counter);
    $finalOptionsParent['settings']['name_prefix'] = $prefix;
    $finalOptionsParent['data'] = $parent;
    
    $finalOptionsChildren['settings']['name_prefix'] = $prefix;
    $finalOptionsChildren['data'] = $data['children'];
    $finalOptionsChildren['dropdown_options'] = $dropdownOptions;
    $finalOptionsChildren['override']['SampleMaster.parent_id'] = $parent['ViewSample']['sample_master_id'];
    if (isset($parent['AliquotMaster']) && ! empty($parent['AliquotControl']['volume_unit'])) {
        $finalOptionsChildren['override']['AliquotControl.volume_unit'] = $parent['AliquotControl']['volume_unit'];
    }
    
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($sampleInfo, $finalOptionsParent);
    $this->Structures->build($derivativeStructure, $finalOptionsChildren);
}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var labBookFields = new Array("<?php echo is_array($labBookFields) ? implode('", "', $labBookFields) : ""; ?>");
var labBookHideOnLoad = true;
</script>