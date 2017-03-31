<?php
//***********************************************************************************************************************
//TODO Ying Request To Validate
//***********************************************************************************************************************
//	Collection.ovcare_study_summary_id
//***********************************************************************************************************************
// $linked_records_properties['collections'] = array(
// 	'InventoryManagement.ViewCollection.ovcare_study_summary_id',
// 	'/InventoryManagement/Collections/detail/',
// 	'view_collection',
// 	'/InventoryManagement/Collections/detail/%%ViewCollection.collection_id%%/');
//***********************************************************************************************************************
//TODO END Ying Request To Validate
//***********************************************************************************************************************

$linked_records_properties['participants (based on file maker application)'] = array(
  	'ClinicalAnnotation.EventMaster.ovcare_study_summary_id', 
  	'/ClinicalAnnotation/EventMasters/listall/', 
  	'eventmasters, ovcare_ed_study_inclusions',
  	'/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%');

$tmp_ordered_linked_records_properties = array();		
foreach(array('participants', 'participants (based on file maker application)', 'consents', 'aliquots', 'aliquot uses', 'orders', 'tma slides') as $tmp_key) {
	$tmp_ordered_linked_records_properties[$tmp_key] = $linked_records_properties[$tmp_key];
	
}
$linked_records_properties = $tmp_ordered_linked_records_properties;

?>
