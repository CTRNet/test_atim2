<?php

class CodingIcdo3Topo extends CodingIcdAppModel
{
    
    // ---------------------------------------------------------------------------------------------------------------
    // Coding System: ICD-O-3
    // From: Stats Canada through the Manitoba Cancer Registry (CCR_Reference_Tables_2009_FinalDraft_21122009)
    // Notes: An effort is underway to verify the file authenticity.
    // ---------------------------------------------------------------------------------------------------------------
    protected static $singleton = null;

    public $name = 'CodingIcdo3Topo';

    public $useTable = 'coding_icd_o_3_topography';

    public $icd_description_table_fields = array(
        'search_format' => array(/*'title': All values are equal to 'Malignant neoplasms' */ 'sub_title',
            'description'
        ),
        'detail_format' => array(
            'description'
        )
    );

    public $validate = array();

    function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    static function validateId($id)
    {
        return self::$singleton->globalValidateId($id);
    }

    static function getSingleton()
    {
        return self::$singleton;
    }

    static function getTopoCategoriesCodes()
    {
        $data = array();
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        foreach (self::$singleton->find('all', array(
            'fields' => array(
                'DISTINCT SUBSTRING(id, 1, 3) AS id, ' . $lang . '_sub_title'
            )
        )) as $new_id) {
            $data[$new_id['0']['id']] = $new_id['0']['id'] . ' - ' . $new_id['CodingIcdo3Topo'][$lang . '_sub_title'];
        }
        return $data;
    }
}
