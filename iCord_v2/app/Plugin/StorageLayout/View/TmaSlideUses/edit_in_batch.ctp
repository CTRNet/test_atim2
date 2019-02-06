<?php
$structureLinks = array(
    'top' => '/StorageLayout/TmaSlideUses/editInBatch/',
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'settings' => array(
        'pagination' => false,
        'header' => __('tma slide uses')
    ),
    'extras' => '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/><input type="hidden" name="data[tma_slide_use_ids]" value="' . $tmaSlideUseIds . '"/>'
);

$finalAtimStructure = $atimStructure;

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script type="text/javascript">
var copyControl = true;
</script>