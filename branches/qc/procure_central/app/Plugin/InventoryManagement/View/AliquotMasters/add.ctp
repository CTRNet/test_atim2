<?php
$options = array(
    "links" => array(
        "top" => '/InventoryManagement/AliquotMasters/add/' . $sampleMasterId . '/0',
        'bottom' => array(
            'cancel' => $urlToCancel
        )
    )
);

if ($isAjax) {
    $options['links']['top'] .= '/1';
}
$optionsParent = array_merge($options, array(
    "type" => "edit",
    "settings" => array(
        "actions" => false,
        "form_top" => false,
        "form_bottom" => false,
        "stretch" => false,
        'section_start' => $isBatchProcess
    )
));

if (isset($templateNodeDefaultValues)) {
    $templateNodeDefaultValues = array_filter($templateNodeDefaultValues, function ($var) {
        return (! ($var == '' || is_null($var)));
    });
    $structureOverride = array_merge($structureOverride, $templateNodeDefaultValues);
}
$args = AppController::getInstance()->passedArgs;
if (isset($args['templateInitId'])) {
    $templateInitDefaultValues = Set::flatten(AppController::getInstance()->Session->read('Template.init_data.' . $args['templateInitId']));
    $templateInitDefaultValues = array_filter($templateInitDefaultValues, function ($var) {
        return (! ($var == '' || is_null($var)));
    });
    $structureOverride = array_merge($structureOverride, $templateInitDefaultValues);
}

$optionsChildren = array_merge($options, array(
    "type" => "addgrid",
    "settings" => array(
        "add_fields" => true,
        "del_fields" => true,
        "actions" => false,
        "form_top" => false,
        "form_bottom" => false,
        'section_end' => $isBatchProcess
    ),
    "override" => $structureOverride
));

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243 : Derivative in batch: control id not posted when last record is hidden
$emptyStructureOptions = $optionsParent;
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '
		<input type="hidden" name="data[0][realiquot_into]" value="' . $aliquotControlId . '"/>
		<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';

$this->Structures->build($emptyStructure, $emptyStructureOptions);

// print the layout
$hookLink = $this->Structures->hook('loop');
$counter = 0;
while ($data = array_shift($this->request->data)) {
    $counter ++;
    $parent = $data['parent'];
    $finalOptionsParent = $optionsParent;
    $finalOptionsChildren = $optionsChildren;
    if (count($this->request->data) == 0) {
        $finalOptionsChildren['settings']['form_bottom'] = true;
        $finalOptionsChildren['settings']['actions'] = true;
        if ($isBatchProcess)
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    if ($isBatchProcess)
        $finalOptionsParent['settings']['header'] = __('aliquot creation batch process') . ' - ' . __('creation') . " #" . $counter;
    $finalOptionsParent['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
    $finalOptionsParent['data'] = $parent;
    
    $finalOptionsChildren['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
    $finalOptionsChildren['data'] = $data['children'];
    
    if ($hookLink) {
        require ($hookLink);
    }
    
    if ($isBatchProcess)
        $this->Structures->build($sampleInfo, $finalOptionsParent);
    $this->Structures->build($atimStructure, $finalOptionsChildren);
}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>

<?php
if ($isAjax) {
    $display = ob_get_contents();
    ob_end_clean();
    $display = ob_get_contents() . $display;
    ob_clean();
    $this->layout = 'json';
    $this->json = array(
        'goToNext' => false,
        'page' => $display,
        'id' => null
    );
}