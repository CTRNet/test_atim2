<?php

unset($linked_records_properties['tma slides']);

if($this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) {
	$tmp_participant_data = $linked_records_properties['participants'];
	unset($linked_records_properties['participants']);
	$linked_records_properties = array_merge(array('participants' => $tmp_participant_data, 'participants (based on file maker application)' => array()), $linked_records_properties);
} else {
	unset($linked_records_properties['participants']);
}

?>
