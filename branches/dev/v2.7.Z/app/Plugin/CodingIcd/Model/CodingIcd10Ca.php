<?php

/**
 * Class CodingIcd10Ca
 */
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

    /**
     * CodingIcd10Ca constructor.
     */
    public function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    /**
     *
     * @param $id
     * @return bool
     */
    public static function validateId($id)
    {
        return self::$singleton->globalValidateId($id);
    }

    /**
     *
     * @return CodingIcd10Ca|null
     */
    public static function getSingleton()
    {
        return self::$singleton;
    }

    /**
     *
     * @param array $terms
     * @param $exactSearch
     * @param $searchOnId
     * @param $limit
     * @return array|bool|null|The
     */
    public function globalSearch(array $terms, $exactSearch, $searchOnId, $limit)
    {
        if (isset($terms[0])) {
            $terms[0] = preg_replace('/([cC][0-9]{2})\.([0-9])/', '$1$2', $terms[0]);
        }
        return parent::globalSearch($terms, $exactSearch, $searchOnId, $limit);
    }
}