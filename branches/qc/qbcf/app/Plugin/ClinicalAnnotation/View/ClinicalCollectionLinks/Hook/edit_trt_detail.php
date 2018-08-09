<?php 
	$finalOptions['settings']['actions'] = true;
	$finalOptions['settings']['form_bottom'] = true;
	$finalOptions['links']['bottom'] = array('cancel' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atimMenuVariables['Participant.id'].'/');
	$finalOptions['links']['bottom'] = array('cancel' => '/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$atimMenuVariables['Participant.id'].'/'.$atimMenuVariables['Collection.id'].'/');