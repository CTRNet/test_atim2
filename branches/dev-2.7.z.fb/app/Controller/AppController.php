<?php
/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
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
App::uses('Controller', 'Controller');

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package app.Controller
 * @link http://book.cakephp.org/2.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller
{

    private static $missingTranslations = array();

    private static $me = null;

    private static $acl = null;

    public static $beignFlash = false;

    const CONFIRM = 1;

    const ERROR = 2;

    const WARNING = 3;

    const INFORMATION = 4;

    public $uses = array(
        'Config',
        'SystemVar'
    );

    public $components = array(
        'Acl',
        'Session',
        'SessionAcl',
        'Auth',
        'Menus',
        'RequestHandler',
        'Structures',
        'PermissionManager',
        'Paginator',
        'Flash',
        'DebugKit.Toolbar'
    );

    public $helpers = array(
        'Session',
        'Csv',
        'Html',
        'Js',
        'Shell',
        'Structures',
        'Time',
        'Form'
    );
    
    // use AppController::getCalInfo to get those with translations
    private static $calInfoShort = array(
        1 => 'jan',
        'feb',
        'mar',
        'apr',
        'may',
        'jun',
        'jul',
        'aug',
        'sep',
        'oct',
        'nov',
        'dec'
    );

    private static $calInfoLong = array(
        1 => 'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
    );

    public static $query;

    private static $calInfoShortTranslated = false;

    private static $calInfoLongTranslated = false;

    public static $highlightMissingTranslations = true;
    
    // Used as a set from the array keys
    public $allowedFilePrefixes = array();

    private function addUrl($type = "nonAjax")
    {
        if (! empty(Router::getPaths($this->here)->url)) {
            $_SESSION['url'][$type][] = "/" . Router::getPaths($this->here)->url;
        }
    }

    private function checkUrl()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            return false;
        }
        if (empty($_SESSION['url'])) {
            $_SESSION['url'] = array(
                'nonAjax' => array(),
                'ajax' => array(),
                'all' => array()
            );
        }
        
        if (! $this->request->is('ajax')) {
            $this->addUrl('nonAjax');
        } else {
            $this->addUrl('ajax');
        }
        $this->addUrl('all');
    }

    private function getBackHistoryUrl($type = "nonAjax", $num = 1)
    {
        $url = "/Menus";
        if (isset($_SERVER["HTTP_REFERER"])) {
            $url = $_SERVER["HTTP_REFERER"];
        } else {
            $size = count($_SESSION['url'][$type]);
            if ($size <= $num) {
                $url = "/Menus";
            } else {
                $currentUrl = $_SESSION['url'][$type][$size - 1];
                $url = $_SESSION['url'][$type][$size - $num - 1];
                $index = $size - $num - 1;
                while ($url == $currentUrl && $index > 0) {
                    $index --;
                    $url = $_SESSION['url'][$type][$index];
                }
                if ($index == - 1) {
                    $url = "/Menus";
                }
                array_splice($_SESSION['url'][$type], $index + 1);
            }
        }
        return $url;
    }

    /**
     * This function is executed before every action in the controller.
     * It's a
     * handy place to check for an active session or inspect user permissions.
     */
    public function beforeFilter()
    {
        $this->checkUrl();
        App::uses('Sanitize', 'Utility');
        AppController::$me = $this;
        if (Configure::read('debug') != 0) {
            Cache::clear(false, "structures");
            Cache::clear(false, "menus");
        }
        
        if ($this->Session->read('permission_timestamp') < $this->SystemVar->getVar('permission_timestamp')) {
            $this->resetPermissions();
        }
        if (Configure::read('Config.language') != $this->Session->read('Config.language')) {
            // set language
            // echo(Configure::read('Config.language'));
            $this->Session->write('Config.language', Configure::read('Config.language'));
        }
        
        $this->Auth->authorize = 'Actions';
        
        // Check password should be reset
        $lowerUrlHere = strtolower($this->request->here);
        if ($this->Session->read('Auth.User.force_password_reset') && strpos($lowerUrlHere, '/users/logout') === false) {
            if (strpos($lowerUrlHere, '/customize/passwords/index') === false) {
                if (! $this->request->is('ajax')) {
                    $this->redirect('/Customize/Passwords/index/');
                }
            }
        }
        
        // record URL in logs
        $logActivityData['UserLog']['user_id'] = $this->Session->read('Auth.User.id');
        $logActivityData['UserLog']['url'] = $this->request->here;
        $logActivityData['UserLog']['visited'] = now();
        $logActivityData['UserLog']['allowed'] = 1;
        
        if (isset($this->UserLog)) {
            $logActivityModel = & $this->UserLog;
        } else {
            App::uses('UserLog', 'Model');
            $logActivityModel = new UserLog();
        }
        
        $logActivityModel->save($logActivityData);
        
        // record URL in logs file
        
        if (Configure::read('atim_user_log_output_path')) {
            $userLogFileHandle = fopen(Configure::read('atim_user_log_output_path') . '/user_logs.txt', "a");
            if ($userLogFileHandle) {
                $userLogStrg = '[' . $logActivityData['UserLog']['visited'] . '] ' . '{IP: ' . AppModel::getRemoteIPAddress() . ' || user_id: ' . (strlen($logActivityData['UserLog']['user_id']) ? $logActivityData['UserLog']['user_id'] : 'NULL') . '} ' . $logActivityData['UserLog']['url'] . ' (allowed:' . $logActivityData['UserLog']['allowed'] . ')';
                fwrite($userLogFileHandle, "$userLogStrg\n");
                fclose($userLogFileHandle);
            } else {
                $logDirectory = Configure::read('atim_user_log_output_path');
                $permission = substr(sprintf('%o', fileperms($logDirectory)), - 4);
                $debug = Configure::read("debug");
                if ($debug > 0) {
                    if ($permission != '0777') {
                        AppController::addWarningMsg(__('the permission of "log" directory is not correct.'));
                    } else {
                        AppController::addWarningMsg(__("unable to write user log data into 'user_logs.txt' file"));
                    }
                }
            }
        }
        
        // menu grabbed for HEADER
        if ($this->request->is('ajax')) {
            Configure::write('debug', 0);
            $this->Components->unload('DebugKit.Toolbar');
        } else {
            $atimSubMenuForHeader = array();
            $menuModel = AppModel::getInstance("", "Menu", true);
            
            $mainMenuItems = $menuModel->find('all', array(
                'conditions' => array(
                    'Menu.parent_id' => 'MAIN_MENU_1'
                )
            ));
            foreach ($mainMenuItems as $item) {
                $atimSubMenuForHeader[$item['Menu']['id']] = $menuModel->find('all', array(
                    'conditions' => array(
                        'Menu.parent_id' => $item['Menu']['id'],
                        'Menu.is_root' => 1
                    ),
                    'order' => array(
                        'Menu.display_order'
                    )
                ));
            }
            
            $this->set('atimMenuForHeader', $this->Menus->get('/menus/tools'));
            $this->set('atimSubMenuForHeader', $atimSubMenuForHeader);
            
            // menu, passed to Layout where it would be rendered through a Helper
            $this->set('atimMenuVariables', array());
            $this->set('atimMenu', $this->Menus->get());
        }
        // get default STRUCTRES, used for forms, views, and validation
        $this->Structures->set();
        
        $this->checkIfDownloadFile();
        
        // Fixe for issue #3396: Msg "You are not authorized to access that location." is not translated
        $this->Auth->authError = __('You are not authorized to access that location.');
    }

    private function checkIfDownloadFile()
    {
        if (isset($this->request->query['file']) && $this->Auth->isAuthorized()) {
            $plugin = $this->request->params['plugin'];
            $modelName = Inflector::camelize(Inflector::singularize($this->request->params['controller']));
            $fileName = $this->request->query['file'];
            if (! $this->Session->read('flag_show_confidential')) {
                preg_match('/(' . $modelName . ')\.(.+)\.([0-9]+)\.(.+)/', $fileName, $matches, PREG_OFFSET_CAPTURE);
                if (! empty($matches)) {
                    if ($matches[1][0] == $modelName) {
                        $model = AppModel::getInstance($plugin, $modelName, true);
                        $fields = $model->schema();
                        if (isset($fields[$matches[2][0]])) {
                            $this->atimFlashError(__('You are not authorized to access that location.'), '/Menus');
                        }
                    }
                }
            }
            $file = Configure::read('uploadDirectory') . DS . $fileName;
            if (file_exists($file)) {
                header('Content-Description: File Transfer');
                header('Content-Type: application/octet-stream');
                header('Content-Disposition: attachment; filename="' . basename($file) . '"');
                header('Expires: 0');
                header('Cache-Control: must-revalidate');
                header('Pragma: public');
                header('Content-Length: ' . filesize($file));
                readfile($file);
            } else {
                $this->atimFlashError(__('file does not exist'), '');
            }
        }
    }

    /**
     * AppController constructor.
     *
     * @param null $request
     * @param null $response
     */
    public function __construct($request = null, $response = null)
    {
        $className = get_class($this);
        $this->name = substr($className, 0, strlen(get_class($this)) - (strpos($className, 'ControllerCustom') === false ? 10 : 16));
        parent::__construct($request, $response);
    }

    /**
     *
     * @param string $hookExtension
     * @return bool|string
     */
    public function hook($hookExtension = '')
    {
        if ($hookExtension) {
            $hookExtension = '_' . $hookExtension;
        }
        
        $hookFile = APP . ($this->request->params['plugin'] ? 'Plugin' . DS . $this->request->params['plugin'] . DS : '') . 'Controller' . DS . 'Hook' . DS . $this->request->params['controller'] . '_' . $this->request->params['action'] . $hookExtension . '.php';
        
        if (! file_exists($hookFile)) {
            $hookFile = false;
        }
        
        return $hookFile;
    }

    /**
     *
     * @return CakeResponse|null
     */
    private function handleFileRequest()
    {
        $file = $this->request->query['file'];
        
        $redirectInvalidFile = function ($caseType) use(&$file) {
            CakeLog::error("User tried to download invalid file (" . $caseType . "): " . $file);
            if ($caseType === 3) {
                AppController::getInstance()->redirect("/Pages/err_file_not_auth?p[]=" . $file);
            } else {
                AppController::getInstance()->redirect("/Pages/err_file_not_found?p[]=" . $file);
            }
        };
        
        $index = - 1;
        foreach (range(0, 1) as $_) {
            $index = strpos($file, '.', $index + 1);
        }
        $prefix = substr($file, 0, $index);
        if ($prefix && array_key_exists($prefix, $this->allowedFilePrefixes)) {
            $dir = Configure::read('uploadDirectory');
            // NOTE: Cannot use flash for errors because file is still in the
            // url and that would cause an infinite loop
            if (strpos($file, '/') > - 1 || strpos($file, '\\') > - 1) {
                $redirectInvalidFile(1);
            }
            $fullFile = $dir . '/' . $file;
            if (! file_exists($fullFile)) {
                $redirectInvalidFile(2);
            }
            $index = strpos($file, '.', $index + 1) + 1;
            $this->response->file($fullFile, array(
                'name' => substr($file, $index)
            ));
            return $this->response;
        }
        $redirectInvalidFile(3);
    }

    /**
     * Called after controller action logic, but before the view is rendered.
     * This callback is not used often, but may be needed if you are calling
     * render() manually before the end of a given action.
     */
    public function beforeRender()
    {
        if (isset($this->request->query['file'])) {
            return $this->handleFileRequest();
        }
        // Fix an issue where cakephp 2.0 puts the first loaded model with the key model in the registry.
        // Causes issues on validation messages
        ClassRegistry::removeObject('model');
        
        if (isset($this->passedArgs['batchsetVar'])) {
            // batchset handling
            $data = null;
            if (isset($this->viewVars[$this->passedArgs['batchsetVar']])) {
                $data = $this->viewVars[$this->passedArgs['batchsetVar']];
            }
            if (empty($data)) {
                unset($this->passedArgs['batchsetVar']);
                $this->atimFlashWarning(__('there is no data to add to a temporary batchset'), 'javascript:history.back()');
                return false;
            }
            if (isset($this->passedArgs['batchsetCtrl'])) {
                $data = $data[$this->passedArgs['batchsetCtrl']];
            }
            $this->requestAction('/Datamart/BatchSets/add/0', array(
                '_data' => $data
            ));
        }
        
        if ($this->layout == 'ajax') {
            $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
        }
    }

    public function afterFilter()
    {
        // global $startTime;
        // echo("Exec time (sec): ".(AppController::microtimeFloat() - $startTime));
        if (sizeof(AppController::$missingTranslations) > 0 && Configure::read('debug')==0) {
            App::uses('MissingTranslation', 'Model');
            $mt = new MissingTranslation();
            foreach (AppController::$missingTranslations as $missingTranslation) {
                $mt->set(array(
                    "MissingTranslation" => array(
                        "id" => $missingTranslation
                    )
                ));
                $mt->save(); // ignore errors, kind of insert ingnore
            }
        }
    }

    /**
     * Simple function to replicate PHP 5 behaviour
     */
    public static function microtimeFloat()
    {
        list ($usec, $sec) = explode(" ", microtime());
        return ((float) $usec + (float) $sec);
    }

    /**
     *
     * @param $word
     */
    public static function missingTranslation(&$word)
    {
        if (! is_numeric($word) && strpos($word, "<span class='untranslated'>") === false) {
            AppController::$missingTranslations[] = $word;
            if (Configure::read('debug') == 2 && self::$highlightMissingTranslations) {
                $word = "<span class='untranslated'>" . $word . "</span>";
            }
        }
    }

    /**
     *
     * @param array|string $url
     * @param null $status
     * @param bool $exit
     * @return \Cake\Network\Response|null|void
     */
    public function redirect($url, $status = null, $exit = true)
    {
        $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
        parent::redirect($url, $status, $exit);
    }

    /**
     *
     * @param $message
     * @param $url
     * @param int $type
     */
    public function atimFlash($message, $url, $type = self::CONFIRM)
    {
        if (empty($url)) {
            $url = "/Menus";
        }
        if (strpos(strtolower($url), 'javascript') !== false) {
            $url = $this->getBackHistoryUrl();
        }
        if (strpos(strtolower($url), 'javascript') === false) {
            if ($type == self::CONFIRM) {
                $_SESSION['ctrapp_core']['confirm_msg'] = $message;
            } elseif ($type == self::INFORMATION) {
                $_SESSION['ctrapp_core']['info_msg'][] = $message;
            } elseif ($type == self::WARNING) {
                $_SESSION['ctrapp_core']['warning_trace_msg'][] = $message;
            } elseif ($type == self::ERROR) {
                $_SESSION['ctrapp_core']['error_msg'][] = $message;
            }
            $this->redirect($url);
        } elseif (false) {
            // TODO:: Check if can use javascript functions for blue screen message
            echo '<script type="text/javascript">', 'javascript:history.back();', 'window.location.reload();', '</script>';
        } else {
            $this->autoRender = false;
            $this->set('url', Router::url($url));
            $this->set('message', $message);
            $this->set('pageTitle', $message);
            $this->render(false, "flash");
        }
    }

    /**
     *
     * @param $message
     * @param $url
     */
    public function atimFlashError($message, $url)
    {
        $this->atimFlash($message, $url, self::ERROR);
    }

    /**
     *
     * @param $message
     * @param $url
     */
    public function atimFlashInfo($message, $url)
    {
        $this->atimFlash($message, $url, self::INFORMATION);
    }

    /**
     *
     * @param $message
     * @param $url
     */
    public function atimFlashConfirm($message, $url)
    {
        $this->atimFlash($message, $url, self::CONFIRM);
    }

    /**
     *
     * @param $message
     * @param $url
     */
    public function atimFlashWarning($message, $url)
    {
        $this->atimFlash($message, $url, self::WARNING);
    }

    /**
     *
     * @return null
     */
    public static function getInstance()
    {
        return AppController::$me;
    }

    public static function init()
    {
        Configure::write('Config.language', 'eng');
        Configure::write('Acl.classname', 'AtimAcl');
        Configure::write('Acl.database', 'default');
        
        // ATiM2 configuration variables from Datatable
        
        define('VALID_INTEGER', '/^[-+]?[\\s]?[0-9]+[\\s]?$/');
        define('VALID_INTEGER_POSITIVE', '/^[+]?[\\s]?[0-9]+[\\s]?$/');
        define('VALID_FLOAT', '/^[-+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
        define('VALID_FLOAT_POSITIVE', '/^[+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
        define('VALID_24TIME', '/^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/');
        
        // ripped from validation.php date + time
        define('VALID_DATETIME_YMD', '%^(?:(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(-)(?:0?2\\1(?:29)))|(?:(?:(?:1[6-9]|2\\d)\\d{2})(-)(?:(?:(?:0?[13578]|1[02])\\2(?:31))|(?:(?:0?(1|[3-9])|1[0-2])\\2(29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\\2(?:0?[1-9]|1\\d|2[0-8])))\s([0-1][0-9]|2[0-3])\:[0-5][0-9]\:[0-5][0-9]$%');
        
        // parse URI manually to get passed PARAMS
        global $startTime;
        $startTime = AppController::microtimeFloat();
        
        $requestUriParams = array();
        
        // Fix REQUEST_URI on IIS
        if (! isset($_SERVER['REQUEST_URI'])) {
            $_SERVER['REQUEST_URI'] = substr($_SERVER['PHP_SELF'], 1);
            if (isset($_SERVER['QUERY_STRING'])) {
                $_SERVER['REQUEST_URI'] .= '?' . $_SERVER['QUERY_STRING'];
            }
        }
        $requestUri = $_SERVER['REQUEST_URI'];
        $requestUri = explode('/', $requestUri);
        $requestUri = array_filter($requestUri);
        
        foreach ($requestUri as $uri) {
            $explodedUri = explode(':', $uri);
            if (count($explodedUri) > 1) {
                $requestUriParams[$explodedUri[0]] = $explodedUri[1];
            }
        }
        
        // import APP code required...
        App::import('Model', 'Config');
        $configDataModel = new Config();
        
        // get CONFIG data from table and SET
        $configResults = false;
        
        App::uses('CakeSession', 'Model/Datasource');
        $userId = CakeSession::read('Auth.User.id');
        $loggedInUser = CakeSession::read('Auth.User.id');
        $loggedInGroup = CakeSession::read('Auth.User.group_id');
        
        $configResults = $configDataModel->getConfig(CakeSession::read('Auth.User.group_id'), CakeSession::read('Auth.User.id'));
        // parse result, set configs/defines
        if ($configResults) {
            
            Configure::write('Config.language', $configResults['Config']['config_language']);
            foreach ($configResults['Config'] as $configKey => $configData) {
                if (strpos($configKey, '_') !== false) {
                    
                    // break apart CONFIG key
                    $configKey = explode('_', $configKey);
                    $configFormat = array_shift($configKey);
                    $configKey = implode('_', $configKey);
                    
                    // if a DEFINE or CONFIG, set new setting for APP
                    if ($configFormat == 'define') {
                        
                        // override DATATABLE value with URI PARAM value
                        if ($configKey == 'PAGINATION_AMOUNT' && isset($requestUriParams['per'])) {
                            $configData = $requestUriParams['per'];
                        }
                        
                        define(strtoupper($configKey), $configData);
                    } elseif ($configFormat == 'config') {
                        Configure::write($configKey, $configData);
                    }
                }
            }
        }
        
        define('CONFIDENTIAL_MARKER', __('confidential data')); // Moved here to allow translation
        
        if (Configure::read('debug') == 0) {
            set_error_handler("myErrorHandler");
        }
    }

    /**
     *
     * @param boolean $short Wheter to return short or long month names
     * @return an associative array containing the translated months names so that key = month_number and value = month_name
     */
    public static function getCalInfo($short = true)
    {
        if ($short) {
            if (! AppController::$calInfoShortTranslated) {
                AppController::$calInfoShortTranslated = true;
                AppController::$calInfoShort = array_map(create_function('$a', 'return __($a);'), AppController::$calInfoShort);
            }
            return AppController::$calInfoShort;
        } else {
            if (! AppController::$calInfoLongTranslated) {
                AppController::$calInfoLongTranslated = true;
                AppController::$calInfoLong = array_map(create_function('$a', 'return __($a);'), AppController::$calInfoLong);
            }
            return AppController::$calInfoLong;
        }
    }

    /**
     *
     * @param int $year
     * @param mixed int | string $month
     * @param int $day
     * @param boolean $nbspSpaces True if white spaces must be printed as &nbsp;
     * @param boolean $shortMonths True if months names should be short (used if $month is an int)
     * @return string The formated datestring with user preferences
     */
    public static function getFormatedDateString($year, $month, $day, $nbspSpaces = true, $shortMonths = true)
    {
        $result = null;
        if (empty($year) && empty($month) && empty($day)) {
            $result = "";
        } else {
            $divider = $nbspSpaces ? "&nbsp;" : " ";
            if (is_numeric($month)) {
                $monthStr = AppController::getCalInfo($shortMonths);
                $month = $month > 0 && $month < 13 ? $monthStr[(int) $month] : "-";
            }
            if (DATE_FORMAT == 'MDY') {
                $result = $month . (empty($month) ? "" : $divider) . $day . (empty($day) ? "" : $divider) . $year;
            } elseif (DATE_FORMAT == 'YMD') {
                $result = $year . (empty($month) ? "" : $divider) . $month . (empty($day) ? "" : $divider) . $day;
            } else { // default of DATE_FORMAT=='DMY'
                $result = $day . (empty($day) ? "" : $divider) . $month . (empty($month) ? "" : $divider) . $year;
            }
        }
        return $result;
    }

    /**
     *
     * @param $hour
     * @param $minutes
     * @param bool $nbspSpaces
     * @return string
     */
    public static function getFormatedTimeString($hour, $minutes, $nbspSpaces = true)
    {
        if (TIME_FORMAT == 12) {
            $meridiem = $hour >= 12 ? "PM" : "AM";
            $hour %= 12;
            if ($hour == 0) {
                $hour = 12;
            }
            return $hour . (empty($minutes) ? '' : ":" . $minutes . ($nbspSpaces ? "&nbsp;" : " ")) . $meridiem;
        } elseif (empty($minutes)) {
            return $hour . __('hour_sign');
        } else {
            return $hour . ":" . $minutes;
        }
    }

    /**
     *
     * Enter description here ...
     *
     * @param $datetimeString String with format yyyy[-MM[-dd[ hh[:mm:ss]]]] (missing parts represent the accuracy
     * @param boolean $nbspSpaces True if white spaces must be printed as &nbsp;
     * @param boolean $shortMonths True if months names should be short (used if $month is an int)
     * @return string The formated datestring with user preferences
     */
    public static function getFormatedDatetimeString($datetimeString, $nbspSpaces = true, $shortMonths = true)
    {
        $month = null;
        $day = null;
        $hour = null;
        $minutes = null;
        if (strpos($datetimeString, ' ') === false) {
            $date = $datetimeString;
        } else {
            list ($date, $time) = explode(" ", $datetimeString);
            if (strpos($time, ":") === false) {
                $hour = $time;
            } else {
                list ($hour, $minutes) = explode(":", $time);
            }
        }
        
        $date = explode("-", $date);
        $year = $date[0];
        switch (count($date)) {
            case 3:
                $day = $date[2];
            case 2:
                $month = $date[1];
                break;
        }
        $formatedDate = self::getFormatedDateString($year, $month, $day, $nbspSpaces);
        return $hour === null ? $formatedDate : $formatedDate . ($nbspSpaces ? "&nbsp;" : " ") . self::getFormatedTimeString($hour, $minutes, $nbspSpaces);
    }

    /**
     * Return formatted date in SQL format from a date array returned by an application form.
     *
     * @param $datetimeArray Array gathering date data into following structure:
     *        array('month' => string, '
     *        'day' => string,
     *        'year' => string,
     *        'hour' => string,
     *        'min' => string)
     * @param Specify|string $dateType Specify
     *        the type of date ('normal', 'start', 'end')
     *        - normal => Will force function to build a date witout specific rules.
     *        - start => Will force function to build date as a 'start date' of date range defintion
     *        (ex1: when just year is specified, will return a value like year-01-01 00:00)
     *        (ex2: when array is empty, will return a value like -9999-99-99 00:00)
     *        - end => Will force function to build date as an 'end date' of date range defintion
     *        (ex1: when just year is specified, will return a value like year-12-31 23:59)
     *        (ex2: when array is empty, will return a value like 9999-99-99 23:59)
     * @return string The formated SQL date having following format yyyy-MM-dd hh:mn
     */
    public static function getFormatedDatetimeSQL($datetimeArray, $dateType = 'normal')
    {
        $formattedDate = '';
        switch ($dateType) {
            case 'normal':
                if ((! empty($datetimeArray['year'])) && (! empty($datetimeArray['month'])) && (! empty($datetimeArray['day']))) {
                    $formattedDate = $datetimeArray['year'] . '-' . $datetimeArray['month'] . '-' . $datetimeArray['day'];
                }
                if ((! empty($formattedDate)) && (! empty($datetimeArray['hour']))) {
                    $formattedDate .= ' ' . $datetimeArray['hour'] . ':' . (empty($datetimeArray['min']) ? '00' : $datetimeArray['min']);
                }
                break;
            
            case 'start':
                if (empty($datetimeArray['year'])) {
                    $formattedDate = '-9999-99-99 00:00';
                } else {
                    $formattedDate = $datetimeArray['year'];
                    if (empty($datetimeArray['month'])) {
                        $formattedDate .= '-01-01 00:00';
                    } else {
                        $formattedDate .= '-' . $datetimeArray['month'];
                        if (empty($datetimeArray['day'])) {
                            $formattedDate .= '-01 00:00';
                        } else {
                            $formattedDate .= '-' . $datetimeArray['day'];
                            if (empty($datetimeArray['hour'])) {
                                $formattedDate .= ' 00:00';
                            } else {
                                $formattedDate .= ' ' . $datetimeArray['hour'] . ':' . (empty($datetimeArray['min']) ? '00' : $datetimeArray['min']);
                            }
                        }
                    }
                }
                break;
            
            case 'end':
                if (empty($datetimeArray['year'])) {
                    $formattedDate = '9999-12-31 23:59';
                } else {
                    $formattedDate = $datetimeArray['year'];
                    if (empty($datetimeArray['month'])) {
                        $formattedDate .= '-12-31 23:59';
                    } else {
                        $formattedDate .= '-' . $datetimeArray['month'];
                        if (empty($datetimeArray['day'])) {
                            $formattedDate .= '-31 23:59';
                        } else {
                            $formattedDate .= '-' . $datetimeArray['day'];
                            if (empty($datetimeArray['hour'])) {
                                $formattedDate .= ' 23:59';
                            } else {
                                $formattedDate .= ' ' . $datetimeArray['hour'] . ':' . (empty($datetimeArray['min']) ? '59' : $datetimeArray['min']);
                            }
                        }
                    }
                }
                break;
            
            default:
        }
        
        return $formattedDate;
    }

    /**
     * Clones the first level of an array
     *
     * @param array $arr The array to clone
     * @return array
     */
    public static function cloneArray(array $arr)
    {
        $result = array();
        foreach ($arr as $k => $v) {
            if (is_array($v)) {
                $result[$k] = self::cloneArray($v);
            } else {
                $result[$k] = $v;
            }
        }
        return $result;
    }

    /**
     *
     * @param $msg
     * @param bool $withTrace
     */
    public static function addWarningMsg($msg, $withTrace = false)
    {
        if ($withTrace) {
            $_SESSION['ctrapp_core']['warning_trace_msg'][] = array(
                'msg' => $msg,
                'trace' => self::getStackTrace()
            );
        } else {
            if (isset($_SESSION['ctrapp_core']['warning_no_trace_msg'][$msg])) {
                $_SESSION['ctrapp_core']['warning_no_trace_msg'][$msg] ++;
            } else {
                $_SESSION['ctrapp_core']['warning_no_trace_msg'][$msg] = 1;
            }
        }
    }

    /**
     *
     * @param $msg
     */
    public static function addInfoMsg($msg)
    {
        if (isset($_SESSION['ctrapp_core']['info_msg'][$msg])) {
            $_SESSION['ctrapp_core']['info_msg'][$msg] ++;
        } else {
            $_SESSION['ctrapp_core']['info_msg'][$msg] = 1;
        }
    }
    
    /**
     *
     * @param $msg
     */
    public static function addErrorMsg($msg)
    {
        $_SESSION['ctrapp_core']['error_msg'][] = $msg;
    }

    /**
     */
    public static function forceMsgDisplayInPopup()
    {
        $_SESSION['ctrapp_core']['force_msg_display_in_popup'] = true;
    }

    /**
     *
     * @return array
     */
    public static function getStackTrace()
    {
        $bt = debug_backtrace();
        $result = array();
        foreach ($bt as $unit) {
            $result[] = (isset($unit['file']) ? $unit['file'] : '?') . ", " . $unit['function'] . " at line " . (isset($unit['line']) ? $unit['line'] : '?');
        }
        return $result;
    }

    /**
     * Builds the value definition array for an updateAll call
     *
     * @param array $data
     * @return array
     * @internal param $ array They data array to build the values with* array They data array to build the values with
     */
    public static function getUpdateAllValues(array $data)
    {
        $result = array();
        foreach ($data as $model => $fields) {
            foreach ($fields as $name => $value) {
                if (is_array($value)) {
                    if (strlen($value['year'])) {
                        $result[$model . "." . $name] = "'" . AppController::getFormatedDatetimeSQL($value) . "'";
                    }
                } elseif (strlen($value)) {
                    $result[$model . "." . $name] = "'" . $value . "'";
                }
            }
        }
        return $result;
    }

    /**
     * Encrypt a text
     *
     * @param String $string
     * @return String
     */
    public static function encrypt($string)
    {
        return Security::hash($string, null, true);
    }

    /**
     * cookie manipulation to counter cake problems.
     * see eventum #1032
     *
     * @param $skipExpirationCookie
     */
    public static function atimSetCookie($skipExpirationCookie)
    {
        if (! $skipExpirationCookie) {
            $sessionExpiration = time() + Configure::read("Session.timeout");
            setcookie('last_request', time(), $sessionExpiration, '/');
            setcookie('session_expiration', $sessionExpiration, $sessionExpiration, '/');
            if (isset($_COOKIE[Configure::read("Session.cookie")])) {
                setcookie(Configure::read("Session.cookie"), $_COOKIE[Configure::read("Session.cookie")], $sessionExpiration, "/");
            }
            $sessionId = (! empty($_SESSION['Auth']['User']['id'])) ? self::encrypt($_SESSION['Auth']['User']['id']) : self::encrypt("nul string");
            setcookie('sessionId', $sessionId, 0, "/");
        }
    }

    /**
     * Global function to initialize a batch action.
     * Redirect/flashes on error.
     *
     * @param AppModek $model The model to work on
     * @param string $dataModelName The model name used in $this->request->data
     * @param string $dataKey The data key name used in $this->request->data
     * @param string $controlKeyName The name of the control field used in the model table
     * @param AppModel $possibilitiesModel The model to fetch the possibilities from
     * @param string $possibilitiesParentKey The possibilities parent key to base the search on
     * @param $noPossibilitiesMsg
     * @return An array with the ids and the possibilities
     */
    public function batchInit($model, $dataModelName, $dataKey, $controlKeyName, $possibilitiesModel, $possibilitiesParentKey, $noPossibilitiesMsg)
    {
        if (empty($this->request->data)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } elseif (! is_array($this->request->data[$dataModelName][$dataKey]) && strpos($this->request->data[$dataModelName][$dataKey], ',')) {
            return array(
                'error' => "batch init - number of submitted records too big"
            );
        }
        // extract valid ids
        $ids = $model->find('all', array(
            'conditions' => array(
                $model->name . '.id' => $this->request->data[$dataModelName][$dataKey]
            ),
            'fields' => array(
                $model->name . '.id'
            ),
            'recursive' => - 1
        ));
        if (empty($ids)) {
            return array(
                'error' => "batch init no data"
            );
        }
        $model->sortForDisplay($ids, $this->request->data[$dataModelName][$dataKey]);
        $ids = self::defineArrayKey($ids, $model->name, 'id');
        $ids = array_keys($ids);
        
        $controls = $model->find('all', array(
            'conditions' => array(
                $model->name . '.id' => $ids
            ),
            'fields' => array(
                $model->name . '.' . $controlKeyName
            ),
            'group' => array(
                $model->name . '.' . $controlKeyName
            ),
            'recursive' => - 1
        ));
        if (count($controls) != 1) {
            return array(
                'error' => "you must select elements with a common type"
            );
        }
        
        $possibilities = $possibilitiesModel->find('all', array(
            'conditions' => array(
                $possibilitiesParentKey => $controls[0][$model->name][$controlKeyName],
                'flag_active' => '1'
            )
        ));
        
        if (empty($possibilities)) {
            return array(
                'error' => $noPossibilitiesMsg
            );
        }
        
        return array(
            'ids' => implode(',', $ids),
            'possibilities' => $possibilities,
            'control_id' => $controls[0][$model->name][$controlKeyName]
        );
    }

    /**
     * Replaces the array key (generally of a find) with an inner value
     *
     * @param array $inArray
     * @param string $model The model ($inArray[$model])
     * @param string $field The field (new key = $inArray[$model][$field])
     * @param bool $unique If true, the array block will be directly under the model.field, not in an array.
     * @return array
     */
    public static function defineArrayKey($inArray, $model, $field, $unique = false)
    {
        $outArray = array();
        if ($unique) {
            foreach ($inArray as $val) {
                $outArray[$val[$model][$field]] = $val;
            }
        } else {
            foreach ($inArray as $val) {
                if (isset($val[$model])) {
                    $outArray[$val[$model][$field]][] = $val;
                } else {
                    // the key cannot be foud
                    $outArray[- 1][] = $val;
                }
            }
        }
        return $outArray;
    }

    /**
     * Recursively removes entries returning true on empty($value).
     *
     * @param array $data
     * @internal param $ array &$data* array &$data
     */
    public static function removeEmptyValues(array &$data)
    {
        foreach ($data as $key => &$val) {
            if (is_array($val)) {
                self::removeEmptyValues($val);
            }
            if (empty($val)) {
                unset($data[$key]);
            }
        }
    }

    /**
     *
     * @return mixed
     */
    public static function getNewSearchId()
    {
        return AppController::getInstance()->Session->write('search_id', AppController::getInstance()->Session->read('search_id') + 1);
    }

    /**
     *
     * @param string $link The link to check
     * @return True if the user can access that page, false otherwise
     */
    public static function checkLinkPermission($link)
    {
        if (strpos($link, 'javascript:') === 0 || strpos($link, '#') === 0) {
            return true;
        }
        
        $parts = Router::parse($link);
        if (empty($parts)) {
            return false;
        }
        $acoAlias = 'Controller/' . ($parts['plugin'] ? Inflector::camelize($parts['plugin']) . '/' : '');
        $acoAlias .= ($parts['controller'] ? Inflector::camelize($parts['controller']) . '/' : '');
        $acoAlias .= ($parts['action'] ? $parts['action'] : '');
        $instance = AppController::getInstance();
        
        return strpos($acoAlias, 'Controller/Users') !== false || strpos($acoAlias, 'Controller/Pages') !== false || $acoAlias == "Controller/Menus/index" || $instance->SessionAcl->check('Group::' . $instance->Session->read('Auth.User.group_id'), $acoAlias);
    }

    /**
     *
     * @param $inArray
     * @param $model
     * @param $field
     */
    public static function applyTranslation(&$inArray, $model, $field)
    {
        foreach ($inArray as &$part) {
            $part[$model][$field] = __($part[$model][$field]);
        }
    }

    /**
     * Handles automatic pagination of model records Adding
     * the necessary bind on the model to fetch detail level, if there is a unique ctrl id
     *
     * @param Model|string $object Model to paginate (e.g: model instance, or 'Model', or 'Model.InnerModel')
     * @param string|array $scope Conditions to use while paginating
     * @param array $whitelist List of allowed options for paging
     * @return array Model query results
     */
    public function paginate($object = null, $scope = array(), $whitelist = array())
    {
        $this->setControlerPaginatorSettings($object);
        $modelName = isset($object->baseModel) ? $object->baseModel : $object->name;
        if (isset($object->Behaviors->MasterDetail->__settings[$modelName])) {
            extract(self::convertArrayKeyFromSnakeToCamel($object->Behaviors->MasterDetail->__settings[$modelName]));
            if ($isMasterModel && isset($scope[$modelName . '.' . $controlForeign]) && preg_match('/^[0-9]+$/', $scope[$modelName . '.' . $controlForeign])) {
                self::buildDetailBinding($object, array(
                    $modelName . '.' . $controlForeign => $scope[$modelName . '.' . $controlForeign]
                ), $emptyStructureAlias);
            }
        }
        return parent::paginate($object, $scope, $whitelist);
    }

    /**
     * Finds and paginate search results.
     * Stores search in cache.
     * Handles detail level when there is a unique ctrl_id.
     * Defines/updates the result structure.
     * Sets 'result_are_unique_ctrl' as true if the results are based on a unique ctrl id,
     * false otherwise. (Non master/detail models will return false)
     *
     * @param int $searchId The search id used by the pagination
     * @param Object $model The model to search upon
     * @param string $structureAlias The structure alias to parse the search conditions on
     * @param string $url The base url to use in the pagination links (meaning without the search_id)
     * @param bool $ignoreDetail If true, even if the model is a master_detail ,the detail level won't be loaded
     * @param mixed $limit If false, will make a paginate call, if an int greater than 0, will make a find with the limit
     */
    public function searchHandler($searchId, $model, $structureAlias, $url, $ignoreDetail = false, $limit = false)
    {
        // setting structure
        $structure = $this->Structures->get('form', $structureAlias);
        $this->set('atimStructure', $structure);
        if (empty($searchId)) {
            $plugin = $this->request->params['plugin'];
            $controller = $this->request->params['controller'];
            $action = $this->request->params['action'];
            if (isset($_SESSION['post_data'][$plugin][$controller][$action])) {
                convertArrayToJavaScript($_SESSION['post_data'][$plugin][$controller][$action], 'jsPostData');
            }
            
            $this->Structures->set('empty', 'emptyStructure');
        } else {
            if ($this->request->data) {
                
                // newly submitted search, parse conditions and store in session
                $_SESSION['ctrapp_core']['search'][$searchId]['criteria'] = $this->Structures->parseSearchConditions($structure);
            } elseif (! isset($_SESSION['ctrapp_core']['search'][$searchId]['criteria'])) {
                self::addWarningMsg(__('you cannot resume a search that was made in a previous session'));
                $this->redirect('/menus');
                exit();
            }
            
            // check if the current model is a master/detail one or a similar view
            if (! $ignoreDetail) {
                self::buildDetailBinding($model, $_SESSION['ctrapp_core']['search'][$searchId]['criteria'], $structureAlias);
                $this->Structures->set($structureAlias);
            }
            
            if ($limit) {
                $this->request->data = $model->find('all', array(
                    'conditions' => $_SESSION['ctrapp_core']['search'][$searchId]['criteria'],
                    'limit' => $limit
                ));
            } else {
                $this->setControlerPaginatorSettings($model);
                $this->request->data = $this->Paginator->paginate($model, $_SESSION['ctrapp_core']['search'][$searchId]['criteria']);
            }
            
            // if SEARCH form data, save number of RESULTS and URL (used by the form builder pagination links)
            if ($searchId == - 1) {
                // don't use the last search button if search id = -1
                unset($_SESSION['ctrapp_core']['search'][$searchId]);
            } else {
                $_SESSION['ctrapp_core']['search'][$searchId]['results'] = $this->request->params['paging'][$model->name]['count'];
                $_SESSION['ctrapp_core']['search'][$searchId]['url'] = $url;
            }
        }
        
        if ($this->request->is('ajax')) {
            Configure::write('debug', 0);
            $this->set('isAjax', true);
        }
    }

    /**
     * Set the Pagination settings based on user preferences and controller Pagination settings.
     *
     * @param Object $model The model to search upon
     */
    public function setControlerPaginatorSettings($model)
    {
        if (PAGINATION_AMOUNT) {
            $this->Paginator->settings = array_merge($this->Paginator->settings, array(
                'limit' => PAGINATION_AMOUNT
            ));
        }
        if ($model && isset($this->paginate[$model->name])) {
            $this->Paginator->settings = array_merge($this->Paginator->settings, $this->paginate[$model->name]);
        }
    }

    /**
     * Adds the necessary bind on the model to fetch detail level, if there is a unique ctrl id
     *
     * @param AppModel &$model
     * @param array $conditions Search conditions
     * @param string &$structureAlias
     */
    public static function buildDetailBinding(&$model, array $conditions, &$structureAlias)
    {
        $controller = AppController::getInstance();
        $masterClassName = isset($model->baseModel) ? $model->baseModel : $model->name;
        if (! isset($model->Behaviors->MasterDetail->__settings[$masterClassName])) {
            $controller->$masterClassName; // try to force lazyload
            if (! isset($model->Behaviors->MasterDetail->__settings[$masterClassName])) {
                if (Configure::read('debug') != 0) {
                    AppController::addWarningMsg("buildDetailBinding requires you to force instanciation of model " . $masterClassName);
                }
                return;
            }
        }
        if ($model->Behaviors->MasterDetail->__settings[$masterClassName]['is_master_model']) {
            $ctrlIds = null;
            $singleCtrlId = $model->getSingleControlIdCondition(array(
                'conditions' => $conditions
            ));
            $controlField = $model->Behaviors->MasterDetail->__settings[$masterClassName]['control_foreign'];
            if ($singleCtrlId === false) {
                // determine if the results contain only one control id
                $ctrlIds = $model->find('all', array(
                    'fields' => array(
                        $model->name . '.' . $controlField
                    ),
                    'conditions' => $conditions,
                    'group' => array(
                        $model->name . '.' . $controlField
                    ),
                    'limit' => 2
                ));
                if (count($ctrlIds) == 1) {
                    $singleCtrlId = current(current($ctrlIds[0]));
                }
            }
            if ($singleCtrlId !== false) {
                // only one ctrl, attach detail
                $hasOne = array();
                extract(self::convertArrayKeyFromSnakeToCamel($model->Behaviors->MasterDetail->__settings[$masterClassName]));
                $ctrlModel = isset($controller->$controlClass) ? $controller->$controlClass : AppModel::getInstance('', $controlClass, false);
                if (! $ctrlModel) {
                    if (Configure::read('debug') != 0) {
                        AppController::addWarningMsg('buildDetailBinding requires you to force instanciation of model ' . $controlClass);
                    }
                    return;
                }
                $ctrlData = $ctrlModel->findById($singleCtrlId);
                $ctrlData = current($ctrlData);
                // put a new instance of the detail model in the cache
                ClassRegistry::removeObject($detailClass); // flush the old detail from cache, we'll need to reinstance it
                assert(strlen($ctrlData['detail_tablename'])) or die("detail_tablename cannot be empty");
                new AppModel(array(
                    'table' => $ctrlData['detail_tablename'],
                    'name' => $detailClass,
                    'alias' => $detailClass
                ));
                
                // has one and win
                $hasOne[$detailClass] = array(
                    'className' => $detailClass,
                    'foreignKey' => $masterForeign
                );
                
                if ($masterClassName == 'SampleMaster') {
                    // join specimen/derivative details
                    if ($ctrlData['sample_category'] == 'specimen') {
                        $hasOne['SpecimenDetail'] = array(
                            'className' => 'SpecimenDetail',
                            'foreignKey' => 'sample_master_id'
                        );
                    } else {
                        // derivative
                        $hasOne['DerivativeDetail'] = array(
                            'className' => 'DerivativeDetail',
                            'foreignKey' => 'sample_master_id'
                        );
                    }
                }
                
                // persistent bind
                $model->bindModel(array(
                    'hasOne' => $hasOne,
                    'belongsTo' => array(
                        $controlClass => array(
                            'className' => $controlClass
                        )
                    )
                ), false);
                isset($model->{$detailClass}); // triggers model lazy loading (See cakephp Model class)
                                               
                // updating structure
                if (($pos = strpos($ctrlData['form_alias'], ',')) !== false) {
                    $structureAlias = $structureAlias . ',' . substr($ctrlData['form_alias'], $pos + 1);
                }
                
                ClassRegistry::removeObject($detailClass); // flush the new model to make sure the default one is loaded if needed
            } elseif (count($ctrlIds) > 0) {
                // more than one
                AppController::addInfoMsg(__("the results contain various data types, so the details are not displayed"));
            }
        }
    }

    /**
     * Builds menu options based on 1-display_order and 2-translation
     *
     * @param array $menuOptions An array containing arrays of the form array('order' => #, 'label' => '', 'link' => '')
     *        The label must be translated already.
     */
    public static function buildBottomMenuOptions(array &$menuOptions)
    {
        $tmp = array();
        foreach ($menuOptions as $menuOption) {
            $tmp[sprintf("%05d", $menuOption['order']) . '-' . $menuOption['label']] = $menuOption['link'];
        }
        ksort($tmp);
        $menuOptions = array();
        foreach ($tmp as $label => $link) {
            $menuOptions[preg_replace('/^[0-9]+-/', '', $label)] = $link;
        }
    }

    /**
     * Sets url_to_cancel based on $this->request->data['url_to_cancel']
     * If nothing exists, javascript:history.go(-1) is used.
     * If a similar entry exists, the value is decremented.
     * Otherwise, url_to_cancel is uses as such.
     */
    public function setUrlToCancel()
    {
        if (isset($this->request->data['url_to_cancel'])) {
            $pattern = '/^javascript:history.go\((-?[0-9]*)\)$/';
            $matches = array();
            if (preg_match($pattern, $this->request->data['url_to_cancel'], $matches)) {
                $back = empty($matches[1]) ? - 2 : $matches[1] - 1;
                $this->request->data['url_to_cancel'] = 'javascript:history.go(' . $back . ')';
            }
        } else {
            $this->request->data['url_to_cancel'] = 'javascript:history.go(-1)';
        }
        
        $this->set('urlToCancel', $this->request->data['url_to_cancel']);
    }

    public function resetPermissions()
    {
        if ($this->Auth->user()) {
            $userModel = AppModel::getInstance('', 'User', true);
            $user = $userModel->findById($this->Session->read('Auth.User.id'));
            $this->Session->write('Auth.User.group_id', $user['User']['group_id']);
            $this->Session->write('flag_show_confidential', $user['Group']['flag_show_confidential']);
            $this->Session->write('permission_timestamp', time());
            $this->SessionAcl->flushCache();
        }
    }

    /**
     *
     * @param array $list
     * @param $lModel
     * @param $lKey
     * @param array $data
     * @param $dModel
     * @param $dKey
     * @return bool
     */
    public function setForRadiolist(array &$list, $lModel, $lKey, array $data, $dModel, $dKey)
    {
        foreach ($list as &$unit) {
            if ($data[$dModel][$dKey] == $unit[$lModel][$lKey]) {
                // we found the one that interests us
                $unit[$dModel] = $data[$dModel];
                return true;
            }
        }
        return false;
    }

    /**
     * Builds a cancel link based on the passed data.
     * Works for data send by batch sets and browsing.
     *
     * @param strint or null $data
     * @return null|string
     */
    public static function getCancelLink($data)
    {
        $result = null;
        if (isset($data['node']['id'])) {
            $result = '/Datamart/Browser/browse/' . $data['node']['id'];
        } elseif (isset($data['BatchSet']['id'])) {
            $result = '/Datamart/BatchSets/listall/' . $data['BatchSet']['id'];
        } elseif (isset($data['cancel_link'])) {
            $result = $data['cancel_link'];
        }
        
        return $result;
    }

    /**
     * Does multiple tasks related to having a version updated
     * -Permissions
     * -i18n version field
     * -language files
     * -cache
     * -Delete all browserIndex > Limit
     * -databrowser lft rght
     */
    public function newVersionSetup()
    {
        // new version installed!
        
        // ------------------------------------------------------------------------------------------------------------------------------------------
        
        // *** 1 *** regen permissions
        $this->PermissionManager->buildAcl();
        AppController::addWarningMsg(__('permissions have been regenerated'));
        
        // *** 1.5 *** Check the upload, temp and local directory permission
        $uploadDirectory = Configure::read('uploadDirectory');
        $permission = substr(sprintf('%o', fileperms($uploadDirectory)), - 4);
        if ($permission != '0777') {
            AppController::addWarningMsg(__('the permission of "upload" directory is not correct.'));
        }
        
        // *** 2 *** update the i18n string for version
        $storageControlModel = AppModel::getInstance('StorageLayout', 'StorageControl', true);
        $isTmaBlock = $storageControlModel->find('count', array(
            'condition' => array(
                'StorageControl.flag_active' => '1',
                'is_tma_block' => '1'
            )
        ));
        $this->Version->query("REPLACE INTO i18n (id,en,fr) (SELECT 'storage layout management - value generated by newVersionSetup function', en, fr FROM i18n WHERE id = '" . ($isTmaBlock ? 'storage layout & tma blocks management' : 'storage layout management') . "')");
        $this->Version->query("REPLACE INTO i18n (id,en,fr) (SELECT 'storage layout management description - value generated by newVersionSetup function', en, fr FROM i18n WHERE id = '" . ($isTmaBlock ? 'storage layout & tma blocks management description' : 'storage layout management description') . "')");
        $this->Version->query("REPLACE INTO i18n (id,en,fr) (SELECT 'storage (non tma block) - value generated by newVersionSetup function', en, fr FROM i18n WHERE id = '" . ($isTmaBlock ? 'storage (non tma block)' : 'storage') . "')");
        
        $i18nModel = new Model(array(
            'table' => 'i18n',
            'name' => 0
        ));
        $versionNumber = $this->Version->data['Version']['version_number'];
        $i18nModel->save(array(
            'id' => 'core_app_version',
            'en' => $versionNumber,
            'fr' => $versionNumber
        ));
        
        // *** 3 ***rebuild language files
        
        $filee = fopen("../../app/Locale/eng/LC_MESSAGES/default.po", "w+t") or die("Failed to open english file");
        $filef = fopen("../../app/Locale/fra/LC_MESSAGES/default.po", "w+t") or die("Failed to open french file");
        $i18n = $i18nModel->find('all');
        foreach ($i18n as &$i18nLine) {
            // Takes information returned by query and creates variable for each field
            $id = preg_replace('/\s\s+/', ' ', $i18nLine[0]['id']);
            $en = preg_replace('/\s\s+/', ' ', $i18nLine[0]['en']);
            $fr = preg_replace('/\s\s+/', ' ', $i18nLine[0]['fr']);
            $error = "";
            if (strlen($en) > 2048) {
                $error = "msgid    \"$id\"\nen    \"$en\"\n";
                $en = substr($en, 0, 2048);
            }
            
            if (strlen($fr) > 2048) {
                if (strlen($error) > 2) {
                    $error = "$error\\nmsgstr    \"$fr\"\n";
                } else {
                    $error = "msgid    \"$id\"\nmsgstr=\"$fr\"\n";
                }
                $fr = substr($fr, 0, 2048);
            }
            $english = "msgid    \"$id\"\nmsgstr   \"$en\"\n";
            $french = "msgid    \"$id\"\nmsgstr   \"$fr\"\n";
            
            // Writes output to file
            fwrite($filee, $english);
            fwrite($filef, $french);
        }
        fclose($filee);
        fclose($filef);
        AppController::addWarningMsg(__('language files have been rebuilt'));
        
        // *** 4 *** rebuilts lft rght in datamart_browsing_result if needed + delete all temporary browsing index if > $tmpBrowsingLimit. Since v2.5.0.
        
        $browsingIndexModel = AppModel::getInstance('Datamart', 'BrowsingIndex', true);
        $browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult', true);
        $rootNodeIdsToKeep = array();
        $userRootNodeCounter = 0;
        $lastUserId = null;
        $forceRebuildLeftRght = false;
        $tmpBrowsing = $browsingIndexModel->find('all', array(
            'conditions' => array(
                'BrowsingIndex.temporary' => true
            ),
            'order' => array(
                'BrowsingResult.user_id, BrowsingResult.created DESC'
            )
        ));
        foreach ($tmpBrowsing as $newBrowsingIndex) {
            if ($lastUserId != $newBrowsingIndex['BrowsingResult']['user_id'] || $userRootNodeCounter < $browsingIndexModel->tmpBrowsingLimit) {
                if ($lastUserId != $newBrowsingIndex['BrowsingResult']['user_id'])
                    $userRootNodeCounter = 0;
                $lastUserId = $newBrowsingIndex['BrowsingResult']['user_id'];
                $userRootNodeCounter ++;
                $rootNodeIdsToKeep[$newBrowsingIndex['BrowsingIndex']['root_node_id']] = $newBrowsingIndex['BrowsingIndex']['root_node_id'];
            } else {
                // Some browsing index will be deleted
                $forceRebuildLeftRght = true;
            }
        }
        $resultIdsToKeep = $rootNodeIdsToKeep;
        $newParentIds = $rootNodeIdsToKeep;
        $loopCounter = 0;
        while (! empty($newParentIds)) {
            // Just in case
            $loopCounter ++;
            if ($loopCounter > 100)
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $newParentIds = $browsingResultModel->find('list', array(
                'conditions' => array(
                    "BrowsingResult.parent_id" => $newParentIds
                ),
                'fields' => array(
                    'BrowsingResult.id'
                )
            ));
            $resultIdsToKeep = array_merge($resultIdsToKeep, $newParentIds);
        }
        if (! empty($resultIdsToKeep)) {
            $browsingIndexModel->deleteAll("BrowsingIndex.root_node_id NOT IN (" . implode(',', $rootNodeIdsToKeep) . ")");
            $browsingResultModel->deleteAll("BrowsingResult.id NOT IN (" . implode(',', $resultIdsToKeep) . ")");
        }
        $result = $browsingResultModel->find('first', array(
            'conditions' => array(
                'NOT' => array(
                    'BrowsingResult.parent_id' => null
                ),
                'BrowsingResult.lft' => null
            )
        ));
        if ($result || $forceRebuildLeftRght) {
            self::addWarningMsg(__('rebuilt lft rght for datamart_browsing_results'));
            $browsingResultModel->recover('parent');
        }
        
        // *** 5 *** rebuild views
        
        $viewModels = array(
            AppModel::getInstance('InventoryManagement', 'ViewCollection'),
            AppModel::getInstance('InventoryManagement', 'ViewSample'),
            AppModel::getInstance('InventoryManagement', 'ViewAliquot'),
            AppModel::getInstance('StorageLayout', 'ViewStorageMaster'),
            AppModel::getInstance('InventoryManagement', 'ViewAliquotUse')
        );
        
        foreach ($viewModels as $viewModel) {
            $this->Version->query('DROP TABLE IF EXISTS ' . $viewModel->table);
            $this->Version->query('DROP VIEW IF EXISTS ' . $viewModel->table);
            if (isset($viewModel::$tableCreateQuery)) {
                // Must be done with multiple queries
                $this->Version->query($viewModel::$tableCreateQuery);
                $queries = explode("UNION ALL", $viewModel::$tableQuery);
                foreach ($queries as $query) {
                    $this->Version->query('INSERT INTO ' . $viewModel->table . '(' . str_replace('%%WHERE%%', '', $query) . ')');
                }
            } else {
                $this->Version->query('CREATE TABLE ' . $viewModel->table . '(' . str_replace('%%WHERE%%', '', $viewModel::$tableQuery) . ')');
                if ($viewModel->table == 'view_aliquots') {
                    $this->Version->query('ALTER TABLE `' . $viewModel->table . '` ADD INDEX `view_aliquot_barcode_index` (`barcode`)');
                    $this->Version->query('ALTER TABLE `' . $viewModel->table . '` ADD INDEX `view_aliquot_aliquot_label_index` (`aliquot_label`)');
                    $this->Version->query('ALTER TABLE `' . $viewModel->table . '` ADD INDEX `view_aliquot_acquisition_label_index` (`acquisition_label`)');
                }
                if ($viewModel->table == 'view_samples') {
                    $this->Version->query('ALTER TABLE `' . $viewModel->table . '` ADD INDEX `view_samples_sample_code_index` (`sample_code`)');
                }
                if ($viewModel->table == 'view_collections') {
                    $this->Version->query('ALTER TABLE `' . $viewModel->table . '` ADD INDEX `view_collections_acquisition_label_index` (`acquisition_label`)');
                }
            }
            $desc = $this->Version->query('DESC ' . $viewModel->table);
            $fields = array();
            $field = array_shift($desc);
            $pkey = $field['COLUMNS']['Field'];
            foreach ($desc as $field) {
                if ($field['COLUMNS']['Type'] != 'text') {
                    $fields[] = $field['COLUMNS']['Field'];
                }
            }
            $this->Version->query('ALTER TABLE ' . $viewModel->table . ' ADD PRIMARY KEY(' . $pkey . '), ADD KEY (' . implode('), ADD KEY (', $fields) . ')');
            /*
             * $database = new DATABASE_CONFIG();
             * $database = $database->default['database'];
             * $columns = $this->Version->query("SELECT column_name FROM information_schema.columns WHERE table_name = '".$viewModel->table."' && TABLE_SCHEMA='".$database."' order by column_name ;");
             * foreach($columns as $column){
             * $c= $column['columns']['column_name'];
             * try {
             * $this->Version->query("ALTER TABLE ".$viewModel->table." ADD INDEX (".$c.");");
             * } catch (Exception $exc) {
             * }
             * }
             */
        }
        
        AppController::addWarningMsg(__('views have been rebuilt'));
        
        // *** 6 *** Current Volume clean up
        
        $viewAliquotModel = AppModel::getInstance("InventoryManagement", "ViewAliquot", false); // To fix bug on table created on the fly (http://stackoverflow.com/questions/8167038/cakephp-pagination-using-temporary-table)
        $tmpAliquotModelCacheSources = $viewAliquotModel->cacheSources;
        $viewAliquotModel->cacheSources = false;
        $viewAliquotModel->schema();
        $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $aliquotMasterModel->checkWritableFields = false;
        AppModel::acquireBatchViewsUpdateLock();
        // Current Volume
        $currentVolumesUpdated = array();
        // Search all aliquots having initial_volume but no current_volume
        $tmpSql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume, am.current_volume
			FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
			WHERE am.deleted != 1 AND ac.volume_unit IS NOT NULL AND am.initial_volume IS NOT NULL AND am.current_volume IS NULL;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        foreach ($aliquotsToCleanUp as $newAliquot) {
            $aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
            $aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
            if (! $aliquotMasterModel->save(array(
                'AliquotMaster' => array(
                    'id' => $newAliquot['am']['aliquot_master_id'],
                    'current_volume' => $newAliquot['am']['initial_volume']
                )
            ), false))
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $currentVolumesUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
        }
        // Search all aliquots having current_volume but no initial_volume
        $tmpSql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume, am.current_volume
			FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id
			WHERE am.deleted != 1 AND ac.volume_unit IS NOT NULL AND am.initial_volume IS NULL AND am.current_volume IS NOT NULL;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        foreach ($aliquotsToCleanUp as $newAliquot) {
            $aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
            $aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
            if (! $aliquotMasterModel->save(array(
                'AliquotMaster' => array(
                    'id' => $newAliquot['am']['aliquot_master_id'],
                    'current_volume' => ''
                )
            ), false))
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $currentVolumesUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
        }
        // Search all aliquots having current_volume > 0 but a sum of used_volume (from view_aliquot_uses) > initial_volume
        $tmpSql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume, am.current_volume, us.sum_used_volumes FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id INNER JOIN (SELECT aliquot_master_id, SUM(used_volume) AS sum_used_volumes FROM view_aliquot_uses WHERE used_volume IS NOT NULL GROUP BY aliquot_master_id) AS us ON us.aliquot_master_id = am.id WHERE am.deleted != 1 AND ac.volume_unit IS NOT NULL AND am.initial_volume < us.sum_used_volumes AND am.current_volume != 0;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        foreach ($aliquotsToCleanUp as $newAliquot) {
            $aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
            $aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
            if (! $aliquotMasterModel->save(array(
                'AliquotMaster' => array(
                    'id' => $newAliquot['am']['aliquot_master_id'],
                    'current_volume' => '0'
                )
            ), false))
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $currentVolumesUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
        }
        // Search all aliquots having current_volume != initial volume - used_volume (from view_aliquot_uses) > initial_volume
        $tmpSql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume, am.current_volume, us.sum_used_volumes FROM aliquot_masters am INNER JOIN aliquot_controls ac ON ac.id = am.aliquot_control_id INNER JOIN (SELECT aliquot_master_id, SUM(used_volume) AS sum_used_volumes FROM view_aliquot_uses WHERE used_volume IS NOT NULL GROUP BY aliquot_master_id) AS us ON us.aliquot_master_id = am.id WHERE am.deleted != 1 AND ac.volume_unit IS NOT NULL AND am.initial_volume >= us.sum_used_volumes AND am.current_volume != (am.initial_volume - us.sum_used_volumes);";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        foreach ($aliquotsToCleanUp as $newAliquot) {
            $aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
            $aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
            if (! $aliquotMasterModel->save(array(
                'AliquotMaster' => array(
                    'id' => $newAliquot['am']['aliquot_master_id'],
                    'current_volume' => ($newAliquot['am']['initial_volume'] - $newAliquot['us']['sum_used_volumes'])
                )
            ), false))
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $currentVolumesUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
        }
        if ($currentVolumesUpdated) {
            AppController::addWarningMsg(__('aliquot current volume has been corrected for following aliquots : ') . (implode(', ', $currentVolumesUpdated)));
        }
        // -C-Used Volume
        $usedVolumeUpdated = array();
        // Search all aliquot internal use having used volume not null but no volume unit
        $tmpSql = "SELECT AliquotInternalUse.id AS aliquot_internal_use_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			AliquotInternalUse.used_volume AS used_volume,
			AliquotControl.volume_unit
			FROM aliquot_internal_uses AS AliquotInternalUse
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE AliquotInternalUse.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND AliquotInternalUse.used_volume IS NOT NULL;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        if ($aliquotsToCleanUp) {
            $aliquotInternalUseModel = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
            $aliquotInternalUseModel->checkWritableFields = false;
            foreach ($aliquotsToCleanUp as $newAliquot) {
                $aliquotInternalUseModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
                $aliquotInternalUseModel->id = $newAliquot['AliquotInternalUse']['aliquot_internal_use_id'];
                if (! $aliquotInternalUseModel->save(array(
                    'AliquotInternalUse' => array(
                        'id' => $newAliquot['AliquotInternalUse']['aliquot_internal_use_id'],
                        'used_volume' => ''
                    )
                ), false))
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
            }
        }
        // Search all aliquot used as source aliquot, used volume not null but no volume unit
        $tmpSql = "SELECT SourceAliquot.id AS source_aliquot_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			SourceAliquot.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM source_aliquots AS SourceAliquot
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE SourceAliquot.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND SourceAliquot.used_volume IS NOT NULL;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        if ($aliquotsToCleanUp) {
            $sourceAliquotModel = AppModel::getInstance("InventoryManagement", "SourceAliquot", true);
            $sourceAliquotModel->checkWritableFields = false;
            foreach ($aliquotsToCleanUp as $newAliquot) {
                $sourceAliquotModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
                $sourceAliquotModel->id = $newAliquot['SourceAliquot']['source_aliquot_id'];
                if (! $sourceAliquotModel->save(array(
                    'SourceAliquot' => array(
                        'id' => $newAliquot['SourceAliquot']['source_aliquot_id'],
                        'used_volume' => ''
                    )
                ), false))
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
            }
        }
        // Search all aliquot used as parent aliquot, used volume not null but no volume unit
        $tmpSql = "SELECT Realiquoting.id AS realiquoting_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			Realiquoting.parent_used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM realiquotings AS Realiquoting
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE Realiquoting.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND Realiquoting.parent_used_volume IS NOT NULL;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        if ($aliquotsToCleanUp) {
            $realiquotingModel = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
            $realiquotingModel->checkWritableFields = false;
            foreach ($aliquotsToCleanUp as $newAliquot) {
                $realiquotingModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
                $realiquotingModel->id = $newAliquot['Realiquoting']['realiquoting_id'];
                if (! $realiquotingModel->save(array(
                    'Realiquoting' => array(
                        'id' => $newAliquot['Realiquoting']['realiquoting_id'],
                        'parent_used_volume' => ''
                    )
                ), false))
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
            }
        }
        // Search all aliquot used for quality conbtrol, used volume not null but no volume unit
        $tmpSql = "SELECT QualityCtrl.id AS quality_control_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			QualityCtrl.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM quality_ctrls AS QualityCtrl
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE QualityCtrl.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND QualityCtrl.used_volume IS NOT NULL;";
        $aliquotsToCleanUp = $aliquotMasterModel->query($tmpSql);
        if ($aliquotsToCleanUp) {
            $qualityCtrlModel = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
            $qualityCtrlModel->checkWritableFields = false;
            foreach ($aliquotsToCleanUp as $newAliquot) {
                $qualityCtrlModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
                $qualityCtrlModel->id = $newAliquot['QualityCtrl']['quality_control_id'];
                if (! $qualityCtrlModel->save(array(
                    'QualityCtrl' => array(
                        'id' => $newAliquot['QualityCtrl']['quality_control_id'],
                        'used_volume' => ''
                    )
                ), false))
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
            }
        }
        if ($usedVolumeUpdated) {
            $viewAliquotUseModel = AppModel::getInstance('InventoryManagement', 'ViewAliquotUse');
            foreach (explode("UNION ALL", $viewAliquotUseModel::$tableQuery) as $query) {
                $viewAliquotUseModel->query('REPLACE INTO ' . $viewAliquotUseModel->table . '(' . str_replace('%%WHERE%%', 'AND AliquotMaster.id IN (' . implode(',', array_keys($usedVolumeUpdated)) . ')', $query) . ')');
            }
            AppController::addWarningMsg(__('aliquot used volume has been removed for following aliquots : ') . (implode(', ', $usedVolumeUpdated)));
        }
        $viewAliquotModel->cacheSources = $tmpAliquotModelCacheSources;
        $viewAliquotModel->schema();
        
        // *** 7 *** clear cache
        
        Cache::clear(false);
        Cache::clear(false, 'structures');
        Cache::clear(false, 'menus');
        Cache::clear(false, 'browser');
        Cache::clear(false, 'models');
        Cache::clear(false, '_cake_core_');
        Cache::clear(false, '_cake_model_');
        AppController::addWarningMsg(__('cache has been cleared'));
        
        // *** 8 *** Clean up parent to sample control + aliquot control
        
        $studiedSampleControlId = array();
        $activeSampleControlIds = array();
        $this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
        
        $conditions = array(
            'ParentToDerivativeSampleControl.parent_sample_control_id' => null,
            'ParentToDerivativeSampleControl.flag_active' => true
        );
        while ($activeParentSampleTypes = $this->ParentToDerivativeSampleControl->find('all', array(
            'conditions' => $conditions
        ))) {
            foreach ($activeParentSampleTypes as $newParentSampleType) {
                $activeSampleControlIds[] = $newParentSampleType['DerivativeControl']['id'];
                $studiedSampleControlId[] = $newParentSampleType['DerivativeControl']['id'];
            }
            $conditions = array(
                'ParentToDerivativeSampleControl.parent_sample_control_id' => $activeSampleControlIds,
                'ParentToDerivativeSampleControl.flag_active' => true,
                'not' => array(
                    'ParentToDerivativeSampleControl.derivative_sample_control_id' => $studiedSampleControlId
                )
            );
        }
        $this->Version->query('UPDATE parent_to_derivative_sample_controls SET flag_active = false WHERE parent_sample_control_id IS NOT NULL AND parent_sample_control_id NOT IN (' . implode(',', $activeSampleControlIds) . ')');
        $this->Version->query('UPDATE aliquot_controls SET flag_active = false WHERE sample_control_id NOT IN (' . implode(',', $activeSampleControlIds) . ')');
        
        // *** 9 *** Clean up structure_permissible_values_custom_controls counters values
        
        $structurePermissibleValuesCustomControl = AppModel::getInstance('', 'StructurePermissibleValuesCustomControl');
        $hasManyDetails = array(
            'hasMany' => array(
                'StructurePermissibleValuesCustom' => array(
                    'className' => 'StructurePermissibleValuesCustom',
                    'foreignKey' => 'control_id'
                )
            )
        );
        $structurePermissibleValuesCustomControl->bindModel($hasManyDetails);
        $allCusomListsControls = $structurePermissibleValuesCustomControl->find('all');
        foreach ($allCusomListsControls as $newCustomList) {
            $valuesUsedAsInputCounter = 0;
            $valuesCounter = 0;
            foreach ($newCustomList['StructurePermissibleValuesCustom'] as $newCustomValue) {
                if (! $newCustomValue['deleted']) {
                    $valuesCounter ++;
                    if ($newCustomValue['use_as_input'])
                        $valuesUsedAsInputCounter ++;
                }
            }
            $structurePermissibleValuesCustomControl->tryCatchQuery("UPDATE structure_permissible_values_custom_controls SET values_counter = $valuesCounter, values_used_as_input_counter = $valuesUsedAsInputCounter WHERE id = " . $newCustomList['StructurePermissibleValuesCustomControl']['id']);
        }
        
        // *** 10 *** rebuilts lft rght in storage_masters
        
        $storageMasterModel = AppModel::getInstance('StorageLayout', 'StorageMaster', true);
        $result = $storageMasterModel->find('first', array(
            'conditions' => array(
                'NOT' => array(
                    'StorageMaster.parent_id' => null
                ),
                'StorageMaster.lft' => null
            )
        ));
        if ($result) {
            self::addWarningMsg(__('rebuilt lft rght for storage_masters'));
            $storageMasterModel->recover('parent');
        }
        
        // *** 11 *** Disable unused treatment_extend_controls
        
        $this->Version->query("UPDATE treatment_extend_controls SET flag_active = 0 WHERE id NOT IN (select distinct treatment_extend_control_id from treatment_controls WHERE flag_active = 1 AND treatment_extend_control_id IS NOT NULL)");
        
        // *** 12 *** Check storage controls data
        
        $storageCtrlModel = AppModel::getInstance('Administrate', 'StorageCtrl', true);
        $storageCtrlModel->validatesAllStorageControls();
        
        // *** 13 *** Update structure_formats of 'shippeditems', 'orderitems' and 'orderlines' forms based on core variable 'order_item_type_config'
        
        $tmpSql = "SELECT DISTINCT `flag_detail`
			FROM structure_formats
			WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters')
			AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label')";
        $flagDetailResult = $aliquotMasterModel->query($tmpSql);
        $aliquotLabelFlagDetail = '1';
        if ($flagDetailResult) {
            $aliquotLabelFlagDetail = empty($flagDetailResult[0]['structure_formats']['flag_detail']) ? '0' : '1';
        }
        
        $structureFormatsQueries = array();
        switch (Configure::read('order_item_type_config')) {
            case '1':
                // both tma slide and aliquot could be added to order
                
                $structureFormatsQueries = array(
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Order' AND `model`='Generated' AND `field`='type');",
                    
                    // 1 - 'shippeditems' structure
                    "UPDATE structure_formats SET `flag_addgrid`=$aliquotLabelFlagDetail, `flag_addgrid_readonly`=$aliquotLabelFlagDetail, `flag_editgrid`=$aliquotLabelFlagDetail, `flag_editgrid_readonly`=$aliquotLabelFlagDetail, `flag_index`=$aliquotLabelFlagDetail, `flag_detail`=$aliquotLabelFlagDetail
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `field`='aliquot_label');",
                    "UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewAliquot' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='TmaSlide' AND field != 'barcode');",
                    
                    // 2 - 'orderitems' structure
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode');",
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode');",
                    
                    "UPDATE structure_formats SET `flag_edit`=$aliquotLabelFlagDetail, `flag_edit_readonly`=$aliquotLabelFlagDetail, `flag_editgrid`=$aliquotLabelFlagDetail, `flag_editgrid_readonly`=$aliquotLabelFlagDetail, `flag_index`=$aliquotLabelFlagDetail, `flag_detail`=$aliquotLabelFlagDetail 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label');",
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewAliquot' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='TmaSlide' AND field != 'barcode');",
                    
                    // 3 - `orderlines` structure
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderlines') 
						AND structure_field_id IN (SELECT id FROM structure_fields 
						WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='is_tma_slide' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');",
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');",
                    
                    // 4 - `orderitems_plus` structure
                    "UPDATE structure_formats SET `flag_index`='1'
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus')
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');",
                    "UPDATE structure_formats SET `flag_index`='1'
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus')
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');"
                );
                
                break;
            
            case '2':
                // aliquot only could be added to order
                
                $structureFormatsQueries = array(
                    "UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Order' AND `model`='Generated' AND `field`='type');",
                    
                    // 1 - 'shippeditems' structure
                    "UPDATE structure_formats SET `flag_addgrid`=$aliquotLabelFlagDetail, `flag_addgrid_readonly`=$aliquotLabelFlagDetail, `flag_editgrid`=$aliquotLabelFlagDetail, `flag_editgrid_readonly`=$aliquotLabelFlagDetail, `flag_index`=$aliquotLabelFlagDetail, `flag_detail`=$aliquotLabelFlagDetail
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `field`='aliquot_label');",
                    "UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewAliquot' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='TmaSlide');",
                    
                    // 2 - 'orderitems' structure
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode');",
                    "UPDATE structure_formats SET `flag_search`='0' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode');",
                    
                    "UPDATE structure_formats SET `flag_edit`=$aliquotLabelFlagDetail, `flag_edit_readonly`=$aliquotLabelFlagDetail, `flag_editgrid`=$aliquotLabelFlagDetail, `flag_editgrid_readonly`=$aliquotLabelFlagDetail, `flag_index`=$aliquotLabelFlagDetail, `flag_detail`=$aliquotLabelFlagDetail 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label');",
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewAliquot' AND `field` NOT IN ('aliquot_label','barcode'));",
                    "UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='TmaSlide');",
                    
                    // 3 - `orderlines` structure
                    "UPDATE structure_formats SET `flag_search`='0' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderlines') 
						AND structure_field_id IN (SELECT id FROM structure_fields 
						WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='is_tma_slide' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');",
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');",
                    
                    // 4 - `orderitems_plus` structure
                    "UPDATE structure_formats SET `flag_index`='1'
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus')
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');",
                    "UPDATE structure_formats SET `flag_index`='1'
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus')
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');"
                );
                
                break;
            
            case '3':
                // tma slide only could be added to order
                
                $structureFormatsQueries = array(
                    "UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Order' AND `model`='Generated' AND `field`='type');",
                    
                    // 1 - 'shippeditems' structure
                    "UPDATE structure_formats SET `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster');",
                    "UPDATE structure_formats SET `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewAliquot');",
                    "UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='shippeditems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='TmaSlide' AND field != 'barcode');",
                    
                    // 2 - 'orderitems' structure
                    "UPDATE structure_formats SET `flag_search`='0' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode');",
                    "UPDATE structure_formats SET `flag_search`='1' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode');",
                    
                    "UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems') 
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters');",
                    "UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_detail`='0'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewAliquot');",
                    "UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1'
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems')
						AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='TmaSlide' AND field != 'barcode');",
                    
                    // 3 - `orderlines` structure
                    "UPDATE structure_formats SET `flag_search`='0' 
						WHERE structure_id = (SELECT id FROM structures WHERE alias='orderlines') 
						AND structure_field_id IN (SELECT id FROM structure_fields 
						WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='is_tma_slide' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');",
                    "UPDATE structure_formats SET `flag_search`='0' 
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderlines') 
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');",
                    
                    // 4 - `orderitems_plus` structure
                    "UPDATE structure_formats SET `flag_index`='0' 
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus') 
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');",
                    "UPDATE structure_formats SET `flag_index`='0' 
						WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus') 
						AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');"
                );
                
                break;
            
            default:
        }
        $ldap = Configure::read('if_use_ldap_authentication');
        if (! empty($ldap)) {
            $structureFormatsQueries[] = "update structure_formats SET `flag_edit`='0', `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='users_form_for_admin') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='User' AND `tablename`='users' AND `field`='force_password_reset')";
        }
        
        foreach ($structureFormatsQueries as $tmpSql) {
            $aliquotMasterModel->query($tmpSql);
        }
        AppController::addWarningMsg(__("structures 'shippeditems', 'orderitems' and 'orderlines' have been updated based on the core variable 'order_item_type_config'."));
        
        // ------------------------------------------------------------------------------------------------------------------------------------------
        
        // update the permissions_regenerated flag and redirect
        $this->Version->data = array(
            'Version' => array(
                'permissions_regenerated' => 1
            )
        );
        $this->Version->checkWritableFields = false;
        if ($this->Version->save()) {
            $this->redirect('/Users/login');
        }
    }

    /**
     *
     * @param $config
     */
    public function configureCsv($config)
    {
        $this->csvConfig = $config;
        $this->Session->write('Config.language', $config['config_language']);
    }

    /**
     *
     * @param $connection
     * @param array $options
     * @return string
     */
    public function getQueryLogs($connection, $options = array())
    {
        $db = ConnectionManager::getDataSource($connection);
        $log = $db->getLog();
        if ($log['count'] == 0) {
            $out = "";
        } else {
            $out = '<span class="untranslated">Total Time: ' . $log['time'] . '<br>Total Queries: ' . $log['count'] . '<br></span>';
            $out .= '<table class="debug-table">' . '<thead>' . '<tr>' . '<th>Query</th>' . '<th>Affected</th>' . '<th>Num. rows</th>' . '<th>Took (ms)</th>' . 
            // '<th>Actions</th>'.
            '</tr>';
            $class = 'odd';
            foreach ($log['log'] as $i => $value) {
                $out .= '<tr class="' . $class . '">' . '<td>' . $value['query'] . '</td>' . '<td>' . $value['affected'] . '</td>' . '<td>' . $value['numRows'] . '</td>' . '<td>' . $value['took'] . '</td>' . '</tr>';
                $class = ($class == 'even' ? 'odd' : 'even');
            }
            $out .= "</thead>" . "</table>";
        }
        return $out;
    }

    /**
     *
     * @param null $array
     * @return array
     */
    public static function convertArrayKeyFromSnakeToCamel($array = null)
    {
        $answer = array();
        if ($array) {
            foreach ($array as $key => $value) {
                $answer[Inflector::variable($key)] = $value;
            }
        }
        return $answer;
    }
}

