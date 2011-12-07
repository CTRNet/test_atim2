<?php

class OrderAppController extends AppController {

	static $search_links = array(
		'order'			=> array('link'=> '/order/orders/search/', 'icon' => 'search'),
		'order item'	=> array('link'=> '/order/order_items/search/', 'icon' => 'search'),
		'shipment'		=> array('link'=> '/order/shipments/search/', 'icon' => 'search')
	);
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
}

?>