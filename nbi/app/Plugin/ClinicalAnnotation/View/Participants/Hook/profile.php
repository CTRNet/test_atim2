<?php
/** **********************************************************************
 * NBI Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// Add button to launch collection creation from profile.
// To speed up the data entry.
$structureLinks['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
$finalOptions['links'] = $structureLinks;