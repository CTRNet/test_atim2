<?php
$structureLinks = array(
    'top' => '/Tools/CollectionProtocol/edit/' . $atimMenuVariables['CollectionProtocol.id'] . '/',
    'bottom' => array(
        'undo' => '/Tools/CollectionProtocol/edit/' . $atimMenuVariables['CollectionProtocol.id'] . '/' . true,
        'cancel' => '/Tools/CollectionProtocol/detail/' . $atimMenuVariables['CollectionProtocol.id'] . '/'
    )
);

// 1- PROTOCOL

$structureSettings = array(
    'actions' => false,
    'tabindex' => '1000',
    'header' => __('protocol', null),
    'form_bottom' => false
);

$finalAtimStructure = $collectionProtocolStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'data' => $collectionProtocolData
);
$hookLink = $this->Structures->hook('protocol');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- SEPARATOR

$structureSettings = array(
    'actions' => false,
    'tabindex' => '2000',
    'header' => __('visits', null),
    'form_top' => false,
    'form_bottom' => false
);

$this->Structures->build($emptyStructure, array(
    'settings' => $structureSettings
));

// 3- VISIT

$structureSettings = array(
    'tabindex' => '3000',
    'pagination' => false,
    'add_fields' => true,
    'del_fields' => true,
    'form_top' => false
);

$finalAtimStructure = $collectionProtocolVisitStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'data' => $collectionProtocolVisitData,
    'type' => 'addgrid',
    'settings' => $structureSettings
);

$hookLink = $this->Structures->hook('visit');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>