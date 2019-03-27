<?php

/**
 * Class OrderAppController
 */
class OrderAppController extends AppController
{

    public static $searchLinks = array(
        'order' => array(
            'link' => '/Order/Orders/search/',
            'icon' => 'search'
        ),
        'order item' => array(
            'link' => '/Order/OrderItems/search/',
            'icon' => 'search'
        ),
        'shipment' => array(
            'link' => '/Order/Shipments/search/',
            'icon' => 'search'
        )
    );
}