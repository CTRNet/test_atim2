<?php

/**
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */
App::uses('DebugPanel', 'DebugKit.Lib');

/**
 * Provides debug information on previous requests.
 */
class LogFilePanel extends DebugPanel {

    /**
     * Number of history elements to keep
     *
     * @var string
     */
    /**
     * Constructor
     *
     * @param array $settings Array of settings.
     */
    public function __construct($settings) {
    }

    /**
     * beforeRender callback function
     *
     * @param Controller $controller The controller.
     * @return array contents for panel
     */
    public function beforeRender(Controller $controller) {
    }

}