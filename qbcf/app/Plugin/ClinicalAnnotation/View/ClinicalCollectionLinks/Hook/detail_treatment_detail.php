<?php 
	
$finalOptions['settings']['actions'] = true;
	$finalOptions['settings']['form_bottom'] = true;
	$finalOptions['links']['bottom'] = array(
			'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atimMenuVariables['Participant.id'].'/'.$atimMenuVariables['Collection.id'],
			'delete'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atimMenuVariables['Participant.id'].'/'.$atimMenuVariables['Collection.id'],
			'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atimMenuVariables['Participant.id'].'/',
			'details' => array(
				'collection'=> '/InventoryManagement/Collections/detail/'.$atimMenuVariables['Collection.id'],
				'diagnosis event' => '/ClinicalAnnotation/TreatmentMasters/detail/'.$collectionData['participant_id'].'/'.$collectionData['treatment_master_id'].'/'),
			'copy for new collection'	=> array('link' => '/InventoryManagement/Collections/add/0/'.$atimMenuVariables['Collection.id'], 'icon' => 'copy')
	);