<?php
/** **********************************************************************
 * CUSM-Kidney Transplant
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-05-28
 */
 
$finalOptions['links']['bottom']['cancel'] = '/ClinicalAnnotation/EventMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id'];
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
