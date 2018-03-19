<?php

class CollectionCustom extends Collection
{

    var $useTable = 'collections';

    var $name = 'Collection';

    public function validates($options = array())
    {
        $validateRes = parent::validates($options);
        
        if (array_key_exists('collection_property', $this->data['Collection'])) {
            if ($this->data['Collection']['collection_property'] == 'independent collection') {
                if ((array_key_exists('qc_tf_collection_type', $this->data['Collection']) && $this->data['Collection']['qc_tf_collection_type']) || (array_key_exists('collection_site', $this->data['Collection']) && $this->data['Collection']['collection_site']) || (array_key_exists('collection_datetime', $this->data['Collection']) && $this->data['Collection']['collection_datetime'])) {
                    $this->validationErrors[][] = __('independent collection') . ' : ' . __('no field has to be completed');
                    $validateRes = false;
                }
            }
        }
        return $validateRes;
    }
}