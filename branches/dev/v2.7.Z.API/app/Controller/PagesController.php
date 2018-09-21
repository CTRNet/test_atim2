<?php
/**
 * Static content controller.
 *
 * This file will render views from views/pages/
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link http://cakephp.org CakePHP(tm) Project
 * @package app.Controller
 * @since CakePHP(tm) v 0.2.9
 * @license MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
App::uses('AppController', 'Controller');

/**
 * Static content controller
 *
 * Override this controller by placing a copy in controllers directory of an application
 *
 * @package app.Controller
 * @link http://book.cakephp.org/2.0/en/controllers/pages-controller.html
 */
class PagesController extends AppController
{

    /**
     *
     * @var array
     */
    public $uses = array(
        'Page'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->AtimAuth->allowedActions = array(
            'display'
        );
    }

    /**
     * Displays a view
     *
     * @param mixed What page to display
     * @return void
     * @throws NotFoundException When the view file could not be found
     *         or MissingViewException in debug mode.
     */
    public function display()
    {
        $path = func_get_args();
        $results = $this->Page->getOrRedirect($path);
        if (isset($this->request->query['err_msg'])) {
            // this message will be displayed in red
            $results['err_trace'] = urldecode($this->request->query['err_msg']);
        }
        $results['Page']['language_body'] = __($results['Page']['language_body']);
        if (isset($this->request->query['p'])) {
            // these will be replaced in the body string
            $p = $this->request->query['p'];
            if (count($p) == 1) {
                $results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0]);
            } elseif (count($p) == 2) {
                $results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0], $p[1]);
            } elseif (count($p) == 3) {
                $results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0], $p[1], $p[2]);
            } elseif (count($p) > 3) {
                $results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0], $p[1], $p[2], $p[3]);
            }
            // if it's more than 4 we'll get a warning
        }
        $this->set('data', $results);
        
        if (isset($results) && isset($results['Page']) && isset($results['Page']['use_link']) && $results['Page']['use_link']) {
            $useLink = $results['Page']['use_link'];
        } else {
            $useLink = '/menus';
        }
        
        API::addToBundle(array('result'=>$results, 'link'=>$useLink), API::$errors);
        API::sendDataAndClear();
        
        $this->set('atimMenu', $this->Menus->get($useLink));
    }
}