<?php

class OrderItemCustom extends OrderItem {
	var $useTable = 'order_items';
	var $name = 'OrderItem';

	function beforeSave($options = array()) {
		if(array_key_exists('OrderItem', $this->data) && !$this->id && array_key_exists('order_id', $this->data['OrderItem'])) {
			//Initial record
			$this->data['OrderItem']['procure_created_by_bank'] = Configure::read('procure_bank_id');
			$this->addWritableField(array('procure_created_by_bank'));
		}
		parent::beforeSave($options);
	}
	
}
	
?>