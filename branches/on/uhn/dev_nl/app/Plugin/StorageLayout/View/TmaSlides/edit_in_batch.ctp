<?php
$structureLinks = array(
    'top' => '/StorageLayout/TmaSlides/editInBatch/',
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'settings' => array(
        'pagination' => false,
        'header' => __('tma slides')
    ),
    'extras' => '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/><input type="hidden" name="data[tma_slide_ids]" value="' . $tmaSlideIds . '"/>'
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