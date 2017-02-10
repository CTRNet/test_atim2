<?php


  $servername = "127.0.0.1:3306";
  $username = "shlfung";
  $password = "eEdZbSwanj4Bjbn4";
  $dbName = "atim_ccbr_dev";

  try {
    $db = new PDO("mysql:host=$servername; dbname=$dbName", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "<br>";
    echo "Connected successfully";
    echo "</br>";
  } catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
  }

  //Return the participant identifier of the participant owning the sample
  function getParticipantIdentifierFromSample($sampleId, $db) {
    $stmt = $db->query("SELECT collections.participant_id FROM sample_masters, collections WHERE sample_masters.collection_id = collections.id AND sample_masters.id=".$sampleId);
    $participantId = $stmt->fetch(PDO::FETCH_ASSOC)['participant_id'];
    
    //now use $participantId to get participant_identifier
    $query = "SELECT participant_identifier FROM participants WHERE id=".$participantId;
    $stmt = $db->query("SELECT participant_identifier FROM participants WHERE id=".$participantId);
    $participantIdentifier = $stmt->fetch(PDO::FETCH_ASSOC)['participant_identifier'];
    
    return $participantIdentifier;
  }
  
  //Return the participant id of the participant owning the sample
  function getParticipantIdFromSample($sampleId, $db) {
    $stmt = $db->query("SELECT collections.participant_id FROM sample_masters, collections WHERE sample_masters.collection_id = collections.id AND sample_masters.id=".$sampleId);
    $participantId = $stmt->fetch(PDO::FETCH_ASSOC)['participant_id'];
    
    return $participantId;
  }

  // Count the deleted samples as well, as the counter function in the applicaiton considers deleted samples when generating a new sample code
  // This function needs debugging
  function getNumOfParticipantSamples($participantId, $db) {
    $stmt = $db->query("SELECT * FROM sample_masters, collections WHERE sample_masters.collection_id = collections.id AND collections.participant_id=".$participantId);
    $rowCount = $stmt->rowCount();
    return $rowCount;
  }

  //Get bone marrow aliquots associated with this sample
  function getBoneMarrowAliquotsFromBoneMarrowSamples($sampleId, $db) {

    $listOfBMAliquotId = array();

    $stmt = $db->query("SELECT aliquot_masters.id FROM sample_masters, aliquot_masters WHERE aliquot_masters.sample_master_id = sample_masters.id AND sample_masters.id=".$sampleId);
    $records = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach($records as $record) {
      array_push($listOfBMAliquotId, $record['id']);
    }
    return $listOfBMAliquotId;
  }
  

  

  //Get Bone marrow sample id
  //Get mononuclear cells sample id
  $stmt = $db->query("SELECT id FROM sample_controls WHERE sample_type = 'bone marrow' AND sample_category = 'specimen'");
  $boneMarrowId = $stmt->fetch(PDO::FETCH_ASSOC)['id'];

  $stmt = $db->query("SELECT id FROM sample_controls WHERE sample_type = 'ccbr mononuclear cells' AND sample_category = 'derivative'");
  $mcId = $stmt->fetch(PDO::FETCH_ASSOC)['id'];
  
  echo "Bone Marrow Control Id is ". $boneMarrowId;
  echo '<br>';
  echo "Mononuclear Cell Control Id is ".$mcId;
  echo '<br>';
  
  //Get all the bone marrow samples
  $stmt = $db->query("SELECT id, sample_code, collection_id FROM sample_masters WHERE sample_control_id = ".$boneMarrowId." AND deleted=0");
  $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

  //This array holds the bone marrow sample id that should be reviewed for migration
  //$listOfBMId = array();

  //Find the bone marrow samples id that needs to be reviewed
  //Should double check the filter with Adam
  foreach($result as $row) {
    if (strpos($row['sample_code'], "CCBR") !== false) {
      //Samples that needs to be reviewed for data migration
      
      print_r("Matched Pattern");
      print_r("<br>");
      print_r($row);
      //array_push($listOfBMId, $row['id']);
      
      //Need these fields to create a new MC sample under the bone marrow sample
      // Parent sample id 
      // Collection id 
      // sample code 
      $sample_id = $row['id'];
      $collection_id = $row['collection_id'];
      
      //To construct new sample code for the MC sample, 
      // need participant identifier:
      $participantIdentifier = getParticipantIdentifierFromSample($row['id'], $db);
      
      // need the number of samples already under the participant     
      $participantId = getParticipantIdFromSample($row['id'], $db);      
      $numOfSamples = getNumOfParticipantSamples($participantId, $db); 
      
      
      
      if ($numOfSamples <= 8) {
        $num = "00" . strval(($numOfSamples + 1));
      }
      
      if ($numOfSamples > 8 ) {
        $num = "0" . strval(($numOfsamples + 1));
      }
      
      $sample_code = $participantIdentifier . "MC" . $num;
      
      //Create a MC derivative under the Bone Marrow      
      echo "<br>";
      $queryCreateMCSample = "INSERT INTO sample_masters 
      (`sample_code`, `sample_control_id`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES 
      (".$sample_code.", ".$mcId.", ".$sample_id.", bone marrow, ". $collection_id. " ,".$sample_id.", bone marrow, NOW(), 1, NOW(), 1, 0)";
      print_r($queryCreateMCSample);
      echo "<br>";
      
      
      
      //Get the sample id of the newly created derivative. It would be the last entry of the sample master table
      $stmt = $db->query("SELECT id FROM sample_masters ORDER BY id DESC LIMIT 1");
      $derivativeId = $stmt->fetch(PDO::FETCH_ASSOC)['id'];
      echo "Derivative id:" . $derivativeId;
      
      //Get the bone marrow aliquots under the bone marrow samples 
      $query_for_aliquots = "SELECT id, barcode, aliquot_label, sample_master_id FROM aliquot_masters WHERE sample_master_id=".$row['id']." AND deleted=0";
      $stmt = $db->query($query_for_aliquots);
      $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
      
      // Update the sample_master_id of each aliquots
      foreach($result as $row) {
        print_r("<br>");
        print_r("Aliquot is:");
        print_r("<br>");
        print_r($row);
        
        $query = "UPDATE aliquot_masters SET sample_master_id=" . $derivativeId. " WHERE id=" . $row['id'];
        echo $query;
        
      } 
      
      
      print_r('<br>');
    } else {
      //Print the sample ids that do not required data migration
      print_r("Does not matched pattern");
      print_r("<br>");
      print_r($row);
      print_r('<br>');
    }
  }
  /*
  print_r(count($listOfBMId));

  foreach($listOfBMId as $id) {
    print_r("Bone Marrow Sample Id is:");
    print_r($id);
    print_r("<br>");
    print_r("Ids of Bone Marrow Aliquots associate with this sample are: ");
    print_r(getBoneMarrowAliquotsFromBoneMarrowSamples($id, $db));
    print_r("<br>");
    print_r("Participant Id is:");
    print_r(getParticipantIdFromSample($id, $db));
    $temp = getParticipantIdFromSample($id, $db);
    print_r("<br>");
    print_r("Number of Samples this Participant already has: ");
    print_r(getNumOfParticipantSamples($temp, $db));
    print_r("<br>");
    print_r("<br>");
  }
  */
  $connection = null;
 ?>
