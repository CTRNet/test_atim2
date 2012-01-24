<?php
class MissingTranslation extends AppModel {

	var $name = 'MissingTranslation';
	var $validate = array(
		'id' => array(
			'rule' => 'isUnique',
			'message' => ''
		)
	);
	
	public $check_writtable_fields = false;
}
?>