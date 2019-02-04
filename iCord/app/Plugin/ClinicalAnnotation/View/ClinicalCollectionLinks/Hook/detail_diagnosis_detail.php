<?php
/** **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-01-31
 */

// Hide the Treatment and Event selection sections
$final_options['settings']['actions'] = true;
$structure_bottom_links = array(
	'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
	'delete collection link'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
	'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
	'details' => array('collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']),
	'copy for new collection'	=> array('link' => '/InventoryManagement/Collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy')
);
if($collection_data['consent_master_id']){
	$structure_bottom_links['details']['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['consent_master_id'].'/';
}
if($collection_data['diagnosis_master_id']){
	$structure_bottom_links['details']['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['diagnosis_master_id'].'/';
}
$final_options['links'] = array('bottom' => $structure_bottom_links);