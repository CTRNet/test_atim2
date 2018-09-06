<?php

class AliquotReviewMasterCustom extends AliquotReviewMaster
{

    var $useTable = 'aliquot_review_masters';

    var $name = 'AliquotReviewMaster';

    public function beforeSave($options = array())
    {
        if (array_key_exists('AliquotReviewDetail', $this->data) && array_key_exists('gleason_grade', $this->data['AliquotReviewDetail'])) {
            if (preg_match('/^([0-9]+)\+([0-9]+)$/', $this->data['AliquotReviewDetail']['gleason_grade'], $matches)) {
                $this->data['AliquotReviewDetail']['gleason_sum'] = $matches[1] + $matches[2];
            } else {
                $this->data['AliquotReviewDetail']['gleason_sum'] = '';
            }
            $this->addWritableField(array(
                'gleason_sum'
            ));
        }
        parent::beforeSave($options);
    }
}