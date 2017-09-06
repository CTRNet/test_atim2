<?php

class SopsComponent extends Object
{

    public function initialize(&$controller, $settings = array())
    {
        $this->controller = & $controller;
    }
}