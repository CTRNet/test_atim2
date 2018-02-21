<?php

unset($structureLinks['bottom']['add identifier']);
$structureLinks['bottom']['add collection'] = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/';
$finalOptions['links'] = $structureLinks;
$finalOptions['settings']['actions'] = true;
$isAjax = true;