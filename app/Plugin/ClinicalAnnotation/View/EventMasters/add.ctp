<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
$structureLinks = array(
    'top' => '/ClinicalAnnotation/EventMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventControl.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/EventMasters/listall/' . $atimMenuVariables['EventControl.event_group'] . '/' . $atimMenuVariables['Participant.id']
    )
);

// 1- EVENT DATA

$structureSettings = array(
    'actions' => false,
    'header' => $evHeader,
    'form_bottom' => false
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks
);

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

// 2- DIAGNOSTICS
// Define radio should be checked
$radioChecked = $initialDisplay || empty($this->request->data['EventMaster']['diagnosis_master_id']);
$finalOptions = array(
    'type' => 'tree',
    'data' => $dataForChecklist,
    'settings' => array(
        'form_top' => false,
        'header' => __('related diagnosis'),
        'tree' => array(
            'DiagnosisMaster' => 'DiagnosisMaster'
        ),
        'form_inputs' => false
    ),
    'extras' => array(
        'start' => '<input type="radio" name="data[EventMaster][diagnosis_master_id]" value="" ' . ($radioChecked ? 'checked="checked"' : '') . '/>' . __('n/a', null)
    ),
    'links' => array(
        'top' => '/ClinicalAnnotation/EventMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventControl.id'] . '/',
        'bottom' => array(
            'cancel' => '/ClinicalAnnotation/EventMasters/listall/' . $atimMenuVariables['EventControl.event_group'] . '/' . $atimMenuVariables['Participant.id']
        ),
        'tree' => array(
            'DiagnosisMaster' => array(
                'radiolist' => array(
                    'EventMaster.diagnosis_master_id' => '%%DiagnosisMaster.id' . '%%'
                )
            )
        )
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

if ($displayNextSubForm) {
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
?>
<script>
    var treeView = true;
    var copyControl = true;
</script>