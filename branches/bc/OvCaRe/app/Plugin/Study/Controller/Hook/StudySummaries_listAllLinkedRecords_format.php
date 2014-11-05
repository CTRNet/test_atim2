<?php

$link_permissions['participant'] = false;
if($this->checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) {
	$link_permissions['participant'] = true;
}
$this->set('link_permissions', $link_permissions);

?>
