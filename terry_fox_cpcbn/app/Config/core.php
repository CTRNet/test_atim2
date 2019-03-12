<?php
/**
 * This is core configuration file.
 *
 * Use it to configure core behavior of Cake.
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
 * CakePHP Debug Level:
 *
 * Production Mode:
 * 0: No error messages, errors, or warnings shown. Flash messages redirect.
 *
 * Development Mode:
 * 1: Errors and warnings shown, model caches refreshed, flash messages halted.
 * 2: As in 1, but also with full debug messages and SQL output.
 *
 * In production mode, flash messages redirect after a time interval.
 * In development mode, you need to click the flash message to continue.
 */
$debug = 2;
Configure::write('debug', $debug);

/**
 * ATiM Prod vs Test.
 *
 * 1: Core install name color will be changed to red and 'Test' word will be added to the install name.
 * 0: Install name will be displayed as usual.
 */
$isTest = 0;
Configure::write('IsTest', $isTest);

/**
 * Configure the Error handler used to handle errors for your application.
 * By default
 * ErrorHandler::handleError() is used. It will display errors using Debugger, when debug > 0
 * and log errors with CakeLog when debug = 0.
 *
 * Options:
 *
 * - `handler` - callback - The callback to handle errors. You can set this to any callable type,
 * including anonymous functions.
 * Make sure you add App::uses('MyHandler', 'Error'); when using a custom handler class
 * - `level` - integer - The level of errors you are interested in capturing.
 * - `trace` - boolean - Include stack traces for errors in log files.
 *
 * @see ErrorHandler for more information on error handling and configuration.
 */
Configure::write('Error', array(
    'handler' => 'ErrorHandler::handleError',
    'level' => E_ALL & ~ E_DEPRECATED,
    'trace' => true
));

/**
 * Configure the Exception handler used for uncaught exceptions.
 * By default,
 * ErrorHandler::handleException() is used. It will display a HTML page for the exception, and
 * while debug > 0, framework errors like Missing Controller will be displayed. When debug = 0,
 * framework errors will be coerced into generic HTTP errors.
 *
 * Options:
 *
 * - `handler` - callback - The callback to handle exceptions. You can set this to any callback type,
 * including anonymous functions.
 * Make sure you add App::uses('MyHandler', 'Error'); when using a custom handler class
 * - `renderer` - string - The class responsible for rendering uncaught exceptions. If you choose a custom class you
 * should place the file for that class in app/Lib/Error. This class needs to implement a render method.
 * - `log` - boolean - Should Exceptions be logged?
 * - `skipLog` - array - list of exceptions to skip for logging. Exceptions that
 * extend one of the listed exceptions will also be skipped for logging.
 * Example: `'skipLog' => array('NotFoundException', 'UnauthorizedException')`
 *
 * @see ErrorHandler for more information on exception handling and configuration.
 */
Configure::write('Exception', array(
    'handler' => 'ErrorHandler::handleException',
    'renderer' => 'ExceptionRenderer',
    'log' => true
));

/**
 * Application wide charset encoding
 */
Configure::write('App.encoding', 'UTF-8');

/**
 * To configure CakePHP *not* to use mod_rewrite and to
 * use CakePHP pretty URLs, remove these .
 *
 * htaccess
 * files:
 *
 * /.htaccess
 * /app/.htaccess
 * /app/webroot/.htaccess
 *
 * And uncomment the App.baseUrl below. But keep in mind
 * that plugin assets such as images, CSS and JavaScript files
 * will not work without URL rewriting!
 * To work around this issue you should either symlink or copy
 * the plugin assets into you app's webroot directory. This is
 * recommended even when you are using mod_rewrite. Handling static
 * assets through the Dispatcher is incredibly inefficient and
 * included primarily as a development convenience - and
 * thus not recommended for production applications.
 */
// Configure::write('App.baseUrl', env('SCRIPT_NAME'));

/**
 * To configure CakePHP to use a particular domain URL
 * for any URL generation inside the application, set the following
 * configuration variable to the http(s) address to your domain.
 * This
 * will override the automatic detection of full base URL and can be
 * useful when generating links from the CLI (e.g. sending emails)
 */
// Configure::write('App.fullBaseUrl', 'http://example.com');

