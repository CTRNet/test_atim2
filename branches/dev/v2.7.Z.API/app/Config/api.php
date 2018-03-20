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

$APIGlobalVariable=0;

/**
 * Class API
 */
class API
{
    private static $counter=0;
    private static $user;
    private static $structure;
    public static $errors = 'errors';
    public static $confirms = 'confirms';
    public static $warnings = 'warnings';
    public static $informations = 'informations';
    public static $data = 'data';
    public static $redirect = 'redirect';
    private static $stop = 'stop';


    /**
     * @param int $counter after $counter time that this function run, it send $message to API
     * @param array $message the message that will be send to API after $counter time of execution of this function
     */
    public static function stop($counter=1, $message=array('message')) 
    {
        self::stopCondition(self::$counter, '==', $counter, $message);
        self::$counter++;
    }
    
    /**
     * @param int $counter after $counter time that this function run, it send $message to API
     * @param array $message the message that will be send to API after $counter time of execution of this function
     */
    public static function stopCondition($var1, $con, $var2, $message=array()) 
    {
        $condition = false;
        $condition = ($var1==$var2 && $con=="==")?true:$condition;
        $condition = ($var1!=$var2 && $con=="!=")?true:$condition;
        $condition = ($var1<$var2 && $con=="<")?true:$condition;
        $condition = ($var1<=$var2 && $con=="<=")?true:$condition;
        $condition = ($var1>$var2 && $con==">")?true:$condition;
        $condition = ($var1>=$var2 && $con==">=")?true:$condition;
        if ($condition){
            self::addToBundle($message, self::$stop);
            self::sendDataAndClear();
        }
    }
    
    /**
     * @param array $message
     * @param null $type
     */
    public static function addToBundle($message, $type = null) 
    {
        if (self::isAPIMode()) {
            if (empty($type)){
                $type='informations';
            }
            $modelName = self::getModelName();
            if ($modelName == 'missingtranslation' || $modelName == 'userlog') {
                return;
            }
            $newMessage = true;
            if (empty($message)){
                return;
            }
            $bundle = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            if (!isset($bundle[$type]) || !is_array($bundle[$type])) {
                $bundle[$type] =array();
            }
            
            $bundle[$type][]=$message;
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = $bundle;
        }
    }

    /**
     * @param $data
     */
    public static function sendTo($data, $internal = false)
    {        
        if (self::isAPIMode() && (self::getAction()!='getApiCmalp' && self::getAction()!='getBrowserSearchlist' || $internal)) {
            if (ob_get_contents()){
                ob_end_clean();
            }
            $result = json_encode($data);
            exit($result);
        }
    }

    public static function sendDataAndClear()
    {
        if (self::isAPIMode()) {
            $return = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            unset($_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE]);
            self::sendTo($return, true);
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
        if (self::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][MODEL_NAME];
        }
    }

    /**
     * @return mixed
     */
    public static function getAction()
    {
        if (self::isAPIMode()) {
            return $_SESSION[REST_API][CONFIG_API][REST_API_ACTION];
        }
    }

    /**
     * @param $message
     */
    public static function addToQueue($message)
    {
        global $APIGlobalVariable;
        $APIGlobalVariable++;

        if (self::isAPIMode()) {
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE][QUEUE][] = $APIGlobalVariable . ': ' . $message;
        }
    }

    /**
     * @return null
     */
    public static function getApiKey()
    {
        if (self::isAPIMode()){
            return $_SESSION[REST_API][CONFIG_API][ATIM_API_KEY];
        }
        return null;
    }

    /**
     * @param $controller
     * @internal param array $data
     * @internal param string $model
     */
    public static function checkData(&$controller)
    {
        if (is_string($controller->request->data)){
            $data = json_decode($controller->request->data, true);
        }elseif (is_array($controller->request->data)){
            $data = $controller->request->data;
        }else{
            return false;
        }       
        if (isset($data['modelName'])){
            $model = $data['modelName'];
            unset($controller->request->data['modelName']);
        }else{
            $model = $controller->modelClass;
        }
        
        if (!(isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api'])){
            unset($_SESSION[REST_API]);
        }
        if (!empty($data)) {
            if ($data && isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api']) {
                $controller->request->data = $data;
                Configure::write('debug', 0);
                $_SESSION[REST_API][CONFIG_API][ATIM_API_KEY]=$data['data_put_options']['atimApiKey'];
                $_SESSION[REST_API][CONFIG_API][MODEL_NAME] = strtolower($model);
                $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = true;
                $_SESSION[REST_API][CONFIG_API][REST_API_ACTION] = $data['data_put_options']['action'];
                $_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE] = isset($data['data_put_options']['mode']) && $data['data_put_options']['mode'] == 'structure';
                $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = array();
                unset($controller->request->data['data_put_options']);
            } 
        }
        $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = isset($_SESSION[REST_API][CONFIG_API][REST_API_MODE]) ? $_SESSION[REST_API][CONFIG_API][REST_API_MODE] : false;
    }
       
    /**
     * @param $data
     */
    public static function sendDataToAPI($data) 
    {
        if (self::isAPIMode()) {
            $actionsList = array('view', 'profile', 'detail', 'listall', 'search', 'index', 'autocompletedrug', 'browse');
            if (!API::isStructMode() && isset($data) && is_array($data) && !empty($data) && in_array(self::getAction(), $actionsList)) {
                if(!self::showConfidential()){
                    $Sfs = self::$structure['Sfs'];
                    foreach ($Sfs as $value) {
                        if ($value['flag_confidential']){
                            for ($i=0; $i<count($data); $i++){
                                unset($data[$i][ucfirst(self::getModelName())][$value['field']]);
                            }
                        }
                    }
                }
                self::addToBundle(array('Model, Action' => self::getModelName() . ', ' . self::getAction(), $data), 'data');
            }
            self::sendDataAndClear();
        }
    }

    /**
     * @param $user
     * @return mixed
     */
    public static function setUser(&$user)
    {
        unset($user['UserApiKey']);
        self::$user = $user;
        return $user;
    }
    
    public static function getUser()
    {
        return self::$user;
    }

    /**
     * @param $structure
     */
    public static function setStructure($structure)
    {
        self::$structure = $structure;
        if (!self::allowModifyConfidentialData()){
            AppController::getInstance()->atimFlashError(__('you are not authorized to reach that page because you cannot input data into confidential fields'), '/Menus');
        }
    }

    /**
     * @return bool
     */
    private static function allowModifyConfidentialData()
    {
        $allow = true;
        if (!self::showConfidential()){
            $Sfs = self::$structure['Sfs'];
            foreach ($Sfs as $value) {
                if ($value['flag_confidential'] && (strpos(self::getAction(), 'edit')!==false || strpos(self::getAction(), 'add')!==false)){
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
        return self::getUser()['Group']['flag_show_confidential'];
    }
}