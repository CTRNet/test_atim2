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
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
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
 * @property StructuresComponent $Structures
 * @property MenusComponent $Menus
 * @property SystemVar $SystemVar
 * @property SessionAclComponent $SessionAcl
 * @property Version $Version
 * @property SessionComponent $Session
 * @property AuthComponent $Auth
 */
class AppController extends Controller {

	public $uses = array('Config', 'SystemVar');

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

	// Used as a set from the array keys
	public $allowedFilePrefixes = array();

	public static $beginFlash = false;

	public static $highlightMissingTranslations = true;

	private static $__missingTranslations = array();

	protected static $_me = null;

	protected static $_calInfoShort = array(
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

	protected static $_calInfoLong = array(
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

	//use AppController::getCalInfo to get those with translations
	protected static $_calInfoShortTranslated = false;

	protected static $_calInfoLongTranslated = false;

/**
 * Highlight missing translation
 *
 * @param string &$word The word that should be translated
 *
 * @return bool True if translation is missing
 */
	public static function missingTranslation(&$word) {
		if (!is_numeric($word) && strpos($word, "<span class='untranslated'>") === false) {
			AppController::$__missingTranslations[] = $word;
			if (Configure::read('debug') == 2 && self::$highlightMissingTranslations) {
				$word = "<span class='untranslated'>" . $word . "</span>";
				return true;
			}
		}
		return false;
	}

/**
 * Enter description here ...
 *
 * @param string $datetimeString String with format yyyy[-MM[-dd[ hh[:mm:ss]]]] (missing parts represent the accuracy
 * @param bool $nbspSpaces True if white spaces must be printed as &nbsp;
 * @param bool $shortMonths True if months names should be short (used if $month is an int)
 *
 * @return string The formatted date string with user preferences
 */
	public static function getFormatedDatetimeString($datetimeString, $nbspSpaces = true, $shortMonths = true) {
		$month = null;
		$day = null;
		$hour = null;
		$minutes = null;
		if (strpos($datetimeString, ' ') === false) {
			$date = $datetimeString;
		} else {
			list($date, $time) = explode(" ", $datetimeString);
			if (strpos($time, ":") === false) {
				$hour = $time;
			} else {
				list($hour, $minutes) = explode(":", $time);
			}
		}

		$date = explode("-", $date);
		$year = $date[0];
		switch (count($date)) {
			case 3:
				$day = $date[2];
				$month = $date[1];
				break;
			case 2:
				$month = $date[1];
				break;
		}
		$formattedDate = self::getFormatedDateString($year, $month, $day, $nbspSpaces);
		return $hour === null ? $formattedDate : $formattedDate . ($nbspSpaces ? "&nbsp;" : " ") .
			self::getFormatedTimeString($hour, $minutes, $nbspSpaces);
	}

/**
 * Get a formatted Time String
 *
 * @param int $year Year
 * @param int|string $month Month
 * @param int $day Day
 * @param bool $nbspSpaces True if white spaces must be printed as &nbsp;
 * @param bool $shortMonths True if months names should be short (used if $month is an int)
 *
 * @return string The formatted datestring with user preferences
 */
	public static function getFormatedDateString($year, $month, $day, $nbspSpaces = true, $shortMonths = true) {
		$result = null;
		if (empty($year) && empty($month) && empty($day)) {
			$result = "";
		} else {
			$divider = $nbspSpaces ? "&nbsp;" : " ";
			if (is_numeric($month)) {
				$monthStr = AppController::getCalInfo($shortMonths);
				$month = $month > 0 && $month < 13 ? $monthStr[(int)$month] : "-";
			}
			if (DATE_FORMAT == 'MDY') {
				$result = $month . (empty($month) ? "" : $divider) . $day . (empty($day) ? "" : $divider) . $year;
			} else {
				if (DATE_FORMAT == 'YMD') {
					$result = $year . (empty($month) ? "" : $divider) . $month . (empty($day) ? "" : $divider) . $day;
				} else { // default of DATE_FORMAT=='DMY'
					$result = $day . (empty($day) ? "" : $divider) . $month . (empty($month) ? "" : $divider) . $year;
				}
			}
		}
		return $result;
	}

/**
 * Get Calender Info including translated month names
 *
 * @param bool $short Whether to return short or long month names
 * @return array An associative array containing the translated months names so that key = month_number and value =
 *     month_name
 */
	public static function getCalInfo($short = true) {
		if ($short) {
			if (!AppController::$_calInfoShortTranslated) {
				AppController::$_calInfoShortTranslated = true;
				AppController::$_calInfoShort = array_map(create_function('$a', 'return __($a);'),
					AppController::$_calInfoShort);
			}
			return AppController::$_calInfoShort;
		} else {
			if (!AppController::$_calInfoLongTranslated) {
				AppController::$_calInfoLongTranslated = true;
				AppController::$_calInfoLong = array_map(create_function('$a', 'return __($a);'),
					AppController::$_calInfoLong);
			}
			return AppController::$_calInfoLong;
		}
	}

/**
 * Get Formatted Time String
 *
 * @param int $hour Hour
 * @param int $minutes Minutes
 * @param bool $nbspSpaces Include space as HTML character
 *
 * @return string
 */
	public static function getFormatedTimeString($hour, $minutes, $nbspSpaces = true) {
		if (TIME_FORMAT == 12) {
			$meridiem = $hour >= 12 ? "PM" : "AM";
			$hour %= 12;
			if ($hour == 0) {
				$hour = 12;
			}
			return $hour . (empty($minutes) ? '' : ":" . $minutes . ($nbspSpaces ? "&nbsp;" : " ")) . $meridiem;
		} else {
			if (empty($minutes)) {
				return $hour . __('hour_sign');
			} else {
				return $hour . ":" . $minutes;
			}
		}
	}

/**
 * Clones the first level of an array
 *
 * @param array $arr The array to clone
 *
 * @return array result
 */
	public static function cloneArray(array $arr) {
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
 * Builds the value definition array for an updateAll call
 *
 * @param array $data They data array to build the values with
 *
 * @return array result
 */
	public static function getUpdateAllValues(array $data) {
		$result = array();
		foreach ($data as $model => $fields) {
			foreach ($fields as $name => $value) {
				if (is_array($value)) {
					if (strlen($value['year'])) {
						$result[$model . "." . $name] = "'" . AppController::getFormattedDatetimeSQL($value) . "'";
					}
				} else {
					if (strlen($value)) {
						$result[$model . "." . $name] = "'" . $value . "'";
					}
				}
			}
		}
		return $result;
	}

/**
 * Return formatted date in SQL format from a date array returned by an application form.
 *
 * @param array $datetimeArray Array gathering date data into following structure:
 *    array('month' => string, '
 *        'day' => string,
 *        'year' => string,
 *        'hour' => string,
 *        'min' => string)
 * @param string $dateType Specify the type of date ('normal', 'start', 'end')
 *        - normal => Will force function to build a date witout specific rules.
 *      - start => Will force function to build date as a 'start date' of date range defintion
 *            (ex1: when just year is specified, will return a value like year-01-01 00:00)
 *            (ex2: when array is empty, will return a value like -9999-99-99 00:00)
 *      - end => Will force function to build date as an 'end date' of date range defintion
 *            (ex1: when just year is specified, will return a value like year-12-31 23:59)
 *            (ex2: when array is empty, will return a value like 9999-99-99 23:59)
 *
 * @return string The formated SQL date having following format yyyy-MM-dd hh:mn
 */
	public static function getFormattedDatetimeSQL($datetimeArray, $dateType = 'normal') {
		$formattedDate = '';
		switch ($dateType) {
			case 'normal':
				if ((!empty($datetimeArray['year'])) && (!empty($datetimeArray['month'])) && (!empty($datetimeArray['day']))) {
					$formattedDate = $datetimeArray['year'] . '-' . $datetimeArray['month'] . '-' . $datetimeArray['day'];
				}
				if ((!empty($formattedDate)) && (!empty($datetimeArray['hour']))) {
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
 * Set Cookie
 *
 * @param bool $skipExpirationCookie If setting cookie should be skipped
 * @return bool
 *
 * @desc cookie manipulation to counter cake problems. see eventum #1032
 */
	public static function atimSetCookie($skipExpirationCookie) {
		$sessionExpiration = time() + Configure::read("Session.timeout");

		setcookie('last_request', time(), $sessionExpiration, '/');

		if (!$skipExpirationCookie) {
			setcookie('session_expiration', $sessionExpiration, $sessionExpiration, '/');
			if (isset($_COOKIE[Configure::read("Session.cookie")])) {
				setcookie(Configure::read("Session.cookie"), $_COOKIE[Configure::read("Session.cookie")],
					$sessionExpiration, "/");
			}
		}
		return true;
	}

/**
 * Recursively removes entries returning true on empty($value).
 *
 * @param array &$data Data
 * @return bool
 */
	public static function removeEmptyValues(array &$data) {
		foreach ($data as $key => &$val) {
			if (is_array($val)) {
				self::removeEmptyValues($val);
			}
			if (empty($val)) {
				unset($data[$key]);
			}
		}
		return true;
	}

/**
 * Get New Search Id
 *
 * @return mixed
 */
	public static function getNewSearchId() {
		return AppController::getInstance()->Session->write('search_id',
			AppController::getInstance()->Session->read('search_id') + 1);
	}

/**
 * Get Instance
 *
 * @return AppController Instance
 */
	public static function getInstance() {
		return AppController::$_me;
	}

/**
 * Check Link Permission
 *
 * @param string $link The link to check
 * @return True if the user can access that page, false otherwise
 */
	public static function checkLinkPermission($link) {
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

		return strpos($acoAlias, 'Controller/Users') !== false
			|| strpos($acoAlias, 'Controller/Pages') !== false
			|| $acoAlias == "Controller/Menus/index"
			|| $instance->SessionAcl->check('Group::' . $instance->Session->read('Auth.User.group_id'), $acoAlias);
	}

/**
 * Apply Translation
 *
 * @param array &$inArray An array
 * @param string $model Model name
 * @param string $field Field name
 * @return bool
 */
	public static function applyTranslation(&$inArray, $model, $field) {
		foreach ($inArray as &$part) {
			$part[$model][$field] = __($part[$model][$field]);
		}
		return true;
	}

/**
 * Builds menu options based on 1-display_order and 2-translation
 *
 * @param array &$menuOptions An array containing arrays of the form array('order' => #, 'label' => '', 'link' =>
 *     '') The label must be translated already.
 * @return bool
 */
	public static function buildBottomMenuOptions(array &$menuOptions) {
		$tmp = array();
		foreach ($menuOptions as $menuOption) {
			$tmp[sprintf("%05d", $menuOption['order']) . '-' . $menuOption['label']] = $menuOption['link'];
		}
		ksort($tmp);
		$menuOptions = array();
		foreach ($tmp as $label => $link) {
			$menuOptions[preg_replace('/^[0-9]+-/', '', $label)] = $link;
		}
		return true;
	}

/**
 * Builds a cancel link based on the passed data. Works for data send by batch sets and browsing.
 *
 * @param string|null $data Data
 *
 * @return string|null
 */
	public static function getCancelLink($data) {
		$result = null;
		if (isset($data['node']['id'])) {
			$result = '/Datamart/Browser/browse/' . $data['node']['id'];
		} else {
			if (isset($data['BatchSet']['id'])) {
				$result = '/Datamart/BatchSets/listall/' . $data['BatchSet']['id'];
			} else {
				if (isset($data['cancel_link'])) {
					$result = $data['cancel_link'];
				}
			}
		}

		return $result;
	}

/**
 * This function is executed before every action in the controller. It’s a
 * handy place to check for an active session or inspect user permissions.
 *
 * @return void
 **/
	public function beforeFilter() {
		$this->_fixRequestUriForIis();

		App::uses('Sanitize', 'Utility');
		AppController::$_me = $this;
		if (Configure::read('debug') != 0) {
			Cache::clear(false, "structures");
			Cache::clear(false, "menus");
		}

		if ($this->Session->read('permission_timestamp') < $this->SystemVar->getVar('permission_timestamp')) {
			$this->resetPermissions();
		}
		if (Configure::read('Config.language') !== $this->Session->read('Config.language')) {
			$this->Session->write('Config.language', Configure::read('Config.language'));
		}

		$this->Auth->authorize = 'Actions';

		// record URL in logs
		$logActivityData['UserLog']['user_id'] = $this->Session->read('Auth.User.id');
		$logActivityData['UserLog']['url'] = $this->request->here;
		$logActivityData['UserLog']['visited'] = date("Y-m-d H:i:s");
		$logActivityData['UserLog']['allowed'] = 1;

		if (isset($this->UserLog)) {
			$logActivityModel =& $this->UserLog;
		} else {
			App::uses('UserLog', 'Model');
			$logActivityModel = new UserLog;
		}

		$logActivityModel->save($logActivityData);

		// menu grabbed for HEADER
		if ($this->request->is('ajax')) {
			Configure::write('debug', 0);
		} else {
			$atimSubMenuForHeader = array();
			$menuModel = AppModel::getInstance("", "Menu", true);

			$mainMenuItems = $menuModel->find('all',
				array('conditions' => array('Menu.parent_id' => 'MAIN_MENU_1')));
			foreach ($mainMenuItems as $item) {
				$atimSubMenuForHeader[$item['Menu']['id']] = $menuModel->find('all', array(
					'conditions' => array('Menu.parent_id' => $item['Menu']['id'], 'Menu.is_root' => 1),
					'order' => array('Menu.display_order')
				));
			}

			$this->set('atim_menu_for_header', $this->Menus->get('/menus/tools'));
			$this->set('atim_sub_menu_for_header', $atimSubMenuForHeader);

			// menu, passed to Layout where it would be rendered through a Helper
			$this->set('atim_menu_variables', array());
			$this->set('atim_menu', $this->Menus->get());
		}
		// get default STRUCTURES, used for forms, views, and validation
		$this->Structures->set();
		if (isset($this->request->query['file'])) {
			pr($this->request->query['file']);
		}
	}

/**
 * Reset Permissions
 *
 * @return void
 */
	public function resetPermissions() {
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
 * Hook Function
 *
 * @param string $hookExtension Name of the extension
 *
 * @return bool|string
 */
	public function hook($hookExtension = '') {
		if ($hookExtension) {
			$hookExtension = '_' . $hookExtension;
		}

		$hookFile = APP . ($this->request->params['plugin'] ? 'Plugin' . DS . $this->request->params['plugin'] . DS : '') .
			'Controller' . DS . 'Hook' . DS . $this->request->params['controller'] . '_' .
			$this->request->params['action'] . $hookExtension . '.php';

		if (!file_exists($hookFile)) {
			$hookFile = false;
		}

		return $hookFile;
	}

/**
 * Called after controller action logic, but before the view is rendered.
 * This callback is not used often, but may be needed if you are calling
 * render() manually before the end of a given action.
 *
 * @return void|CakeResponse
 **/
	public function beforeRender() {
		if (isset($this->request->query['file'])) {
			return $this->__handleFileRequest();
		}
		//Fix an issue where cakephp 2.0 puts the first loaded model with the key model in the registry.
		//Causes issues on validation messages
		ClassRegistry::removeObject('model');

		if (isset($this->passedArgs['batchsetVar'])) {
			//batchset handling
			$data = $this->viewVars[$this->passedArgs['batchsetVar']];
			if (empty($data)) {
				unset($this->passedArgs['batchsetVar']);
				return $this->Flash->error(__('there is no data to add to a temporary batchset'), 'javascript:history.back()');
			}
			if (isset($this->passedArgs['batchsetCtrl'])) {
				$data = $data[$this->passedArgs['batchsetCtrl']];
			}
			$this->requestAction('/Datamart/BatchSets/add/0', array('_data' => $data));
		}
	}

/**
 * Handle File Request
 *
 * @return CakeResponse|null
 */
	private function __handleFileRequest() {
		$file = $this->request->query['file'];

		$redirectInvalidFile = function ($caseType) use (&$file) {
			CakeLog::error("User tried to download invalid file (" . $caseType . "): " . $file);
			if ($caseType === 3) {
				AppController::getInstance()->redirect("/Pages/err_file_not_auth?p[]=" . $file);
			} else {
				AppController::getInstance()->redirect("/Pages/err_file_not_found?p[]=" . $file);
			}
		};

		$index = -1;
		foreach (range(0, 1) as $item) {
			$index = strpos($file, '.', $index + 1);
		}
		$prefix = substr($file, 0, $index);
		if ($prefix && array_key_exists($prefix, $this->allowedFilePrefixes)) {
			$dir = Configure::read('uploadDirectory');
			// NOTE: Cannot use flash for errors because file is still in the
			// url and that would cause an infinite loop
			if (strpos($file, '/') > -1 || strpos($file, '\\') > -1) {
				$redirectInvalidFile(1);
			}
			$fullFile = $dir . '/' . $file;
			if (!file_exists($fullFile)) {
				$redirectInvalidFile(2);
			}
			$index = strpos($file, '.', $index + 1) + 1;
			$this->response->file($fullFile, array('name' => substr($file, $index)));
			return $this->response;
		}
		$redirectInvalidFile(3);
	}

/**
 * After Filter Callback
 *
 * @return void
 */
	public function afterFilter() {
		// 		global $start_time;
		// 		echo("Exec time (sec): ".(AppController::microtime_float() - $start_time));

		if (count(AppController::$__missingTranslations) > 0) {
			App::uses('MissingTranslation', 'Model');
			$mt = new MissingTranslation();
			foreach (AppController::$__missingTranslations as $missingTranslation) {
				$mt->set(array("MissingTranslation" => array("id" => $missingTranslation)));
				$mt->save();//ignore errors, kind of insert ingnore
			}
		}
	}

/**
 * Display Flash Message and redirect to URL
 *
 * @param string $message The Message to display
 * @param string $url Redirect url
 * @return \Cake\Network\Response|null
 */
	public function atimFlash($message, $url) {
		if (Configure::read('debug') > 0) {
			$this->Flash->set($message);
		} else {
			$_SESSION['ctrapp_core']['confirm_msg'] = $message;
		}
		return $this->redirect($url);
	}

/**
 * Global function to initialize a batch action. Redirect/flashes on error.
 *
 * @param AppModel $model The model to work on
 * @param string $dataModelName The model name used in $this->request->data
 * @param string $dataKey The data key name used in $this->request->data
 * @param string $controlKeyName The name of the control field used in the model table
 * @param AppModel $possibilitiesModel The model to fetch the possibilities from
 * @param string $possibilitiesParentKey The possibilities parent key to base the search on
 * @param string $noPossibilitiesMsg Error Message
 *
 * @return array with the ids and the possibilities
 */
	public function batchInit(
		$model,
		$dataModelName,
		$dataKey,
		$controlKeyName,
		$possibilitiesModel,
		$possibilitiesParentKey,
		$noPossibilitiesMsg
	) {
		if (empty($this->request->data)) {
			$this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
		} else {
			if (!is_array($this->request->data[$dataModelName][$dataKey]) && strpos($this->request->data[$dataModelName][$dataKey],
					',')
			) {
				return array('error' => "batch init - number of submitted records too big");
			}
		}
		//extract valid ids
		$ids = $model->find('all', array(
			'conditions' => array($model->name . '.id' => $this->request->data[$dataModelName][$dataKey]),
			'fields' => array($model->name . '.id'),
			'recursive' => -1
		));
		if (empty($ids)) {
			return array('error' => "batch init no data");
		}
		$model->sortForDisplay($ids, $this->request->data[$dataModelName][$dataKey]);
		$ids = self::defineArrayKey($ids, $model->name, 'id');
		$ids = array_keys($ids);

		$controls = $model->find('all', array(
			'conditions' => array($model->name . '.id' => $ids),
			'fields' => array($model->name . '.' . $controlKeyName),
			'group' => array($model->name . '.' . $controlKeyName),
			'recursive' => -1
		));
		if (count($controls) != 1) {
			return array('error' => "you must select elements with a common type");
		}

		$possibilities = $possibilitiesModel->find('all', array(
			'conditions' => array(
				$possibilitiesParentKey => $controls[0][$model->name][$controlKeyName],
				'flag_active' => '1'
			)
		));

		if (empty($possibilities)) {
			return array('error' => $noPossibilitiesMsg);
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
 * @param array $inArray Array
 * @param string $model The model ($in_array[$model])
 * @param string $field The field (new key = $in_array[$model][$field])
 * @param bool $unique If true, the array block will be directly under the model.field, not in an array.
 *
 * @return array
 */
	public static function defineArrayKey($inArray, $model, $field, $unique = false) {
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
					//the key cannot be found
					$outArray[-1][] = $val;
				}
			}

		}
		return $outArray;
	}

/**
 * Handles automatic pagination of model records Adding
 * the necessary bind on the model to fetch detail level, if there is a unique ctrl id
 *
 * @param AppModel|string $object Model to paginate (e.g: model instance, or 'Model', or 'Model.InnerModel')
 * @param string|array $scope Conditions to use while paginating
 * @param array $whitelist List of allowed options for paging
 *
 * @return array Model query results
 */
	public function paginate($object = null, $scope = array(), $whitelist = array()) {
		// TODO: Temporary fix linked to issue #3040: TreatmentMaster & EventMaster listall: variable $paginate data won't be used
		if (!is_null($object) && !isset($this->passedArgs['sort']) && isset($this->paginate[$object->name]['order'])) {
			$object->order = $this->paginate[$object->name]['order'];
		}

		$modelName = isset($object->base_model) ? $object->base_model : $object->name;
		if (isset($object->Behaviors->MasterDetail->settings[$modelName])) {
			$settings = $object->Behaviors->MasterDetail->settings[$modelName];
			if ($settings['is_master_model']
				&& isset($scope[$modelName . '.' . $settings['control_foreign']])
				&& preg_match('/^[0-9]+$/', $scope[$modelName . '.' . $settings['control_foreign']])
			) {
				self::buildDetailBinding(
					$object,
					array($modelName . '.' . $settings['control_foreign'] => $scope[$modelName . '.' . $settings['control_foreign']]),
					$settings['empty_structure_alias']
				);
			}
		}
		return parent::paginate($object, $scope, $whitelist);
	}

/**
 * Adds the necessary bind on the model to fetch detail level, if there is a unique ctrl id
 *
 * @param AppModel &$model Model
 * @param array $conditions Search conditions
 * @param string &$structureAlias Alias of Structure
 *
 * @return void
 */
	public static function buildDetailBinding(&$model, array $conditions, &$structureAlias) {
		$controller = AppController::getInstance();
		$masterClassName = isset($model->base_model) ? $model->base_model : $model->name;
		if (!isset($model->Behaviors->MasterDetail->settings[$masterClassName])) {
			$controller->$masterClassName;//try to force lazyload
			if (!isset($model->Behaviors->MasterDetail->settings[$masterClassName])) {
				if (Configure::read('debug') != 0) {
					AppController::addWarningMsg("buildDetailBinding requires you to force instantiation of model " . $masterClassName);
				}
				return;
			}
		}
		if ($model->Behaviors->MasterDetail->settings[$masterClassName]['is_master_model']) {
			$ctrlIds = null;
			$singleCtrlId = $model->getSingleControlIdCondition(array('conditions' => $conditions));
			$controlField = $model->Behaviors->MasterDetail->settings[$masterClassName]['control_foreign'];
			if ($singleCtrlId === false) {
				//determine if the results contain only one control id
				$ctrlIds = $model->find('all', array(
					'fields' => array($model->name . '.' . $controlField),
					'conditions' => $conditions,
					'group' => array($model->name . '.' . $controlField),
					'limit' => 2
				));
				if (count($ctrlIds) == 1) {
					$singleCtrlId = current(current($ctrlIds[0]));
				}
			}
			if ($singleCtrlId !== false) {
				//only one ctrl, attach detail
				$hasOne = array();
				$controlClass = $model->Behaviors->MasterDetail->settings[$masterClassName]['control_class'];
				$ctrlModel = isset($controller->$controlClass) ? $controller->$controlClass : AppModel::getInstance('', $controlClass, false);
				if (!$ctrlModel) {
					if (Configure::read('debug') != 0) {
						AppController::addWarningMsg('buildDetailBinding requires you to force instanciation of model ' . $controlClass);
					}
					return;
				}
				$ctrlData = $ctrlModel->findById($singleCtrlId);
				$ctrlData = current($ctrlData);
				//put a new instance of the detail model in the cache
				$detailClass = $model->Behaviors->MasterDetail->settings[$masterClassName]['detail_class'];
				ClassRegistry::removeObject($detailClass);//flush the old detail from cache, we'll need to reinstance it
				// todo: Write this as UnitTest
				// assert(strlen($ctrlData['detail_tablename'])) || die("detail_tablename cannot be empty");
				new AppModel(array(
					'table' => $ctrlData['detail_tablename'],
					'name' => $detailClass,
					'alias' => $detailClass
				));

				//has one and win
				$masterForeign = $model->Behaviors->MasterDetail->settings[$masterClassName]['master_foreign'];
				$hasOne[$detailClass] = array(
					'className' => $detailClass,
					'foreignKey' => $masterForeign
				);

				if ($masterClassName == 'SampleMaster') {
					//join specimen/derivative details
					if ($ctrlData['sample_category'] == 'specimen') {
						$hasOne['SpecimenDetail'] = array(
							'className' => 'SpecimenDetail',
							'foreignKey' => 'sample_master_id'
						);
					} else {
						//derivative
						$hasOne['DerivativeDetail'] = array(
							'className' => 'DerivativeDetail',
							'foreignKey' => 'sample_master_id'
						);
					}
				}

				//persistent bind
				$model->bindModel(array(
					'hasOne' => $hasOne,
					'belongsTo' => array(
						$controlClass => array(
							'className' => $controlClass
						)
					)
				), false);
				isset($model->{$detailClass});//triggers model lazy loading (See cakephp Model class)

				//updating structure
				if (($pos = strpos($ctrlData['form_alias'], ',')) !== false) {
					$structureAlias = $structureAlias . ',' . substr($ctrlData['form_alias'], $pos + 1);
				}

				ClassRegistry::removeObject($detailClass);//flush the new model to make sure the default one is loaded if needed

			} else {
				if (count($ctrlIds) > 0) {
					//more than one
					AppController::addInfoMsg(__("the results contain various data types, so the details are not displayed"));
				}
			}
		}
	}

/**
 * Add a warning message
 *
 * @param string $msg Message
 * @param bool $withTrace Leave trace
 *
 * @return void
 */
	public static function addWarningMsg($msg, $withTrace = false) {
		if ($withTrace) {
			$_SESSION['ctrapp_core']['warning_trace_msg'][] = array('msg' => $msg, 'trace' => self::getStackTrace());
		} else {
			if (isset($_SESSION['ctrapp_core']['warning_no_trace_msg'][$msg])) {
				$_SESSION['ctrapp_core']['warning_no_trace_msg'][$msg]++;
			} else {
				$_SESSION['ctrapp_core']['warning_no_trace_msg'][$msg] = 1;
			}
		}
	}

/**
 * get Stack Trace
 *
 * @return array Result
 */
	public static function getStackTrace() {
		$bt = debug_backtrace();
		$result = array();
		foreach ($bt as $unit) {
			$result[] = (isset($unit['file']) ? $unit['file'] : '?') . ", " . $unit['function'] . " at line " . (isset($unit['line']) ? $unit['line'] : '?');
		}
		return $result;
	}

/**
 * add Info Message
 *
 * @param string $msg Message
 * @return void
 */
	public static function addInfoMsg($msg) {
		if (isset($_SESSION['ctrapp_core']['info_msg'][$msg])) {
			$_SESSION['ctrapp_core']['info_msg'][$msg]++;
		} else {
			$_SESSION['ctrapp_core']['info_msg'][$msg] = 1;
		}
	}

/**
 * Finds and paginate search results. Stores search in cache.
 * Handles detail level when there is a unique ctrl_id.
 * Defines/updates the result structure.
 * Sets 'result_are_unique_ctrl' as true if the results are based on a unique ctrl id,
 *    false otherwise. (Non master/detail models will return false)
 *
 * @param int $searchId The search id used by the pagination
 * @param AppModel $model The model to search upon
 * @param string $structureAlias The structure alias to parse the search conditions on
 * @param string $url The base url to use in the pagination links (meaning without the search_id)
 * @param bool $ignoreDetail If true, even if the model is a master_detail ,the detail level won't be loaded
 * @param mixed $limit If false, will make a paginate call, if an int greater than 0, will make a find with the
 *     limit
 * @return \Cake\Network\Response|null
 */
	public function searchHandler($searchId, $model, $structureAlias, $url, $ignoreDetail = false, $limit = false) {
		//setting structure
		$structure = $this->Structures->get('form', $structureAlias);
		$this->set('atim_structure', $structure);
		if (empty($searchId)) {
			$this->Structures->set('empty', 'empty_structure');
		} else {
			if ($this->request->data) {
				//newly submitted search, parse conditions and store in session
				$_SESSION['ctrapp_core']['search'][$searchId]['criteria'] = $this->Structures->parseSearchConditions($structure);
			} else {
				if (!isset($_SESSION['ctrapp_core']['search'][$searchId]['criteria'])) {
					self::addWarningMsg(__('you cannot resume a search that was made in a previous session'));
					return $this->redirect('/menus');
				}
			}

			//check if the current model is a master/detail one or a similar view
			if (!$ignoreDetail) {
				self::buildDetailBinding($model, $_SESSION['ctrapp_core']['search'][$searchId]['criteria'],
					$structureAlias);
				$this->Structures->set($structureAlias);
			}

			if ($limit) {
				$this->request->data = $model->find('all', array(
					'conditions' => $_SESSION['ctrapp_core']['search'][$searchId]['criteria'],
					'limit' => $limit
				));
			} else {
				if (isset($this->paginate[$model->name])) {
					$this->Paginator->settings = $this->paginate[$model->name];
				}
				$this->request->data = $this->Paginator->paginate($model,
					$_SESSION['ctrapp_core']['search'][$searchId]['criteria']);
			}

			// if SEARCH form data, save number of RESULTS and URL (used by the form builder pagination links)
			if ($searchId == -1) {
				//don't use the last search button if search id = -1
				unset($_SESSION['ctrapp_core']['search'][$searchId]);
			} else {
				$_SESSION['ctrapp_core']['search'][$searchId]['results'] = $this->request->params['paging'][$model->name]['count'];
				$_SESSION['ctrapp_core']['search'][$searchId]['url'] = $url;
			}
		}

		if ($this->request->is('ajax')) {
			Configure::write('debug', 0);
			$this->set('is_ajax', true);
		}
	}

/**
 * Sets url_to_cancel based on $this->request->data['url_to_cancel']
 * If nothing exists, javascript:history.go(-1) is used.
 * If a similar entry exists, the value is decremented.
 * Otherwise, url_to_cancel is uses as such.
 *
 * @return void
 */
	public function setUrlToCancel() {
		if (isset($this->request->data['url_to_cancel'])) {
			$pattern = '/^javascript:history.go\((-?[0-9]*)\)$/';
			$matches = array();
			if (preg_match($pattern, $this->request->data['url_to_cancel'], $matches)) {
				$back = empty($matches[1]) ? -2 : $matches[1] - 1;
				$this->request->data['url_to_cancel'] = 'javascript:history.go(' . $back . ')';
			}

		} else {
			$this->request->data['url_to_cancel'] = 'javascript:history.go(-1)';
		}

		$this->set('url_to_cancel', $this->request->data['url_to_cancel']);
	}

/**
 * Set for Radio List
 *
 * @param array &$list List
 * @param string $lModel Left Model
 * @param string $lKey Left Key
 * @param array $data Data
 * @param string $dModel Model
 * @param string $dKey Key
 *
 * @return bool
 */
	public function setForRadiolist(array &$list, $lModel, $lKey, array $data, $dModel, $dKey) {
		foreach ($list as &$unit) {
			if ($data[$dModel][$dKey] == $unit[$lModel][$lKey]) {
				//we found the one that interests us
				$unit[$dModel] = $data[$dModel];
				return true;
			}
		}
		return false;
	}

/**
 * Does multiple tasks related to having a version updated
 * -Permissions
 * -i18n version field
 * -language files
 * -cache
 * -Delete all browserIndex > Limit
 * -databrowser lft rght
 *
 * @return void
 * @throws Exception
 */
	public function newVersionSetup() {
		//new version installed!

		// *** 1 *** regen permissions

		$this->PermissionManager->buildAcl();
		AppController::addWarningMsg(__('permissions have been regenerated'));

		// *** 2 *** update the i18n string for version

		$i18nModel = new Model(array('table' => 'i18n', 'name' => 0));
		$versionNumber = $this->Version->data['Version']['version_number'];
		$i18nModel->save(array('id' => 'core_app_version', 'en' => $versionNumber, 'fr' => $versionNumber));

		// *** 3 ***rebuild language files

		$fileEnglish = fopen("../../app/Locale/eng/LC_MESSAGES/default.po", "w+t");
		if (!$fileEnglish) {
			throw new Exception("Failed to open english file");
		}
		$fileFrench = fopen("../../app/Locale/fra/LC_MESSAGES/default.po", "w+t");
		if (!$fileFrench) {
			throw new Exception("Failed to open french file");
		}
		$i18n = $i18nModel->find('all');
		foreach ($i18n as &$i18nLine) {
			//Takes information returned by query and creates variable for each field
			$id = $i18nLine[0]['id'];
			$en = $i18nLine[0]['en'];
			$fr = $i18nLine[0]['fr'];
			if (strlen($en) > 1014) {
				$error = "msgid\t\"$id\"\nen\t\"$en\"\n";
				$en = substr($en, 0, 1014);
			}

			if (strlen($fr) > 1014) {
				if (strlen($error) > 2) {
					$error = "$error\\nmsgstr\t\"$fr\"\n";
				} else {
					$error = "msgid\t\"$id\"\nmsgstr=\"$fr\"\n";
				}
				$fr = substr($fr, 0, 1014);
			}
			$english = "msgid\t\"$id\"\nmsgstr\t\"$en\"\n";
			$french = "msgid\t\"$id\"\nmsgstr\t\"$fr\"\n";

			//Writes output to file
			fwrite($fileEnglish, $english);
			fwrite($fileFrench, $french);
		}
		fclose($fileEnglish);
		fclose($fileFrench);
		AppController::addWarningMsg(__('language files have been rebuilt'));

		// *** 4 *** rebuilds lft rght in datamart_browsing_result if needed + delete all temporary browsing index if > $tmp_browsing_limit. Since v2.5.0.

		$browsingIndexModel = AppModel::getInstance('Datamart', 'BrowsingIndex', true);
		$browsingResultModel = AppModel::getInstance('Datamart', 'BrowsingResult', true);
		$rootNodeIdsToKeep = array();
		$userRootNodeCounter = 0;
		$lastUserId = null;
		$forceRebuildLeftRight = false;
		$tmpBrowsing = $browsingIndexModel->find('all', array(
			'conditions' => array('BrowsingIndex.temporary' => true),
			'order' => array('BrowsingResult.user_id, BrowsingResult.created DESC')
		));
		foreach ($tmpBrowsing as $newNrowsingIndex) {
			if ($lastUserId != $newNrowsingIndex['BrowsingResult']['user_id'] || $userRootNodeCounter < $browsingIndexModel->tmp_browsing_limit) {
				if ($lastUserId != $newNrowsingIndex['BrowsingResult']['user_id']) {
					$userRootNodeCounter = 0;
				}
				$lastUserId = $newNrowsingIndex['BrowsingResult']['user_id'];
				$userRootNodeCounter++;
				$rootNodeIdsToKeep[$newNrowsingIndex['BrowsingIndex']['root_node_id']] = $newNrowsingIndex['BrowsingIndex']['root_node_id'];
			} else {
				//Some browsing index will be deleted
				$forceRebuildLeftRight = true;
			}
		}
		$resultIdsToKeep = $rootNodeIdsToKeep;
		$newParentIds = $rootNodeIdsToKeep;
		$loopCounter = 0;
		while (!empty($newParentIds)) {
			//Just in case
			$loopCounter++;
			if ($loopCounter > 100) {
				$this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null,
					true);
			}
			$newParentIds = $browsingResultModel->find('list', array(
				'conditions' => array("BrowsingResult.parent_id" => $newParentIds),
				'fields' => array('BrowsingResult.id')
			));
			$resultIdsToKeep = array_merge($resultIdsToKeep, $newParentIds);
		}
		if (!empty($resultIdsToKeep)) {
			$browsingIndexModel->deleteAll("BrowsingIndex.root_node_id NOT IN (" . implode(',',
					$rootNodeIdsToKeep) . ")");
			$browsingResultModel->deleteAll("BrowsingResult.id NOT IN (" . implode(',', $resultIdsToKeep) . ")");
		}
		$result = $browsingResultModel->find('first', array(
			'conditions' => array(
				'NOT' => array('BrowsingResult.parent_id' => null),
				'BrowsingResult.lft' => null
			)
		));
		if ($result || $forceRebuildLeftRight) {
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
			if (isset($viewModel::$table_create_query)) {
				//Must be done with multiple queries
				$this->Version->query($viewModel::$table_create_query);
				$queries = explode("UNION ALL", $viewModel::$table_query);
				foreach ($queries as $query) {
					$this->Version->query('INSERT INTO ' . $viewModel->table . '(' . str_replace('%%WHERE%%', '', $query) . ')');
				}

			} else {
				$this->Version->query('CREATE TABLE ' . $viewModel->table . '(' . str_replace('%%WHERE%%', '',
						$viewModel::$table_query) . ')');
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
			$this->Version->query('ALTER TABLE ' . $viewModel->table . ' ADD PRIMARY KEY(' . $pkey . '), ADD KEY (' . implode('), ADD KEY (',
					$fields) . ')');
		}

		AppController::addWarningMsg(__('views have been rebuilt'));

		// *** 6 *** Use Counter and Current Volume clean up

		//To fix bug on table created on the fly (http://stackoverflow.com/questions/8167038/cakephp-pagination-using-temporary-table)
		$viewAliquotModel = AppModel::getInstance("InventoryManagement", "ViewAliquot", false);
		$tmpAliquotModelCacheSources = $viewAliquotModel->cacheSources;
		$viewAliquotModel->cacheSources = false;
		$viewAliquotModel->schema();
		$aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$aliquotMasterModel->check_writable_fields = false;
		AppModel::acquireBatchViewsUpdateLock();
		//-A-Use counter
		$useCountersUpdated = array();
		//Search all aliquots linked to at least one use and having use_counter = 0
		$sqlToSearchAllAliquots = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, us.use_counter 
				FROM aliquot_masters am 
				INNER JOIN (SELECT count(*) AS use_counter, aliquot_master_id
							FROM view_aliquot_uses
							GROUP BY aliquot_master_id) us
							ON am.id = us.aliquot_master_id
							WHERE am.deleted <> 1 AND (am.use_counter IS NULL OR am.use_counter = 0)";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		foreach ($aliquotsToCleanUp as $newAliquot) {
			$aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
			if (!$aliquotMasterModel->save(array(
				'AliquotMaster' => array(
					'id' => $newAliquot['am']['aliquot_master_id'],
					'use_counter' => $newAliquot['us']['use_counter']
				)
			), false)
			) {
				$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
			}
			$useCountersUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
		}
		//Search all unused aliquots having use_counter != 0
		$sqlToSearchAllAliquots = "SELECT id AS aliquot_master_id, barcode, aliquot_label 
									FROM aliquot_masters 
									WHERE deleted <> 1 
										AND use_counter != 0 
										AND id NOT IN (SELECT DISTINCT aliquot_master_id FROM view_aliquot_uses);";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		foreach ($aliquotsToCleanUp as $newAliquot) {
			$aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$aliquotMasterModel->id = $newAliquot['aliquot_masters']['aliquot_master_id'];
			if (!$aliquotMasterModel->save(array(
				'AliquotMaster' => array(
					'id' => $newAliquot['aliquot_masters']['aliquot_master_id'],
					'use_counter' => '0'
				)
			), false)
			) {
				$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
			}
			$useCountersUpdated[$newAliquot['aliquot_masters']['aliquot_master_id']] = $newAliquot['aliquot_masters']['barcode'];
		}
		//Search all aliquots having use_counter != real use counter (from view_aliquot_uses)
		$sqlToSearchAllAliquots = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label,us.use_counter
									FROM aliquot_masters am 
									INNER JOIN (SELECT aliquot_master_id, count(*) AS use_counter 
												FROM view_aliquot_uses
												GROUP BY aliquot_master_id) us
									ON us.aliquot_master_id = am.id
									WHERE am.deleted <> 1 AND us.use_counter != am.use_counter;";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		foreach ($aliquotsToCleanUp as $newAliquot) {
			$aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
			if (!$aliquotMasterModel->save(array(
				'AliquotMaster' => array(
					'id' => $newAliquot['am']['aliquot_master_id'],
					'use_counter' => $newAliquot['us']['use_counter']
				)
			), false)
			) {
				$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
			}
			$useCountersUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
		}
		if ($useCountersUpdated) {
			AppController::addWarningMsg(__('aliquot use counter has been corrected for following aliquots : ') . (implode(', ',
					$useCountersUpdated)));
		}
		//-B-Current Volume
		$currentVolumesUpdated = array();
		//Search all aliquots having current_volume > 0 but a sum of used_volume (from view_aliquot_uses) > initial_volume
		$sqlToSearchAllAliquots = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume,
									am.current_volume, us.sum_used_volumes 
									FROM aliquot_masters am 
									INNER JOIN aliquot_controls ac 
										ON ac.id = am.aliquot_control_id 
									INNER JOIN (SELECT aliquot_master_id, SUM(used_volume) AS sum_used_volumes 
												FROM view_aliquot_uses 
												WHERE used_volume IS NOT NULL GROUP BY aliquot_master_id) AS us 
										ON us.aliquot_master_id = am.id 
									WHERE am.deleted != 1 
										AND ac.volume_unit IS NOT NULL 
										AND am.initial_volume < us.sum_used_volumes 
										AND am.current_volume != 0;";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		foreach ($aliquotsToCleanUp as $newAliquot) {
			$aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
			if (!$aliquotMasterModel->save(array(
				'AliquotMaster' => array(
					'id' => $newAliquot['am']['aliquot_master_id'],
					'current_volume' => '0'
				)
			), false)
			) {
				$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
			}
			$currentVolumesUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
		}
		//Search all aliquots having current_volume != initial volume - used_volume (from view_aliquot_uses) > initial_volume
		$sqlToSearchAllAliquots = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, am.initial_volume,
									am.current_volume, us.sum_used_volumes 
									FROM aliquot_masters am 
									INNER JOIN aliquot_controls ac
									 ON ac.id = am.aliquot_control_id 
									INNER JOIN (SELECT aliquot_master_id, SUM(used_volume) AS sum_used_volumes 
												FROM view_aliquot_uses 
												WHERE used_volume IS NOT NULL 
												GROUP BY aliquot_master_id) AS us 
										ON us.aliquot_master_id = am.id 
									WHERE am.deleted != 1 
										AND ac.volume_unit IS NOT NULL 
										AND am.initial_volume >= us.sum_used_volumes 
										AND am.current_volume != (am.initial_volume - us.sum_used_volumes);";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		foreach ($aliquotsToCleanUp as $newAliquot) {
			$aliquotMasterModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
			$aliquotMasterModel->id = $newAliquot['am']['aliquot_master_id'];
			if (!$aliquotMasterModel->save(array(
				'AliquotMaster' => array(
					'id' => $newAliquot['am']['aliquot_master_id'],
					'current_volume' => ($newAliquot['am']['initial_volume'] - $newAliquot['us']['sum_used_volumes'])
				)
			), false)
			) {
				$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
			}
			$currentVolumesUpdated[$newAliquot['am']['aliquot_master_id']] = $newAliquot['am']['barcode'];
		}
		if ($currentVolumesUpdated) {
			AppController::addWarningMsg(__('aliquot current volume has been corrected for following aliquots : ') . (implode(', ',
					$currentVolumesUpdated)));
		}
		// C-Used Volume
		$usedVolumeUpdated = array();
		// Search all aliquot internal use having used volume not null but no volume unit
		$sqlToSearchAllAliquots = "SELECT AliquotInternalUse.id AS aliquot_internal_use_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			AliquotInternalUse.used_volume AS used_volume,
			AliquotControl.volume_unit
			FROM aliquot_internal_uses AS AliquotInternalUse
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE AliquotInternalUse.deleted <> 1
				AND AliquotControl.volume_unit IS NULL
				AND AliquotInternalUse.used_volume IS NOT NULL;";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		if ($aliquotsToCleanUp) {
			$aliquotInternalUseModel = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
			$aliquotInternalUseModel->check_writable_fields = false;
			foreach ($aliquotsToCleanUp as $newAliquot) {
				$aliquotInternalUseModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$aliquotInternalUseModel->id = $newAliquot['AliquotInternalUse']['aliquot_internal_use_id'];
				if (!$aliquotInternalUseModel->save(array(
					'AliquotInternalUse' => array(
						'id' => $newAliquot['AliquotInternalUse']['aliquot_internal_use_id'],
						'used_volume' => ''
					)
				), false)
				) {
					$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
				}
				$usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
			}
		}
		// Search all aliquot used as source aliquot, used volume not null but no volume unit
		$sqlToSearchAllAliquots = "SELECT SourceAliquot.id AS source_aliquot_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			SourceAliquot.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM source_aliquots AS SourceAliquot
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE SourceAliquot.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND SourceAliquot.used_volume IS NOT NULL;";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		if ($aliquotsToCleanUp) {
			$sourceAliquotModel = AppModel::getInstance("InventoryManagement", "SourceAliquot", true);
			$sourceAliquotModel->check_writable_fields = false;
			foreach ($aliquotsToCleanUp as $newAliquot) {
				$sourceAliquotModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$sourceAliquotModel->id = $newAliquot['SourceAliquot']['source_aliquot_id'];
				if (!$sourceAliquotModel->save(array(
					'SourceAliquot' => array(
						'id' => $newAliquot['SourceAliquot']['source_aliquot_id'],
						'used_volume' => ''
					)
				), false)
				) {
					$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null,
						true);
				}
				$usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
			}
		}
		// Search all aliquot used as parent aliquot, used volume not null but no volume unit
		$sqlToSearchAllAliquots = "SELECT Realiquoting.id AS realiquoting_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			Realiquoting.parent_used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM realiquotings AS Realiquoting
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE Realiquoting.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND Realiquoting.parent_used_volume IS NOT NULL;";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		if ($aliquotsToCleanUp) {
			$realiquotingModel = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
			$realiquotingModel->check_writable_fields = false;
			foreach ($aliquotsToCleanUp as $newAliquot) {
				$realiquotingModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$realiquotingModel->id = $newAliquot['Realiquoting']['realiquoting_id'];
				if (!$realiquotingModel->save(array(
					'Realiquoting' => array(
						'id' => $newAliquot['Realiquoting']['realiquoting_id'],
						'parent_used_volume' => ''
					)
				), false)
				) {
					$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
				}
				$usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
			}
		}
		//Search all aliquot used for quality conbtrol, used volume not null but no volume unit 
		$sqlToSearchAllAliquots = "SELECT QualityCtrl.id AS quality_control_id,
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.barcode AS barcode,
			QualityCtrl.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit
			FROM quality_ctrls AS QualityCtrl
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			WHERE QualityCtrl.deleted <> 1 AND AliquotControl.volume_unit IS NULL AND QualityCtrl.used_volume IS NOT NULL;";
		$aliquotsToCleanUp = $aliquotMasterModel->query($sqlToSearchAllAliquots);
		if ($aliquotsToCleanUp) {
			$qualityCtrlModel = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
			$qualityCtrlModel->check_writable_fields = false;
			foreach ($aliquotsToCleanUp as $newAliquot) {
				$qualityCtrlModel->data = array(); // *** To guaranty no merge will be done with previous AliquotMaster data ***
				$qualityCtrlModel->id = $newAliquot['QualityCtrl']['quality_control_id'];
				if (!$qualityCtrlModel->save(array(
					'QualityCtrl' => array(
						'id' => $newAliquot['QualityCtrl']['quality_control_id'],
						'used_volume' => ''
					)
				), false)
				) {
					$this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null,
						true);
				}
				$usedVolumeUpdated[$newAliquot['AliquotMaster']['aliquot_master_id']] = $newAliquot['AliquotMaster']['barcode'];
			}
		}
		if ($usedVolumeUpdated) {
			$viewAliquotUseModel = AppModel::getInstance('InventoryManagement', 'ViewAliquotUse');
			foreach (explode("UNION ALL", $viewAliquotUseModel::$table_query) as $query) {
				$replacedQuery = str_replace('%%WHERE%%', 'AND AliquotMaster.id IN (' . implode(',', array_keys($usedVolumeUpdated)) . ')', $query);
				$viewAliquotUseModel->query('REPLACE INTO ' . $viewAliquotUseModel->table . '(' . $replacedQuery . ')');
			}
			AppController::addWarningMsg(__('aliquot used volume has been removed for following aliquots : ') . (implode(', ',
					$usedVolumeUpdated)));
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
		while ($activeParentSampleTypes = $this->ParentToDerivativeSampleControl->find('all',
			array('conditions' => $conditions))) {
			foreach ($activeParentSampleTypes as $newParentSampleType) {
				$activeSampleControlIds[] = $newParentSampleType['DerivativeControl']['id'];
				$studiedSampleControlId[] = $newParentSampleType['DerivativeControl']['id'];
			}
			$conditions = array(
				'ParentToDerivativeSampleControl.parent_sample_control_id' => $activeSampleControlIds,
				'ParentToDerivativeSampleControl.flag_active' => true,
				'not' => array('ParentToDerivativeSampleControl.derivative_sample_control_id' => $studiedSampleControlId)
			);
		}
		$this->Version->query('UPDATE parent_to_derivative_sample_controls 
								SET flag_active = FALSE 
								WHERE parent_sample_control_id IS NOT NULL 
									AND parent_sample_control_id NOT IN (' . implode(',', $activeSampleControlIds) . ')');
		$this->Version->query('UPDATE aliquot_controls 
								SET flag_active = FALSE 
								WHERE sample_control_id NOT IN (' . implode(',', $activeSampleControlIds) . ')');

		// *** 9 *** Clean up structure_permissible_values_custom_controls counters values

		$StructurePermissibleValuesCustomControl = AppModel::getInstance('', 'StructurePermissibleValuesCustomControl');
		$hasManyDetails = array(
			'hasMany' => array(
				'StructurePermissibleValuesCustom' => array(
					'className' => 'StructurePermissibleValuesCustom',
					'foreignKey' => 'control_id'
				)
			)
		);
		$StructurePermissibleValuesCustomControl->bindModel($hasManyDetails);
		$allCusomListsControls = $StructurePermissibleValuesCustomControl->find('all');
		foreach ($allCusomListsControls as $newCustomList) {
			$valuesUsedAsInputCounter = 0;
			$valuesCounter = 0;
			foreach ($newCustomList['StructurePermissibleValuesCustom'] as $newCustomValue) {
				if (!$newCustomValue['deleted']) {
					$valuesCounter++;
					if ($newCustomValue['use_as_input']) {
						$valuesUsedAsInputCounter++;
					}
				}
			}
			$StructurePermissibleValuesCustomControl->tryCatchQuery(
				"UPDATE structure_permissible_values_custom_controls 
				SET values_counter = $valuesCounter, values_used_as_input_counter = $valuesUsedAsInputCounter 
				WHERE id = " . $newCustomList['StructurePermissibleValuesCustomControl']['id']);
		}

		// *** 10 *** rebuilds lft rght in storage_masters

		$storageMasterModel = AppModel::getInstance('StorageLayout', 'StorageMaster', true);
		$result = $storageMasterModel->find('first', array(
			'conditions' => array(
				'NOT' => array('StorageMaster.parent_id' => null),
				'StorageMaster.lft' => null
			)
		));
		if ($result) {
			self::addWarningMsg(__('rebuilt lft rght for storage_masters'));
			$storageMasterModel->recover('parent');
		}

		// *** 11 *** Disable unused treatment_extend_controls

		$this->Version->query("UPDATE treatment_extend_controls 
								SET flag_active = 0 
								WHERE id NOT IN (SELECT DISTINCT treatment_extend_control_id 
												FROM treatment_controls 
												WHERE flag_active = 1 AND treatment_extend_control_id IS NOT NULL)");

		//update the permissions_regenerated flag and redirect
		$this->Version->data = array('Version' => array('permissions_regenerated' => 1));
		$this->Version->checkWritableFields = false;
		if ($this->Version->save()) {
			$this->redirect('/Users/login');
		}
	}

/**
 * Configure Csv
 *
 * @param string $config How csv_config should be set
 * @return void
 */
	public function configureCsv($config) {
		$this->csv_config = $config;
		$this->Session->write('Config.language', $config['config_language']);
	}

/**
 * Fix REQUEST_URI on IIS
 *
 * @return void
 */
	protected function _fixRequestUriForIis() {
		// parse URI manually to get passed PARAMS
		$requestUriParams = array();

		//Fix REQUEST_URI on IIS
		if (!isset($_SERVER['REQUEST_URI'])) {
			$_SERVER['REQUEST_URI'] = substr($_SERVER['PHP_SELF'], 1);
			if (isset($_SERVER['QUERY_STRING'])) {
				$_SERVER['REQUEST_URI'] .= '?' . $_SERVER['QUERY_STRING'];
			}
		}
		$requestUri = $_SERVER['REQUEST_URI'];
		if (stripos($requestUri, ':') !== false) {
			$requestUri = explode('/', $requestUri);
			$requestUri = array_filter($requestUri); // Remove entries of array equal to FALSE

			foreach ($requestUri as $uri) {
				$explodedUri = explode(':', $uri);
				if (count($explodedUri) > 1) {
					$requestUriParams[$explodedUri[0]] = $explodedUri[1];
					if ($explodedUri[0] === 'per') {
						define('PAGINATION_AMOUNT', $explodedUri[1]);
					}
				}
			}
		}
	}
}