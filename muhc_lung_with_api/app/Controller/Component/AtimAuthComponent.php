<?php

/**
 * Class AtimAuthComponent
 */

App::uses('AuthComponent', 'Controller/Component');

/**
 * Class AtimAuthComponent
 */
class AtimAuthComponent extends AuthComponent
{
    /**
     * @param string $message
     */
    public function flash($message) {
//        parent::flash($message);
        AppController::getInstance()->atimFlashError($message, '/Menus/');
//        if (API::isAPIMode()){
//                API::addToBundle($message);
//                API::sendDataAndClear();
//        }
    }
}