/**
 * Web path to the public images directory under webroot.
 * If not set defaults to 'img/'
 */
// Configure::write('App.imageBaseUrl', 'img/');

/**
 * Web path to the CSS files directory under webroot.
 * If not set defaults to 'css/'
 */
// Configure::write('App.cssBaseUrl', 'css/');

/**
 * Web path to the js files directory under webroot.
 * If not set defaults to 'js/'
 */
// Configure::write('App.jsBaseUrl', 'js/');

/**
 * Uncomment the define below to use CakePHP prefix routes.
 *
 * The value of the define determines the names of the routes
 * and their associated controller actions:
 *
 * Set to an array of prefixes you want to use in your application. Use for
 * admin or other prefixed routes.
 *
 * Routing.prefixes = array('admin', 'manager');
 *
 * Enables:
 * `admin_index()` and `/admin/controller/index`
 * `manager_index()` and `/manager/controller/index`
 */
// Configure::write('Routing.prefixes', array('admin'));

/**
 * Turn off all caching application-wide.
 */
// Configure::write('Cache.disable', true);

/**
 * Enable cache checking.
 *
 * If set to true, for view caching you must still use the controller
 * public $cacheAction inside your controllers to define caching settings.
 * You can either set it controller-wide by setting public $cacheAction = true,
 * or in each action using $this->cacheAction = true.
 */
// Configure::write('Cache.check', true);

/**
 * Enable cache view prefixes.
 *
 * If set it will be prepended to the cache name for view file caching. This is
 * helpful if you deploy the same application via multiple subdomains and languages,
 * for instance. Each version can then have its own view cache namespace.
 * Note: The final cache file name will then be `prefix_cachefilename`.
 */
// Configure::write('Cache.viewPrefix', 'prefix');

/**
 * Session configuration.
 *
 * Contains an array of settings to use for session configuration. The defaults key is
 * used to define a default preset to use for sessions, any settings declared here will override
 * the settings of the default config.
 *
 * ## Options
 *
 * - `Session.cookie` - The name of the cookie to use. Defaults to 'CAKEPHP'
 * - `Session.timeout` - The number of minutes you want sessions to live for. This timeout is handled by CakePHP
 * - `Session.cookieTimeout` - The number of minutes you want session cookies to live for.
 * - `Session.checkAgent` - Do you want the user agent to be checked when starting sessions? You might want to set the
 * value to false, when dealing with older versions of IE, Chrome Frame or certain web-browsing devices and AJAX
 * - `Session.defaults` - The default configuration set to use as a basis for your session.
 * There are four builtins: php, cake, cache, database.
 * - `Session.handler` - Can be used to enable a custom session handler. Expects an array of callables,
 * that can be used with `session_save_handler`. Using this option will automatically add `session.save_handler`
 * to the ini array.
 * - `Session.autoRegenerate` - Enabling this setting, turns on automatic renewal of sessions, and
 * sessionids that change frequently. See CakeSession::$requestCountdown.
 * - `Session.ini` - An associative array of additional ini values to set.
 *
 * The built in defaults are:
 *
 * - 'php' - Uses settings defined in your php.ini.
 * - 'cake' - Saves session files in CakePHP's /tmp directory.
 * - 'database' - Uses CakePHP's database sessions.
 * - 'cache' - Use the Cache class to save sessions.
 *
 * To define a custom session handler, save it at /app/Model/Datasource/Session/<name>.php.
 * Make sure the class implements `CakeSessionHandlerInterface` and set Session.handler to <name>
 *
 * To use database sessions, run the app/Config/Schema/sessions.php schema using
 * the cake shell command: cake schema create Sessions
 */
Configure::write('Session', array(
    'defaults' => 'cake',
    'cookie' => 'ATiMC'
));
/**
 * A random string used in security hashing methods.
 */
Configure::write('Security.salt', 'somerandomstringforsecurityhash');

/**
 * A random numeric string (digits only) used to encrypt/decrypt strings.
 */
Configure::write('Security.cipherSeed', '768593096574535424921345678');

/**
 * Apply timestamps with the last modified time to static assets (js, css, images).
 * Will append a query string parameter containing the time the file was modified. This is
 * useful for invalidating browser caches.
 *
 * Set to `true` to apply timestamps when debug > 0. Set to 'force' to always enable
 * timestamping regardless of debug value.
 */
