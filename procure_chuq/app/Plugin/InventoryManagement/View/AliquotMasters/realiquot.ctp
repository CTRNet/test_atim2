<?php
$options = array(
    "links" => array(
        "top" => "/InventoryManagement/AliquotMasters/realiquot/" . $aliquotId,
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
        "language_heading" => __('parent aliquot (for update)'),
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
        "language_heading" => __('created children aliquot(s)'),
        'section_end' => true
    )
));

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243 : Derivative in batch: control id not posted when last record is hidden
$emptyStructureOptions = $optionsParent;
$emptyStructureOptions['settings']['language_heading'] = '';
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '<input type="hidden" name="data[ids]" value="' . $parentAliquotsIds . '"/>
		<input type="hidden" name="data[sample_ctrl_id]" value="' . $sampleCtrlId . '"/>
		<input type="hidden" name="data[realiquot_from]" value="' . $realiquotFrom . '"/>
		<input type="hidden" name="data[realiquot_into]" value="' . $realiquotInto . '"/>
		<input type="hidden" name="data[Realiquoting][lab_book_master_code]" value="' . $labBookCode . '"/>
		<input type="hidden" name="data[Realiquoting][sync_with_lab_book]" value="' . $syncWithLabBook . '"/>
		<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';
$this->Structures->build($emptyStructure, $emptyStructureOptions);

if ($displayBatchProcessAliqStorageAndInStockDetails) {
    // Form to aplly data to all parents
    $structureOptions = $optionsParent;
    $structureOptions['settings']['header'] = array(
        'title' => __('realiquoting process') . ' : ' . __('data to apply to all'),
        'description' => __('fields values of the section below will be applied to all other sections if entered and will replace sections fields values')
    );
    $structureOptions['settings']['section_start'] = false;
    $hookLink = $this->Structures->hook('apply_to_all');
    $this->Structures->build($batchProcessAliqStorageAndInStockDetails, $structureOptions);
}

// print the layout

$hookLink = $this->Structures->hook('loop');

$counter = 0;
$finalParentStructure = null;
$finalChildrenStructure = null;
while ($data = array_shift($this->request->data)) {
    $counter ++;
    $parent = $data['parent'];
    $finalOptionsParent = $optionsParent;
    $finalOptionsChildren = $optionsChildren;
    if (count($this->request->data) == 0) {
        $finalOptionsChildren['settings']['form_bottom'] = true;
        $finalOptionsChildren['settings']['actions'] = true;
        $finalOptionsChildren['settings']['actions'] = true;
        if (empty($aliquotId))
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    $finalOptionsParent['settings']['header'] = __('realiquoting process') . ' - ' . __('children creation') . (empty($aliquotId) ? " #" . $counter : '');
    $finalOptionsParent['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
    $finalOptionsParent['data'] = $parent;
    
    $finalOptionsChildren['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
    $finalOptionsChildren['override'] = $createdAliquotStructureOverride;
    $finalOptionsChildren['data'] = $data['children'];
    
    if (empty($parent['AliquotControl']['volume_unit'])) {
        $finalParentStructure = $inStockDetail;
    } else {
        $finalParentStructure = $inStockDetailVolume;
    }
    
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalParentStructure, $finalOptionsParent);
    $this->Structures->build($atimStructure, $finalOptionsChildren);
}
?>

<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var labBookFields = new Array("<?php echo implode('", "', $labBookFields); ?>");
var labBookHideOnLoad = true;
</script>