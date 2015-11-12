<?php

unset($linked_records_properties['consents']);
unset($linked_records_properties['tma slides']);

if($this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) {
	$linked_records_properties['participants'] = array();
} else {
	unset($linked_records_properties['participants']);
}

?>
