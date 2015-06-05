<?php

$link_permissions['participant'] = false;
if($this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) {
	$link_permissions['participant'] = true;
}
$link_permissions['consent'] = false;
if($this->checkLinkPermission('/ClinicalAnnotation/ConsentMasters/listall/')) {
	$link_permissions['consent'] = true;
}
$this->set('link_permissions', $link_permissions);

?>
