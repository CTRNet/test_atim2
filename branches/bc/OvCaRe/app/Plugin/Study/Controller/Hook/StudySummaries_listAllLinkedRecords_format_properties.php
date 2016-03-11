<?php

$linked_records_properties['participants (based on file maker application)'] = array();
$linked_records_properties['collections'] = array(
		'InventoryManagement.ViewCollection.ovcare_study_summary_id',
		'/InventoryManagement/Collections/detail/',
		'view_collection',
		'/InventoryManagement/Collections/detail/%%ViewCollection.collection_id%%/');

$sub_list_sorted = array(
	'consents',
	'collections',
	'aliquots',
	'aliquot uses',
	'orders',
	'order lines');
if($this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) {
	$sub_list_sorted = array_merge(array('participants', 'participants (based on file maker application)'), $sub_list_sorted);
}

$tmp_list = array();
foreach($sub_list_sorted as $sub_list_name) {
	if(array_key_exists($sub_list_name, $linked_records_properties)) {
		$tmp_list[$sub_list_name] = $linked_records_properties[$sub_list_name];
	}
}
$linked_records_properties = $tmp_list;

?>