// Configure::write('Asset.timestamp', true);

/**
 * Compress CSS output by removing comments, whitespace, repeating tags, etc.
 * This requires a/var/cache directory to be writable by the web server for caching.
 * and /vendors/csspp/csspp.php
 *
 * To use, prefix the CSS link URL with '/ccss/' instead of '/css/' or use HtmlHelper::css().
 */
// Configure::write('Asset.filter.css', 'css.php');

/**
 * Plug in your own custom JavaScript compressor by dropping a script in your webroot to handle the
 * output, and setting the config below to the name of the script.
 *
 * To use, prefix your JavaScript link URLs with '/cjs/' instead of '/js/' or use JsHelper::link().
 */
// Configure::write('Asset.filter.js', 'custom_javascript_output_filter.php');

/**
 * The class name and database used in CakePHP's
 * access control lists.
 */
// Configure::write('Acl.classname', 'DbAcl');
// Configure::write('Acl.database', 'default');

/**
 * Uncomment this line and correct your server timezone to fix
 * any date & time related errors.
 */
// date_default_timezone_set('UTC');

/**
 * `Config.timezone` is available in which you can set users' timezone string.
 * If a method of CakeTime class is called with $timezone parameter as null and `Config.timezone` is set,
 * then the value of `Config.timezone` will be used. This feature allows you to set users' timezone just
 * once instead of passing it each time in function calls.
 */
// Configure::write('Config.timezone', 'Europe/Paris');

/**
 * Cache Engine Configuration
 * Default settings provided below
 *
 * File storage engine.
 *
 * Cache::config('default', array(
 * 'engine' => 'File', //[required]
 * 'duration' => 3600, //[optional]
 * 'probability' => 100, //[optional]
 * 'path' => CACHE, //[optional] use system tmp directory - remember to use absolute path
 * 'prefix' => 'cake_', //[optional] prefix every cache file with this string
 * 'lock' => false, //[optional] use file locking
 * 'serialize' => true, //[optional]
 * 'mask' => 0664, //[optional]
 * ));
 *
 * APC (http://pecl.php.net/package/APC)
 *
 * Cache::config('default', array(
 * 'engine' => 'Apc', //[required]
 * 'duration' => 3600, //[optional]
 * 'probability' => 100, //[optional]
 * 'prefix' => Inflector::slug(APP_DIR) . '_', //[optional] prefix every cache file with this string
 * ));
 *
 * Xcache (http://xcache.lighttpd.net/)
 *
 * Cache::config('default', array(
 * 'engine' => 'Xcache', //[required]
 * 'duration' => 3600, //[optional]
 * 'probability' => 100, //[optional]
 * 'prefix' => Inflector::slug(APP_DIR) . '_', //[optional] prefix every cache file with this string
 * 'user' => 'user', //user from xcache.admin.user settings
 * 'password' => 'password', //plaintext password (xcache.admin.pass)
 * ));
 *
 * Memcache (http://www.danga.com/memcached/)
 *
 * Cache::config('default', array(
 * 'engine' => 'Memcache', //[required]
 * 'duration' => 3600, //[optional]
 * 'probability' => 100, //[optional]
 * 'prefix' => Inflector::slug(APP_DIR) . '_', //[optional] prefix every cache file with this string
 * 'servers' => array(
 * '127.0.0.1:11211' // localhost, default port 11211
 * ), //[optional]
 * 'persistent' => true, // [optional] set this to false for non-persistent connections
 * 'compress' => false, // [optional] compress data in Memcache (slower, but uses less memory)
 * ));
 *
 * Wincache (http://php.net/wincache)
 *
 * Cache::config('default', array(
 * 'engine' => 'Wincache', //[required]
 * 'duration' => 3600, //[optional]
 * 'probability' => 100, //[optional]
 * 'prefix' => Inflector::slug(APP_DIR) . '_', //[optional] prefix every cache file with this string
 * ));
 */

