<?php

class RtbformAppController extends AppController
{	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Rtbform/';
	}
	
}

?>