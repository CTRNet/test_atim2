<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentControl.id'],
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/TreatmentMasters/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

// 1- TRT
$structureSettings = array(
    'actions' => false,
    'header' => $txHeader,
    'form_bottom' => false
);

$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings
);
$finalAtimStructure = $atimStructure;

if ($useAddgrid) {
    // *** Add new events in batch ***
    $finalOptions['settings'] = array_merge($finalOptions['settings'], array(
        'pagination' => false,
        'add_fields' => true,
        'del_fields' => true
    ));
    $finalOptions['type'] = 'addgrid';
}

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- SEPARATOR & HEADER

$structureSettings = array(
    'header' => __('related diagnosis', null),
    'form_top' => false,
    'tree' => array(
        'DiagnosisMaster' => 'DiagnosisMaster'
    ),
    'form_inputs' => false
);

// Define radio should be checked
$radioChecked = ! isset($this->request->data['TreatmentMaster']['diagnosis_master_id']);

$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentControl.id'],
    'tree' => array(
        'DiagnosisMaster' => array(
            'radiolist' => array(
                'TreatmentMaster.diagnosis_master_id' => '%%DiagnosisMaster.id' . '%%'
            )
        )
    ),
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/TreatmentMasters/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

$finalOptions = array(
    'type' => 'tree',
    'data' => $dataForChecklist,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'start' => '<input type="radio" name="data[TreatmentMaster][diagnosis_master_id]" ' . ($radioChecked ? 'checked="checked"' : '') . ' value=""/>' . __('n/a', null)
    )
);

$finalAtimStructure = array(
    'DiagnosisMaster' => $diagnosisStructure
);

$displayNextSubForm = true;

$hookLink = $this->Structures->hook('dx_list');
if ($hookLink) {
    require ($hookLink);
}

if ($displayNextSubForm)
    $this->Structures->build($finalAtimStructure, $finalOptions);
?>
<script>
var treeView = true;
var copyControl = true;
</script>