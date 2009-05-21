<?php

class OrderLine extends OrderAppModel
{
	var $name = 'OrderLine';
	var $useTable = 'order_lines';
	var $hasMany = array(
						'OrderItem' =>
						 array('className'   => 'OrderItem',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'orderline_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => '')
						);
						
	var $validate = array();
	
}

?>