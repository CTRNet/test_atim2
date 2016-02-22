<?php
App::uses('AppModel', 'Model');

class StructureFormat extends AppModel {

	var $name = 'StructureFormat';

	var $belongsTo = array('StructureField');
	
}