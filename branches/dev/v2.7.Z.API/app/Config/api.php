<?php

define("REST_API", "API");
define("CONFIG_API", "config");
define("MODEL_NAME", "modelName");
define("CONTROLLER_NAME", "controller");
define("REST_API_MODE", "APIMode");
define("REST_API_ACTION", "APIAction");
define("REST_API_MODE_STRUCTURE", "APISModeStructure");
define("NUMBER", "number");

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
    
    private static $apiKey;

    public static function d_api_app($data) 
    {
        if (static::isAPIMode()) {
            if (static::getAction()!='initialAPI') {
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
    public static function stop($counter = 1, $message = array('message')) 
    {
        static::stopCondition(static::$counter, '==', $counter, $message);
        static::$counter++;
    }

    /**
     * @param int $counter after $counter time that this function run, it send $message to API
     * @param array $message the message that will be send to API after $counter time of execution of this function
     */
    public static function stopCondition($var1, $con, $var2, $message = array())
    {
        $condition = false;
        $condition = ($var1 == $var2 && $con == "==") ? true : $condition;
        $condition = ($var1 != $var2 && $con == "!=") ? true : $condition;
        $condition = ($var1 < $var2 && $con == "<") ? true : $condition;
        $condition = ($var1 <= $var2 && $con == "<=") ? true : $condition;
        $condition = ($var1 > $var2 && $con == ">") ? true : $condition;
        $condition = ($var1 >= $var2 && $con == ">=") ? true : $condition;
        if ($condition) {
            static::addToBundle($message, static::$stop);
            static::sendDataAndClear();
        }
    }

    /**
     * @param array $message
     * @param null $type
     */
    public static function addToBundle($message, $type = null)
    {
        $modelName = static::getModelName();
        if ($modelName == 'missingtranslation' || $modelName == 'userlog') {
            return;
        }
        if (empty($type)) {
            $type = 'informations';
        }
        if (static::isAPIMode() && $type !=static::$structures) {
            $bundle = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            if (!isset($bundle[$type]) || !is_array($bundle[$type])) {
                $bundle[$type] = array();
            }

            $bundle[$type][] = $message;
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = $bundle;
        }elseif(static::isAPIMode() && $type == static::$structures){
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
    public static function sendTo($data, $internal = false) 
    {
        if (static::isAPIMode() && (static::getAction() != 'initialAPI' || $internal)) {
            if (ob_get_contents()) {
                ob_end_clean();
            }
            $result = json_encode($data);
            exit($result);
        }
    }

    public static function sendDataAndClear() 
    {
        if (static::isAPIMode()) {
            $return = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            unset($_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE]);
            static::sendTo($return, true);
        }
    }

    /**
     * @return bool
     */
    public static function isAPIMode() 
    {
        return (isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE]) && $_SESSION[REST_API][CONFIG_API][REST_API_MODE]);
    }

    /**
     * @return bool
     */
    public static function isStructMode() 
    {
        return (isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE]) && $_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE]);
    }

    /**
     * @return mixed
     */
    public static function getModelName() 
    {
        if (static::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][MODEL_NAME];
        }
    }

    /**
     * @return mixed
     */
    public static function clearData() 
    {
        if (static::isAPIMode()) {
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = array();
        }
    }

    /**
     * @return mixed
     */
    public static function getAction() 
    {
        if (static::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][REST_API_ACTION];
        }
    }

    /**
     * @return mixed
     */
    public static function getNumber() 
    {
        if (static::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][NUMBER];
        }
    }

    /**
     * @return mixed
     */
    public static function getController()
    {
        if (static::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][CONTROLLER_NAME];
        }
    }

    /**
     * @param $message
     */
    public static function addToQueue($message) 
    {
        global $APIGlobalVariable;
        $APIGlobalVariable++;

        if (static::isAPIMode()) {
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE][QUEUE][] = $APIGlobalVariable . ': ' . json_encode($message);
        }
    }

    /**
     * @return null
     */
    public static function getApiKey() 
    {
        if (static::isAPIMode()) {
            return static::$apiKey;
        }
        return null;
    }

    public static function checkExtradata($data)
    {
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
    public static function checkData(&$controller) 
    {
        if (!self::isAPIMode()){
            if (is_string($controller->request->data)) {
                $data = json_decode($controller->request->data, true);
            } elseif (is_array($controller->request->data)) {
                $data = $controller->request->data;
            } else {
                return false;
            }

            $data = static::checkExtradata($data);

            if (!(isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api'])) {
                if (isset($_SESSION[REST_API])){
                    unset($_SESSION[REST_API]);
                }
            }
            if (!empty($data)) {
                if ($data && isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api']) {
                    $controller->request->data = $data;
                    Configure::write('debug', 0);
                    static::$apiKey = $data['data_put_options']['atimApiKey'];
                    $_SESSION[REST_API][CONFIG_API][MODEL_NAME] = $data['data_put_options']['model'];
                    $_SESSION[REST_API][CONFIG_API][CONTROLLER_NAME] = $data['data_put_options']['controller'];
                    $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = true;
                    $_SESSION[REST_API][CONFIG_API][REST_API_ACTION] = $data['data_put_options']['action'];
                    $_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE] = isset($data['data_put_options']['mode']) && $data['data_put_options']['mode'] == 'structure';
                    $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = array();
                    unset($controller->request->data['data_put_options']);
                }
            }
            $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE]) ? $_SESSION[REST_API][CONFIG_API][REST_API_MODE] : false;
            $_SESSION[REST_API][CONFIG_API][NUMBER] = 1;
        }else{
            $_SESSION[REST_API][CONFIG_API][NUMBER]++;
        }
    }

    /**
     * @param $data
     */
    public static function sendDataToAPI($data)
    {
        if (static::isAPIMode()) {
            $actionsList = array('view', 'profile', 'detail', 'listall', 'search', 'index', 'autocompletedrug', 'browse', 'searchById');
            if (!API::isStructMode() && isset($data) && is_array($data) && !empty($data) && in_array(static::getAction(), $actionsList)) {
                if (!static::showConfidential()) {
                    $Sfs = static::$structure['Sfs'];
                    foreach ($Sfs as $value) {
                        if ($value['flag_confidential']) {
                            for ($i = 0; $i < count($data); $i++) {
                                unset($data[$i][ucfirst(static::getModelName())][$value['field']]);
                            }
                        }
                    }
                }
//                static::addToBundle(array('Model, Action' => static::getModelName() . ', ' . static::getAction(), $data), 'data');
                static::addToBundle($data, static::$data);
            }
            static::sendDataAndClear();
        }
    }

    /**
     * @param $user
     * @return mixed
     */
    public static function setUser(&$user) 
    {
        unset($user['UserApiKey']);
        unset($user['User']['password']);
        static::$user = $user;
        return $user;
    }

    public static function getUser() 
    {
        return static::$user;
    }

    /**
     * @param $structure
     */
    public static function setStructure($structure) 
    {
        static::$structure = $structure;
        if (!static::allowModifyConfidentialData()) {
            AppController::getInstance()->atimFlashError(__('you are not authorized to reach that page because you cannot input data into confidential fields'), '/Menus');
        }
    }

    /**
     * @return bool
     */
    private static function allowModifyConfidentialData() 
    {
        $allow = true;
        if (!static::showConfidential()) {
            $Sfs = static::$structure['Sfs'];
            foreach ($Sfs as $value) {
                if ($value['flag_confidential'] && (strpos(static::getAction(), 'edit') !== false || strpos(static::getAction(), 'add') !== false)) {
                    $allow = false;
                }
            }
        }
        return $allow;
    }

    /**
     * @return mixed
     */
    public static function showConfidential() 
    {
        return static::getUser()['Group']['flag_show_confidential'];
    }

    /**
     * @param $response
     * @param $item
     * @param $suffixes
     * @param $options
     */
    private static function setField(&$response, $item, $suffixes, $options) 
    {
        $optionType = $options['type'];
        $type = $item['type'];
        $field = null;
        if ($suffixes == null) {
            $response['fields'][$item['field']]['field'] = $item['field'];
            $response['fields'][$item['field']]['name'] = $item['model'] . '[' . $item['field'] . ']';
            if (in_array($optionType, array("addgrid", "editgrid"))) {
                $response['example'][0][$item['model']][$item['field']] = null;
                $response['example'][1][$item['model']][$item['field']] = null;
            } elseif (empty($item['readonly'])){
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
                } elseif (empty($item['readonly'])){
                    $response['example'][$item['model']][$field] = null;
                }
                if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                    $response['fields'][$field]['defined'] = $item['settings']['options']['defined'];
                }
                $response['fields'][$field]['type'] = $item['type'];
                $response['fields'][$field]['readonly'] = $item['readonly'];
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
            } elseif (empty($item['readonly'])){
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
     * @param $options
     * @internal param string $type
     */
    private static function setDate(&$response, $item, $suffixes, $options) 
    {
        $optionType = $options['type'];
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
            } elseif (empty($item['readonly'])){
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
                    } elseif (empty($item['readonly'])){
                        $response['example'][$item['model']][$field] = array('year' => null, 'month' => null, 'day' => null);
                    }
                }
                if (isset($item['settings']['options']['defined']) && is_array($item['settings']['options']['defined']) && !empty($item['settings']['options']['defined'])) {
                    $response['fields'][$field]['defined'] = $item['settings']['options']['defined'];
                }
                $response['fields'][$field]['type'] = $item['type'];
                $response['fields'][$field]['readonly'] = $item['readonly'];
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
     * @param $options
     * @return array
     */
    private static function createStructure($tableIndex, $structures, $options, $data) 
    {
        if (empty($tableIndex) && $options['type'] != 'index') {
            return null;
        }

        $response = array('fields' => array(), 'example' => array());
        if ($options['type'] == 'index'){
            foreach ($data as $dataVal) {
                foreach($dataVal as $modelName => $modelArray) {
                    $radioLists = "";
                    if (isset($options['links']['tree'][$modelName]['radiolist'])) {
                        $radioLists = $options['links']['tree'][$modelName]['radiolist'];
                    }elseif (isset($options['links']['radiolist'])) {
                        $radioLists = $options['links']['radiolist'];
                    }
                    if (!empty($radioLists)){
                        static::createTreeRadioButtonStructure($response, $data, $modelName, $radioLists, 'radiolist');
                    }
                }
            }
        }else{
            foreach ($tableIndex as $columns) {
                foreach ($columns as $column) {
                    foreach ($column as $item) {
                        if (!$item['flag_confidential'] || static::$user['Group']['flag_show_confidential']) {
                            $suffixes = null;
                            if (API::getAction() == "browse" && API::isStructMode()) {
                                $suffixes = in_array($item['type'], StructuresComponent::$rangeTypes) ? array("_start", "_end", "") : "[]";
                            }
                            if (in_array($item['type'], array('date', 'datetime'))) {
                                static::setDate($response, $item, $suffixes, $options);
                            } elseif (in_array($item['type'], array("select", "radio", "checkbox", "yes_no", "y_n_u", "autocomplete", "textarea", "input", "integer", "integer_positive", "float", "float_positive"))) {
                                static::setField($response, $item, $suffixes, $options);
                                if ($suffixes && strpos($item['setting'], 'range') && $item['type'] == 'input') {
                                    $suffixes = array("_start", "_end");
                                    static::setField($response, $item, $suffixes, $options);
                                }
                            } else {
                                continue;
                            }
                        }
                    }
                }
            }
        }
        
        $response['phpArray'] = "[" . convertJSONtoArray($response['example']) . "]";
        $response['jsArray'] = (isAssoc($response['example'])) ? "{" . json_encode_js($response['example']) . "}" : associateToIndexArray($response['example']);
        return $response;
    }

    private static function createTreeRadioButtonStructure(&$response, $data, $modelName, $radioLists, $treeType)
    {
        if ($treeType == 'radiolist') {
                foreach ($radioLists as $radiobuttonName => $radiobuttonValue) {
                    list ($tmpModel, $tmpField) = explode(".", $radiobuttonName);
                    $field = str_replace("%", "", $radiobuttonValue);
                    $field = (strpos($field, ".") !== false) ? substr($field, strpos($field, ".") + 1) : null;
                    break;
                }
        }
        $values = static::getAllPossibleValue($data, $modelName, $field);
        $response['fields'][$tmpField]=array(
            'field' => $tmpField,
            'name' => $tmpModel."[".$tmpField."]",
            'type' =>'radiobutton',
            'note' =>"(IMPORTANT) ".$tmpModel."[".$tmpField."] is a dynamic field related to your model, to have more information about it, should use the related functions in your API model.",
            'defined' => $values
        );
//        $response['example'][$tmpModel][$tmpField] = count($values)>0?array_keys($values)[1]:0;
        $response['example'][$tmpModel][$tmpField] = null;
    }
    
    private static function getAllPossibleValue($data, $modelName, $field=null)
    {
        $ids = array("0" => "N/A");
        if (isset($data[0])){
            for ($i=0; $i<count($data); $i++){
                $ids += static::getAllPossibleValue($data[$i], $modelName, $field);
            }
        }else
            if (!empty($field) && isset($data[$modelName][$field])) {
            $ids += array($data[$modelName][$field] => $modelName . ".$field: " . $data[$modelName][$field]);
            if (!empty($data['children'])) {
                $ids += static::getAllPossibleValue($data['children'], $modelName, $field);
            }
        }
        return $ids;
    }

    /**
     * @param $tableIndex
     * @param $structure
     * @param $options
     * @return array|null
     */
    public static function getStructure($tableIndex, $structure, $options, $data = array())
    {
        if (API::isStructMode()) {
            $result = static::createStructure($tableIndex, $structure, $options, $data);
            return $result;
        } else {
            return null;
        }
    }

}
