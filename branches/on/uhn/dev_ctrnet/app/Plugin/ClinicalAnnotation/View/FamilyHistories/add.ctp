<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/FamilyHistories/add/' . $atimMenuVariables['Participant.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/FamilyHistories/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

$structureSettings = array(
    'pagination' => false,
    'add_fields' => true,
    'del_fields' => true
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'addgrid',
    'settings' => $structureSettings
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>