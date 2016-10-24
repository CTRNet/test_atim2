<?php
App::uses('AppModel', 'Model');

class MissingTranslation extends AppModel {

	public $name = 'MissingTranslation';

	public $validate = array(
		'id' => array(
			'rule' => 'isUnique',
			'message' => ''
		)
	);

	public $checkWritableFields = false;
}