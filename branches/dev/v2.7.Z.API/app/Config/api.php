<?php

define("REST_API", "API");
define("CONFIG_API", "config");
define("MODEL_NAME", "modelName");
define("REST_API_MODE", "APIMode");
define("REST_API_ACTION", "APIAction");
define("REST_API_MODE_STRUCTURE", "APISModeStructure");
define("ATIM_API_KEY", "atimApiKey");

define("RECEIVE", "receive");

define("SEND", "send");
define("REST_API_SEND_INFO_BUNDLE", "sendToRestApi");

define("DATA", "data");

define("QUEUE", "QUEUE");

define("SHOW_IN_API", 1);

$APIGlobalVariable = 0;

/**
 * Class API
 */
class API {

    private static $counter = 0;
    private static $user;
    private static $structure;
    public static $errors = 'errors';
    public static $confirms = 'confirms';
    public static $warnings = 'warnings';
    public static $informations = 'informations';
    public static $data = 'data';
    public static $structures = 'structure';
    public static $redirect = 'redirect';
    private static $stop = 'stop';

    public static function d_api_app($data) {
        if (self::isAPIMode()) {
            if (self::getAction()!='initialAPI') {
                ob_clean();

                $response = json_encode($data);
                if (empty($response) && is_string($data)) {
                    $response = $data;
                } elseif (empty($response)) {
                    $response = "Error in d_api_app function";
                }
                ob_clean();
                die($response);
            }
        } else {
            $debug = Configure::read("debug");
            Configure::write("debug", 2);
            d($data, true, true, true, true);
            Configure::write("debug", $debug);
        }
    }

    /**
     * @param int $counter after $counter time that this function run, it send $message to API
     * @param array $message the message that will be send to API after $counter time of execution of this function
     */
    public static function stop($counter = 1, $message = array('message')) {
        self::stopCondition(self::$counter, '==', $counter, $message);
        self::$counter++;
    }

    /**
     * @param int $counter after $counter time that this function run, it send $message to API
     * @param array $message the message that will be send to API after $counter time of execution of this function
     */
    public static function stopCondition($var1, $con, $var2, $message = array()) {
        $condition = false;
        $condition = ($var1 == $var2 && $con == "==") ? true : $condition;
        $condition = ($var1 != $var2 && $con == "!=") ? true : $condition;
        $condition = ($var1 < $var2 && $con == "<") ? true : $condition;
        $condition = ($var1 <= $var2 && $con == "<=") ? true : $condition;
        $condition = ($var1 > $var2 && $con == ">") ? true : $condition;
        $condition = ($var1 >= $var2 && $con == ">=") ? true : $condition;
        if ($condition) {
            self::addToBundle($message, self::$stop);
            self::sendDataAndClear();
        }
    }

    /**
     * @param array $message
     * @param null $type
     */
    public static function addToBundle($message, $type = null) {
        $modelName = self::getModelName();
        if ($modelName == 'missingtranslation' || $modelName == 'userlog') {
            return;
        }
        if (empty($type)) {
            $type = 'informations';
        }
        if (self::isAPIMode() && $type !=self::$structures) {
            $bundle = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            if (!isset($bundle[$type]) || !is_array($bundle[$type])) {
                $bundle[$type] = array();
            }

            $bundle[$type][] = $message;
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = $bundle;
        }elseif(self::isAPIMode() && $type == self::$structures){
            $bundle = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            if (!isset($bundle[$type]) || !is_array($bundle[$type])) {
                $bundle[$type] = $message;
                $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = $bundle;
            }else{
                if (isset($bundle[$type]['fields']) && isset ($message['fields'])){
                    foreach ($message['fields'] as $k=>$v){
                        $bundle[$type]['fields'][$k] = $v;
                    }
                }
                if (isset($bundle[$type]['example']) && isset ($message['example'])){
                    foreach ($message['example'] as $k=>$v){
                        if (!isset($bundle[$type]['example'][$k])){
                            $bundle[$type]['example'][$k] = $v;
                        }else{
                            foreach ($message['example'][$k] as $key=>$value){
                                $bundle[$type]['example'][$k][$key] = $value;
                            }
                        }
                    }
                }
                $bundle[$type]['phpArray'] = "[" . convertJSONtoArray($bundle[$type]['example']) . "]";
                $bundle[$type]['jsArray'] = (isAssoc($bundle[$type]['example'])) ? "{" . json_encode_js($bundle[$type]['example']) . "}" : associateToIndexArray($bundle[$type]['example']);
                $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = $bundle;
            }
        }
    }

