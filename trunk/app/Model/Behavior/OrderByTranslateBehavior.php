<?php

App::uses('ModelBehavior', 'Model');
App::uses('I18n', 'I18n');
App::uses('I18nModel', 'Model');


class OrderByTranslateBehavior extends ModelBehavior {
    
    private $modelsFieldsAssoc = array();
    
    public function setup(Model $model, $config = array()) {
        $current = array();
        foreach($config as $value){
            $s = explode(".", $value);
            if(count($s) == 1){
                $current[] = $model->name.".".$value;
            }else if(count($s) == 2){
                assert($s[0] == $model->name) or die("Left side should be model name in ".$value);
                $current[] = $value;
            }else{
                die("Invalid field ".$value);
            }
        }
        $this->modelsFieldsAssoc[$model->name] = $current;
    }
    
    
    public function beforeFind(Model $model, $query) {
        $index = 0;
        $this->log($query['order']);
        $c = count($query['order']);
        if($c == 0){
            //do nothing
            return $query;
        }
        assert($c == 1) or die("Only supports a single order by");
        $value = $query['order'][0];
        foreach($value as $key => $direction){
            if(in_array($key, $this->modelsFieldsAssoc[$model->name])){
                $query['joins'][] = array(
                    'table' => 'i18n',
                    'alias' => 'i18n',
                    'type' => 'LEFT',
                    'conditions' => array(
                	   sprintf('%s=i18n.id', $key)
                    )
                );
                $lang = substr(CakeSession::read('Config.language'), 0, 2);
                $query['order'][0] = array(
                	'i18n.'.$lang => $direction
                );
            }
        }
        return $query;
    }
}