AppController::init();

/**
 * Returns the date in a classic format (useful for SQL)
 *
 * @throws Exception
 */
function now()
{
    return date("Y-m-d H:i:s");
}

/**
 *
 * @param $errno
 * @param $errstr
 * @param $errfile
 * @param $errline
 * @param null $context
 * @return bool
 */
function myErrorHandler($errno, $errstr, $errfile, $errline, $context = null)
{
    if (class_exists("AppController")) {
        $controller = AppController::getInstance();
        if ($errno == E_USER_WARNING && strpos($errstr, "SQL Error:") !== false && $controller->name != 'Pages') {
            $traceMsg = "<table><tr><th>File</th><th>Line</th><th>Function</th></tr>";
            try {
                throw new Exception("");
            } catch (Exception $e) {
                $traceArr = $e->getTrace();
                foreach ($traceArr as $traceLine) {
                    if (is_array($traceLine)) {
                        $traceMsg .= "<tr><td>" . (isset($traceLine['file']) ? $traceLine['file'] : "") . "</td><td>" . (isset($traceLine['line']) ? $traceLine['line'] : "") . "</td><td>" . $traceLine['function'] . "</td></tr>";
                    } else {
                        $traceMsg .= "<tr><td></td><td></td><td></td></tr>";
                    }
                }
            }
            $traceMsg .= "</table>";
            $controller->redirect('/Pages/err_query?err_msg=' . urlencode($errstr . $traceMsg));
        }
    }
    return false;
}