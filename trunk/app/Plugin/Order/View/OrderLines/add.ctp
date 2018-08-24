<?php
$structureLinks = array(
    'top' => '/Order/OrderLines/add/' . $atimMenuVariables['Order.id'] . '/',
    'bottom' => array(
        'cancel' => '/Order/Orders/detail/' . $atimMenuVariables['Order.id'] . '/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => array(
        'pagination' => false,
        'add_fields' => true,
        'del_fields' => true
    ),
    'type' => 'addgrid'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>