<?php
class SystemVar extends Model{
	
	var $primaryKey = 'k';
	
	private static $cache = array(); 
	
	function getVar($key){
		if(isset(self::$cache[$key])){
			return self::$cache[$key];
		}
		
		$val = $this->find('first', array('conditions' => array('k' => $key)));
		if($val){
			$val = $val['SystemVar']['v'];
			self::$cache[$key] = $val;
		}
		return $val;
	}
	
	function setVar($key, $val){
		$this->save(array('k' => $key, 'v' => $val));
		self::$cache[$key] = $val;
	}
	
}