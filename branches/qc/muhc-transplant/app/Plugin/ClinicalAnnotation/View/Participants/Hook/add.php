<?php 
	if(!isset($this->request->data) || empty($this->request->data)) $this->request->data['Participant']['date_of_birth'] = array('year_accuracy' => '1', 'month'=> '', 'day' => '', 'year' => '');
	