<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */
 
// No diagnosis can be created thus no event can be linked to a diagnosis.
// Activate action to display buttons at the end of the event data section.
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
$finalOptions['links']['bottom'] = array(
    'cancel' => '/ClinicalAnnotation/EventMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id']
);