<?php

/**
 * Class AtimAuthComponent
 */

App::uses('AuthComponent', 'Controller/Component');
class AtimAuthComponent extends AuthComponent
{
    public function flash($message) {
        parent::flash($message);
        if (API::isAPIMode()){
                API::addToBundle($message);
                API::sendDataAndClear();
        }
    }
}