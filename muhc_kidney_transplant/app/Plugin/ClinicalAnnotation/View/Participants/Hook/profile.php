<?php
/** **********************************************************************
 * TFRI-4MS Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-05-28
 */

// Add button to launch collection creation from profile
$structureLinks['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
$finalOptions['links'] = $structureLinks;