<?php

class CollectionCustom extends Collection
{

    var $name = "Collection";

    var $useTable = "collections";
        
    // TODO: Kidney transplant customisation
    // Change Collection Time & Participant Type to upper
    
    /**
     * @param array $options
     * @return bool
     */
    public function beforeSave($options = array())
    {
        $retVal = parent::beforeSave($options);
        if (isset($this->data['Collection']['chum_kidney_transp_collection_part_type'])) {
            $this->data['Collection']['chum_kidney_transp_collection_part_type'] = strtoupper($this->data['Collection']['chum_kidney_transp_collection_part_type']);
        }
        if (isset($this->data['Collection']['chum_kidney_transp_collection_time'])) {
            $this->data['Collection']['chum_kidney_transp_collection_time'] = strtoupper($this->data['Collection']['chum_kidney_transp_collection_time']);
        }
        return $retVal;
    }
}