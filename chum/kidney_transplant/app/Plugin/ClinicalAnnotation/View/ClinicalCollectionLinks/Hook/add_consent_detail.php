<?php
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
$structureLinks['top'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/' . (isset($collectionProtocolId) ? $collectionProtocolId . '/' : '');
$finalOptions['links'] = $structureLinks;