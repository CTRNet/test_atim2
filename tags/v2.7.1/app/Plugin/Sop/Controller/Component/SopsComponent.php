<?php

/**
 * Class SopsComponent
 */
class SopsComponent extends Object
{

    /**
     *
     * @param $controller
     * @param array $settings
     */
    public function initialize(&$controller, $settings = array())
    {
        $this->controller = & $controller;
    }
}