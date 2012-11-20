<?php
$form = $this->Structures->build($atim_structure, array(
		'type' 		=> 'add',
		'links'		=> array('top' => '/Datamart/BrowsingSteps/save/'.$node_id),
		'settings'	=> array('header' => __('save browsing steps'), 'return' => true)
));

$form = $this->Shell->validationErrors().ob_get_contents().$form;
$this->validationErrors = null;
$this->layout = 'json';
$this->json = array('type' => 'form', 'page' => $form);
