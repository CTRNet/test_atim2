<?php

class CodingIcd9 extends CodingIcdAppModel
{

    protected static $singleton = null;

    var $name = 'CodingIcd9';

    var $useTable = 'coding_icd9_v2';

    var $validate = array();

    public function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    public static function validateId($id)
    {
        return self::$singleton->globalValidateId($id);
    }

    public static function getSingleton()
    {
        return self::$singleton;
    }
}