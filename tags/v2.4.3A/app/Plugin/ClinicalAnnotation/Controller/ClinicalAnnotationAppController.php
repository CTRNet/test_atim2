<?php

class ClinicalAnnotationAppController extends AppController {

	static $search_links = array(
		'participants' => array('link'=> '/ClinicalAnnotation/Participants/search/', 'icon' => 'search'),
		'misc identifiers' => array('link'=> '/ClinicalAnnotation/MiscIdentifiers/search/', 'icon' => 'search'),
		'participant messages' => array('link'=> '/ClinicalAnnotation/ParticipantMessages/search/', 'icon' => 'search')
	); 
}

?>