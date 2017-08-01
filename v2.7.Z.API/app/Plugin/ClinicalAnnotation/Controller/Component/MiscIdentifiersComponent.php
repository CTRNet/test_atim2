<?php

class MiscIdentifiersComponent extends Object
{

    public function initialize(&$controller, $settings = array())
    {
        $this->controller = & $controller;
    }
}