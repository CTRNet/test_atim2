<?php

class Order extends OrderAppModel
{
	var $name = 'Order';
	var $useTable = 'orders';
	var $hasMany = array(
						'OrderLine' =>
						 array('className'   => 'OrderLine',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'order_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
                         'Shipment' =>
						 array('className'   => 'Shipment',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'order_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => '')
						);
                             
	var $validate = array();
	
}

?>