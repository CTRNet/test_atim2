<?php
/**
 * Routes configuration
 *
 * In this file, you set up routes to your controllers and their actions.
 * Routes are very important mechanism that allows you to freely connect
 * different URLs to chosen controllers and their actions (functions).
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
 * @package app.Config
 * @since CakePHP(tm) v 0.2.9
 * @license MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
/**
 * Here, we are connecting '/' (base path) to controller called 'Pages',
 * its action called 'display', and we pass a param to select the view file
 * to use (in this case, /app/View/Pages/home.ctp)...
 */
Router::connect('/Menus', array(
    'controller' => 'Menus',
    'action' => 'index'
));
Router::connect('/Menus/update', array(
    'controller' => 'Menus',
    'action' => 'update'
));
Router::connect('/Menus/tools', array(
    'controller' => 'Menus',
    'action' => 'index',
    'tools'
));
Router::connect('/Menus/datamart', array(
    'controller' => 'Menus',
    'action' => 'index',
    'datamart'
));

Router::connect('/Pages/*', array(
    'controller' => 'Pages',
    'action' => 'display'
));
Router::connect('/', array(
    'controller' => 'Users',
    'action' => 'login'
));
foreach (CakePlugin::loaded() as $plugin) {
    Router::connect('/' . $plugin . '/:controller', array(
        'plugin' => $plugin,
        'action' => 'index'
    ));
    Router::connect('/' . $plugin . '/:controller/:action/*', array(
        'plugin' => $plugin
    ));
}

Router::connect('/:controller/:action/*');