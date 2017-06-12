<?php

class CodingIcd10Ca extends CodingIcdAppModel
{

    // ---------------------------------------------------------------------------------------------------------------
    // Coding System: ICD-10-CA
    // From: CIHI publications department (ICD10CA_Code_Eng_Desc2010_V2_0 & ICD10CA_Code_Fra_Desc2010_V2_0)
    // Notes: The title and sub-title columns are not officially published as part of the code standard
    // ---------------------------------------------------------------------------------------------------------------
    protected static $singleton = null;

    public $name = 'CodingIcd10Ca';

    public $useTable = 'coding_icd10_ca';

    public $icdDescriptionTableFields = array(
        'search_format' => array(
            'title',
            'sub_title',
            'description'
        ),
        'detail_format' => array(
            'description'
        )
    );

    public $validate = array();

    public function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    static public function validateId($id)
    {
        return self::$singleton->globalValidateId($id);
    }

    static public function getSingleton()
    {
        return self::$singleton;
    }
}
