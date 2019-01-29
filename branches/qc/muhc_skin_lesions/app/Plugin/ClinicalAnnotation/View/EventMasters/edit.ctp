<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/EventMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id']
);

// 1- EVENT DATA

$structureSettings = array(
    'actions' => false,
    'form_bottom' => false
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- SEPARATOR & HEADER

$structureSettings = array(
    'header' => __('related diagnosis'),
    'form_top' => false,
    'tree' => array(
        'DiagnosisMaster' => 'DiagnosisMaster'
    ),
    'form_inputs' => false
);

// Define radio should be checked
$radioChecked = empty($this->request->data['EventMaster']['diagnosis_master_id']);

$structureLinks = array(
    'top' => '/ClinicalAnnotation/EventMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id'],
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/EventMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id']
    ),
    'tree' => array(
        'DiagnosisMaster' => array(
            'radiolist' => array(
                'EventMaster.diagnosis_master_id' => '%%DiagnosisMaster.id' . '%%'
            )
        )
    )
);

$finalOptions = array(
    'type' => 'tree',
    'data' => $dataForChecklist,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'start' => '<input type="radio" name="data[EventMaster][diagnosis_master_id]" ' . ($radioChecked ? 'checked="checked"' : '') . ' value=""/>' . __('n/a', null)
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