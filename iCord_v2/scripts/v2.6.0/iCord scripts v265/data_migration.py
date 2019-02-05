print("Data Migration")


import csv
from datetime import datetime, date, time

def main():

    paricipant_collection_dict = dict()
       
    with open('data.csv') as csv_file:
        reader = csv.DictReader(csv_file, delimiter=',')
        for row in reader:


            

            participant_collection_dict[(row['Experiment'], row['Patient ID '], row['ASIA Grade'], row['DOI'])] = 
            
            print(row)
            print(row['DOI'])
            print(date.today())
            print(date.today().strftime('%Y-%m-%d'))
            time = " 00:00:00"
            today = date.today().strftime('%Y-%m-%d') + time
            #print(datetime.strptime('06-Jun-12','%d-%b-%y'))
            #Construct SQL statement for participant here
            participant_insert = "INSERT INTO participants (`participant_type`, `participant_identifier`, `icord_asia_grade`, `icord_injury_datetime`, `icord_injury_datetime_accuracy`, `icord_injury_level_neurological`, `last_modification`, `last_modification_ds_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES ('" + row['Experiment'] + "', '" + row['Patient ID '] + "', '" + row['ASIA Grade'] + "', '" + row['DOI'] + " 00:00:00" + "', '" + row['INURY LEVEL'] + "', '" + today + "', 4, '" + today + "', 1, '" + today + "', 1, 0);" 
            print(participant_insert)
            input("Press Enter to continue...")
            
if __name__ == "__main__":
    main()

