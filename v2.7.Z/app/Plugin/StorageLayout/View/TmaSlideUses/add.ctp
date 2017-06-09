<?php
$structureLinks = array(
    'top' => '/StorageLayout/TmaSlideUses/add/' . $tmaSlideId,
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
        'header' => __('tma slide uses'),
        'stretch' => false,
        'section_start' => ($tmaSlideId ? false : true)
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
        'section_end' => ($tmaSlideId ? false : true)
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243
$emptyStructureOptions = $parentSettings;
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['settings']['language_heading'] = '';
$emptyStructureOptions['settings']['header'] = '';
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';

$this->Structures->build(array(), $emptyStructureOptions);

// BUILD FORM

$hookLink = $this->Structures->hook('loop');

$first = true;
$creation = 0;

$manyTmaBlocks = (sizeof($this->request->data) == 1) ? false : true;
while ($dataUnit = array_shift($this->request->data)) {
    $finalOptionsParent = $parentSettings;
    $finalOptionsChildren = $childrenSettings;
    
    $finalOptionsParent['settings']['header'] .= $manyTmaBlocks ? " #" . (++ $creation) : '';
    
    $finalOptionsParent['settings']['name_prefix'] = $dataUnit['parent']['TmaSlide']['id'];
    $finalOptionsChildren['settings']['name_prefix'] = $dataUnit['parent']['TmaSlide']['id'];
    
    $finalOptionsParent['data'] = $dataUnit['parent'];
    $finalOptionsChildren['data'] = $dataUnit['children'];
    
    if ($first) {
        $first = false;
        $finalOptionsParent['settings']['form_top'] = true;
    }
    if (empty($this->request->data)) {
        $finalOptionsChildren['settings']['actions'] = true;
        $finalOptionsChildren['settings']['form_bottom'] = true;
        if ($manyTmaBlocks)
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    
    $finalStructureParent = $tmaSlidesAtimStructure;
    $finalStructureChildren = $atimStructure;
    
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