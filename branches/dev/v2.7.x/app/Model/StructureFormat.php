<?php
App::uses('AppModel', 'Model');

class StructureFormat extends AppModel {

	public $name = 'StructureFormat';

	public $belongsTo = array('StructureField');

}