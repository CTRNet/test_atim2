<?php
$model = $formData['model'];
$formBuilderId = $formData['formBuilderId'];
$this->request->data = (!empty($formData['master']))?$formData['indexData']:$formData['indexData'];

$structureOptions = array(
    'links' => array(
        'top' => "/Administrate/FormBuilders/add/$formBuilderId",
    ),
    'type' => 'add',
    'settings' =>array(
        'header' => __("control information"),
        'form_bottom' => false
    )
);

$this->Structures->build($atimStructure, $structureOptions);


$structureLinks = array(
    'top' => "/Administrate/FormBuilders/add/$formBuilderId",
    'bottom' => array(
        'cancel' => "/Administrate/FormBuilders/detail/$formBuilderId"
    )
);

$structureOptions = array(
    'links' => $structureLinks,
    'type' => 'addgrid',
    'settings' =>array(
        'header' => __("control information"),
        'add_fields' => true,
        'del_fields' => true
    )
);
if (isset($options["prefix-common"])){
    $structureOptions["settings"]['name_prefix'] = $options["prefix-common"];
}
$this->Structures->build($atimStructureForControl, $structureOptions);
?>

<script>
    var getI18nVariable = true;
    var i18n = Array();
    var typeValue = "";
    var warningValidationMessage = "<?php echo __("check the validations rules after changing the data type");?>";
    var warningValueDomainMessage = "<?php echo __("please select the list items");?>";
    var confirmMessage = "<?php echo __("do you want to update the labels?");?>";
    var alertMessage = "<?php echo __("the labels are already exist and unchangeable");?>";
    var addValidationMessage = "<?php echo __("click to add the validation rules");?>";
    var addValueDomainMessage = "<?php echo __("click to add/modify list");?>";
    var errorToFromMesage = "<?php echo __("should complete both or none of them");?>";
    var validationData = '<?php echo (isset($this->request->data['validationData'])?$this->request->data['validationData']:""); ?>';
    var valueDomainData = '<?php echo (isset($this->request->data['valueDomainData'])?$this->request->data['valueDomainData']:""); ?>';
    
    
    var copyStr = "<?php echo(__("copy", null)); ?>";
    var pasteStr = "<?php echo(__("paste")); ?>";
    var copyingStr = "<?php echo(__("copying")); ?>";
    var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
    var copyControl = true;
</script>

<?php
echo $this->Html->script('form-builder');
?>
<style>
    input[type=checkbox]{
        display: inline-block;
        width: 100%;
    }
</style>