<?php

/**
 * Class AtimDebug
 */
class AtimDebug{
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
            d($message);
            die("stop");
        }else{
            self::$counter++;
        }
    }
}

/**
 * @param $message1
 * @param string $message2
 */
function debug_die($message1, $message2="")
{
    debug($message1);
    if (is_array($message2)){
        $message2= json_encode($message2);
    }
    die($message2);
}

//override_function('__', '$singular, $args', 'return newTranslate($singular, $args);');
/**
 * @param $singular
 * @param null $args
 * @return mixed|string
 */
function newTranslate($singular, $args = null){
    if(is_numeric($singular)){
        return '123456789';
    }
    return __($singular, $args); 
}


/**
 * @param array|int $arr
 * @return bool
 */
function isAssoc(array $arr)
{
    if (array() === $arr){
        return false;
    }
    return array_keys($arr) !== range(0, count($arr) - 1);
}

/**
 * @param $data
 * @param int $level
 * @param int $formattage
 * @return string
 */
function convertJSONtoArray($data, $level=3, $formattage=0)
{
    $s="";
    if ($formattage==0){
        $newLine="";
        $tab="";
    }else{
        $newLine="\n";
        $tab="\t";
    }
    if (isAssoc($data)){
        foreach ($data as $key1 => $value1) {
            if (is_array($value1)) {
                $s.= str_repeat($tab, $level) . "'" . $key1 . "' => [" . $newLine;
                $s.=convertJSONtoArray($value1, $level + 1);
                $s.= str_repeat($tab, $level) . "]," . $newLine;
            } else {
                if (( $value1 == 'true' ) || ( $value1 == 'false' ) || ( is_numeric($value1) )) {
                    $s.= str_repeat($tab, $level) . "'" . $key1 . "' => '" . $value1 . "'," . $newLine;
                } else {
                    $s.= str_repeat($tab, $level) . "'" . $key1 . "' => '" . $value1 . "'," . $newLine;
                }
            }
        }
        $s=rtrim($s,",");
    }else{
        foreach ($data as $key1 => $value1) {
            if (is_array($value1)) {
                $s.= str_repeat($tab, $level) . "[" . $newLine;
                $s.=convertJSONtoArray($value1, $level + 1);
                $s.= str_repeat($tab, $level) . "]," . $newLine;
            } else {
                if (( $value1 == 'true' ) || ( $value1 == 'false' ) || ( is_numeric($value1) )) {
                    $s.= str_repeat($tab, $level) . "'" . $value1 . "'," . $newLine;
                } else {
                    $s.= str_repeat($tab, $level) . "'" . $value1 . "'," . $newLine;
                }
            }
        }
        $s=rtrim($s,",");
    }
    return $s;
}

/**
 * @param $data
 * @param int $level
 * @param int $formattage
 * @return string
 */
function json_encode_js($data, $level=3, $formattage=0)
{
    $s="";
    if ($formattage==0){
        $newLine="";
        $tab="";
    }else{
        $newLine="\n";
        $tab="\t";
    }
    if (isAssoc($data)){
        foreach ($data as $key1 => $value1) {
            if (is_array($value1)) {
                $s.= str_repeat($tab, $level) . "'" . $key1 . "': [" . $newLine;
                $s.=json_encode_js($value1, $level + 1);
                $s.= str_repeat($tab, $level) . "]," . $newLine;
            } else {
                if (( $value1 == 'true' ) || ( $value1 == 'false' ) || ( is_numeric($value1) )) {
                    $s.= str_repeat($tab, $level) . "'" . $key1 . "' : '" . $value1 . "'," . $newLine;
                } else {
                    $s.= str_repeat($tab, $level) . "'" . $key1 . "' : '" . $value1 . "'," . $newLine;
                }
            }
        }
        $s=rtrim($s,",");
    }else{
        foreach ($data as $value1) {
            if (is_array($value1)) {
                $s.= str_repeat($tab, $level) . "[" . $newLine;
                $s.=json_encode_js($value1, $level + 1);
                $s.= str_repeat($tab, $level) . "]," . $newLine;
            } else {
                
                if (( $value1 == 'true' ) || ( $value1 == 'false' ) || ( is_numeric($value1) )) {
                    $s.= str_repeat($tab, $level) . "'" . $value1 . "'," . $newLine;
                } else {
                    $s.= str_repeat($tab, $level) . "'" . $value1 . "'," . $newLine;
                }
            }
        }
        $s=rtrim($s,",");
    }
    return $s;
}

/**
 * @param $str
 * @return mixed
 */
function stringCorrection($str)
{
    if (empty($str)){
        return $str;
    }elseif(is_string($str)){
        return str_replace("~~~~", "\\", str_replace("\\\\", "~~~~", $str));
    }elseif (is_array($str)){
        foreach ($str as &$value) {
            $value= stringCorrection($value);
        }
        return $str;
    }else{
        return $str;
    }
}

/**
 * @param mixed $var The variable that will be printed.
 * @param bool $screen If write on Screen.
 * @param bool $log If write in log
 * @param bool $die If die after write
 * @return void
 */
function d($var, $screen=true, $log=true, $die=false) 
{
    if (!Configure::read('debug')) {
        return;
    }
    App::uses('Debugger', 'Utility');

    $trace = Debugger::trace(array('start' => 1, 'depth' => 2, 'format' => 'array'));
    $file = str_replace(array(CAKE_CORE_INCLUDE_PATH, ROOT), '', $trace[0]['file']);
    $line = $trace[0]['line'];
    $html = <<<HTML
<div class="cake-debug-output">
<div class="minus-button"><a href="javascript:void(0)" class="debug-button">-</a></div>
%s
<pre class="cake-debug">
%s
</pre>
</div>
HTML;
    $text = <<<TEXT
%s
########## DEBUG ##########
%s
###########################

TEXT;
    $template = $html;
    if (PHP_SAPI === 'cli') {
        $template = $text;
        $lineInfo = sprintf('%s (line %s)', $file, $line);
    }
    $var = print_r($var, true);
    $var = h($var);
    $lineInfo = sprintf('<span><strong>%s</strong> (line <strong>%s</strong>)</span>', $file, $line);
    if ($screen){
        printf($template, $lineInfo, $var);
    }
    if ($log){
        $l=empty($_SESSION['debug']['dl'])?0:count($_SESSION['debug']['dl']);
        $_SESSION['debug']['dl'][$l][0]=$template;
        $_SESSION['debug']['dl'][$l][1]=$lineInfo;
        $_SESSION['debug']['dl'][$l][2]=$var;
    }
    if ($die){
        die();
    }
}

/**
 * @param int $number
 */
function dc($number=0)
{
    if (!Configure::read('debug')) {
        return;
    }
    if ($number==0){
        unset($_SESSION['debug']);
    }else{
        array_splice($_SESSION['debug']['dl'], 0, $number);
    }
}