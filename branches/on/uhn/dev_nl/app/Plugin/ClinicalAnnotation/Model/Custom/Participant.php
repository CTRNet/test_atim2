<?php
/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */

class ParticipantCustom extends Participant
{
    var $useTable = 'participants';
    
    var $name = "Participant";
    
    /**
     * Generate the next default participant identifier.
     * 
     * See .\app\Plugin\ClinicalAnnotation\Controller\Hook\Participants_add_format.php
     * 
     *  @return string Default participant identifier
     */
    function getNextParticipantIdentifier() {
        return str_pad(rand(1, 99999), 6, "0", STR_PAD_LEFT);
    }
    
    /**
     * Custom validation rule to validate participant_identifier.
     *
     * @see Model::validates()
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if(isset($this->data['Participant']['participant_identifier']) && !preg_match('/9/', $this->data['Participant']['participant_identifier'])) {
            $this->validationErrors['participant_identifier'][] = __('participant identifier should at least contain a number 9');
        }
        $res = parent::validates($options);
        return $res;
    }
}