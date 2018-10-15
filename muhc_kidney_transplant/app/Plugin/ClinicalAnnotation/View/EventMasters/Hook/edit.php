<?php
/** **********************************************************************
 * CUSM-Kidney Transplant
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
$finalOptions['links']['bottom']['cancel'] = '/ClinicalAnnotation/EventMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['EventMaster.id'];
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
