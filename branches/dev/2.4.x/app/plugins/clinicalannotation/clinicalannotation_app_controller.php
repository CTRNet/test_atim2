<?php

class ClinicalannotationAppController extends AppController {

	static $search_links = array(
		'participants' => array('link'=> '/clinicalannotation/participants/search/', 'icon' => 'search'),
		'misc identifiers' => array('link'=> '/clinicalannotation/misc_identifiers/search/', 'icon' => 'search'),
		'participant messages' => array('link'=> '/clinicalannotation/participant_messages/search/', 'icon' => 'search')
	); 

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
	
	
}

?>