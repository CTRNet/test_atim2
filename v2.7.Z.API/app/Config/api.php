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
    
    /**
     * @param int $counter after $counter time that this function run, it send $message to API
     * @param array $message the message that will be send to API after $counter time of execution of this function
     */
    public static function stop($counter=1, $message=array('message')) 
    {
        if (!is_array($message)){
            $message=array($message);
        }
        if (self::$counter==$counter){
            self::addToBundle($message, 'Stop');
            self::sendDataAndClear();
        }else{
            self::$counter++;
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
                $message = array('This is an empty array.');
            }
            $bundle = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            if (!isset($bundle[$type]) || !is_array($bundle[$type])) {
                $bundle[$type] =array();
            }
            foreach ($bundle[$type] as $model => &$values) {
                if ($modelName == $model) {
                    $newMessage = false;
                    $bundle[$type][$model][]=$message;
                }
            }
            if ($newMessage) {
                $bundle[$type][$modelName][]=$message;
            }
            $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = $bundle;
        }
    }

    /**
     * @param $data
     */
    public static function sendTo($data)
    {        
        if (self::isAPIMode()) {
            if (ob_get_contents()){
                ob_end_clean();
            }
            $result = json_encode($data);
            die($result);
        }
    }

    public static function sendDataAndClear()
    {
        if (self::isAPIMode()) {
            $return = $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE];
            unset($_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE]);
            self::sendTo($return);
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

    public static function getApiKey(){
        if (self::isAPIMode()){
            return $_SESSION[REST_API][CONFIG_API][ATIM_API_KEY];
        }
        return null;
    }
    
    /**
     * @param array $data 
     * @param string $model
     */
    public static function checkData(&$data =array(), $model = '')
    {
        if (!(isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api'])){
            unset($_SESSION[REST_API]);
        }
        if (!empty($data)) {
            if ($data && isset($data['data_put_options']['from_api']) && $data['data_put_options']['from_api']) {
                Configure::write('debug', 0);
                $_SESSION[REST_API][CONFIG_API][MODEL_NAME] = strtolower($model);
                $_SESSION[REST_API][CONFIG_API][ATIM_API_KEY]=$data['data_put_options']['atimApiKey'];
                $_SESSION[REST_API][CONFIG_API][MODEL_NAME] = strtolower($model);
                $_SESSION[REST_API][CONFIG_API][REST_API_MODE] = true;
                $_SESSION[REST_API][CONFIG_API][REST_API_ACTION] = $data['data_put_options']['action'];
                $_SESSION[REST_API][CONFIG_API][REST_API_MODE_STRUCTURE] = isset($data['data_put_options']['mode']) && $data['data_put_options']['mode'] == 'structure';
                $_SESSION[REST_API][SEND][REST_API_SEND_INFO_BUNDLE] = array();
                unset($data['data_put_options']);
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
                self::addToBundle(array('Model, Action' => self::getModelName() . ', ' . self::getAction(), $data), 'data');
            }
            self::sendDataAndClear();
        }
    }
}