<?php

class CodingIcdo3Morpho extends CodingIcdAppModel
{
    
    // ---------------------------------------------------------------------------------------------------------------
    // Coding System: ICD-O-3 (Morphology)
    // From: CIHI publications department (ICD10CA_Code_Eng_Desc2010_V2_0 & ICD10CA_Code_Fra_Desc2010_V2_0)
    // ---------------------------------------------------------------------------------------------------------------
    protected static $singleton = null;

    var $name = 'CodingIcdo3Morpho';

    var $useTable = 'coding_icd_o_3_morphology';

    var $icd_description_table_fields = array(
        'search_format' => array(
            'description'
        ),
        'detail_format' => array(
            'description'
        )
    );

    var $validate = array();

    function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    static function validateId($id)
    {
        $tmp_id = null;
        if (is_array($id)) {
            $tmp_id = array_values($id);
            $tmp_id = $tmp_id[0];
        } else {
            $tmp_id = $id;
        }
        // we need to check if this is an id here because sql will return true on '80000'='80000a'
        return (is_numeric($tmp_id) || strlen($tmp_id) == 0) ? self::$singleton->globalValidateId($id) : false;
    }

    static function getSingleton()
    {
        return self::$singleton;
    }
}

