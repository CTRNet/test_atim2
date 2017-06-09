<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id']
);

// 1- TRT
$structureSettings = array(
    'actions' => false,
    'header' => __('data', null),
    'form_bottom' => false
);

$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings
);
$finalAtimStructure = $atimStructure;

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

$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'],
    'tree' => array(
        'DiagnosisMaster' => array(
            'radiolist' => array(
                'TreatmentMaster.diagnosis_master_id' => '%%DiagnosisMaster.id' . '%%'
            )
        )
    ),
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id']
    )
);

$finalOptions = array(
    'type' => 'tree',
    'data' => $dataForChecklist,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'start' => '<input type="radio" name="data[TreatmentMaster][diagnosis_master_id]" ' . (! $radioChecked ? ' checked="checked"' : '') . ' value=""/>' . __('n/a', null)
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
</script>