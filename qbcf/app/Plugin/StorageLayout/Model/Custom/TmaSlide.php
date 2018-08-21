<?php

class TmaSlideCustom extends TmaSlide
{

    var $useTable = 'tma_slides';

    var $name = 'TmaSlide';

    private $sectionIdsCheck = array();
    // used for validations
    public function validates($options = array())
    {
        // Check tma slide section id (id unique per block)
        if (isset($this->data['TmaSlide']['qbcf_section_id'])) {
            $qbcfSectionId = $this->data['TmaSlide']['qbcf_section_id'];
            $tmaBlockStorageMasterId = null;
            if (isset($this->data['TmaSlide']['tma_block_storage_master_id'])) {
                $tmaBlockStorageMasterId = $this->data['TmaSlide']['tma_block_storage_master_id'];
            } elseif (isset($this->data['TmaSlide']['id'])) {
                $tmpSlide = $this->find('first', array(
                    'conditions' => array(
                        'TmaSlide.id' => $this->data['TmaSlide']['id']
                    ),
                    'fields' => array(
                        'TmaSlide.tma_block_storage_master_id'
                    ),
                    'recursive' => - 1
                ));
                if ($tmpSlide) {
                    $tmaBlockStorageMasterId = $tmpSlide['TmaSlide']['tma_block_storage_master_id'];
                }
            }
            if (! $tmaBlockStorageMasterId)
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                
                // Check duplicated id for the same block into submited record
            if (! strlen($qbcfSectionId)) {
                // Not studied
            } elseif (isset($this->sectionIdsCheck[$tmaBlockStorageMasterId . '-' . $qbcfSectionId])) {
                $this->validationErrors['qbcf_section_id'][] = str_replace('%s', $qbcfSectionId, __('you can not record section id [%s] twice'));
            } else {
                $this->sectionIdsCheck[$tmaBlockStorageMasterId . '-' . $qbcfSectionId] = '';
            }
            
            // Check duplicated id for the same block into db
            $criteria = array(
                'TmaSlide.tma_block_storage_master_id' => $tmaBlockStorageMasterId,
                'TmaSlide.qbcf_section_id' => $qbcfSectionId
            );
            $slidesHavingDuplicatedId = $this->find('all', array(
                'conditions' => $criteria,
                'recursive' => - 1
            ));
            ;
            if (! empty($slidesHavingDuplicatedId)) {
                foreach ($slidesHavingDuplicatedId as $duplicate) {
                    if ((! array_key_exists('id', $this->data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $this->data['TmaSlide']['id'])) {
                        $this->validationErrors['qbcf_section_id'][] = str_replace('%s', $qbcfSectionId, __('the section id [%s] has already been recorded'));
                    }
                }
            }
        }
        
        return parent::validates($options);
    }
}