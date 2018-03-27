<?php
/** **********************************************************************
 * TFRI-4MS Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */
 
// Hide Participant Identifier Section
unset($structureLinks['bottom']['add identifier']);
$finalOptions['settings']['actions'] = true;
$isAjax = true;
// Add button to launch collection creation from profile
$structureLinks['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
$finalOptions['links'] = $structureLinks;