/**
 * Configure the cache handlers that CakePHP will use for internal
 * metadata like class maps, and model schema.
 *
 * By default File is used, but for improved performance you should use APC.
 *
 * Note: 'default' and other application caches should be configured in app/Config/bootstrap.php.
 * Please check the comments in bootstrap.php for more info on the cache engines available
 * and their settings.
 */
$engine = 'File';

// In development mode, caches should expire quickly.
$duration = '+999 days';
if (Configure::read('debug') > 0) {
    $duration = '+10 seconds';
}

// Prefix each application on the same server with a different string, to avoid Memcache and APC conflicts.
$prefix = 'ATiM';

/**
 * Configure the cache used for general framework caching.
 * Path information,
 * object listings, and translation cache files are stored with this configuration.
 */
Cache::config('_cake_core_', array(
    'engine' => $engine,
    'prefix' => $prefix . 'cake_core_',
    'path' => CACHE . 'persistent' . DS,
    'serialize' => ($engine === 'File'),
    'duration' => $duration
));

/**
 * Configure the cache for model and datasource caches.
 * This cache configuration
 * is used to store schema descriptions, and table listings in connections.
 */
Cache::config('_cake_model_', array(
    'engine' => $engine,
    'prefix' => $prefix . 'cake_model_',
    'path' => CACHE . 'models' . DS,
    'serialize' => ($engine === 'File'),
    'duration' => $duration
));

Cache::config('structures', array(
    'engine' => $engine,
    'path' => CACHE . "structures",
    'duration' => $duration
));
Cache::config('menus', array(
    'engine' => $engine,
    'path' => CACHE . "menus",
    'duration' => $duration
));
Cache::config('browser', array(
    'engine' => $engine,
    'path' => CACHE . "browser",
    'duration' => $duration
));
Cache::config('default', array(
    'engine' => $engine
));

Configure::write('use_compression', $debug > 0 ? false : true);
Configure::write('Session.timeout', $debug ? 3600 : 3600);

// --------------------------------------------------------------------------------------------------------------------------------------------
// UPLOAD FILE
// --------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Let user to download a file on the server using a ATiM field with setting set to 'File'.
 *
 * By default, the file will be downloaded into the \atimUploadDirectory. Path of the file
 * could be changed by another one changing the value of the $uploadDirectory variable.
 */

$uploadDirectory = substr(APP, 0, strlen(APP) - 4);

Configure::write('uploadDirectory', $uploadDirectory . 'atimUploadDirectory');
Configure::write('deleteDirectory', 'deleteDirectory');
Configure::write('deleteUploadedFilePhysically', false);
Configure::write('maxUploadFileSize', 10 * 1024 * 1024);

// --------------------------------------------------------------------------------------------------------------------------------------------
// LOGIN & PASSWORD
// --------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Define the complexity of a password format:
 * - level 0: No constrain
 * - level 1: Minimal length of 8 characters + contains at least one lowercase letter
 * - level 2: level 1 + contains at least one number
 * - level 3: level 2 + contains at least one uppercase letter
 * - level 4: level 3 + special at least one character [!$-_.]
 */
Configure::write('password_security_level', 2);

/**
 * Maximum number of successive failed login attempts (max_login_attempts_from_IP)
 * before an IP address is temporary disabled what ever the username used.
 *
 * See 'time_mn_IP_disabled' core variable to set the time before an IP address is reactivated.
 * Set value to null if you don't want the system disables an IP address based on login attempts.
 */
Configure::write('max_login_attempts_from_IP', 5);

/**
 * Time in minute (time_mn_IP_disabled) before an IP address is reactivated.
 */
Configure::write('time_mn_IP_disabled', 2);

/**
 * Maximum number of login attempts with a same username (max_user_login_attempts) before a username is disabled.
 *
 * The status of a disabled username can only be changed by a user with administrator rights.
 * Set value to null if you don't want the system disables a username based on login attempts.
 */
Configure::write('max_user_login_attempts', 5);

/**
 * Period of password validity in month.
 * Keep empty if no control has to be done.
 * When password is invalid, a warning message will be displayed and the user will be redirect to the change password form.
 */
Configure::write('password_validity_period_month', null);

/**
 * Define if the feature of forgotten password reset by user is available on this installation or not
 * plus the complexity level of the process:
 * - level 0: Not supported
 * - level 1: Will require the exact answers to 3 user custom questions
 * - level 2: Will require the exact answers to 3 user custom questions plus the login and password of a second user
 */
