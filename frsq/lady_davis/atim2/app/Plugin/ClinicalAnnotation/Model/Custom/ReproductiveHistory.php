<?php

class ReproductiveHistoryCustom extends ReproductiveHistory
{
	var $name 		= "ReproductiveHistory";
	var $tableName	= "reporductive_histories";
	
	function beforeSave($options = array()) {
		$ret_val = parent::beforeSave();
		if(preg_match('/^[0-9]+$/', $this->data['ReproductiveHistory']['gravida']) && preg_match('/^[0-9]+$/', $this->data['ReproductiveHistory']['aborta'])) {
			$this->addWritableField(array('para'));
			$this->data['ReproductiveHistory']['para'] = $this->data['ReproductiveHistory']['gravida']  + $this->data['ReproductiveHistory']['aborta'];
		}
		return $ret_val; 
	}
}

?>