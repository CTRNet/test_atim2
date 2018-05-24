<?php
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
$finalOptions['links']['bottom'] = array(
    'cancel' => '/ClinicalAnnotation/EventMasters/listall/' . $atimMenuVariables['EventControl.event_group'] . '/' . $atimMenuVariables['Participant.id']
);