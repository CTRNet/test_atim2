<?php


    if(array_key_exists('death_datetime', $this->request->data['ConsentDetail']) && array_key_exists('autopsy_datetime', $this->request->data['ConsentDetail'])) {

        if(!empty($this->request->data['ConsentDetail']['death_datetime']['year']) && !empty($this->request->data['ConsentDetail']['autopsy_datetime']['year'])) {


            $deathAutopsyInterval = $this->ConsentMaster->calculateDateInterval($this->request->data, $this->ConsentMaster->id);


        }

    }
    