Configure::write('reset_forgotten_password_feature', 2);

/**
 * Define the number of different passwords a user should use before to use an old one.
 * - level 0: Not supported (new password should be different than the previous one)
 * - level 1: New password must be different than the 2 old one passwords
 * - level 2: New password must be different than the 3 old one passwords
 */
Configure::write('different_passwords_number_before_re_use', 2);

// --------------------------------------------------------------------------------------------------------------------------------------------
// DATABROWSER AND BATCH ACTIONS
// --------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Set the limit of records that could either be displayed in the databrowser results
 * form or into a report.
 *
 * WARNING: This should be set to a value lower than PHP max_input_vars. See
 * eventum #3333 for details.
 */
Configure::write('databrowser_and_report_results_display_limit', 1000);

/**
 * Set the limit of items that could be processed in batch
 */
Configure::write('ParticipantMessageCreation_processed_participants_limit', 50); // ParticipantMessage.add()

Configure::write('SampleDerivativeCreation_processed_items_limit', 50); // SampleMasters.batchDerivative()

Configure::write('AliquotCreation_processed_items_limit', 50); // AliquotMasters.add()
Configure::write('AliquotModification_processed_items_limit', 50); // AliquotMasters.editInBatch()
Configure::write('AliquotInternalUseCreation_processed_items_limit', 50); // AliquotMasters.addAliquotInternalUse()
Configure::write('RealiquotedAliquotCreation_processed_items_limit', 50); // AliquotMasters.realiquot()
Configure::write('AliquotBarcodePrint_processed_items_limit', 50); // AliquotMasters.printBarcodes()

Configure::write('QualityCtrlsCreation_processed_items_limit', 50); // QualityCtrls.add()

Configure::write('AddToOrder_processed_items_limit', 50); // OrderItems.add() & OrderItems.addOrderItemsInBatch()
Configure::write('AddToShipment_processed_items_limit', 50); // Shipments.addToShipment()
Configure::write('defineOrderItemsReturned_processed_items_limit', 50); // OrderItems.defineOrderItemsReturned()
Configure::write('edit_processed_items_limit', 50); // OrderItems.editInBatch()

Configure::write('TmaSlideCreation_processed_items_limit', 50); // TmaSlides.add(), TmaSlides.editInBatch(), TmaSlideUses.add(), TmaSlideUses.editInBatch(),
                                                                
// --------------------------------------------------------------------------------------------------------------------------------------------
// ORDER
// --------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Set the allowed links that exists between an OrderItem and different Order plugin objects:
 * 1 => link OrderItem to both Order and OrderLine (order line submodule available)
 * 2 => link OrderItem to OrderLine only (order line submodule available)
 * 3 => link OrderItem to Order only (order line submodule not available)
 */
Configure::write('order_item_to_order_objetcs_link_setting', 3); // SampleMasters.batchDerivative()

/**
 * Set the type(s) of item that could be added to order:
 * 1 => both tma slide and aliquot
 * 2 => aliquot only
 * 3 => tma slide only
 */
Configure::write('order_item_type_config', 2);

unset($debug);

// --------------------------------------------------------------------------------------------------------------------------------------------
// USER LOG FILES
// --------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Record any ATiM user log into a txt file 'user_logs.txt' recorded in a directory of the server.
 * The 'user_logs.txt' will gather
 * information about the visited page, the date and the id of the user.
 *
 * Keep variable to null if no user log file has to be created or replace null by the path of the directory
 * where the log file has to be created.
 */
$path = ($isTest) ? null : null;
Configure::write('atim_user_log_output_path', $path);

// --------------------------------------------------------------------------------------------------------------------------------------------
// LDAP
// --------------------------------------------------------------------------------------------------------------------------------------------

Configure::write('if_use_ldap_authentication', false);
Configure::write('ldap_server', 'ldap://ch06chum00001.chum.rtss.qc.ca:389');
Configure::write('ldap_domain', 'CN=%s,OU=GP_Default,OU=GP_Standard,OU=Users,OU=Prod,OU=CHUM,DC=chum,DC=rtss,DC=qc,DC=ca');