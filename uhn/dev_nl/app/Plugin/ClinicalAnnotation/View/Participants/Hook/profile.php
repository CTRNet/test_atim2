<?php
/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */
 
 // Add button to quickly create a collection from rpofile
 $finalOptions['links']['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
 $structureLinks['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
     