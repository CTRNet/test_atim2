<?php
/**
 * This file is loaded automatically by the app/webroot/index.php file after core.php
 *
 * This file should load/create any application wide configuration settings, such as
 * Caching, Logging, loading additional configuration files.
 *
 * You should also use this file to include any files that provide global functions/constants
 * that your application uses.
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Config
 * @since         CakePHP(tm) v 0.10.8.2117
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

$engine = 'File';

// In development mode, caches should expire quickly.
$duration = '+999 days';
if (Configure::read('debug') > 0) {
	$duration = '+10 seconds';
}

// Setup a 'default' cache configuration for use in the application.
Cache::config('default', array('engine' => $engine));
Cache::config('structures', array('engine' => $engine, 'path' => CACHE . "structures", 'duration' => $duration));
Cache::config('menus', array('engine' => $engine, 'path' => CACHE . "menus", 'duration' => $duration));
Cache::config('browser', array('engine' => $engine, 'path' => CACHE . "browser", 'duration' => $duration));
Cache::config('default', array('engine' => $engine));

/**
 * The settings below can be used to set additional paths to models, views and controllers.
 *
 * App::build(array(
 *     'Model'                     => array('/path/to/models/', '/next/path/to/models/'),
 *     'Model/Behavior'            => array('/path/to/behaviors/', '/next/path/to/behaviors/'),
 *     'Model/Datasource'          => array('/path/to/datasources/', '/next/path/to/datasources/'),
 *     'Model/Datasource/Database' => array('/path/to/databases/', '/next/path/to/database/'),
 *     'Model/Datasource/Session'  => array('/path/to/sessions/', '/next/path/to/sessions/'),
 *     'Controller'                => array('/path/to/controllers/', '/next/path/to/controllers/'),
 *     'Controller/Component'      => array('/path/to/components/', '/next/path/to/components/'),
 *     'Controller/Component/Auth' => array('/path/to/auths/', '/next/path/to/auths/'),
 *     'Controller/Component/Acl'  => array('/path/to/acls/', '/next/path/to/acls/'),
 *     'View'                      => array('/path/to/views/', '/next/path/to/views/'),
 *     'View/Helper'               => array('/path/to/helpers/', '/next/path/to/helpers/'),
 *     'Console'                   => array('/path/to/consoles/', '/next/path/to/consoles/'),
 *     'Console/Command'           => array('/path/to/commands/', '/next/path/to/commands/'),
 *     'Console/Command/Task'      => array('/path/to/tasks/', '/next/path/to/tasks/'),
 *     'Lib'                       => array('/path/to/libs/', '/next/path/to/libs/'),
 *     'Locale'                    => array('/path/to/locales/', '/next/path/to/locales/'),
 *     'Vendor'                    => array('/path/to/vendors/', '/next/path/to/vendors/'),
 *     'Plugin'                    => array('/path/to/plugins/', '/next/path/to/plugins/'),
 * ));
 *
 */

/**
 * Custom Inflector rules can be set to correctly pluralize or singularize table, model, controller names or whatever other
 * string is passed to the inflection functions
 *
 * Inflector::rules('singular', array('rules' => array(), 'irregular' => array(), 'uninflected' => array()));
 * Inflector::rules('plural', array('rules' => array(), 'irregular' => array(), 'uninflected' => array()));
 *
 */

/**
 * Plugins need to be loaded manually, you can either load them one by one or all of them in a single call
 * Uncomment one of the lines below, as you need. Make sure you read the documentation on CakePlugin to use more
 * advanced ways of loading plugins
 *
 * CakePlugin::loadAll(); // Loads all plugins at once
 * CakePlugin::load('DebugKit'); //Loads a single plugin named DebugKit
 *
 */
CakePlugin::loadAll(); // Loads all plugins at once

/**
 * You can attach event listeners to the request lifecycle as Dispatcher Filter. By default CakePHP bundles two filters:
 *
 * - AssetDispatcher filter will serve your asset files (css, images, js, etc) from your themes and plugins
 * - CacheDispatcher filter will read the Cache.check configure variable and try to serve cached content generated from controllers
 *
 * Feel free to remove or add filters as you see fit for your application. A few examples:
 *
 * Configure::write('Dispatcher.filters', array(
 *		'MyCacheFilter', //  will use MyCacheFilter class from the Routing/Filter package in your app.
 *		'MyPlugin.MyFilter', // will use MyFilter class from the Routing/Filter package in MyPlugin plugin.
 * 		array('callable' => $aFunction, 'on' => 'before', 'priority' => 9), // A valid PHP callback type to be called on beforeDispatch
 *		array('callable' => $anotherMethod, 'on' => 'after'), // A valid PHP callback type to be called on afterDispatch
 *
 * ));
 */
Configure::write('Dispatcher.filters', array(
	'AssetDispatcher',
	'CacheDispatcher'
));

/**
 * Configures default file logging options
 */