    /**
     * @param $data
     */
    public static function sendTo($data, $internal = false) {
        if (self::isAPIMode() && (self::getAction() != 'initialAPI' || $internal)) {
            if (ob_get_contents()) {
                ob_end_clean();
            }
            $result = json_encode($data);
            exit($result);
        }
    }

    public static function sendDataAndClear() {
        if (self::isAPIMode()) {
            $return = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            unset($_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE]);
            self::sendTo($return, true);
        }
    }

    /**
     * @return bool
     */
    public static function isAPIMode() {
        return (isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE]) && $_SESSION[REST_API][CONFIG_API][REST_API_MODE]);
    }

    /**
     * @return bool
     */
    public static function isStructMode() {
        return (isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE]) && $_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE]);
    }

    /**
     * @return mixed
     */
    public static function getModelName() {
        if (self::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][MODEL_NAME];
        }
    }

    /**
     * @return mixed
     */
    public static function getAction() {
        if (self::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][REST_API_ACTION];
        }
    }

    /**
     * @return mixed
     */
    public static function getController() {
        if (self::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][CONTROLLER_NAME];
        }
    }

    /**
     * @param $message
     */
    public static function addToQueue($message) {
        global $APIGlobalVariable;
        $APIGlobalVariable++;

        if (self::isAPIMode()) {
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE][QUEUE][] = $APIGlobalVariable . ': ' . $message;
        }
    }

    /**
     * @return null
     */
    public static function getApiKey() {
        if (self::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][ATIM_API_KEY];
        }
        return null;
    }

    public static function checkExtradata($data){
        if (isset($data['extraData'])){
            foreach ($data['extraData'][0] as $model=>$values){
                if (is_array($values)){
                    foreach ($values as $k=>$v){
                        $data[$model][$k]=$v;
                    }
                }
            }
            unset($data['extraData']);
        }
        return $data;
    }
    
    /**
     * @param $controller
     * @internal param array $data
     * @internal param string $model
     */
    public static function checkData(&$controller) {

        if (is_string($controller->request->data)) {
            $data = json_decode($controller->request->data, true);
        } elseif (is_array($controller->request->data)) {
            $data = $controller->request->data;
        } else {
            return false;
        }
        
        $data = self::checkExtradata($data);
        
        if (isset($data['modelName'])) {
            $model = $data['modelName'];
        } else {
            $model = $controller->modelClass;
        }
//if ($data['data_put_options']['action']!="initialAPI"){
//print_r($controller->request->data);
//print_r($data);
//exit("______________");
//}
        if (!(isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api'])) {
            unset($_SESSION[REST_API]);
        }
        if (!empty($data)) {
            if ($data && isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api']) {
                $controller->request->data = $data;
                Configure::write('debug', 0);
                $_SESSION[REST_API][CONFIG_API][ATIM_API_KEY] = $data['data_put_options']['atimApiKey'];
                $_SESSION[REST_API][CONFIG_API][MODEL_NAME] = strtolower($model);
                $_SESSION[REST_API][CONFIG_API][CONTROLLER_NAME] = (isset($data['modelName'])) ? $data['modelName'] : Inflector::pluralize($model);
                $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = true;
                $_SESSION[REST_API][CONFIG_API][REST_API_ACTION] = $data['data_put_options']['action'];
                $_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE] = isset($data['data_put_options']['mode']) && $data['data_put_options']['mode'] == 'structure';
                $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = array();
                unset($controller->request->data['data_put_options']);
                unset($controller->request->data['modelName']);
            }
        }
        $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE]) ? $_SESSION[REST_API][CONFIG_API][REST_API_MODE] : false;
    }

    /**
     * @param $data
     */
    public static function sendDataToAPI($data) {
        if (self::isAPIMode()) {
            $actionsList = array('view', 'profile', 'detail', 'listall', 'search', 'index', 'autocompletedrug', 'browse');
            if (!API::isStructMode() && isset($data) && is_array($data) && !empty($data) && in_array(self::getAction(), $actionsList)) {
                if (!self::showConfidential()) {
                    $Sfs = self::$structure['Sfs'];
                    foreach ($Sfs as $value) {
                        if ($value['flag_confidential']) {
                            for ($i = 0; $i < count($data); $i++) {
                                unset($data[$i][ucfirst(self::getModelName())][$value['field']]);
                            }
                        }
                    }
                }
//                self::addToBundle(array('Model, Action' => self::getModelName() . ', ' . self::getAction(), $data), 'data');
                self::addToBundle($data, self::$data);
            }
            self::sendDataAndClear();
        }
    }

    /**
     * @param $user
     * @return mixed
     */
    public static function setUser(&$user) {
        unset($user['UserApiKey']);
        unset($user['User']['password']);
        self::$user = $user;
        return $user;
    }

    public static function getUser() {
        return self::$user;
    }

    /**
     * @param $structure
     */
    public static function setStructure($structure) {
        self::$structure = $structure;
        if (!self::allowModifyConfidentialData()) {
            AppController::getInstance()->atimFlashError(__('you are not authorized to reach that page because you cannot input data into confidential fields'), '/Menus');
        }
    }

    /**
     * @return bool
     */
    private static function allowModifyConfidentialData() {
        $allow = true;
        if (!self::showConfidential()) {
            $Sfs = self::$structure['Sfs'];
            foreach ($Sfs as $value) {
                if ($value['flag_confidential'] && (strpos(self::getAction(), 'edit') !== false || strpos(self::getAction(), 'add') !== false)) {
                    $allow = false;
                }
            }
        }
        return $allow;
    }

    /**
     * @return mixed
     */
    public static function showConfidential() {
        return self::getUser()['Group']['flag_show_confidential'];
    }

    /**
     * @param $response
     * @param $item
     * @param $suffixes
     * @param $option
     */
    private static function setField(&$response, $item, $suffixes, $option) {
        $optionType = $option['type'];
        $type = $item['type'];
        $field = null;
        if ($suffixes == null) {
            $response['fields'][$item['field']]['field'] = $item['field'];
            $response['fields'][$item['field']]['name'] = $item['model'] . '[' . $item['field'] . ']';
            if (in_array($optionType, array("addgrid", "editgrid"))) {
                $response['example'][0][$item['model']][$item['field']] = null;
                $response['example'][1][$item['model']][$item['field']] = null;
            } else {
                $response['example'][$item['model']][$item['field']] = null;
            }
            if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                $response['fields'][$item['field']]['defined'] = $item['settings']['options']['defined'];
            }
            $response['fields'][$item['field']]['type'] = $item['type'];
            $response['fields'][$item['field']]['readonly'] = $item['readonly'];
            $response['fields'][$item['field']]['flag_confidential'] = $item['flag_confidential'];
            $response['fields'][$item['field']]['help'] = removeHTMLTags($item['help']);
            if (isset($item['settings']['required'])) {
                $response['fields'][$item['field']]['required'] = $item['settings']['required'];
            }
            if (isset($item['settings']['url'])) {
                $response['fields'][$item['field']]['url'] = $item['settings']['url'] . '?term=';
            }
        } else if (is_array($suffixes)) {
            foreach ($suffixes as $suffix) {
                $field = $item['field'] . $suffix;
                $response['fields'][$field]['field'] = $field;
                $response['fields'][$field]['name'] = $item['model'] . '[' . $field . ']';
                if (in_array($optionType, array("addgrid", "editgrid"))) {
                    $response['example'][0][$item['model']][$field] = null;
                    $response['example'][1][$item['model']][$field] = null;
                } else {
                    $response['example'][$item['model']][$field] = null;
                }
                if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                    $response['fields'][$field]['defined'] = $item['settings']['options']['defined'];
                }
                $response['fields'][$field]['type'] = $item['type'];
                $response['fields'][$item['field']]['readonly'] = $item['readonly'];
                $response['fields'][$field]['flag_confidential'] = $item['flag_confidential'];
                $response['fields'][$field]['help'] = removeHTMLTags($item['help']);
                if (isset($item['settings']['required'])) {
                    $response['fields'][$field]['required'] = $item['settings']['required'];
                }
                if (isset($item['settings']['url'])) {
                    $response['fields'][$item['field']]['url'] = $item['settings']['url'] . '?term=';
                }
            }
        } else {
            $field = $item['field'];
            $response['fields'][$item['field']]['field'] = $item['field'];
            $response['fields'][$item['field']]['name'] = $item['model'] . '[' . $item['field'] . ']' . $suffixes;
            if (in_array($optionType, array("addgrid", "editgrid"))) {
                $response['example'][0][$item['model']][$field] = array('e1', 'e2');
                $response['example'][1][$item['model']][$field] = array('e1', 'e2');
            } else {
                $response['example'][$item['model']][$field] = array('e1', 'e2');
            }
            if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                $response['fields'][$item['field']]['defined'] = $item['settings']['options']['defined'];
            }
            $response['fields'][$item['field']]['type'] = $item['type'];
            $response['fields'][$item['field']]['readonly'] = $item['readonly'];
            $response['fields'][$item['field']]['flag_confidential'] = $item['flag_confidential'];
            $response['fields'][$item['field']]['help'] = removeHTMLTags($item['help']);
            if (isset($item['settings']['required'])) {
                $response['fields'][$item['field']]['required'] = $item['settings']['required'];
            }
            if (isset($item['settings']['url'])) {
                $response['fields'][$item['field']]['url'] = $item['settings']['url'] . '?term=';
            }
        }
    }

    /**
     * @param $response
     * @param $item
     * @param $suffixes
     * @param $option
     * @internal param string $type
     */
    private static function setDate(&$response, $item, $suffixes, $option) {
        $optionType = $option['type'];
        $type = $item['type'];
        if (!$suffixes) {
            $response['fields'][$item['field']]['field'] = $item['field'];
            $response['fields'][$item['field']]['name']['year']['name'] = $item['model'] . '[' . $item['field'] . '][year]';
            $response['fields'][$item['field']]['name']['year']['defined'] = array('1900..2100');
            $response['fields'][$item['field']]['name']['month']['name'] = $item['model'] . '[' . $item['field'] . '][month]';
            $response['fields'][$item['field']]['name']['month']['defined'] = array('01..12');
            $response['fields'][$item['field']]['name']['day']['name'] = $item['model'] . '[' . $item['field'] . '][day]';
            $response['fields'][$item['field']]['name']['day']['defined'] = array('01..31');
            if (in_array($optionType, array("addgrid", "editgrid"))) {
                $response['example'][0][$item['model']][$item['field']] = array('year' => null, 'month' => null, 'day' => null);
                $response['example'][1][$item['model']][$item['field']] = array('year' => null, 'month' => null, 'day' => null);
            } else {
                $response['example'][$item['model']][$item['field']] = array('year' => null, 'month' => null, 'day' => null);
            }
            if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                $response['fields'][$item['field']]['defined'] = $item['settings']['options']['defined'];
            }
            $response['fields'][$item['field']]['type'] = $item['type'];
            $response['fields'][$item['field']]['readonly'] = $item['readonly'];
            $response['fields'][$item['field']]['flag_confidential'] = $item['flag_confidential'];
            $response['fields'][$item['field']]['help'] = removeHTMLTags($item['help']);
            if (isset($item['settings']['required'])) {
                $response['fields'][$item['field']]['required'] = $item['settings']['required'];
            }
            if (isset($item['settings']['url'])) {
                $response['fields'][$item['field']]['url'] = $item['settings']['url'] . '?term=';
            }
        } else {
            foreach ($suffixes as $suffix) {
                $field = $item['field'] . $suffix;
                $response['fields'][$field]['field'] = $field;
                $response['fields'][$field]['name']['year']['name'] = $item['model'] . '[' . $field . '][year]';
                $response['fields'][$field]['name']['year']['defined'] = array('1900..2100');
                $response['fields'][$field]['name']['month']['name'] = $item['model'] . '[' . $field . '][month]';
                $response['fields'][$field]['name']['month']['defined'] = array('01..12');
                $response['fields'][$field]['name']['day']['name'] = $item['model'] . '[' . $field . '][day]';
                $response['fields'][$field]['name']['day']['defined'] = array('01..31');
                if ($type == 'datetime') {
                    $response['fields'][$field]['name']['hour']['name'] = $item['model'] . '[' . $field . '][hour]';
                    $response['fields'][$field]['name']['hour']['defined'] = array('00..23');
                    $response['fields'][$field]['name']['min']['name'] = $item['model'] . '[' . $field . '][min]';
                    $response['fields'][$field]['name']['min']['defined'] = array('00..59');
                    if (in_array($optionType, array("addgrid", "editgrid"))) {
                        $response['example'][0][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null, 'hour' => null, 'min' => null);
                        $response['example'][1][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null, 'hour' => null, 'min' => null);
                    } else {
                        $response['example'][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null, 'hour' => null, 'min' => null);
                    }
                } else if ($type == 'date') {
                    if (in_array($optionType, array("addgrid", "editgrid"))) {
                        $response['example'][0][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null);
                        $response['example'][0][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null);
                    } else {
                        $response['example'][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null);
                    }
                }
                if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                    $response['fields'][$field]['defined'] = $item['settings']['options']['defined'];
                }
                $response['fields'][$field]['type'] = $item['type'];
                $response['fields'][$item['field']]['readonly'] = $item['readonly'];
                $response['fields'][$field]['flag_confidential'] = $item['flag_confidential'];
                $response['fields'][$field]['help'] = removeHTMLTags($item['help']);
                if (isset($item['settings']['required'])) {
                    $response['fields'][$field]['required'] = $item['settings']['required'];
                }
                if (isset($item['settings']['url'])) {
                    $response['fields'][$item['field']]['url'] = $item['settings']['url'] . '?term=';
                }
            }
        }
    }

    /**
     * @param $tableIndex
     * @param $structures
     * @param $option
     * @return array
     */
    private static function createStructure($tableIndex, $structures, $option) {
        if (empty($tableIndex)) {
            return null;
        }
        $response = array('fields' => array(), 'example' => array());
        foreach ($tableIndex as $columns) {
            foreach ($columns as $column) {
                foreach ($column as $item) {
                    if (!$item['flag_confidential'] || self::$user['Group']['flag_show_confidential']) {
                        $suffixes = null;
                        if (API::getAction() == "search") {
                            $suffixes = in_array($item['type'], StructuresComponent::$rangeTypes) ? array("_start", "_end") : "[]";
                        }
                        if (in_array($item['type'], array('date', 'datetime'))) {
                            self::setDate($response, $item, $suffixes, $option);
                        } elseif (in_array($item['type'], array("select", "radio", "checkbox", "yes_no", "y_n_u", "autocomplete", "textarea", "input", "integer", "integer_positive", "float", "float_positive"))) {
                            self::setField($response, $item, $suffixes, $option);
                            if ($suffixes && strpos($item['setting'], 'range') && $item['type'] == 'input') {
                                $suffixes = array("_start", "_end");
                                self::setField($response, $item, $suffixes, $option);
                            }
                        } else {
                            continue;
                        }
                    }
                }
            }
        }
        $response['phpArray'] = "[" . convertJSONtoArray($response['example']) . "]";
        $response['jsArray'] = (isAssoc($response['example'])) ? "{" . json_encode_js($response['example']) . "}" : associateToIndexArray($response['example']);
        return $response;
    }

    /**
     * @param $tableIndex
     * @param $structure
     * @param $option
     * @return array|null
     */
    public static function getStructure($tableIndex, $structure, $option) {
        if (API::isStructMode()) {
            $result = self::createStructure($tableIndex, $structure, $option);
            return $result;
        } else {
            return null;
        }
    }

}
