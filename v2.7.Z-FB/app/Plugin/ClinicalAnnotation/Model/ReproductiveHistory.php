<?php

/**
 * Class ReproductiveHistory
 */
class ReproductiveHistory extends ClinicalAnnotationAppModel
{

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        // if ( isset($variables['ReproductiveHistory.id']) ) {
        //
        // $result = $this->find('first', array('conditions'=>array('ReproductiveHistory.id'=>$variables['ReproductiveHistory.id'])));
        //
        // $return = array(
        // 'data' => $result,
        // 'structure alias'=>'reproductivehistories'
        // );
        // }
        
        return $return;
    }
}