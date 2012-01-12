<?php

class OrderAppController extends AppController {

	static $search_links = array(
		'order'			=> array('link'=> '/Order/orders/search/', 'icon' => 'search'),
		'order item'	=> array('link'=> '/Order/OrderItems/search/', 'icon' => 'search'),
		'shipment'		=> array('link'=> '/Order/shipments/search/', 'icon' => 'search')
	);
	
}

?>