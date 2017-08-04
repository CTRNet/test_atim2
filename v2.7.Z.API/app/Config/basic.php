<?php

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
 * @param int $arr
 * @return boolean
 */
function isAssoc(array $arr)
{
    if (array() === $arr) return false;
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
