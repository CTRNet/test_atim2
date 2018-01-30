<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/defineRealiquotedChildren/' . $aliquotId,
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$structureSettings = array(
    'pagination' => false,
    'form_top' => false,
    'form_bottom' => false,
    'actions' => false
);

$finalAtimStructure = $atimStructureForChildrenAliquotsSelection;
$options = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'settings' => $structureSettings
);
$parentOptions = array_merge($options, array(
    "type" => "edit",
    "settings" => array_merge($structureSettings, array(
        "stretch" => false,
        'section_start' => true
    ))
));
$parentOptions['settings']["language_heading"] = __('parent aliquot (for update)');

$childrenOptions = array_merge($options, array(
    'type' => 'addgrid',
    'links' => $structureLinks,
    'settings' => array_merge($structureSettings, array(
        'section_end' => true
    ))
));
$childrenOptions['settings']["language_heading"] = __('selected children aliquot(s)');

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243 : Derivative in batch: control id not posted when last record is hidden
$emptyStructureOptions = $options;
$emptyStructureOptions['type'] = "edit";
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
    $structureOptions = $parentOptions;
    $structureOptions['settings']['header'] = array(
        'title' => __('realiquoting process') . ' : ' . __('data to apply to all'),
        'description' => __('fields values of the section below will be applied to all other sections if entered and will replace sections fields values')
    );
    $structureOptions['settings']['section_start'] = false;
    $hookLink = $this->Structures->hook('apply_to_all');
    $this->Structures->build($batchProcessAliqStorageAndInStockDetails, $structureOptions);
}

// BUILD FORM
$hookLink = $this->Structures->hook('loop');
$counter = 0;
$elementNbr = sizeof($this->request->data);
foreach ($this->request->data as $aliquot) {
    $counter ++;
    
    $finalParentOptions = $parentOptions;
    $finalChildrenOptions = $childrenOptions;
    if ($elementNbr == $counter) {
        $finalChildrenOptions['settings']['form_bottom'] = true;
        $finalChildrenOptions['settings']['actions'] = true;
        if (empty($aliquotId))
            $finalChildrenOptions['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    $finalParentOptions['settings']['header'] = __('realiquoting process') . ' - ' . __('children selection') . (empty($aliquotId) ? " #" . $counter : '');
    $finalParentOptions['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
    $finalParentOptions['data'] = $aliquot['parent'];
    $finalChildrenOptions['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
    $finalChildrenOptions['data'] = $aliquot['children'];
    
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($inStockDetail, $finalParentOptions);
    $this->Structures->build($finalAtimStructure, $finalChildrenOptions);
}

?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var labBookFields = new Array("<?php echo implode('", "', $labBookFields); ?>");
var labBookHideOnLoad = true;
</script>