App::uses('CakeLog', 'Log');
CakeLog::config('debug', array(
	'engine' => 'File',
	'types' => array('notice', 'info', 'debug'),
	'file' => 'debug',
));
CakeLog::config('error', array(
	'engine' => 'File',
	'types' => array('warning', 'error', 'critical', 'alert', 'emergency'),
	'file' => 'error',
));

/**
 * Set Custom Error Handler
 */
App::uses('AppError', 'Lib');

/**
 * Default Configuration
 */

Configure::write('Config.language', 'eng');

Configure::write('use_compression', false);


/**
 * Define the complexity of a password format:
 *	- level 0: No constrain
 *	- level 1: Minimal length of 8 characters + contains at least one lowercase letter
 *	- level 2: level 1 + contains at least one number
 *	- level 3: level 2 + contains at least one uppercase letter
 *	- level 4: level 3 + special at least one character [!$-_.]
 */
Configure::write('password_security_level', 0);

/**
 * Maximum number of successive failed login attempts (max_login_attempts_from_IP) before an IP address is disabled.
 * Time in minute (time_mn_IP_disabled) before an IP adress can retest login.
 */
Configure::write('max_login_attempts_from_IP', 5);
/**
 * Time in minute (time_mn_IP_disabled) before an IP address is reactivated.
 */
Configure::write('time_mn_IP_disabled', 20);

/**
 * Maximum number of login attempts with a same username (max_user_login_attempts) before a username is disabled.
 */
Configure::write('max_user_login_attempts', 5);

/**
 * Period of password validity in month.
 * Keep empty if no control has to be done.
 * When password is invalid, a warning message will be displayed and the user will be redirect to the change password form.
 */
Configure::write('password_validity_period_month', null);

/**
 * Set the limit of records that could either be displayed in the databrowser results
 * form or into a report.
 */
Configure::write('databrowser_and_report_results_display_limit', 1000);

/**
 * Set the limit of items that could be processed in batch
 */
Configure::write('SampleDerivativeCreation_processed_items_limit', 50);		// SampleMasters.batchDerivative()

Configure::write('AliquotCreation_processed_items_limit', 50);				// AliquotMasters.add()
Configure::write('AliquotModification_processed_items_limit', 50);			// AliquotMasters.editInBatch()
Configure::write('AliquotInternalUseCreation_processed_items_limit', 50);	// AliquotMasters.addAliquotInternalUse()
Configure::write('RealiquotedAliquotCreation_processed_items_limit', 50);	// AliquotMasters.realiquot()
Configure::write('AliquotBarcodePrint_processed_items_limit', 50);			// AliquotMasters.printBarcodes()

Configure::write('QualityCtrlsCreation_processed_items_limit', 50);			// QualityCtrls.add()

Configure::write('AddAliquotToOrder_processed_items_limit', 50);			// OrderItems.addAliquotsInBatch()
Configure::write('AddAliquotToShipment_processed_items_limit', 50);			// Shipments.addToShipment()

Configure::write('TmaSlideCreation_processed_items_limit', 50);				// TmaSlides.add()

/**
 * Set the allowed links that exists between an OrderItem and different Order plugin objects:
 * 		1 => link OrderItem to both Order and OrderLine (order line submodule available)
 * 		2 => link OrderItem to OrderLine only (order line submodule available)
 * 		3 => link OrderItem to Order only (order line submodule not available)
 */
Configure::write('order_item_to_order_objetcs_link_setting', 1);		// SampleMasters.batchDerivative()

Configure::write('uploadDirectory', './atimUploadDirectory');

// ATiM2 configuration variables from Datatable

define('VALID_INTEGER', '/^[-+]?[\\s]?[0-9]+[\\s]?$/');
define('VALID_INTEGER_POSITIVE', '/^[+]?[\\s]?[0-9]+[\\s]?$/');
define('VALID_FLOAT', '/^[-+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
define('VALID_FLOAT_POSITIVE', '/^[+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
define('VALID_24TIME', '/^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/');

/**
 * Set Configuration
 */
// Copied from validation.php date + time
define('VALID_DATETIME_YMD', '%^(?:(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(-)(?:0?2\\1(?:29)))|(?:(?:(?:1[6-9]|2\\d)\\d{2})(-)(?:(?:(?:0?[13578]|1[02])\\2(?:31))|(?:(?:0?(1|[3-9])|1[0-2])\\2(29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\\2(?:0?[1-9]|1\\d|2[0-8])))\s([0-1][0-9]|2[0-3])\:[0-5][0-9]\:[0-5][0-9]$%');

// import APP code required...
App::import('Model', 'Config');
$configDataModel = new Config();

App::uses('AuthComponent', 'Controller/Component');
$userId = AuthComponent::user('id');
$loggedInGroup = AuthComponent::user('group_id');

// get CONFIG data from table and SET
$configResults = $configDataModel->getConfig($loggedInGroup, $userId);
// parse result, set configs/defines
$configDataModel->setConfig($configResults);

define('CONFIDENTIAL_MARKER', __('confidential data')); // Moved here to allow translation