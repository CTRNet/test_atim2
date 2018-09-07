<?php

/**
 * Class SystemVar
 */
class SystemVar extends Model
{

    public $primaryKey = 'k';

    private static $cache = array();

    /**
     *
     * @param $key
     * @return array|mixed|null
     */
    public function getVar($key)
    {
        if (isset(self::$cache[$key])) {
            return self::$cache[$key];
        }
        
        $val = $this->find('first', array(
            'conditions' => array(
                'k' => $key
            )
        ));
        if ($val) {
            $val = $val['SystemVar']['v'];
            self::$cache[$key] = $val;
        }
        return $val;
    }

    /**
     *
     * @param $key
     * @param $val
     */
    public function setVar($key, $val)
    {
        $this->save(array(
            'k' => $key,
            'v' => $val
        ));
        self::$cache[$key] = $val;
    }
}