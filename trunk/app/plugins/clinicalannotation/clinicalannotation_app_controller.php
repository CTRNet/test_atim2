<?php

class ClinicalannotationAppController extends AppController {

	static $search_links = array(
		'participants' => array('link'=> '/clinicalannotation/participants/index/', 'icon' => 'search'),
		'misc identifiers' => array('link'=> '/clinicalannotation/misc_identifiers/index/', 'icon' => 'search'),
		'participant messages' => array('link'=> '/clinicalannotation/participant_messages/index/', 'icon' => 'search')
	); 

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
	
	
}

?>