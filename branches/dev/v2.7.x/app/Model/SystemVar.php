<?php
App::uses('AppModel', 'Model');

class SystemVar extends AppModel {

	public $primaryKey = 'k';

	protected static $_cache = array();

	public function getVar($key) {
		if (isset(self::$_cache[$key])) {
			return self::$_cache[$key];
		}

		$val = $this->find('first', array('conditions' => array('k' => $key)));
		if ($val) {
			$val = $val['SystemVar']['v'];
			self::$_cache[$key] = $val;
		}
		return $val;
	}

	public function setVar($key, $val) {
		$this->save(array('k' => $key, 'v' => $val));
		self::$_cache[$key] = $val;
	}
}