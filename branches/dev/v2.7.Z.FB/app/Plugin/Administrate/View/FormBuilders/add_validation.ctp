<?php
$structureOptions = array(
    'links' => array(
        'top' => "/Administrate/FormBuilders/add/1",
    ),
    'type' => 'edit',
    'settings' =>array(
        'header' => __("validation rules"),
    )
);

$this->Structures->build($formBuilderValidationStructure, $structureOptions);

if ($activeValidations===null){
    AppController::forceMsgDisplayInPopup();
    AppController::addWarningMsg(__("there is no validation rule for %s datatype", __($type)));
}
?>
<script>
    var addValidationsData = JSON.parse('<?php echo json_encode($activeValidations); ?>');
</script>